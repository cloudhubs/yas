#!/usr/bin/env python3
"""
EvoSuite Benchmark Run Aggregator

Aggregates metrics across multiple runs for a single endpoint,
calculating averages, min, max, and standard deviation.
"""

import json
import os
import sys
import math
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Optional, Any, Union


def calculate_stats(values: List[float]) -> Dict[str, float]:
    """
    Calculate statistical measures for a list of values.

    Args:
        values: List of numeric values

    Returns:
        Dictionary with avg, min, max, std_dev, count
    """
    if not values:
        return {
            "avg": None,
            "min": None,
            "max": None,
            "std_dev": None,
            "count": 0
        }

    n = len(values)
    avg = sum(values) / n
    min_val = min(values)
    max_val = max(values)

    # Calculate standard deviation
    if n > 1:
        variance = sum((x - avg) ** 2 for x in values) / (n - 1)
        std_dev = math.sqrt(variance)
    else:
        std_dev = 0.0

    return {
        "avg": round(avg, 4),
        "min": round(min_val, 4),
        "max": round(max_val, 4),
        "std_dev": round(std_dev, 4),
        "count": n
    }


def safe_float(value: Any) -> Optional[float]:
    """Safely convert value to float, returning None if not possible."""
    if value is None or value == "N/A" or value == "":
        return None
    try:
        return float(value)
    except (ValueError, TypeError):
        return None


def aggregate_endpoint_runs(endpoint_dir: str) -> Dict[str, Any]:
    """
    Aggregate metrics across all runs for an endpoint.

    Args:
        endpoint_dir: Path to endpoint directory containing run_* subdirs

    Returns:
        Aggregated metrics dictionary
    """
    endpoint_path = Path(endpoint_dir)
    endpoint_id = int(endpoint_path.name.split("_")[1])

    # Collect data from all runs
    runs_data = []

    for run_dir in sorted(endpoint_path.glob("run_*")):
        run_number = int(run_dir.name.split("_")[1])
        run_data = {"run_number": run_number}

        # Read resource metrics
        resource_file = run_dir / "resource-metrics.json"
        if resource_file.exists():
            try:
                with open(resource_file, 'r') as f:
                    run_data["resource"] = json.load(f)
            except json.JSONDecodeError:
                run_data["resource"] = {}

        # Read exit status
        status_file = run_dir / "exit-status.json"
        if status_file.exists():
            try:
                with open(status_file, 'r') as f:
                    run_data["status"] = json.load(f)
            except json.JSONDecodeError:
                run_data["status"] = {}

        runs_data.append(run_data)

    if not runs_data:
        return {"error": "No runs found", "endpoint_id": endpoint_id}

    # Extract numeric values for aggregation
    durations = []
    cpu_values = []
    memory_values = []
    tests_generated = []
    test_methods = []
    assertions = []
    exit_codes = []

    successful_runs = 0
    failed_runs = 0
    timed_out_count = 0
    hung_up_count = 0
    error_types = {}
    error_messages = []
    total_errors_list = []
    missing_packages_list = []

    for run in runs_data:
        resource = run.get("resource", {})
        status = run.get("status", {})

        # Collect numeric metrics
        if safe_float(resource.get("duration_seconds")) is not None:
            durations.append(safe_float(resource.get("duration_seconds")))

        if safe_float(resource.get("cpu_average_percent")) is not None:
            cpu_values.append(safe_float(resource.get("cpu_average_percent")))

        if safe_float(resource.get("memory_peak_mb")) is not None:
            memory_values.append(safe_float(resource.get("memory_peak_mb")))

        tests_generated.append(resource.get("tests_generated", 0))
        test_methods.append(resource.get("test_methods", 0))
        assertions.append(resource.get("assertions", 0))

        # Collect status metrics
        exit_codes.append(status.get("exit_code", -1))

        if status.get("runs_without_error", False):
            successful_runs += 1
        else:
            failed_runs += 1

        if status.get("timed_out", False):
            timed_out_count += 1

        if status.get("hung_up", False):
            hung_up_count += 1

        # Track error types
        error_type = status.get("error_type", "")
        if error_type and error_type != "UNKNOWN":
            error_types[error_type] = error_types.get(error_type, 0) + 1

        # Collect error messages
        error_msg = status.get("error_message", "")
        if error_msg:
            error_messages.append(error_msg)

        # Collect error counts
        error_counts = status.get("error_counts", {})
        if error_counts:
            total_errors_list.append(error_counts.get("total_errors", 0))
            missing_packages_list.append(error_counts.get("missing_packages", 0))

    # Determine primary error type (most common)
    primary_error_type = max(error_types, key=error_types.get) if error_types else "NONE"

    # Get unique error messages (deduplicated)
    unique_error_messages = list(set(error_messages))[:5]  # Limit to 5 unique messages

    # Build aggregated result
    aggregated = {
        "endpoint_id": endpoint_id,
        "aggregation_timestamp": datetime.utcnow().isoformat() + "Z",
        "total_runs": len(runs_data),
        "successful_runs": successful_runs,
        "failed_runs": failed_runs,
        "success_rate": round(successful_runs / len(runs_data), 4) if runs_data else 0,

        "generation_time": calculate_stats(durations),
        "cpu_usage": calculate_stats(cpu_values),
        "memory_usage": calculate_stats(memory_values),

        "tests_generated": calculate_stats([float(x) for x in tests_generated]),
        "test_methods": calculate_stats([float(x) for x in test_methods]),
        "assertions": calculate_stats([float(x) for x in assertions]),

        "exit_codes": {
            "values": exit_codes,
            "unique": list(set(exit_codes))
        },

        "timed_out_count": timed_out_count,
        "hung_up_count": hung_up_count,

        # Error summary
        "error_summary": {
            "primary_error_type": primary_error_type,
            "error_types": error_types,
            "total_compilation_errors": calculate_stats([float(x) for x in total_errors_list]) if total_errors_list else None,
            "missing_packages_errors": calculate_stats([float(x) for x in missing_packages_list]) if missing_packages_list else None,
            "unique_error_messages": unique_error_messages
        },

        "individual_runs": [
            {
                "run_number": run.get("run_number"),
                "duration_sec": run.get("resource", {}).get("duration_seconds"),
                "cpu_pct": run.get("resource", {}).get("cpu_average_percent"),
                "memory_mb": run.get("resource", {}).get("memory_peak_mb"),
                "tests": run.get("resource", {}).get("tests_generated", 0),
                "exit_code": run.get("status", {}).get("exit_code"),
                "error_type": run.get("status", {}).get("error_type", ""),
                "error_message": run.get("status", {}).get("error_message", "")[:200]  # Truncated
            }
            for run in runs_data
        ]
    }

    return aggregated


