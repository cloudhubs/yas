#!/usr/bin/env python3
"""
EvoSuite Test Analyzer

Analyzes generated test files for semantic metrics.
Provides semi-automated analysis to assist manual evaluation.
"""

import re
import json
from pathlib import Path
from typing import Dict, List, Optional, Any
from dataclasses import dataclass, field, asdict


@dataclass
class TestMethod:
    """Represents a single test method."""
    name: str
    line_number: int
    assertions: List[str] = field(default_factory=list)
    has_timeout: bool = False
    has_expected_exception: bool = False
    inputs: List[str] = field(default_factory=list)


@dataclass
class TestFileAnalysis:
    """Analysis results for a test file."""
    file_path: str
    class_name: str
    test_methods: List[TestMethod] = field(default_factory=list)
    total_assertions: int = 0
    assertion_types: Dict[str, int] = field(default_factory=dict)
    boundary_inputs: List[str] = field(default_factory=list)
    http_status_checks: List[str] = field(default_factory=list)
    null_checks: int = 0
    imports: List[str] = field(default_factory=list)


class TestAnalyzer:
    """Analyzes EvoSuite generated test files."""

    # Patterns for analysis
    ASSERTION_PATTERNS = {
        "assertEquals": r'assertEquals\s*\([^)]+\)',
        "assertNotNull": r'assertNotNull\s*\([^)]+\)',
        "assertNull": r'assertNull\s*\([^)]+\)',
        "assertTrue": r'assertTrue\s*\([^)]+\)',
        "assertFalse": r'assertFalse\s*\([^)]+\)',
        "assertThat": r'assertThat\s*\([^)]+\)',
        "fail": r'fail\s*\([^)]*\)',
        "verifyException": r'verifyException\s*\([^)]+\)'
    }

    BOUNDARY_PATTERNS = [
        r'\(\s*null\s*\)',
        r'\(\s*""\s*\)',
        r'\(\s*0\s*\)',
        r'\(\s*-1\s*\)',
        r'\(\s*Integer\.MAX_VALUE\s*\)',
        r'\(\s*Integer\.MIN_VALUE\s*\)',
        r'\(\s*Long\.MAX_VALUE\s*\)',
        r'\(\s*Long\.MIN_VALUE\s*\)',
        r'\(\s*0\.0\s*\)',
        r'\(\s*-0\.0\s*\)',
        r'\(\s*Double\.NaN\s*\)',
        r'\(\s*Float\.NaN\s*\)',
        r'Collections\.emptyList\(\)',
        r'new\s+ArrayList<>\(\)',
        r'new\s+HashMap<>\(\)'
    ]

    HTTP_STATUS_PATTERNS = [
        r'assertEquals\s*\(\s*(200|201|204|400|401|403|404|500|502|503)',
        r'assertThat.*status.*is\((200|201|204|400|401|403|404|500)',
        r'HttpStatus\.(OK|CREATED|BAD_REQUEST|UNAUTHORIZED|FORBIDDEN|NOT_FOUND)',
        r'\.getStatusCode\(\).*==\s*(200|201|204|400|401|403|404|500)'
    ]

    def __init__(self, tests_dir: str):
        """
        Initialize analyzer.

        Args:
            tests_dir: Path to directory containing generated tests
        """
        self.tests_dir = Path(tests_dir)
        self.analyses: List[TestFileAnalysis] = []

    def analyze_all(self) -> List[TestFileAnalysis]:
        """
        Analyze all test files in the directory.

        Returns:
            List of analysis results
        """
        test_files = list(self.tests_dir.rglob("*_ESTest.java"))

        for test_file in test_files:
            analysis = self.analyze_file(test_file)
            self.analyses.append(analysis)

        return self.analyses

    def analyze_file(self, file_path: Path) -> TestFileAnalysis:
        """
        Analyze a single test file.

        Args:
            file_path: Path to test file

        Returns:
            Analysis results
        """
        content = file_path.read_text()

        # Extract class name
        class_match = re.search(r'public\s+class\s+(\w+)', content)
        class_name = class_match.group(1) if class_match else file_path.stem

        analysis = TestFileAnalysis(
            file_path=str(file_path),
            class_name=class_name
        )

        # Extract imports
        analysis.imports = re.findall(r'import\s+([\w.]+);', content)

        # Analyze test methods
        analysis.test_methods = self._extract_test_methods(content)

        # Count assertions by type
        for assertion_type, pattern in self.ASSERTION_PATTERNS.items():
            count = len(re.findall(pattern, content))
            if count > 0:
                analysis.assertion_types[assertion_type] = count
                analysis.total_assertions += count

        # Find boundary inputs
        for pattern in self.BOUNDARY_PATTERNS:
            matches = re.findall(pattern, content)
            analysis.boundary_inputs.extend(matches)

        # Find HTTP status checks
        for pattern in self.HTTP_STATUS_PATTERNS:
            matches = re.findall(pattern, content)
            analysis.http_status_checks.extend(matches)

        # Count null checks
        analysis.null_checks = len(re.findall(r'\bnull\b', content))

        return analysis

    def _extract_test_methods(self, content: str) -> List[TestMethod]:
        """
        Extract test methods from file content.

        Args:
            content: File content

        Returns:
            List of test methods
        """
        methods = []

        # Pattern to match test methods
        test_pattern = r'@Test(?:\([^)]*\))?\s*\n\s*public\s+void\s+(\w+)\s*\([^)]*\)\s*(?:throws\s+[^{]+)?\s*\{'

        for match in re.finditer(test_pattern, content):
            method_name = match.group(1)
            start_pos = match.end()

            # Find method body (simplified - count braces)
            brace_count = 1
            end_pos = start_pos
            while brace_count > 0 and end_pos < len(content):
                if content[end_pos] == '{':
                    brace_count += 1
                elif content[end_pos] == '}':
                    brace_count -= 1
                end_pos += 1

            method_body = content[start_pos:end_pos]

            # Extract assertions from method body
            assertions = []
            for assertion_type, pattern in self.ASSERTION_PATTERNS.items():
                for assertion_match in re.findall(pattern, method_body):
                    assertions.append(f"{assertion_type}: {assertion_match[:100]}")

            # Check for timeout annotation
            annotation_region = content[max(0, match.start() - 100):match.start()]
            has_timeout = 'timeout' in annotation_region.lower()

            # Check for expected exception
            has_expected_exception = 'expected' in annotation_region or 'Expecting exception' in method_body

            # Extract inputs (simplified)
            inputs = re.findall(r'(\w+)\s*\([^)]*\)', method_body)[:5]  # First 5 method calls

            methods.append(TestMethod(
                name=method_name,
                line_number=content[:match.start()].count('\n') + 1,
                assertions=assertions,
                has_timeout=has_timeout,
                has_expected_exception=has_expected_exception,
                inputs=inputs
            ))

        return methods

    def get_summary(self) -> Dict[str, Any]:
        """
        Get summary of all analyses.

        Returns:
            Summary dictionary
        """
        summary = {
            "total_files": len(self.analyses),
            "total_test_methods": 0,
            "total_assertions": 0,
            "assertion_types": {},
            "boundary_inputs_found": 0,
            "http_status_checks_found": 0,
            "files_with_exceptions": 0
        }

        for analysis in self.analyses:
            summary["total_test_methods"] += len(analysis.test_methods)
            summary["total_assertions"] += analysis.total_assertions
            summary["boundary_inputs_found"] += len(analysis.boundary_inputs)
            summary["http_status_checks_found"] += len(analysis.http_status_checks)

            # Aggregate assertion types
            for assertion_type, count in analysis.assertion_types.items():
                summary["assertion_types"][assertion_type] = \
                    summary["assertion_types"].get(assertion_type, 0) + count

            # Check for expected exceptions
            for method in analysis.test_methods:
                if method.has_expected_exception:
                    summary["files_with_exceptions"] += 1
                    break

        return summary

    def generate_evaluation_hints(self) -> Dict[str, Any]:
        """
        Generate hints to assist manual evaluation.

        Returns:
            Dictionary with evaluation hints
        """
        hints = {
            "semantic_validity": {
                "targets_correct_endpoint": self._hint_endpoint_targeting(),
                "asserts_http_status": self._hint_http_status(),
                "correct_comparator": self._hint_comparators(),
                "boundary_conditions": self._hint_boundaries()
            },
            "semantic_quality": {
                "assertions_meaningful": self._hint_assertion_quality(),
                "boundary_tests": self._hint_boundary_tests()
            }
        }

        return hints

    def _hint_endpoint_targeting(self) -> str:
        """Generate hint about endpoint targeting."""
        if not self.analyses:
            return "N/A - No test files found"

        # Look for controller method invocations
        method_calls = set()
        for analysis in self.analyses:
            for method in analysis.test_methods:
                method_calls.update(method.inputs)

        if method_calls:
            return f"Found method calls: {', '.join(list(method_calls)[:10])}"
        return "No controller method invocations detected"

    def _hint_http_status(self) -> str:
        """Generate hint about HTTP status assertions."""
        all_status_checks = []
        for analysis in self.analyses:
            all_status_checks.extend(analysis.http_status_checks)

        if all_status_checks:
            return f"Found {len(all_status_checks)} HTTP status checks: {', '.join(all_status_checks[:5])}"
        return "No HTTP status code assertions found"

    def _hint_comparators(self) -> str:
        """Generate hint about assertion comparators."""
        summary = self.get_summary()
        assertion_types = summary.get("assertion_types", {})

        if assertion_types:
            top_types = sorted(assertion_types.items(), key=lambda x: x[1], reverse=True)[:5]
            return f"Assertion types used: {', '.join(f'{t}({c})' for t, c in top_types)}"
        return "No assertions found"

    def _hint_boundaries(self) -> str:
        """Generate hint about boundary conditions."""
        all_boundaries = []
        for analysis in self.analyses:
            all_boundaries.extend(analysis.boundary_inputs)

        if all_boundaries:
            unique_boundaries = list(set(all_boundaries))[:10]
            return f"Boundary inputs found: {', '.join(unique_boundaries)}"
        return "No boundary inputs (null, empty, 0, -1) detected"

    def _hint_assertion_quality(self) -> str:
        """Generate hint about assertion quality."""
        summary = self.get_summary()
        assertion_types = summary.get("assertion_types", {})

        null_checks = assertion_types.get("assertNotNull", 0) + assertion_types.get("assertNull", 0)
        value_assertions = assertion_types.get("assertEquals", 0)

        if value_assertions > null_checks:
            return f"Good: More value assertions ({value_assertions}) than null checks ({null_checks})"
        elif null_checks > 0:
            return f"Review: More null checks ({null_checks}) than value assertions ({value_assertions})"
        return "No assertions to evaluate"

    def _hint_boundary_tests(self) -> str:
        """Generate hint about boundary testing."""
        boundary_count = sum(len(a.boundary_inputs) for a in self.analyses)

        if boundary_count > 5:
            return f"Good: {boundary_count} boundary test inputs found"
        elif boundary_count > 0:
            return f"Partial: Only {boundary_count} boundary inputs found"
        return "No boundary test inputs detected"

    def to_json(self) -> str:
        """
        Export analyses to JSON.

        Returns:
            JSON string
        """
        data = {
            "summary": self.get_summary(),
            "evaluation_hints": self.generate_evaluation_hints(),
            "files": [
                {
                    "file_path": a.file_path,
                    "class_name": a.class_name,
                    "total_assertions": a.total_assertions,
                    "assertion_types": a.assertion_types,
                    "test_method_count": len(a.test_methods),
                    "boundary_inputs": a.boundary_inputs[:20],
                    "http_status_checks": a.http_status_checks,
                    "null_checks": a.null_checks
                }
                for a in self.analyses
            ]
        }

        return json.dumps(data, indent=2)


def main():
    """Main entry point for test analysis."""
    import sys

    if len(sys.argv) < 2:
        print("Usage: python test_analyzer.py <tests_dir>")
        sys.exit(1)

    tests_dir = sys.argv[1]
    analyzer = TestAnalyzer(tests_dir)
    analyzer.analyze_all()

    # Print summary
    summary = analyzer.get_summary()
    print("Test Analysis Summary:")
    print(f"  Total files: {summary['total_files']}")
    print(f"  Total test methods: {summary['total_test_methods']}")
    print(f"  Total assertions: {summary['total_assertions']}")
    print(f"  Boundary inputs: {summary['boundary_inputs_found']}")
    print(f"  HTTP status checks: {summary['http_status_checks_found']}")
    print()
    print("Evaluation Hints:")
    hints = analyzer.generate_evaluation_hints()
    for category, items in hints.items():
        print(f"  {category}:")
        for key, value in items.items():
            print(f"    {key}: {value}")


if __name__ == "__main__":
    main()
