#!/usr/bin/env python3

from __future__ import annotations

import argparse
import csv
import ctypes
import hashlib
import os
import re
import shutil
import stat
import subprocess
import textwrap
import time
import xml.etree.ElementTree as ET
from dataclasses import dataclass
from pathlib import Path
from typing import Optional


CLASS_PATTERN = re.compile(r"(?m)^\s*public\s+class\s+([A-Za-z0-9_]+)")
IMPORT_PATTERN = re.compile(r"(?m)^\s*import\s+(?:static\s+)?([^;]+);")
METHOD_PATTERN = re.compile(
    r"(?ms)(?P<comment>/\*\*.*?\*/)?\s*"
    r"(?P<annotations>(?:@\w+(?:\([^)]*\))?\s*)+)"
    r"public\s+void\s+(?P<method>[A-Za-z0-9_]+)\s*\(\)\s*throws\s+Exception\s*\{"
    r"(?P<body>.*?)^\s*\}"
)
CALL_COMMENT_PATTERN = re.compile(r"\(\d+\)\s+([A-Z]+):([^\r\n\s*]+)")
CALL_COMMENT_ENTRY_PATTERN = re.compile(
    r"^\s*\*\s*(?:(?P<index>\d+)\s*-\s*)?\((?P<status>\d+)\)\s+(?P<http>[A-Z]+):(?P<endpoint>[^\r\n*]+)$",
    re.MULTILINE,
)
REQUEST_PATTERN = re.compile(
    r'\.(get|post|put|patch|delete)\(\s*baseUrlOfSut\s*\+\s*"([^"]+)"',
    re.IGNORECASE,
)
ASSERT_STATUS_PATTERN = re.compile(r"\.statusCode\((\d+)\)")
ASSERT_PATTERN = re.compile(
    r"\.(statusCode|body|header|headers|contentType|statusLine|time|cookie|cookies)\("
)
DIAGNOSTIC_PATTERN = re.compile(
    r"^\[ERROR\]\s+(?P<file>.+?\.java):\[(?P<line>\d+),(?P<column>\d+)\]\s+(?P<message>.+)$"
)
TEST_SUMMARY_PATTERN = re.compile(
    r"Tests run:\s*(?P<run>\d+),\s*Failures:\s*(?P<failures>\d+),\s*Errors:\s*(?P<errors>\d+),\s*Skipped:\s*(?P<skipped>\d+)"
)
EXCEPTION_PATTERN = re.compile(r"\b([A-Za-z_][A-Za-z0-9_$.]*(?:Exception|Error))\b")

SYNTAX_ERROR_PATTERNS = (
    "illegal start of",
    "reached end of file while parsing",
    "';' expected",
    "')' expected",
    "',' expected",
    "not a statement",
    "class, interface, enum, or record expected",
)
TYPE_ERROR_PATTERNS = (
    "incompatible types",
    "cannot be converted",
    "bad operand types",
    "inference variable",
    "no instance(s) of type variable",
)
GENERIC_ERROR_PATTERNS = (
    "type argument",
    "cannot infer type arguments",
    "raw type",
    "generic",
)
DEPENDENCY_ERROR_PATTERNS = (
    "could not resolve dependencies",
    "could not find artifact",
    "failed to collect dependencies",
)
IGNORED_RUNTIME_EXCEPTIONS = {
    "LifecycleExecutionException",
    "MojoFailureException",
    "MojoExecutionException",
}
CSV_HEADERS = [
    "service",
    "profile",
    "file",
    "class",
    "test_method",
    "is_complex_method",
    "call_index",
    "call_expected_status_code",
    "endpoint",
    "http",
    "asserted_code",
    "asserts_the_expected_HTTP_status_codes?",
    "assert_count",
    "missing_url_parameter_values",
    "missing_request_body",
    "credentials_header",
    "file_type",
    "file_path",
    "imports_count",
    "wildcard_imports",
    "compiled",
    "compile_error_count",
    "compile_error_types",
    "missing_imports",
    "incorrect_imports",
    "unused_imports",
    "dependency_availability_pct",
    "syntax_errors",
    "type_errors",
    "undefined_variables",
    "type_annotation_errors",
    "generic_type_misuses",
    "compile_exit_code",
    "compile_timeout",
    "compile_error_summary",
    "class_log_dir",
    "compile_log_path",
    "compile_stdout_log_path",
    "compile_stderr_log_path",
    "runs",
    "run_detected",
    "runtime_error_count",
    "runtime_error_types",
    "run_exit_code",
    "run_timeout",
    "execution_seconds",
    "cpu_seconds",
    "peak_working_set_mb",
    "run_error_summary",
    "method_log_dir",
    "run_log_path",
    "run_stdout_log_path",
    "run_stderr_log_path",
]


@dataclass
class MethodInfo:
    service: str
    profile: str
    file_name: str
    class_name: str
    method_name: str
    is_complex_method: bool
    call_index: int
    call_expected_status_code: str
    endpoint: str
    http: str
    asserted_code: str
    asserts_the_expected_http_status_codes: str
    assert_count: int
    missing_url_parameter_values: str
    missing_request_body: str
    credentials_header: str
    file_type: str
    file_path: Path
    start_line: int
    end_line: int


@dataclass
class ClassInfo:
    service: str
    profile: str
    file_name: str
    class_name: str
    file_type: str
    file_path: Path
    imports: list[str]
    import_line_numbers: set[int]
    wildcard_imports: int
    methods: list[MethodInfo]


@dataclass
class ProcessMetrics:
    exit_code: int
    timed_out: bool
    execution_seconds: float
    cpu_seconds: Optional[float]
    peak_working_set_mb: Optional[float]
    stdout_log_path: Path
    stderr_log_path: Path
    combined_log_path: Path
    combined_log: str


@dataclass
class CompileMetrics:
    compiled: bool
    error_count: int
    error_types: str
    missing_imports: int
    incorrect_imports: int
    unused_imports: str
    dependency_availability_pct: str
    syntax_errors: int
    type_errors: int
    undefined_variables: int
    type_annotation_errors: int
    generic_type_misuses: int
    error_summary: str
    process: ProcessMetrics
    class_log_dir: Path


@dataclass
class RunMetrics:
    runs: bool
    run_detected: bool
    error_count: Optional[int]
    error_types: str
    error_summary: str
    process: Optional[ProcessMetrics]
    method_log_dir: Optional[Path]


@dataclass
class SurefireMethodResult:
    run_detected: bool
    runtime_error_count: Optional[int]
    error_types: set[str]
    error_summary: str


@dataclass
class CommentCall:
    index: int
    expected_status_code: str
    http: str
    endpoint: str


@dataclass
class RequestBlock:
    ordinal: int
    http: str
    endpoint: str
    asserted_code: str
    asserts_the_expected_http_status_codes: str
    assert_count: int
    missing_url_parameter_values: str
    missing_request_body: str
    credentials_header: str