def generate_summary_text(aggregated: Dict[str, Any]) -> str:
    """
    Generate human-readable summary text from aggregated data.

    Args:
        aggregated: Aggregated metrics dictionary

    Returns:
        Formatted summary string
    """
    lines = [
        "=" * 60,
        f"ENDPOINT {aggregated['endpoint_id']} - AGGREGATED RESULTS",
        "=" * 60,
        "",
        f"Aggregation Timestamp: {aggregated['aggregation_timestamp']}",
        "",
        "EXECUTION SUMMARY",
        "-" * 40,
        f"Total Runs:      {aggregated['total_runs']}",
        f"Successful:      {aggregated['successful_runs']}",
        f"Failed:          {aggregated['failed_runs']}",
        f"Success Rate:    {aggregated['success_rate'] * 100:.1f}%",
        f"Timed Out:       {aggregated['timed_out_count']}",
        f"Hung Up:         {aggregated['hung_up_count']}",
        "",
    ]

    # Error summary
    error_summary = aggregated.get('error_summary', {})
    if error_summary and error_summary.get('error_types'):
        lines.extend([
            "ERROR SUMMARY",
            "-" * 40,
            f"Primary Error:   {error_summary.get('primary_error_type', 'NONE')}",
        ])
        lines.append("Error Types:")
        for error_type, count in error_summary.get('error_types', {}).items():
            lines.append(f"  - {error_type}: {count}")

        # Compilation error stats if available
        total_comp_errors = error_summary.get('total_compilation_errors')
        if total_comp_errors and total_comp_errors.get('avg') is not None:
            lines.append(f"Avg Compilation Errors: {total_comp_errors['avg']}")

        # Show unique error messages
        unique_msgs = error_summary.get('unique_error_messages', [])
        if unique_msgs:
            lines.append("")
            lines.append("Sample Error Messages:")
            for msg in unique_msgs[:3]:
                truncated = msg[:100] + "..." if len(msg) > 100 else msg
                lines.append(f"  • {truncated}")

        lines.append("")

    # Generation time stats
    time_stats = aggregated['generation_time']
    lines.extend([
        "GENERATION TIME (seconds)",
        "-" * 40,
        f"Average:         {time_stats['avg']}" if time_stats['avg'] else "Average:         N/A",
        f"Min:             {time_stats['min']}" if time_stats['min'] else "Min:             N/A",
        f"Max:             {time_stats['max']}" if time_stats['max'] else "Max:             N/A",
        f"Std Dev:         {time_stats['std_dev']}" if time_stats['std_dev'] else "Std Dev:         N/A",
        "",
    ])

    # CPU usage stats
    cpu_stats = aggregated['cpu_usage']
    lines.extend([
        "CPU USAGE (%)",
        "-" * 40,
        f"Average:         {cpu_stats['avg']}" if cpu_stats['avg'] else "Average:         N/A",
        f"Min:             {cpu_stats['min']}" if cpu_stats['min'] else "Min:             N/A",
        f"Max:             {cpu_stats['max']}" if cpu_stats['max'] else "Max:             N/A",
        f"Std Dev:         {cpu_stats['std_dev']}" if cpu_stats['std_dev'] else "Std Dev:         N/A",
        "",
    ])

    # Memory usage stats
    mem_stats = aggregated['memory_usage']
    lines.extend([
        "MEMORY USAGE (MB)",
        "-" * 40,
        f"Average:         {mem_stats['avg']}" if mem_stats['avg'] else "Average:         N/A",
        f"Min:             {mem_stats['min']}" if mem_stats['min'] else "Min:             N/A",
        f"Max:             {mem_stats['max']}" if mem_stats['max'] else "Max:             N/A",
        f"Std Dev:         {mem_stats['std_dev']}" if mem_stats['std_dev'] else "Std Dev:         N/A",
        "",
    ])

    # Test generation stats
    test_stats = aggregated['tests_generated']
    lines.extend([
        "TESTS GENERATED",
        "-" * 40,
        f"Average:         {test_stats['avg']}" if test_stats['avg'] is not None else "Average:         0",
        f"Total:           {sum(r['tests'] for r in aggregated['individual_runs'])}",
        "",
    ])

    # Individual runs table
    lines.extend([
        "INDIVIDUAL RUNS",
        "-" * 40,
        f"{'Run':<6} {'Time(s)':<10} {'CPU(%)':<10} {'Mem(MB)':<10} {'Tests':<8} {'Exit':<6} {'Error'}",
        "-" * 70,
    ])

    for run in aggregated['individual_runs']:
        time_str = f"{run['duration_sec']:.1f}" if run['duration_sec'] else "N/A"
        cpu_str = f"{run['cpu_pct']:.1f}" if run['cpu_pct'] else "N/A"
        mem_str = f"{run['memory_mb']:.0f}" if run['memory_mb'] else "N/A"
        lines.append(
            f"{run['run_number']:<6} {time_str:<10} {cpu_str:<10} {mem_str:<10} "
            f"{run['tests']:<8} {run['exit_code']:<6} {run['error_type'][:20]}"
        )

    lines.extend(["", "=" * 60])

    return "\n".join(lines)


