#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_OS="${1:-}"

run_linux_analysis() {
    local root_dir="${1:-$SCRIPT_DIR/../generated-tests/blackbox}"
    local output_csv="${2:-$root_dir/evomaster_analysis_$(date +%Y%m%d_%H%M%S).csv}"

    if [ ! -d "$root_dir" ]; then
        echo "Directory not found: $root_dir" >&2
        exit 1
    fi

    printf '"service","profile","file","class","test_method","endpoint","http","asserted_code","assert_count","file_type","file_path"\n' > "$output_csv"

    while IFS= read -r -d '' file; do
        local relative_path="${file#"$root_dir"/}"
        if [ "$relative_path" = "$file" ]; then
            relative_path="${file#"$root_dir"}"
            relative_path="${relative_path#"/"}"
            relative_path="${relative_path#"\\"}"
        fi

        awk \
            -v FILE_PATH="$file" \
            -v FILE_NAME="$(basename "$file")" \
            -v FILE_RELATIVE_PATH="$relative_path" \
            -f "$SCRIPT_DIR/evomaster-analysis.awk" \
            "$file" >> "$output_csv"
    done < <(find "$root_dir" -type f -name '*.java' -print0 | sort -z)

    echo "CSV gerado em: $output_csv"
}

usage() {
    echo "Uso: ./evomaster-analysis.sh [windows|linux] [root_dir] [output_csv]"
}

select_target_os() {
    local selected
    read -r -p "Choose the target system to run the analysis [windows/linux]: " selected
    echo "$selected"
}

if [ -z "$TARGET_OS" ]; then
    TARGET_OS="$(select_target_os)"
else
    shift
fi

case "$TARGET_OS" in
    windows)
        if command -v pwsh >/dev/null 2>&1; then
            exec pwsh -File "$SCRIPT_DIR/evomaster-analysis.ps1" "$@"
        elif command -v powershell.exe >/dev/null 2>&1; then
            exec powershell.exe -ExecutionPolicy Bypass -File "$SCRIPT_DIR/evomaster-analysis.ps1" "$@"
        else
            echo "PowerShell not found to run the windows mode" >&2
            exit 1
        fi
        ;;
    linux)
        if ! command -v awk >/dev/null 2>&1; then
            echo "awk not found to run the linux mode" >&2
            exit 1
        fi
        run_linux_analysis "$@"
        ;;
    *)
        usage
        echo "Invalid system: '$TARGET_OS'. Use 'windows' or 'linux'" >&2
        exit 1
        ;;
esac