def parse_args() -> argparse.Namespace:
    script_dir = Path(__file__).resolve().parent
    default_root = (script_dir / ".." / "generated-tests" / "blackbox").resolve()
    default_temp = (script_dir / ".." / "tmp-test-runner").resolve()
    default_logs = (script_dir / ".." / "runtime-logs").resolve()
    stamp = time.strftime("%Y%m%d_%H%M%S")
    default_csv = default_root / f"evomaster_method_analysis_{stamp}.csv"

    parser = argparse.ArgumentParser(
        description="Index EvoMaster generated tests, compile them by class, run them by method, and generate a single CSV report."
    )
    parser.add_argument("--root-dir", default=str(default_root))
    parser.add_argument("--output-csv", default=str(default_csv))
    parser.add_argument("--temp-root", default=str(default_temp))
    parser.add_argument("--log-root", default=str(default_logs))
    parser.add_argument("--timeout-sec", type=int, default=300)
    parser.add_argument("--maven-command", default="mvn")
    parser.add_argument("--java-release", default="21")
    parser.add_argument("--evomaster-dependency-version", default="5.1.0")
    parser.add_argument("--targets-file")
    return parser.parse_args()


def resolve_path(value: str) -> Path:
    return Path(value).expanduser().resolve()


def get_file_type(file_name: str) -> str:
    lowered = file_name.lower()
    if "faults" in lowered:
        return "faults"
    if "successes" in lowered:
        return "successes"
    if "others" in lowered:
        return "others"
    return "unknown"


def get_class_name(content: str) -> str:
    match = CLASS_PATTERN.search(content)
    return match.group(1) if match else ""


def get_import_line_numbers(lines: list[str]) -> set[int]:
    line_numbers: set[int] = set()
    for index, line in enumerate(lines, start=1):
        if line.strip().startswith("import "):
            line_numbers.add(index)
    return line_numbers


def get_endpoint_info(comment: str, body: str) -> tuple[str, str]:
    if comment:
        comment_match = CALL_COMMENT_PATTERN.search(comment)
        if comment_match:
            return comment_match.group(1), comment_match.group(2)

    request_match = REQUEST_PATTERN.search(body)
    if request_match:
        return request_match.group(1).upper(), request_match.group(2)

    return "", ""


def get_asserted_status_code(body: str) -> str:
    unique_codes: list[str] = []
    for match in ASSERT_STATUS_PATTERN.finditer(body):
        code = match.group(1)
        if code not in unique_codes:
            unique_codes.append(code)
    return ";".join(unique_codes)


def get_assert_count(body: str) -> int:
    then_index = body.find(".then()")
    assertion_body = body[then_index:] if then_index >= 0 else body
    return len(ASSERT_PATTERN.findall(assertion_body))


def parse_comment_calls(comment: str) -> list[CommentCall]:
    calls: list[CommentCall] = []
    for ordinal, match in enumerate(CALL_COMMENT_ENTRY_PATTERN.finditer(comment), start=1):
        index = int(match.group("index")) if match.group("index") else ordinal
        calls.append(
            CommentCall(
                index=index,
                expected_status_code=match.group("status"),
                http=normalize_http(match.group("http")),
                endpoint=normalize_endpoint(match.group("endpoint").strip()),
            )
        )
    return calls


def extract_call_from_dot(body: str, dot_index: int) -> str:
    if dot_index < 0 or dot_index >= len(body) or body[dot_index] != ".":
        return ""

    open_paren = body.find("(", dot_index)
    if open_paren < 0:
        return ""

    depth = 0
    in_string = False
    escaping = False

    for index in range(open_paren, len(body)):
        char = body[index]

        if in_string:
            if escaping:
                escaping = False
            elif char == "\\":
                escaping = True
            elif char == '"':
                in_string = False
            continue

        if char == '"':
            in_string = True
            continue

        if char == "(":
            depth += 1
            continue

        if char == ")":
            depth -= 1
            if depth == 0:
                return body[dot_index : index + 1].strip()

    return ""


def get_first_http_call(body: str) -> tuple[str, int]:
    request_match = re.search(r"\.(get|post|put|patch|delete)\(", body, re.IGNORECASE)
    if not request_match:
        return "", -1

    dot_index = request_match.start()
    return extract_call_from_dot(body, dot_index), dot_index


def get_missing_url_parameter_values(body: str) -> str:
    http_call, _ = get_first_http_call(body)
    return http_call


def get_missing_request_body(body: str) -> str:
    _, http_index = get_first_http_call(body)
    if http_index < 0:
        return ""

    prefix = body[:http_index]
    body_calls: list[str] = []
    seen: set[str] = set()

    for match in re.finditer(r"\.body\(", prefix):
        snippet = extract_call_from_dot(prefix, match.start())
        if snippet and snippet not in seen:
            seen.add(snippet)
            body_calls.append(snippet)

    return " | ".join(body_calls)


def get_asserts_the_expected_http_status_codes(body: str) -> str:
    snippets: list[str] = []
    seen: set[str] = set()

    for match in re.finditer(r"\.statusCode\(\d+\)", body):
        status_call = extract_call_from_dot(body, match.start())
        if not status_call:
            continue

        search_index = match.start() + len(status_call)
        tail = body[search_index:]
        assert_match = re.match(r"\s*\.assertThat\(\)", tail)
        if not assert_match:
            continue

        assert_snippet = ".assertThat()"
        combined = f"{status_call} {assert_snippet}"
        if combined not in seen:
            seen.add(combined)
            snippets.append(combined)

    return " | ".join(snippets)


def get_credentials_header(body: str) -> str:
    snippets: list[str] = []

    for match in re.finditer(r"\.header\(", body):
        snippet = extract_call_from_dot(body, match.start())
        if not snippet:
            continue
        lowered = snippet.lower()
        if "authorization" not in lowered and "bearer" not in lowered:
            continue
        snippets.append(snippet)

    return " | ".join(snippets)


def split_java_statements(body: str) -> list[str]:
    statements: list[str] = []
    start = 0
    in_string = False
    escaping = False

    for index, char in enumerate(body):
        if in_string:
            if escaping:
                escaping = False
            elif char == "\\":
                escaping = True
            elif char == '"':
                in_string = False
            continue

        if char == '"':
            in_string = True
            continue

        if char == ";":
            snippet = body[start : index + 1].strip()
            if snippet:
                statements.append(snippet)
            start = index + 1

    tail = body[start:].strip()
    if tail:
        statements.append(tail)

    return statements


def extract_endpoint_from_http_call(http_call: str) -> str:
    string_parts = re.findall(r'"((?:[^"\\]|\\.)*)"', http_call)
    if not string_parts:
        return ""

    combined = "".join(string_parts)
    if not combined:
        return ""

    path = combined.split("?", 1)[0].strip()
    return normalize_endpoint(path)


def endpoint_matches_call(actual_endpoint: str, expected_endpoint: str) -> bool:
    normalized_actual = normalize_endpoint(actual_endpoint)
    normalized_expected = normalize_endpoint(expected_endpoint)
    if not normalized_actual or not normalized_expected:
        return False

    actual_parts = [part for part in normalized_actual.strip("/").split("/") if part]
    expected_parts = [part for part in normalized_expected.strip("/").split("/") if part]
    if len(actual_parts) != len(expected_parts):
        return False

    for actual_part, expected_part in zip(actual_parts, expected_parts):
        if expected_part.startswith("{") and expected_part.endswith("}"):
            continue
        if actual_part != expected_part:
            return False

    return True


