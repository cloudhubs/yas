#!/usr/bin/env python3
"""
EvoSuite Benchmark CSV Generator

Generates research-quality CSV output from benchmark results.
Combines automated metrics with placeholders for manual evaluation.
"""

import csv
import json
import os
import sys
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Optional, Any

from metrics_collector import MetricsCollector


class CSVGenerator:
    """Generates CSV output for benchmark results."""

    # CSV column definitions with headers and descriptions
    CSV_COLUMNS = [
        # Identification
        ("endpoint_id", "Endpoint ID (1-13)"),
        ("service", "Service name"),
        ("http_method", "HTTP method"),
        ("endpoint_path", "API endpoint path"),
        ("controller_class", "Controller class name"),
        ("run_number", "Run iteration number"),

        # Generation results
        ("generation_status", "SUCCESS/FAILED/PARTIAL"),
        ("generation_time_sec", "Wall clock time in seconds"),
        ("generation_cpu_pct", "Average CPU usage percentage"),
        ("generation_memory_mb", "Peak memory usage in MB"),

        # Test metrics
        ("tests_generated", "Number of test files generated"),
        ("test_methods_count", "Number of @Test methods"),
        ("assertions_count", "Total number of assertions"),

        # Coverage metrics
        ("line_coverage", "Line coverage (0.0-1.0)"),
        ("branch_coverage", "Branch coverage (0.0-1.0)"),
        ("total_goals", "EvoSuite total goals"),
        ("covered_goals", "EvoSuite covered goals"),

        # Error information
        ("exit_code", "Process exit code"),
        ("error_type", "Error classification"),
        ("error_message", "Error message (truncated)"),

        # Semantic Validity (Manual)
        ("targets_correct_endpoint", "Targets the correct endpoints? (Yes/No/N/A)"),
        ("asserts_http_status", "Asserts expected HTTP status codes? (Yes/Partial/No/N/A)"),
        ("correct_comparator", "Uses correct comparator? (Yes/No/N/A)"),
        ("inline_with_scenarios", "Inline with scenarios? (Yes/Partial/No/N/A)"),
        ("missing_url_params", "Missing URL parameters? (Yes/No/N/A)"),
        ("missing_request_body", "Missing request body? (Yes/No/N/A)"),

        # Semantic Quality (Manual/Semi-auto)
        ("assertions_meaningful", "Assertions specific and meaningful? (Yes/Partial/No/N/A)"),
        ("boundary_conditions", "Boundary conditions covered? (Yes/Partial/No/N/A)"),
        ("verifies_authorization", "Verifies authorization? (Yes/No/N/A)"),
        ("invalid_url_params", "Contains invalid URL params? (Yes/No/N/A)"),
        ("invalid_request_body", "Contains invalid request body? (Yes/No/N/A)"),

        # Runtime Validity (Automated)
        ("runs_without_error", "Runs without error? (TRUE/FALSE)"),
        ("threw_errors", "Threw errors? (TRUE/FALSE)"),
        ("runtime_anomalies", "Runtime anomalies description"),
        ("timed_out", "Timed out? (TRUE/FALSE)"),
        ("hung_up", "Hung up? (TRUE/FALSE)"),

        # Runtime Quality (Conditional)
        ("test_flakiness_rate", "Flakiness rate (0.0-1.0)"),
        ("test_exec_memory_mb", "Test execution memory in MB"),
        ("test_exec_cpu_sec", "Test execution CPU time in seconds"),

        # Performance Quality (Conditional)
        ("mean_test_exec_time_ms", "Mean execution time per test in ms"),
        ("exec_time_std_dev_ms", "Execution time std deviation in ms"),

        # Metadata
        ("manual_evaluation_complete", "Manual evaluation done? (TRUE/FALSE)"),
        ("evaluator_notes", "Evaluator notes and comments")
    ]

    def __init__(self, results_dir: str, endpoints_csv: str = None):
        """
        Initialize CSV generator.

        Args:
            results_dir: Path to benchmark results directory
            endpoints_csv: Path to endpoints configuration CSV
        """
        self.results_dir = Path(results_dir)
        self.endpoints_csv = endpoints_csv
        self.endpoints_info = {}

        if endpoints_csv and Path(endpoints_csv).exists():
            self._load_endpoints_info()

    def _load_endpoints_info(self):
        """Load endpoint information from configuration CSV."""
        with open(self.endpoints_csv, 'r') as f:
            reader = csv.DictReader(f)
            for row in reader:
                endpoint_id = int(row['endpoint_id'])
                self.endpoints_info[endpoint_id] = row

    def generate(self, output_file: str = None) -> str:
        """
        Generate CSV from benchmark results.

        Args:
            output_file: Optional output file path

        Returns:
            Path to generated CSV file
        """
        if output_file is None:
            output_file = self.results_dir / "benchmark-results.csv"
        else:
            output_file = Path(output_file)

        # Collect metrics
        collector = MetricsCollector(str(self.results_dir))
        collector.collect_all()
        rows = collector.to_csv_rows()

        # Enrich with endpoint info
        for row in rows:
            endpoint_id = row.get("endpoint_id")
            if endpoint_id in self.endpoints_info:
                info = self.endpoints_info[endpoint_id]
                row["service"] = info.get("service", "")
                row["http_method"] = info.get("http_method", "")
                row["endpoint_path"] = info.get("endpoint", "")
                row["controller_class"] = info.get("controller_class", "")

        # Write CSV
        with open(output_file, 'w', newline='') as f:
            writer = csv.DictWriter(f, fieldnames=[col[0] for col in self.CSV_COLUMNS])
            writer.writeheader()

            for row in rows:
                # Ensure all columns exist
                complete_row = {col[0]: row.get(col[0], "N/A") for col in self.CSV_COLUMNS}
                writer.writerow(complete_row)

        return str(output_file)

    def generate_detailed(self, output_file: str = None) -> str:
        """
        Generate detailed CSV with all raw metrics.

        Args:
            output_file: Optional output file path

        Returns:
            Path to generated CSV file
        """
        if output_file is None:
            output_file = self.results_dir / "detailed-metrics.csv"
        else:
            output_file = Path(output_file)

        # Collect all metrics in raw form
        rows = []

        for endpoint_dir in sorted(self.results_dir.glob("endpoint_*")):
            endpoint_id = int(endpoint_dir.name.split("_")[1])

            for run_dir in sorted(endpoint_dir.glob("run_*")):
                run_number = int(run_dir.name.split("_")[1])

                # Read all JSON files
                for json_file in run_dir.glob("*.json"):
                    try:
                        with open(json_file, 'r') as f:
                            data = json.load(f)

                        for key, value in data.items():
                            rows.append({
                                "endpoint_id": endpoint_id,
                                "run_number": run_number,
                                "timestamp": datetime.now().isoformat(),
                                "source_file": json_file.name,
                                "metric_name": key,
                                "metric_value": str(value),
                                "metric_type": type(value).__name__
                            })
                    except (json.JSONDecodeError, IOError):
                        pass

        # Write CSV
        columns = ["endpoint_id", "run_number", "timestamp", "source_file",
                   "metric_name", "metric_value", "metric_type"]

        with open(output_file, 'w', newline='') as f:
            writer = csv.DictWriter(f, fieldnames=columns)
            writer.writeheader()
            writer.writerows(rows)

        return str(output_file)

    def merge_manual_evaluations(self, csv_file: str = None) -> str:
        """
        Merge manual evaluation data from markdown checklists into CSV.

        Args:
            csv_file: Path to existing CSV file to update

        Returns:
            Path to updated CSV file
        """
        if csv_file is None:
            csv_file = self.results_dir / "benchmark-results.csv"
        else:
            csv_file = Path(csv_file)

        if not csv_file.exists():
            print(f"CSV file not found: {csv_file}")
            return str(csv_file)

        # Read existing CSV
        rows = []
        with open(csv_file, 'r') as f:
            reader = csv.DictReader(f)
            rows = list(reader)

        # Process each endpoint's manual evaluation
        for endpoint_dir in sorted(self.results_dir.glob("endpoint_*")):
            endpoint_id = int(endpoint_dir.name.split("_")[1])
            eval_file = endpoint_dir / "manual-evaluation.md"

            if eval_file.exists():
                eval_data = self._parse_manual_evaluation(eval_file)

                # Update rows for this endpoint
                for row in rows:
                    if int(row.get("endpoint_id", 0)) == endpoint_id:
                        row.update(eval_data)

        # Write updated CSV
        with open(csv_file, 'w', newline='') as f:
            if rows:
                writer = csv.DictWriter(f, fieldnames=rows[0].keys())
                writer.writeheader()
                writer.writerows(rows)

        return str(csv_file)

    def _parse_manual_evaluation(self, eval_file: Path) -> Dict[str, str]:
        """
        Parse manual evaluation markdown file.

        Args:
            eval_file: Path to evaluation markdown file

        Returns:
            Dictionary of evaluation values
        """
        content = eval_file.read_text()

        # Mapping of checklist items to CSV columns
        mappings = {
            "Targets the correct endpoint": "targets_correct_endpoint",
            "Asserts the expected HTTP status": "asserts_http_status",
            "Uses the correct comparator": "correct_comparator",
            "Inline with the endpoint scenarios": "inline_with_scenarios",
            "Missing URL parameter": "missing_url_params",
            "Missing request body": "missing_request_body",
            "assertions specific and meaningful": "assertions_meaningful",
            "Boundary conditions": "boundary_conditions",
            "Verifies authorization": "verifies_authorization",
            "Invalid URL parameter": "invalid_url_params",
            "Invalid request body": "invalid_request_body"
        }

        result = {"manual_evaluation_complete": "FALSE"}

        for search_text, column in mappings.items():
            # Look for checked boxes after the search text
            pattern = rf'{search_text}.*?\n.*?\[([xX ])\].*?(Yes|No|Partial|N/A)'
            match = re.search(pattern, content, re.IGNORECASE | re.DOTALL)

            if match and match.group(1).lower() == 'x':
                result[column] = match.group(2)
            else:
                # Check if any option is marked
                section_pattern = rf'{search_text}.*?(?=###|\Z)'
                section = re.search(section_pattern, content, re.IGNORECASE | re.DOTALL)
                if section:
                    section_text = section.group(0)
                    for option in ["Yes", "Partial", "No", "N/A"]:
                        if f"[x] {option}" in section_text or f"[X] {option}" in section_text:
                            result[column] = option
                            break

        # Check if evaluation appears complete
        filled_count = sum(1 for v in result.values() if v not in ["", "N/A", "FALSE"])
        if filled_count >= 5:
            result["manual_evaluation_complete"] = "TRUE"

        return result


def main():
    """Main entry point for CSV generation."""
    if len(sys.argv) < 2:
        print("Usage: python csv_generator.py <results_dir> [--merge-manual]")
        print("")
        print("Options:")
        print("  --merge-manual    Merge manual evaluation data from markdown files")
        sys.exit(1)

    results_dir = sys.argv[1]
    merge_manual = "--merge-manual" in sys.argv

    # Find endpoints.csv
    benchmark_dir = Path(results_dir).parent
    if benchmark_dir.name == "results":
        benchmark_dir = benchmark_dir.parent
    endpoints_csv = benchmark_dir / "config" / "endpoints.csv"

    generator = CSVGenerator(
        results_dir,
        str(endpoints_csv) if endpoints_csv.exists() else None
    )

    # Generate main CSV
    csv_file = generator.generate()
    print(f"Generated: {csv_file}")

    # Generate detailed CSV
    detailed_file = generator.generate_detailed()
    print(f"Generated: {detailed_file}")

    # Optionally merge manual evaluations
    if merge_manual:
        csv_file = generator.merge_manual_evaluations(csv_file)
        print(f"Updated with manual evaluations: {csv_file}")


if __name__ == "__main__":
    import re  # Import for regex in parse method
    main()
