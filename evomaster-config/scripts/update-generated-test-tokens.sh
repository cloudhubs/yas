#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET_DIR_DEFAULT="$ROOT_DIR/generated-tests/blackbox"

source "$SCRIPT_DIR/auth-config.sh"

RESOLVE_IP="${EVOMASTER_HOST_RESOLVE:-}"
if [ "${EVOMASTER_NO_AUTO_HOST_RESOLVE:-}" != "1" ]; then
    if [ -z "$RESOLVE_IP" ] && ! getent hosts identity >/dev/null 2>&1; then
        RESOLVE_IP="127.0.0.1"
    fi
fi
if [ -n "$RESOLVE_IP" ]; then
    CURL_HOST_RESOLVE=(--resolve "api.yas.local:80:${RESOLVE_IP}" --resolve "identity:80:${RESOLVE_IP}")
    echo "Using curl --resolve for api.yas.local/identity -> ${RESOLVE_IP}"
fi

TARGET_DIR="$TARGET_DIR_DEFAULT"
ROLE_FILTER=""
DRY_RUN=0

usage() {
    cat <<EOF
Usage: $(basename "$0") [--role ROLE] [--dir PATH] [--dry-run]

Refresh expired Authorization bearer tokens in generated EvoMaster Java tests.
Only the token value inside '.header("Authorization", "Bearer ...")' is changed.

Options:
  --role ROLE   Update only one role directory: admin, admin_only, customer, none
  --dir PATH    Override the base directory to scan
  --dry-run     Show what would change without editing files
  --help        Show this help
EOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --role)
            ROLE_FILTER="${2:-}"
            shift 2
            ;;
        --dir)
            TARGET_DIR="${2:-}"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=1
            shift
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            echo "Unknown argument: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
done

if [ ! -d "$TARGET_DIR" ]; then
    echo "Target directory not found: $TARGET_DIR" >&2
    exit 1
fi

get_role_token() {
    local role="$1"

    case "$role" in
        admin)
            get_admin_token
            ;;
        admin_only)
            ensure_admin_only_user_exists >&2
            get_admin_only_token
            ;;
        customer)
            ensure_customer_user_exists >&2
            get_customer_token
            ;;
        none)
            echo ""
            ;;
        *)
            echo "Unsupported role for token refresh: $role" >&2
            return 1
            ;;
    esac
}

update_file_tokens() {
    local file="$1"
    local token="$2"
    local mode="$3"
    local count

    count=$(grep -c '\.header("Authorization", "Bearer ' "$file" || true)
    if [ "$count" -eq 0 ]; then
        return 0
    fi

    if [ "$mode" = "dry-run" ]; then
        echo "Would update $count token line(s) in $file"
        return 0
    fi

    TOKEN="$token" perl -0pi -e 's/(\.header\("Authorization", "Bearer )[^"]*(".*)/$1$ENV{TOKEN}$2/g' "$file"
    echo "Updated $count token line(s) in $file"
}

roles=()
if [ -n "$ROLE_FILTER" ]; then
    roles+=("$ROLE_FILTER")
else
    while IFS= read -r role; do
        roles+=("$role")
    done < <(find "$TARGET_DIR" -mindepth 2 -maxdepth 2 -type d -printf '%f\n' | sort -u)
fi

total_files=0
total_lines=0

for role in "${roles[@]}"; do
    case "$role" in
        admin|admin_only|customer|none)
            ;;
        *)
            echo "Skipping unsupported role directory '$role'"
            continue
            ;;
    esac

    mapfile -t files < <(find "$TARGET_DIR" -type f -path "*/${role}/*.java" | sort)
    if [ "${#files[@]}" -eq 0 ]; then
        echo "No Java files found for role '$role' under $TARGET_DIR"
        continue
    fi

    if [ "$role" = "none" ]; then
        echo "Skipping role 'none' (no token expected)"
        continue
    fi

    echo "Refreshing token for role '$role'..."
    token="$(get_role_token "$role")"
    if [ -z "$token" ]; then
        echo "Failed to obtain token for role '$role'" >&2
        exit 1
    fi

    role_files=0
    role_lines=0

    for file in "${files[@]}"; do
        matches=$(grep -c '\.header("Authorization", "Bearer ' "$file" || true)
        if [ "$matches" -eq 0 ]; then
            continue
        fi

        update_file_tokens "$file" "$token" "$([ "$DRY_RUN" -eq 1 ] && echo dry-run || echo apply)"
        role_files=$((role_files + 1))
        role_lines=$((role_lines + matches))
    done

    echo "Role '$role': ${role_files} file(s), ${role_lines} token line(s)"
    total_files=$((total_files + role_files))
    total_lines=$((total_lines + role_lines))
done

if [ "$DRY_RUN" -eq 1 ]; then
    echo "Dry-run complete: ${total_files} file(s), ${total_lines} token line(s) would be updated."
else
    echo "Token refresh complete: ${total_files} file(s), ${total_lines} token line(s) updated."
fi