def parse_request_blocks(body: str) -> list[RequestBlock]:
    blocks: list[RequestBlock] = []
    for ordinal, statement in enumerate(split_java_statements(body), start=1):
        if "given()" not in statement:
            continue

        http_call, _ = get_first_http_call(statement)
        if not http_call:
            continue

        request_match = REQUEST_PATTERN.search(statement)
        http = request_match.group(1).upper() if request_match else ""
        blocks.append(
            RequestBlock(
                ordinal=ordinal,
                http=http,
                endpoint=extract_endpoint_from_http_call(http_call),
                asserted_code=get_asserted_status_code(statement),
                asserts_the_expected_http_status_codes=get_asserts_the_expected_http_status_codes(statement),
                assert_count=get_assert_count(statement),
                missing_url_parameter_values=http_call,
                missing_request_body=get_missing_request_body(statement),
                credentials_header=get_credentials_header(statement),
            )
        )

    return blocks


def join_values(values: list[str]) -> str:
    return " | ".join([value for value in values if value])


def get_all_missing_url_parameter_values(request_blocks: list[RequestBlock], body: str) -> str:
    if request_blocks:
        return join_values([block.missing_url_parameter_values for block in request_blocks])
    return get_missing_url_parameter_values(body)


def get_all_missing_request_body_values(request_blocks: list[RequestBlock], body: str) -> str:
    if request_blocks:
        return join_values([block.missing_request_body for block in request_blocks])
    return get_missing_request_body(body)


def get_all_credentials_headers(request_blocks: list[RequestBlock], body: str) -> str:
    if request_blocks:
        return join_values([block.credentials_header for block in request_blocks])
    return get_credentials_header(body)


def method_info_from_block(
    *,
    service: str,
    profile: str,
    file_name: str,
    class_name: str,
    method_name: str,
    file_type: str,
    file_path: Path,
    start_line: int,
    end_line: int,
    is_complex_method: bool,
    call_index: int,
    call_expected_status_code: str,
    block: RequestBlock,
) -> MethodInfo:
    return MethodInfo(
        service=service,
        profile=profile,
        file_name=file_name,
        class_name=class_name,
        method_name=method_name,
        is_complex_method=is_complex_method,
        call_index=call_index,
        call_expected_status_code=call_expected_status_code,
        endpoint=block.endpoint,
        http=block.http,
        asserted_code=block.asserted_code,
        asserts_the_expected_http_status_codes=block.asserts_the_expected_http_status_codes,
        assert_count=block.assert_count,
        missing_url_parameter_values=block.missing_url_parameter_values,
        missing_request_body=block.missing_request_body,
        credentials_header=block.credentials_header,
        file_type=file_type,
        file_path=file_path,
        start_line=start_line,
        end_line=end_line,
    )


def build_method_infos(
    *,
    service: str,
    profile: str,
    file_name: str,
    class_name: str,
    method_name: str,
    file_type: str,
    file_path: Path,
    start_line: int,
    end_line: int,
    comment: str,
    body: str,
) -> list[MethodInfo]:
    comment_calls = parse_comment_calls(comment)
    request_blocks = parse_request_blocks(body)
    is_complex_method = len(request_blocks) > 1 or len(comment_calls) > 1
    aggregated_asserted_code = get_asserted_status_code(body)
    aggregated_asserts = get_asserts_the_expected_http_status_codes(body)
    aggregated_assert_count = get_assert_count(body)
    aggregated_missing_url_parameter_values = get_all_missing_url_parameter_values(request_blocks, body)
    aggregated_missing_request_body = get_all_missing_request_body_values(request_blocks, body)
    aggregated_credentials_header = get_all_credentials_headers(request_blocks, body)

    if len(comment_calls) <= 1:
        http, endpoint = get_endpoint_info(comment, body)
        return [
            MethodInfo(
                service=service,
                profile=profile,
                file_name=file_name,
                class_name=class_name,
                method_name=method_name,
                is_complex_method=is_complex_method,
                call_index=1,
                call_expected_status_code=comment_calls[0].expected_status_code if comment_calls else "",
                endpoint=endpoint,
                http=http,
                asserted_code=aggregated_asserted_code,
                asserts_the_expected_http_status_codes=aggregated_asserts,
                assert_count=aggregated_assert_count,
                missing_url_parameter_values=aggregated_missing_url_parameter_values,
                missing_request_body=aggregated_missing_request_body,
                credentials_header=aggregated_credentials_header,
                file_type=file_type,
                file_path=file_path,
                start_line=start_line,
                end_line=end_line,
            )
        ]

    if comment_calls:
        return [
            MethodInfo(
                service=service,
                profile=profile,
                file_name=file_name,
                class_name=class_name,
                method_name=method_name,
                is_complex_method=is_complex_method,
                call_index=comment_call.index or fallback_index,
                call_expected_status_code=comment_call.expected_status_code,
                endpoint=comment_call.endpoint,
                http=comment_call.http,
                asserted_code=aggregated_asserted_code,
                asserts_the_expected_http_status_codes=aggregated_asserts,
                assert_count=aggregated_assert_count,
                missing_url_parameter_values=aggregated_missing_url_parameter_values,
                missing_request_body=aggregated_missing_request_body,
                credentials_header=aggregated_credentials_header,
                file_type=file_type,
                file_path=file_path,
                start_line=start_line,
                end_line=end_line,
            )
            for fallback_index, comment_call in enumerate(comment_calls, start=1)
        ]

    if request_blocks:
        return [
            method_info_from_block(
                service=service,
                profile=profile,
                file_name=file_name,
                class_name=class_name,
                method_name=method_name,
                file_type=file_type,
                file_path=file_path,
                start_line=start_line,
                end_line=end_line,
                is_complex_method=is_complex_method,
                call_index=index,
                call_expected_status_code=block.asserted_code,
                block=block,
            )
            for index, block in enumerate(request_blocks, start=1)
        ]

    http, endpoint = get_endpoint_info(comment, body)
    return [
        MethodInfo(
            service=service,
            profile=profile,
            file_name=file_name,
            class_name=class_name,
            method_name=method_name,
            is_complex_method=is_complex_method,
            call_index=1,
            call_expected_status_code="",
            endpoint=endpoint,
            http=http,
            asserted_code=get_asserted_status_code(body),
            asserts_the_expected_http_status_codes=get_asserts_the_expected_http_status_codes(body),
            assert_count=get_assert_count(body),
            missing_url_parameter_values=get_missing_url_parameter_values(body),
            missing_request_body=get_missing_request_body(body),
            credentials_header=get_credentials_header(body),
            file_type=file_type,
            file_path=file_path,
            start_line=start_line,
            end_line=end_line,
        )
    ]


def count_newlines_until(content: str, position: int) -> int:
    return content.count("\n", 0, position) + 1