def aggregate_and_save(endpoint_dir: str) -> str:
    """
    Aggregate endpoint runs and save results.

    Args:
        endpoint_dir: Path to endpoint directory

    Returns:
        Path to generated aggregated file
    """
    endpoint_path = Path(endpoint_dir)

    # Aggregate data
    aggregated = aggregate_endpoint_runs(endpoint_dir)

    # Save JSON
    json_file = endpoint_path / "run-averages.json"
    with open(json_file, 'w') as f:
        json.dump(aggregated, f, indent=2)

    # Save human-readable summary
    summary_file = endpoint_path / "run-averages.txt"
    summary_text = generate_summary_text(aggregated)
    with open(summary_file, 'w') as f:
        f.write(summary_text)

    return str(json_file)


def main():
    """Main entry point."""
    if len(sys.argv) < 2:
        print("Usage: python aggregator.py <endpoint_dir>")
        print("       python aggregator.py <results_dir> --all")
        sys.exit(1)

    target_dir = sys.argv[1]
    process_all = "--all" in sys.argv

    if process_all:
        # Process all endpoint directories
        results_path = Path(target_dir)
        for endpoint_dir in sorted(results_path.glob("endpoint_*")):
            print(f"Aggregating: {endpoint_dir.name}")
            output_file = aggregate_and_save(str(endpoint_dir))
            print(f"  Created: {output_file}")
    else:
        # Process single endpoint directory
        output_file = aggregate_and_save(target_dir)
        print(f"Created: {output_file}")

        # Print summary to stdout
        aggregated = aggregate_endpoint_runs(target_dir)
        print()
        print(generate_summary_text(aggregated))


if __name__ == "__main__":
    main()
