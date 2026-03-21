#!/usr/bin/env python3
"""
EvoSuite Benchmark Metrics Collector

Collects and aggregates metrics from EvoSuite benchmark runs.
Parses JSON metrics files, log files, and statistics CSVs.
"""

import json
import os
import re
import csv
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Optional, Any


class MetricsCollector:
    """Collects metrics from EvoSuite benchmark run outputs."""

    def __init__(self, results_dir: str):
        """
        Initialize metrics collector.

        Args:
            results_dir: Path to benchmark results directory
        """
        self.results_dir = Path(results_dir)
        self.endpoints_data: Dict[int, Dict] = {}

    def collect_all(self) -> Dict[int, Dict]:
        """
        Collect metrics from all endpoints and runs.

        Returns:
            Dictionary mapping endpoint_id -> aggregated metrics
        """
        # Find all endpoint directories
        for endpoint_dir in sorted(self.results_dir.glob("endpoint_*")):
            endpoint_id = int(endpoint_dir.name.split("_")[1])
            self.endpoints_data[endpoint_id] = self._collect_endpoint_metrics(endpoint_dir)

        return self.endpoints_data

    def _collect_endpoint_metrics(self, endpoint_dir: Path) -> Dict:
        """
        Collect metrics for a single endpoint across all runs.

        Args:
            endpoint_dir: Path to endpoint directory

        Returns:
            Aggregated metrics for the endpoint
        """
        runs_data = []

        # Collect data from each run
        for run_dir in sorted(endpoint_dir.glob("run_*")):
            run_number = int(run_dir.name.split("_")[1])
            run_data = self._collect_run_metrics(run_dir, run_number)
            runs_data.append(run_data)

        # Aggregate metrics across runs
        return {
            "endpoint_id": int(endpoint_dir.name.split("_")[1]),
            "runs": runs_data,
            "aggregated": self._aggregate_runs(runs_data)
        }

    def _collect_run_metrics(self, run_dir: Path, run_number: int) -> Dict:
        """
        Collect metrics for a single run.

        Args:
            run_dir: Path to run directory
            run_number: Run iteration number

        Returns:
            Metrics dictionary for this run
        """
        metrics = {
            "run_number": run_number,
            "resource_metrics": {},
            "exit_status": {},
            "test_analysis": {}
        }

        # Read resource metrics JSON
        resource_file = run_dir / "resource-metrics.json"
        if resource_file.exists():
            try:
                with open(resource_file, 'r') as f:
                    metrics["resource_metrics"] = json.load(f)
            except json.JSONDecodeError:
                pass

        # Read exit status JSON
        status_file = run_dir / "exit-status.json"
        if status_file.exists():
            try:
                with open(status_file, 'r') as f:
                    metrics["exit_status"] = json.load(f)
            except json.JSONDecodeError:
                pass

        # Analyze generated tests if they exist
        tests_dir = run_dir / "generated-tests"
        if tests_dir.exists():
            metrics["test_analysis"] = self._analyze_tests(tests_dir)

        # Parse EvoSuite log for additional info
        log_file = run_dir / "evosuite-output.log"
        if log_file.exists():
            metrics["log_analysis"] = self._analyze_log(log_file)

        return metrics

    def _analyze_tests(self, tests_dir: Path) -> Dict:
        """
        Analyze generated test files.

        Args:
            tests_dir: Path to generated tests directory

        Returns:
            Analysis results
        """
        analysis = {
            "test_files": 0,
            "test_methods": 0,
            "assertions": 0,
            "assertion_types": {},
            "boundary_tests": 0,
            "null_checks": 0,
            "http_status_assertions": 0
        }

        test_files = list(tests_dir.rglob("*_ESTest.java"))
        analysis["test_files"] = len(test_files)

        for test_file in test_files:
            try:
                content = test_file.read_text()

                # Count test methods
                analysis["test_methods"] += len(re.findall(r'@Test', content))

                # Count assertions by type
                assertion_patterns = {
                    "assertEquals": r'assertEquals\s*\(',
                    "assertNotNull": r'assertNotNull\s*\(',
                    "assertNull": r'assertNull\s*\(',
                    "assertTrue": r'assertTrue\s*\(',
                    "assertFalse": r'assertFalse\s*\(',
                    "assertThat": r'assertThat\s*\(',
                    "fail": r'fail\s*\(',
                    "verifyException": r'verifyException\s*\('
                }

                for assertion_type, pattern in assertion_patterns.items():
                    count = len(re.findall(pattern, content))
                    analysis["assertion_types"][assertion_type] = count
                    analysis["assertions"] += count

                # Check for boundary tests (null, empty, zero)
                analysis["boundary_tests"] += len(re.findall(
                    r'\(\s*null\s*\)|\(\s*""\s*\)|\(\s*0\s*\)|\(\s*-1\s*\)', content
                ))

                # Check for null checks
                analysis["null_checks"] += len(re.findall(r'null', content, re.IGNORECASE))

                # Check for HTTP status assertions
                analysis["http_status_assertions"] += len(re.findall(
                    r'assertEquals\s*\(\s*(200|201|400|401|403|404|500)', content
                ))

            except Exception:
                pass

        return analysis

    def _analyze_log(self, log_file: Path) -> Dict:
        """
        Analyze EvoSuite log file for additional metrics.

        Args:
            log_file: Path to log file

        Returns:
            Log analysis results
        """
        analysis = {
            "compilation_errors": False,
            "rmi_errors": False,
            "coverage_goals": None,
            "search_started": False,
            "search_completed": False
        }

        try:
            content = log_file.read_text()

            # Check for various conditions
            analysis["compilation_errors"] = "Compilation failed" in content or "cannot find symbol" in content
            analysis["rmi_errors"] = "NoClassDefFoundError" in content or "RMI" in content
            analysis["search_started"] = "Starting Client" in content or "Going to generate" in content
            analysis["search_completed"] = "Search finished" in content or "Writing tests" in content

            # Extract coverage goals if present
            coverage_match = re.search(r'(\d+) goals covered out of (\d+)', content)
            if coverage_match:
                analysis["coverage_goals"] = {
                    "covered": int(coverage_match.group(1)),
                    "total": int(coverage_match.group(2))
                }

        except Exception:
            pass

        return analysis

    def _aggregate_runs(self, runs_data: List[Dict]) -> Dict:
        """
        Aggregate metrics across multiple runs.

        Args:
            runs_data: List of run metrics

        Returns:
            Aggregated metrics
        """
        if not runs_data:
            return {}

        aggregated = {
            "total_runs": len(runs_data),
            "successful_runs": 0,
            "failed_runs": 0,
            "avg_duration": 0,
            "avg_cpu": 0,
            "max_memory": 0,
            "total_tests_generated": 0,
            "total_test_methods": 0,
            "total_assertions": 0
        }

        durations = []
        cpus = []
        memories = []

        for run in runs_data:
            # Count success/failure
            exit_status = run.get("exit_status", {})
            if exit_status.get("runs_without_error", False):
                aggregated["successful_runs"] += 1
            else:
                aggregated["failed_runs"] += 1

            # Collect resource metrics
            resource = run.get("resource_metrics", {})
            if "duration_seconds" in resource:
                durations.append(float(resource["duration_seconds"]))
            if "cpu_average_percent" in resource:
                cpus.append(float(resource["cpu_average_percent"]))
            if "memory_peak_mb" in resource:
                memories.append(float(resource["memory_peak_mb"]))

            # Collect test counts
            aggregated["total_tests_generated"] += resource.get("tests_generated", 0)
            aggregated["total_test_methods"] += resource.get("test_methods", 0)
            aggregated["total_assertions"] += resource.get("assertions", 0)

        # Calculate averages
        if durations:
            aggregated["avg_duration"] = sum(durations) / len(durations)
        if cpus:
            aggregated["avg_cpu"] = sum(cpus) / len(cpus)
        if memories:
            aggregated["max_memory"] = max(memories)

        return aggregated

    def to_csv_rows(self) -> List[Dict]:
        """
        Convert collected metrics to CSV rows.

        Returns:
            List of dictionaries for CSV output
        """
        rows = []

        for endpoint_id, endpoint_data in self.endpoints_data.items():
            for run in endpoint_data.get("runs", []):
                row = self._create_csv_row(endpoint_id, run)
                rows.append(row)

        return rows

    def _create_csv_row(self, endpoint_id: int, run_data: Dict) -> Dict:
        """
        Create a single CSV row from run data.

        Args:
            endpoint_id: Endpoint identifier
            run_data: Run metrics data

        Returns:
            Dictionary for CSV row
        """
        resource = run_data.get("resource_metrics", {})
        status = run_data.get("exit_status", {})
        test_analysis = run_data.get("test_analysis", {})

        # Determine coverage value
        coverage = resource.get("coverage", "N/A")
        if coverage != "N/A":
            try:
                coverage = float(coverage)
            except (ValueError, TypeError):
                coverage = "N/A"

        return {
            "endpoint_id": endpoint_id,
            "run_number": run_data.get("run_number", 0),
            "generation_status": status.get("generation_status", "UNKNOWN"),
            "generation_time_sec": resource.get("duration_seconds", "N/A"),
            "generation_cpu_pct": resource.get("cpu_average_percent", "N/A"),
            "generation_memory_mb": resource.get("memory_peak_mb", "N/A"),
            "tests_generated": resource.get("tests_generated", 0),
            "test_methods_count": resource.get("test_methods", 0),
            "assertions_count": resource.get("assertions", 0),
            "line_coverage": coverage,
            "total_goals": resource.get("total_goals", "N/A"),
            "covered_goals": resource.get("covered_goals", "N/A"),
            "exit_code": status.get("exit_code", -1),
            "error_type": status.get("error_type", ""),
            "error_message": status.get("error_message", "")[:200],  # Truncate long messages
            "runs_without_error": "TRUE" if status.get("runs_without_error", False) else "FALSE",
            "threw_errors": "TRUE" if status.get("threw_errors", False) else "FALSE",
            "runtime_anomalies": status.get("error_type", "") if status.get("threw_errors", False) else "",
            "timed_out": "TRUE" if status.get("timed_out", False) else "FALSE",
            "hung_up": "TRUE" if status.get("hung_up", False) else "FALSE",
            # Manual evaluation fields (to be filled later)
            "targets_correct_endpoint": "N/A",
            "asserts_http_status": "N/A",
            "correct_comparator": "N/A",
            "inline_with_scenarios": "N/A",
            "missing_url_params": "N/A",
            "missing_request_body": "N/A",
            "assertions_meaningful": "N/A",
            "boundary_conditions": "N/A",
            "verifies_authorization": "N/A",
            "invalid_url_params": "N/A",
            "invalid_request_body": "N/A",
            # Runtime quality (requires test execution)
            "test_flakiness_rate": "N/A",
            "test_exec_memory_mb": "N/A",
            "test_exec_cpu_sec": "N/A",
            # Performance quality (requires test execution)
            "mean_test_exec_time_ms": "N/A",
            "exec_time_std_dev_ms": "N/A",
            # Metadata
            "manual_evaluation_complete": "FALSE",
            "evaluator_notes": ""
        }


def main():
    """Main entry point for metrics collection."""
    import sys

    if len(sys.argv) < 2:
        print("Usage: python metrics_collector.py <results_dir>")
        sys.exit(1)

    results_dir = sys.argv[1]
    collector = MetricsCollector(results_dir)
    collector.collect_all()

    # Print summary
    print(f"Collected metrics from {len(collector.endpoints_data)} endpoints")
    for endpoint_id, data in collector.endpoints_data.items():
        agg = data.get("aggregated", {})
        print(f"  Endpoint {endpoint_id}: {agg.get('total_runs', 0)} runs, "
              f"{agg.get('successful_runs', 0)} successful, "
              f"{agg.get('failed_runs', 0)} failed")


if __name__ == "__main__":
    main()