def parse_java_file(root_dir: Path, file_path: Path) -> ClassInfo:
    content = file_path.read_text(encoding="utf-8", errors="replace")
    lines = content.splitlines()
    relative_parts = file_path.relative_to(root_dir).parts
    service = relative_parts[0] if len(relative_parts) >= 1 else ""
    profile = relative_parts[1] if len(relative_parts) >= 2 else ""
    file_name = file_path.name
    class_name = get_class_name(content)
    file_type = get_file_type(file_name)
    imports = IMPORT_PATTERN.findall(content)
    methods: list[MethodInfo] = []

    for match in METHOD_PATTERN.finditer(content):
        comment = match.group("comment") or ""
        body = match.group("body") or ""
        methods.extend(
            build_method_infos(
                service=service,
                profile=profile,
                file_name=file_name,
                class_name=class_name,
                method_name=match.group("method"),
                file_type=file_type,
                file_path=file_path,
                start_line=count_newlines_until(content, match.start()),
                end_line=count_newlines_until(content, match.end()),
                comment=comment,
                body=body,
            )
        )

    if not methods:
        methods.append(
            MethodInfo(
                service=service,
                profile=profile,
                file_name=file_name,
                class_name=class_name,
                method_name="",
                is_complex_method=False,
                call_index=1,
                call_expected_status_code="",
                endpoint="",
                http="",
                asserted_code="",
                asserts_the_expected_http_status_codes="",
                assert_count=0,
                missing_url_parameter_values="",
                missing_request_body="",
                credentials_header="",
                file_type=file_type,
                file_path=file_path,
                start_line=1,
                end_line=len(lines),
            )
        )

    return ClassInfo(
        service=service,
        profile=profile,
        file_name=file_name,
        class_name=class_name,
        file_type=file_type,
        file_path=file_path,
        imports=imports,
        import_line_numbers=get_import_line_numbers(lines),
        wildcard_imports=sum(1 for item in imports if item.endswith(".*")),
        methods=methods,
    )


def normalize_http(value: str) -> str:
    return value.strip().upper()


def normalize_endpoint(value: str) -> str:
    normalized = value.strip()
    if not normalized:
        return ""
    if not normalized.startswith("/"):
        normalized = "/" + normalized
    normalized = re.sub(r"/+", "/", normalized)
    return normalized.rstrip("/") or "/"


def endpoint_without_service_prefix(endpoint: str, service: str) -> str:
    normalized_endpoint = normalize_endpoint(endpoint)
    normalized_service = service.strip().strip("/")
    if not normalized_service:
        return normalized_endpoint

    service_prefix = f"/{normalized_service}"
    if normalized_endpoint == service_prefix:
        return "/"
    if normalized_endpoint.startswith(service_prefix + "/"):
        return normalized_endpoint[len(service_prefix) :]
    return normalized_endpoint


def load_targets_file(path: Path) -> set[tuple[str, str]]:
    targets: set[tuple[str, str]] = set()
    for raw_line in path.read_text(encoding="utf-8", errors="replace").splitlines():
        line = raw_line.strip()
        if not line:
            continue
        lowered = line.lower()
        if lowered == "target endpoint":
            continue
        if lowered.startswith("#"):
            continue

        match = re.match(r"^(GET|POST|PUT|PATCH|DELETE)\s*:\s*(.+)$", line, re.IGNORECASE)
        if not match:
            match = re.match(r"^(GET|POST|PUT|PATCH|DELETE)\s+(.+)$", line, re.IGNORECASE)
        if not match:
            continue

        targets.add((normalize_http(match.group(1)), normalize_endpoint(match.group(2))))
    return targets


def services_from_targets(targets: set[tuple[str, str]]) -> set[str]:
    services: set[str] = set()
    for _, endpoint in targets:
        normalized = normalize_endpoint(endpoint)
        parts = [part for part in normalized.split("/") if part]
        if parts:
            services.add(parts[0])
    return services


def resolve_allowed_services(root_dir: Path, targets: set[tuple[str, str]]) -> Optional[set[str]]:
    """
    YAS stores generated tests under root/<service>/<profile>/..., so the first
    path segment of the endpoint is a good pre-filter for services.

    Other projects, such as Train Ticket, can expose endpoints like /api/v1/...
    while the generated-test directories use unrelated service names
    (eg. ts-admin-basic-service). In those layouts, pre-filtering by the first
    endpoint segment would incorrectly eliminate every class before we even match
    methods.

    To keep the YAS optimization without breaking other layouts, only apply the
    service pre-filter when the inferred names actually exist as directories
    under the chosen root_dir.
    """
    inferred_services = services_from_targets(targets)
    if not inferred_services:
        return None

    existing_services = {
        service for service in inferred_services if (root_dir / service).exists()
    }
    return existing_services or None


def method_matches_targets(method: MethodInfo, targets: set[tuple[str, str]]) -> bool:
    method_http = normalize_http(method.http)
    if not method_http:
        return False

    full_endpoint = normalize_endpoint(method.endpoint)
    service_relative_endpoint = endpoint_without_service_prefix(method.endpoint, method.service)

    for target_http, target_endpoint in targets:
        if method_http != target_http:
            continue
        if full_endpoint == target_endpoint or service_relative_endpoint == target_endpoint:
            return True

    return False


def filter_classes_by_targets(
    classes: list[ClassInfo], targets: set[tuple[str, str]]
) -> list[ClassInfo]:
    filtered_classes: list[ClassInfo] = []

    for class_info in classes:
        matching_methods = [
            method for method in class_info.methods if method_matches_targets(method, targets)
        ]
        if not matching_methods:
            continue

        filtered_classes.append(
            ClassInfo(
                service=class_info.service,
                profile=class_info.profile,
                file_name=class_info.file_name,
                class_name=class_info.class_name,
                file_type=class_info.file_type,
                file_path=class_info.file_path,
                imports=class_info.imports,
                import_line_numbers=class_info.import_line_numbers,
                wildcard_imports=class_info.wildcard_imports,
                methods=matching_methods,
            )
        )

    return filtered_classes


def safe_name(value: str) -> str:
    sanitized = re.sub(r"[^A-Za-z0-9._-]+", "_", value.strip())
    return sanitized or "_"


def resolve_maven_executable(command: str) -> str:
    resolved = shutil.which(command)
    if resolved:
        return resolved

    if Path(command).exists():
        return str(Path(command).resolve())

    raise FileNotFoundError(f"Unable to locate Maven command '{command}'.")


def build_maven_command(maven_executable: str, arguments: list[str]) -> list[str]:
    if os.name == "nt" and maven_executable.lower().endswith((".cmd", ".bat")):
        return ["cmd.exe", "/c", maven_executable, *arguments]
    return [maven_executable, *arguments]


