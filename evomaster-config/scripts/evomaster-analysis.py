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
    "endpoint",
    "http",
    "asserted_code",
    "assert_count",
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
    endpoint: str
    http: str
    asserted_code: str
    assert_count: int
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
    parser.add_argument("--evomaster-dependency-version", default="5.0.2")
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
        http, endpoint = get_endpoint_info(comment, body)
        methods.append(
            MethodInfo(
                service=service,
                profile=profile,
                file_name=file_name,
                class_name=class_name,
                method_name=match.group("method"),
                endpoint=endpoint,
                http=http,
                asserted_code=get_asserted_status_code(body),
                assert_count=get_assert_count(body),
                file_type=file_type,
                file_path=file_path,
                start_line=count_newlines_until(content, match.start()),
                end_line=count_newlines_until(content, match.end()),
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
                endpoint="",
                http="",
                asserted_code="",
                assert_count=0,
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


def summarize_run(process: ProcessMetrics, method_log_dir: Path, surefire_dir: Path) -> RunMetrics:
    summary_matches = list(TEST_SUMMARY_PATTERN.finditer(process.combined_log))
    run_detected = bool(summary_matches) or surefire_dir.exists()
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
    return summarize_run(process, method_log_dir, surefire_dir)


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
            "endpoint": method.endpoint,
            "http": method.http,
            "asserted_code": method.asserted_code,
            "assert_count": method.assert_count,
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
        allowed_services = services_from_targets(targets)

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