def build_runner_pom(java_release: str, dependency_version: str) -> str:
    return textwrap.dedent(
        f"""\
        <project xmlns="http://maven.apache.org/POM/4.0.0"
                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
          <modelVersion>4.0.0</modelVersion>
          <groupId>com.yas.evomaster</groupId>
          <artifactId>generated-test-runner</artifactId>
          <version>1.0-SNAPSHOT</version>

          <properties>
            <maven.compiler.release>{java_release}</maven.compiler.release>
            <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
            <junit.jupiter.version>5.12.2</junit.jupiter.version>
            <rest.assured.version>5.5.1</rest.assured.version>
            <evomaster.version>{dependency_version}</evomaster.version>
            <maven.surefire.version>3.5.2</maven.surefire.version>
          </properties>

          <dependencies>
            <dependency>
              <groupId>org.junit.jupiter</groupId>
              <artifactId>junit-jupiter-api</artifactId>
              <version>${{junit.jupiter.version}}</version>
              <scope>test</scope>
            </dependency>
            <dependency>
              <groupId>org.junit.jupiter</groupId>
              <artifactId>junit-jupiter-engine</artifactId>
              <version>${{junit.jupiter.version}}</version>
              <scope>test</scope>
            </dependency>
            <dependency>
              <groupId>io.rest-assured</groupId>
              <artifactId>rest-assured</artifactId>
              <version>${{rest.assured.version}}</version>
              <scope>test</scope>
            </dependency>
            <dependency>
              <groupId>org.hamcrest</groupId>
              <artifactId>hamcrest</artifactId>
              <version>3.0</version>
              <scope>test</scope>
            </dependency>
            <dependency>
              <groupId>org.evomaster</groupId>
              <artifactId>evomaster-client-java-controller-api</artifactId>
              <version>${{evomaster.version}}</version>
              <scope>test</scope>
            </dependency>
            <dependency>
              <groupId>org.evomaster</groupId>
              <artifactId>evomaster-client-java-controller</artifactId>
              <version>${{evomaster.version}}</version>
              <scope>test</scope>
            </dependency>
            <dependency>
              <groupId>org.evomaster</groupId>
              <artifactId>evomaster-test-utils-java</artifactId>
              <version>${{evomaster.version}}</version>
              <scope>test</scope>
            </dependency>
          </dependencies>

          <build>
            <plugins>
              <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.13.0</version>
                <configuration>
                  <release>{java_release}</release>
                </configuration>
              </plugin>
              <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>${{maven.surefire.version}}</version>
                <configuration>
                  <useModulePath>false</useModulePath>
                  <failIfNoTests>false</failIfNoTests>
                  <failIfNoSpecifiedTests>true</failIfNoSpecifiedTests>
                </configuration>
              </plugin>
            </plugins>
          </build>
        </project>
        """
    )


def work_dir_for(temp_root: Path, class_info: ClassInfo) -> Path:
    relative_key = str(class_info.file_path).encode("utf-8", errors="replace")
    digest = hashlib.sha256(relative_key).hexdigest()[:12]
    return temp_root / class_info.service / class_info.profile / digest


def handle_remove_readonly(function, path, excinfo) -> None:
    try:
        os.chmod(path, stat.S_IWRITE)
        function(path)
    except OSError:
        raise excinfo[1]


def remove_tree_if_exists(path: Path, retries: int = 8, delay_seconds: float = 0.5) -> None:
    if not path.exists():
        return

    last_error: Optional[Exception] = None
    for _ in range(retries):
        try:
            shutil.rmtree(path, onexc=handle_remove_readonly)
            return
        except OSError as exc:
            last_error = exc
            time.sleep(delay_seconds)

    if last_error is not None:
        raise last_error


def create_project_layout(work_dir: Path, class_info: ClassInfo, java_release: str, dependency_version: str) -> None:
    if work_dir.exists():
        remove_tree_if_exists(work_dir)

    test_source_dir = work_dir / "src" / "test" / "java"
    test_source_dir.mkdir(parents=True, exist_ok=True)
    shutil.copy2(class_info.file_path, test_source_dir / class_info.file_name)
    (work_dir / "pom.xml").write_text(
        build_runner_pom(java_release, dependency_version),
        encoding="utf-8",
    )


def get_process_sample(pid: int) -> tuple[Optional[float], Optional[float]]:
    if os.name == "nt":
        return get_windows_process_sample(pid)
    return get_linux_process_sample(pid)


def get_linux_process_sample(pid: int) -> tuple[Optional[float], Optional[float]]:
    status_path = Path(f"/proc/{pid}/status")
    stat_path = Path(f"/proc/{pid}/stat")
    if not status_path.exists() or not stat_path.exists():
        return None, None

    memory_mb: Optional[float] = None
    cpu_seconds: Optional[float] = None

    try:
        status_text = status_path.read_text(encoding="utf-8", errors="replace")
        match = re.search(r"VmRSS:\s+(\d+)\s+kB", status_text)
        if match:
            memory_mb = round(int(match.group(1)) / 1024.0, 2)
    except OSError:
        memory_mb = None

    try:
        fields = stat_path.read_text(encoding="utf-8", errors="replace").split()
        ticks = os.sysconf(os.sysconf_names["SC_CLK_TCK"])
        cpu_seconds = round((int(fields[13]) + int(fields[14])) / float(ticks), 2)
    except (IndexError, OSError, ValueError, KeyError):
        cpu_seconds = None

    return memory_mb, cpu_seconds


def get_windows_process_sample(pid: int) -> tuple[Optional[float], Optional[float]]:
    PROCESS_QUERY_INFORMATION = 0x0400
    PROCESS_VM_READ = 0x0010

    class FILETIME(ctypes.Structure):
        _fields_ = [("dwLowDateTime", ctypes.c_ulong), ("dwHighDateTime", ctypes.c_ulong)]

    class PROCESS_MEMORY_COUNTERS(ctypes.Structure):
        _fields_ = [
            ("cb", ctypes.c_ulong),
            ("PageFaultCount", ctypes.c_ulong),
            ("PeakWorkingSetSize", ctypes.c_size_t),
            ("WorkingSetSize", ctypes.c_size_t),
            ("QuotaPeakPagedPoolUsage", ctypes.c_size_t),
            ("QuotaPagedPoolUsage", ctypes.c_size_t),
            ("QuotaPeakNonPagedPoolUsage", ctypes.c_size_t),
            ("QuotaNonPagedPoolUsage", ctypes.c_size_t),
            ("PagefileUsage", ctypes.c_size_t),
            ("PeakPagefileUsage", ctypes.c_size_t),
        ]

    kernel32 = ctypes.windll.kernel32
    psapi = ctypes.windll.psapi
    handle = kernel32.OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, False, pid)
    if not handle:
        return None, None

    memory_mb: Optional[float] = None
    cpu_seconds: Optional[float] = None

    try:
        counters = PROCESS_MEMORY_COUNTERS()
        counters.cb = ctypes.sizeof(PROCESS_MEMORY_COUNTERS)
        if psapi.GetProcessMemoryInfo(handle, ctypes.byref(counters), counters.cb):
            memory_mb = round(counters.WorkingSetSize / (1024.0 * 1024.0), 2)

        creation = FILETIME()
        exit_time = FILETIME()
        kernel_time = FILETIME()
        user_time = FILETIME()
        if kernel32.GetProcessTimes(
            handle,
            ctypes.byref(creation),
            ctypes.byref(exit_time),
            ctypes.byref(kernel_time),
            ctypes.byref(user_time),
        ):
            kernel_ticks = (kernel_time.dwHighDateTime << 32) | kernel_time.dwLowDateTime
            user_ticks = (user_time.dwHighDateTime << 32) | user_time.dwLowDateTime
            cpu_seconds = round((kernel_ticks + user_ticks) / 10_000_000.0, 2)
    finally:
        kernel32.CloseHandle(handle)

    return memory_mb, cpu_seconds


def kill_process_tree(process: subprocess.Popen[bytes]) -> None:
    if os.name == "nt":
        subprocess.run(
            ["taskkill", "/PID", str(process.pid), "/T", "/F"],
            check=False,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        return

    try:
        os.killpg(os.getpgid(process.pid), 9)
    except ProcessLookupError:
        pass


def combine_logs(stdout_path: Path, stderr_path: Path, combined_path: Path) -> str:
    stdout_text = stdout_path.read_text(encoding="utf-8", errors="replace") if stdout_path.exists() else ""
    stderr_text = stderr_path.read_text(encoding="utf-8", errors="replace") if stderr_path.exists() else ""
    combined = (stdout_text + ("\n" if stdout_text and stderr_text else "") + stderr_text).strip()
    combined_path.write_text(combined, encoding="utf-8")
    return combined


def run_command(
    command: list[str],
    cwd: Path,
    timeout_sec: int,
    stdout_path: Path,
    stderr_path: Path,
    combined_path: Path,
) -> ProcessMetrics:
    stdout_path.parent.mkdir(parents=True, exist_ok=True)
    stderr_path.parent.mkdir(parents=True, exist_ok=True)

    creationflags = 0
    if os.name == "nt" and hasattr(subprocess, "CREATE_NO_WINDOW"):
        creationflags = subprocess.CREATE_NO_WINDOW

    start = time.monotonic()
    peak_working_set_mb = 0.0
    cpu_seconds = 0.0
    timed_out = False

    with stdout_path.open("wb") as stdout_file, stderr_path.open("wb") as stderr_file:
        process = subprocess.Popen(
            command,
            cwd=str(cwd),
            stdout=stdout_file,
            stderr=stderr_file,
            creationflags=creationflags,
            start_new_session=os.name != "nt",
        )

        while process.poll() is None:
            memory_sample, cpu_sample = get_process_sample(process.pid)
            if memory_sample is not None:
                peak_working_set_mb = max(peak_working_set_mb, memory_sample)
            if cpu_sample is not None:
                cpu_seconds = max(cpu_seconds, cpu_sample)

            if time.monotonic() - start >= timeout_sec:
                timed_out = True
                kill_process_tree(process)
                break

            time.sleep(0.5)

        try:
            process.wait(timeout=30)
        except subprocess.TimeoutExpired:
            timed_out = True
            kill_process_tree(process)
            process.wait(timeout=30)

        memory_sample, cpu_sample = get_process_sample(process.pid)
        if memory_sample is not None:
            peak_working_set_mb = max(peak_working_set_mb, memory_sample)
        if cpu_sample is not None:
            cpu_seconds = max(cpu_seconds, cpu_sample)

    combined_log = combine_logs(stdout_path, stderr_path, combined_path)
    return ProcessMetrics(
        exit_code=process.returncode if process.returncode is not None else -1,
        timed_out=timed_out,
        execution_seconds=round(time.monotonic() - start, 2),
        cpu_seconds=round(cpu_seconds, 2) if cpu_seconds else None,
        peak_working_set_mb=round(peak_working_set_mb, 2) if peak_working_set_mb else None,
        stdout_log_path=stdout_path.resolve(),
        stderr_log_path=stderr_path.resolve(),
        combined_log_path=combined_path.resolve(),
        combined_log=combined_log,
    )


def parse_compile_diagnostics(combined_log: str) -> list[dict[str, object]]:
    diagnostics: list[dict[str, object]] = []
    current: Optional[dict[str, object]] = None

    for raw_line in combined_log.splitlines():
        line = raw_line.rstrip()
        match = DIAGNOSTIC_PATTERN.match(line)
        if match:
            if current:
                diagnostics.append(current)
            current = {
                "line": int(match.group("line")),
                "column": int(match.group("column")),
                "message": match.group("message").strip(),
                "details": [],
            }
            continue

        if current and line.startswith("[ERROR]   "):
            current["details"].append(line[len("[ERROR]   ") :].strip())
            continue

        if current and not line.startswith("[ERROR]   "):
            diagnostics.append(current)
            current = None

    if current:
        diagnostics.append(current)

    unique: list[dict[str, object]] = []
    seen: set[tuple[int, int, str]] = set()
    for diagnostic in diagnostics:
        key = (
            int(diagnostic["line"]),
            int(diagnostic["column"]),
            str(diagnostic["message"]),
        )
        if key in seen:
            continue
        seen.add(key)
        unique.append(diagnostic)

    return unique


def first_matching_line(combined_log: str, patterns: tuple[str, ...]) -> str:
    for line in combined_log.splitlines():
        lowered = line.lower()
        if any(pattern in lowered for pattern in patterns):
            return line.strip()
    return ""


def iter_surefire_report_dirs(work_dir: Path, preferred_dir: Path) -> list[Path]:
    candidates = [preferred_dir, work_dir / "target" / "surefire-reports"]
    seen: set[Path] = set()
    resolved: list[Path] = []

    for candidate in candidates:
        try:
            normalized = candidate.resolve()
        except OSError:
            normalized = candidate
        if normalized in seen or not candidate.exists() or not candidate.is_dir():
            continue
        seen.add(normalized)
        resolved.append(candidate)

    return resolved


def testcase_matches_class(testcase_classname: str, class_name: str) -> bool:
    return testcase_classname == class_name or testcase_classname.endswith(f".{class_name}")


def summarize_surefire_reports(
    report_dirs: list[Path],
    class_name: str,
    method_name: str,
) -> SurefireMethodResult:
    for report_dir in report_dirs:
        for xml_path in sorted(report_dir.glob("TEST-*.xml")):
            try:
                root = ET.parse(xml_path).getroot()
            except ET.ParseError:
                continue

            matched_testcase: Optional[ET.Element] = None
            for testcase in root.findall(".//testcase"):
                testcase_name = testcase.attrib.get("name", "")
                testcase_classname = testcase.attrib.get("classname", "")
                if testcase_name != method_name:
                    continue
                if class_name and not testcase_matches_class(testcase_classname, class_name):
                    continue
                matched_testcase = testcase
                break

            if matched_testcase is None:
                continue

            error_types: set[str] = set()
            runtime_error_count = 0
            error_summary = ""

            for failure in matched_testcase.findall("failure"):
                runtime_error_count += 1
                error_types.add("test_failure")
                failure_type = failure.attrib.get("type", "").strip()
                if failure_type:
                    error_types.add(failure_type)
                if not error_summary:
                    error_summary = failure.attrib.get("message", "").strip()

            for error in matched_testcase.findall("error"):
                runtime_error_count += 1
                error_types.add("test_error")
                error_type = error.attrib.get("type", "").strip()
                if error_type:
                    error_types.add(error_type)
                if not error_summary:
                    error_summary = error.attrib.get("message", "").strip()

            if matched_testcase.find("skipped") is not None and runtime_error_count == 0:
                error_summary = error_summary or "Test was skipped"

            return SurefireMethodResult(
                run_detected=True,
                runtime_error_count=runtime_error_count,
                error_types=error_types,
                error_summary=error_summary,
            )

    return SurefireMethodResult(
        run_detected=False,
        runtime_error_count=None,
        error_types=set(),
        error_summary="",
    )


def summarize_compile(class_info: ClassInfo, process: ProcessMetrics, class_log_dir: Path) -> CompileMetrics:
    diagnostics = parse_compile_diagnostics(process.combined_log)
    error_types: set[str] = set()
    missing_imports = 0
    incorrect_imports = 0
    syntax_errors = 0
    type_errors = 0
    undefined_variables = 0
    type_annotation_errors = 0
    generic_type_misuses = 0

    for diagnostic in diagnostics:
        message = str(diagnostic["message"]).lower()
        details_blob = " ".join(str(item).lower() for item in diagnostic["details"])
        line_number = int(diagnostic["line"])
        is_import_line = line_number in class_info.import_line_numbers

        if is_import_line and "package " in message and " does not exist" in message:
            missing_imports += 1
            error_types.add("missing_import")
        elif is_import_line and ("cannot find symbol" in message or "cannot access" in message):
            incorrect_imports += 1
            error_types.add("incorrect_import")

        if any(pattern in message for pattern in SYNTAX_ERROR_PATTERNS):
            syntax_errors += 1
            error_types.add("syntax_error")

        if any(pattern in message or pattern in details_blob for pattern in TYPE_ERROR_PATTERNS):
            type_errors += 1
            error_types.add("type_error")

        if "cannot find symbol" in message and "symbol:   variable" in details_blob:
            undefined_variables += 1
            error_types.add("undefined_variable")

        if "annotation" in message or "annotation" in details_blob:
            type_annotation_errors += 1
            error_types.add("annotation_error")

        if any(pattern in message or pattern in details_blob for pattern in GENERIC_ERROR_PATTERNS):
            generic_type_misuses += 1
            error_types.add("generic_type_misuse")

    lowered_log = process.combined_log.lower()
    if any(pattern in lowered_log for pattern in DEPENDENCY_ERROR_PATTERNS):
        error_types.add("dependency_resolution")

    if process.timed_out:
        error_types.add("compile_timeout")

    if process.exit_code != 0 and not error_types:
        error_types.add("compilation_error")

    total_imports = len(class_info.imports)
    resolved_imports = max(total_imports - missing_imports - incorrect_imports, 0)
    dependency_pct = "100.0"
    if total_imports > 0:
        dependency_pct = f"{round((resolved_imports / total_imports) * 100.0, 2)}"

    if "dependency_resolution" in error_types and total_imports > 0:
        dependency_pct = "0.0"

    error_count = len(diagnostics)
    if error_count == 0 and process.exit_code != 0:
        error_count = 1

    compiled = process.exit_code == 0 and not process.timed_out
    error_summary = ""
    if diagnostics:
        error_summary = str(diagnostics[0]["message"])
    elif process.timed_out:
        error_summary = f"Compilation timed out after {process.execution_seconds}s"
    else:
        error_summary = first_matching_line(
            process.combined_log,
            DEPENDENCY_ERROR_PATTERNS + ("compilation error", "[error]"),
        )

    return CompileMetrics(
        compiled=compiled,
        error_count=error_count,
        error_types=";".join(sorted(error_types)),
        missing_imports=missing_imports,
        incorrect_imports=incorrect_imports,
        unused_imports="",
        dependency_availability_pct=dependency_pct,
        syntax_errors=syntax_errors,
        type_errors=type_errors,
        undefined_variables=undefined_variables,
        type_annotation_errors=type_annotation_errors,
        generic_type_misuses=generic_type_misuses,
        error_summary=error_summary,
        process=process,
        class_log_dir=class_log_dir.resolve(),
    )


def summarize_run(
    process: ProcessMetrics,
    method_log_dir: Path,
    surefire_dir: Path,
    work_dir: Path,
    class_name: str,
    method_name: str,
) -> RunMetrics:
    summary_matches = list(TEST_SUMMARY_PATTERN.finditer(process.combined_log))
    surefire_result = summarize_surefire_reports(
        iter_surefire_report_dirs(work_dir, surefire_dir),
        class_name,
        method_name,
    )
    run_detected = bool(summary_matches) or surefire_dir.exists() or surefire_result.run_detected
    runtime_error_count: Optional[int] = None
    error_types: set[str] = set()
    error_summary = ""

    if summary_matches:
        summary = summary_matches[-1]
        failures = int(summary.group("failures"))
        errors = int(summary.group("errors"))
        runtime_error_count = failures + errors
        if failures:
            error_types.add("test_failure")
        if errors:
            error_types.add("test_error")
        if runtime_error_count:
            error_summary = summary.group(0)
    elif surefire_result.run_detected:
        runtime_error_count = surefire_result.runtime_error_count
        error_types.update(surefire_result.error_types)
        error_summary = surefire_result.error_summary

    exception_types = {
        item
        for item in EXCEPTION_PATTERN.findall(process.combined_log)
        if item not in IGNORED_RUNTIME_EXCEPTIONS
    }
    error_types.update(sorted(exception_types))

    if process.timed_out:
        error_types.add("timeout")
        runtime_error_count = (runtime_error_count or 0) + 1
        if not error_summary:
            error_summary = f"Execution timed out after {process.execution_seconds}s"

    if process.exit_code != 0 and not error_types:
        error_types.add("maven_failure")
        runtime_error_count = runtime_error_count if runtime_error_count is not None else 1

    if not error_summary:
        error_summary = first_matching_line(
            process.combined_log,
            ("tests run:", "exception", "[error]", "timeout"),
        )
    if not error_summary and surefire_result.run_detected:
        if runtime_error_count in (None, 0):
            error_summary = "Test passed (detected via Surefire XML)"
        else:
            error_summary = surefire_result.error_summary

    runs = (
        process.exit_code == 0
        and not process.timed_out
        and run_detected
        and (runtime_error_count in (None, 0))
    )

    return RunMetrics(
        runs=runs,
        run_detected=run_detected,
        error_count=runtime_error_count if run_detected or process.timed_out or process.exit_code != 0 else None,
        error_types=";".join(sorted(error_types)),
        error_summary=error_summary,
        process=process,
        method_log_dir=method_log_dir.resolve(),
    )


def compile_class(
    class_info: ClassInfo,
    work_dir: Path,
    maven_executable: str,
    timeout_sec: int,
    log_root: Path,
) -> CompileMetrics:
    class_log_dir = log_root / "classes" / class_info.service / class_info.profile / safe_name(class_info.class_name or class_info.file_name)
    class_log_dir.mkdir(parents=True, exist_ok=True)

    process = run_command(
        build_maven_command(maven_executable, ["-q", "-DskipTests", "test-compile"]),
        cwd=work_dir,
        timeout_sec=timeout_sec,
        stdout_path=class_log_dir / "compile_stdout.log",
        stderr_path=class_log_dir / "compile_stderr.log",
        combined_path=class_log_dir / "compile.log",
    )
    return summarize_compile(class_info, process, class_log_dir)


def run_method(
    class_info: ClassInfo,
    method: MethodInfo,
    work_dir: Path,
    maven_executable: str,
    timeout_sec: int,
    log_root: Path,
) -> RunMetrics:
    if not method.method_name or not class_info.class_name:
        return RunMetrics(
            runs=False,
            run_detected=False,
            error_count=None,
            error_types="",
            error_summary="",
            process=None,
            method_log_dir=None,
        )

    method_log_dir = (
        log_root
        / "methods"
        / class_info.service
        / class_info.profile
        / safe_name(class_info.class_name or class_info.file_name)
        / safe_name(method.method_name)
    )
    method_log_dir.mkdir(parents=True, exist_ok=True)

    surefire_dir = method_log_dir / f"surefire-reports-{time.time_ns()}"

    process = run_command(
        build_maven_command(
            maven_executable,
            [
                "-q",
                f"-Dtest={class_info.class_name}#{method.method_name}",
                "-DfailIfNoTests=false",
                "-Dsurefire.failIfNoSpecifiedTests=false",
                f"-Dsurefire.reportsDirectory={surefire_dir}",
                "surefire:test",
            ],
        ),
        cwd=work_dir,
        timeout_sec=timeout_sec,
        stdout_path=method_log_dir / "run_stdout.log",
        stderr_path=method_log_dir / "run_stderr.log",
        combined_path=method_log_dir / "run.log",
    )
    return summarize_run(
        process,
        method_log_dir,
        surefire_dir,
        work_dir,
        class_info.class_name,
        method.method_name,
    )


def stringify_path(value: Optional[Path]) -> str:
    return str(value.resolve()) if value else ""


def optional_number(value: Optional[float]) -> str:
    if value is None:
        return ""
    return str(value)


def write_row(
    writer: csv.DictWriter,
    class_info: ClassInfo,
    method: MethodInfo,
    compile_metrics: CompileMetrics,
    run_metrics: RunMetrics,
) -> None:
    compile_process = compile_metrics.process
    run_process = run_metrics.process

    writer.writerow(
        {
            "service": method.service,
            "profile": method.profile,
            "file": method.file_name,
            "class": method.class_name,
            "test_method": method.method_name,
            "is_complex_method": method.is_complex_method,
            "call_index": method.call_index,
            "call_expected_status_code": method.call_expected_status_code,
            "endpoint": method.endpoint,
            "http": method.http,
            "asserted_code": method.asserted_code,
            "asserts_the_expected_HTTP_status_codes?": method.asserts_the_expected_http_status_codes,
            "assert_count": method.assert_count,
            "missing_url_parameter_values": method.missing_url_parameter_values,
            "missing_request_body": method.missing_request_body,
            "credentials_header": method.credentials_header,
            "file_type": method.file_type,
            "file_path": str(method.file_path.resolve()),
            "imports_count": len(class_info.imports),
            "wildcard_imports": class_info.wildcard_imports,
            "compiled": compile_metrics.compiled,
            "compile_error_count": compile_metrics.error_count,
            "compile_error_types": compile_metrics.error_types,
            "missing_imports": compile_metrics.missing_imports,
            "incorrect_imports": compile_metrics.incorrect_imports,
            "unused_imports": compile_metrics.unused_imports,
            "dependency_availability_pct": compile_metrics.dependency_availability_pct,
            "syntax_errors": compile_metrics.syntax_errors,
            "type_errors": compile_metrics.type_errors,
            "undefined_variables": compile_metrics.undefined_variables,
            "type_annotation_errors": compile_metrics.type_annotation_errors,
            "generic_type_misuses": compile_metrics.generic_type_misuses,
            "compile_exit_code": compile_process.exit_code,
            "compile_timeout": compile_process.timed_out,
            "compile_error_summary": compile_metrics.error_summary,
            "class_log_dir": stringify_path(compile_metrics.class_log_dir),
            "compile_log_path": stringify_path(compile_process.combined_log_path),
            "compile_stdout_log_path": stringify_path(compile_process.stdout_log_path),
            "compile_stderr_log_path": stringify_path(compile_process.stderr_log_path),
            "runs": run_metrics.runs,
            "run_detected": run_metrics.run_detected,
            "runtime_error_count": "" if run_metrics.error_count is None else run_metrics.error_count,
            "runtime_error_types": run_metrics.error_types,
            "run_exit_code": "" if not run_process else run_process.exit_code,
            "run_timeout": "" if not run_process else run_process.timed_out,
            "execution_seconds": "" if not run_process else optional_number(run_process.execution_seconds),
            "cpu_seconds": "" if not run_process else optional_number(run_process.cpu_seconds),
            "peak_working_set_mb": "" if not run_process else optional_number(run_process.peak_working_set_mb),
            "run_error_summary": run_metrics.error_summary,
            "method_log_dir": stringify_path(run_metrics.method_log_dir),
            "run_log_path": "" if not run_process else stringify_path(run_process.combined_log_path),
            "run_stdout_log_path": "" if not run_process else stringify_path(run_process.stdout_log_path),
            "run_stderr_log_path": "" if not run_process else stringify_path(run_process.stderr_log_path),
        }
    )


def collect_classes(root_dir: Path, allowed_services: Optional[set[str]] = None) -> list[ClassInfo]:
    java_files: list[Path] = []

    if allowed_services:
        for service in sorted(allowed_services):
            service_dir = root_dir / service
            if service_dir.exists():
                java_files.extend(sorted(service_dir.rglob("*.java")))
    else:
        java_files = sorted(root_dir.rglob("*.java"))

    return [parse_java_file(root_dir, path) for path in java_files]


def ensure_parent(path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)


def main() -> int:
    args = parse_args()
    root_dir = resolve_path(args.root_dir)
    output_csv = resolve_path(args.output_csv)
    temp_root = resolve_path(args.temp_root)
    log_root = resolve_path(args.log_root)
    targets_file = resolve_path(args.targets_file) if args.targets_file else None

    if not root_dir.exists():
        raise FileNotFoundError(f"Directory not found: {root_dir}")
    if targets_file and not targets_file.exists():
        raise FileNotFoundError(f"Targets file not found: {targets_file}")

    maven_executable = resolve_maven_executable(args.maven_command)
    targets: Optional[set[tuple[str, str]]] = None
    allowed_services: Optional[set[str]] = None

    if targets_file:
        targets = load_targets_file(targets_file)
        allowed_services = resolve_allowed_services(root_dir, targets)

    classes = collect_classes(root_dir, allowed_services=allowed_services)
    if targets_file:
        assert targets is not None
        classes = filter_classes_by_targets(classes, targets)
        if not classes:
            raise ValueError(f"No methods matched the targets file: {targets_file}")

    ensure_parent(output_csv)
    temp_root.mkdir(parents=True, exist_ok=True)
    log_root.mkdir(parents=True, exist_ok=True)

    with output_csv.open("w", newline="", encoding="utf-8") as csv_file:
        writer = csv.DictWriter(csv_file, fieldnames=CSV_HEADERS)
        writer.writeheader()

        for class_info in classes:
            work_dir = work_dir_for(temp_root, class_info)
            create_project_layout(
                work_dir,
                class_info,
                java_release=args.java_release,
                dependency_version=args.evomaster_dependency_version,
            )
            compile_metrics = compile_class(
                class_info=class_info,
                work_dir=work_dir,
                maven_executable=maven_executable,
                timeout_sec=args.timeout_sec,
                log_root=log_root,
            )

            for method in class_info.methods:
                if compile_metrics.compiled:
                    run_metrics = run_method(
                        class_info=class_info,
                        method=method,
                        work_dir=work_dir,
                        maven_executable=maven_executable,
                        timeout_sec=args.timeout_sec,
                        log_root=log_root,
                    )
                else:
                    run_metrics = RunMetrics(
                        runs=False,
                        run_detected=False,
                        error_count=None,
                        error_types="",
                        error_summary="",
                        process=None,
                        method_log_dir=None,
                    )

                write_row(writer, class_info, method, compile_metrics, run_metrics)

    print(f"CSV gerado em: {output_csv}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
