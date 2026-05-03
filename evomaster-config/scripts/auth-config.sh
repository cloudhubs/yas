#!/bin/bash

# Authentication configuration for EvoMaster on YAS (Yet Another Shop)
# YAS uses Keycloak as identity provider (OAuth2/OIDC)

# ============================================
# KEYCLOAK SETTINGS
# ============================================

export KEYCLOAK_URL="${KEYCLOAK_URL:-http://identity}"
export KEYCLOAK_REALM="Yas"
export KEYCLOAK_TOKEN_URL="${KEYCLOAK_URL}/realms/${KEYCLOAK_REALM}/protocol/openid-connect/token"
export KEYCLOAK_ADMIN_URL="${KEYCLOAK_URL}/admin/realms/${KEYCLOAK_REALM}"

# Client used to obtain application user tokens
export KEYCLOAK_CLIENT_ID="backoffice-bff"
export KEYCLOAK_CLIENT_SECRET="TVacLC0cQ8tiiEKiTVerTb2YvwQ1TRJF"

# API base URL
export YAS_API_URL="${YAS_API_URL:-http://api.yas.local}"

# ============================================
# USER CREDENTIALS
# ============================================

# ADMIN user (roles: ADMIN + CUSTOMER via default-roles-yas)
export ADMIN_USERNAME="admin"
export ADMIN_PASSWORD="password"

# CUSTOMER user (role: CUSTOMER only via default-roles-yas)
# Created via Keycloak Admin API if it does not exist
export CUSTOMER_USERNAME="user"
export CUSTOMER_PASSWORD="password"

# ADMIN-ONLY user (role: ADMIN only, without CUSTOMER)
# Created/adjusted via Keycloak Admin API if it does not exist
export ADMIN_ONLY_USERNAME="admin_only"
export ADMIN_ONLY_PASSWORD="password"

# SUPER-ADMIN user (role: SUPER-ADMIN only)
# Created/adjusted via Keycloak Admin API if it does not exist
export SUPER_ADMIN_USERNAME="super_admin"
export SUPER_ADMIN_PASSWORD="password"

# USER user (role: USER only)
# Created/adjusted via Keycloak Admin API if it does not exist
export USER_ROLE_USERNAME="user_role"
export USER_ROLE_PASSWORD="password"

# Keycloak Admin Console credentials (master realm)
export KC_ADMIN_USERNAME="admin"
export KC_ADMIN_PASSWORD="admin"

# ============================================
# AUTHENTICATION FUNCTIONS
# ============================================

# Obtain an OAuth2 token via Resource Owner Password Credentials (ROPC)
# Usage: get_token <username> <password>
get_token() {
    local username="$1"
    local password="$2"

    local response
    response=$(curl -s "${CURL_HOST_RESOLVE[@]}" -X POST "$KEYCLOAK_TOKEN_URL" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "grant_type=password" \
        -d "client_id=${KEYCLOAK_CLIENT_ID}" \
        -d "client_secret=${KEYCLOAK_CLIENT_SECRET}" \
        -d "username=${username}" \
        -d "password=${password}")

    local token
    token=$(echo "$response" | grep -o '"access_token":"[^"]*"' | cut -d'"' -f4)

    if [ -z "$token" ]; then
        echo "Error obtaining token for ${username}. Response: $response" >&2
        return 1
    fi

    echo "$token"
}

get_admin_token() {
    get_token "$ADMIN_USERNAME" "$ADMIN_PASSWORD"
}

get_customer_token() {
    get_token "$CUSTOMER_USERNAME" "$CUSTOMER_PASSWORD"
}

get_admin_only_token() {
    get_token "$ADMIN_ONLY_USERNAME" "$ADMIN_ONLY_PASSWORD"
}

get_super_admin_token() {
    get_token "$SUPER_ADMIN_USERNAME" "$SUPER_ADMIN_PASSWORD"
}

get_user_role_token() {
    get_token "$USER_ROLE_USERNAME" "$USER_ROLE_PASSWORD"
}

# ============================================
# USER MANAGEMENT
# ============================================

# Ensures the CUSTOMER user exists in Keycloak.
# Creates it via Admin API if missing — CUSTOMER role is assigned automatically
# via the default-roles-yas composite role.
ensure_customer_user_exists() {
    echo "Checking user '${CUSTOMER_USERNAME}' in Keycloak..."

    # Obtain admin token from master realm
    local kc_admin_token
    kc_admin_token=$(curl -s "${CURL_HOST_RESOLVE[@]}" -X POST "${KEYCLOAK_URL}/realms/master/protocol/openid-connect/token" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "grant_type=password" \
        -d "client_id=admin-cli" \
        -d "username=${KC_ADMIN_USERNAME}" \
        -d "password=${KC_ADMIN_PASSWORD}" | grep -o '"access_token":"[^"]*"' | cut -d'"' -f4)

    if [ -z "$kc_admin_token" ]; then
        echo "Error: could not obtain Keycloak admin token" >&2
        return 1
    fi

    # Check if user already exists
    local users_response
    users_response=$(curl -s "${CURL_HOST_RESOLVE[@]}" \
        -H "Authorization: Bearer $kc_admin_token" \
        "${KEYCLOAK_ADMIN_URL}/users?username=${CUSTOMER_USERNAME}&exact=true")

    local user_count
    user_count=$(echo "$users_response" | grep -o '"id"' | wc -l)

    if [ "$user_count" -gt 0 ]; then
        echo "✓ User '${CUSTOMER_USERNAME}' already exists"
        return 0
    fi

    echo "Creating user '${CUSTOMER_USERNAME}' with CUSTOMER role..."

    local http_code
    http_code=$(curl -s "${CURL_HOST_RESOLVE[@]}" -o /dev/null -w "%{http_code}" \
        -X POST "${KEYCLOAK_ADMIN_URL}/users" \
        -H "Authorization: Bearer $kc_admin_token" \
        -H "Content-Type: application/json" \
        -d "{
            \"username\": \"${CUSTOMER_USERNAME}\",
            \"enabled\": true,
            \"credentials\": [{
                \"type\": \"password\",
                \"value\": \"${CUSTOMER_PASSWORD}\",
                \"temporary\": false
            }]
        }")

    if [ "$http_code" = "201" ]; then
        echo "✓ User '${CUSTOMER_USERNAME}' created (CUSTOMER role assigned automatically via default-roles-yas)"
    else
        echo "Error creating user (HTTP $http_code)" >&2
        return 1
    fi
}

# Obtain admin token from Keycloak master realm
get_keycloak_admin_token() {
    local kc_admin_token
    kc_admin_token=$(curl -s "${CURL_HOST_RESOLVE[@]}" -X POST "${KEYCLOAK_URL}/realms/master/protocol/openid-connect/token" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "grant_type=password" \
        -d "client_id=admin-cli" \
        -d "username=${KC_ADMIN_USERNAME}" \
        -d "password=${KC_ADMIN_PASSWORD}" | grep -o '"access_token":"[^"]*"' | cut -d'"' -f4)

    if [ -z "$kc_admin_token" ]; then
        echo "Error: could not obtain Keycloak admin token" >&2
        return 1
    fi

    echo "$kc_admin_token"
}

# Ensure a realm role is added/removed for a user
# Usage: update_user_realm_role <admin_token> <user_id> <role_name> <add|remove>
update_user_realm_role() {
    local admin_token="$1"
    local user_id="$2"
    local role_name="$3"
    local action="$4"

    local role_json
    role_json=$(curl -s "${CURL_HOST_RESOLVE[@]}" \
        -H "Authorization: Bearer $admin_token" \
        "${KEYCLOAK_ADMIN_URL}/roles/${role_name}")

    local role_id
    role_id=$(echo "$role_json" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
    if [ -z "$role_id" ]; then
        echo "Error: role '${role_name}' not found in realm '${KEYCLOAK_REALM}'" >&2
        return 1
    fi

    local payload
    payload="[ { \"id\": \"${role_id}\", \"name\": \"${role_name}\" } ]"

    local method
    if [ "$action" = "add" ]; then
        method="POST"
    else
        method="DELETE"
    fi

    local http_code
    http_code=$(curl -s "${CURL_HOST_RESOLVE[@]}" -o /dev/null -w "%{http_code}" -X "$method" \
        "${KEYCLOAK_ADMIN_URL}/users/${user_id}/role-mappings/realm" \
        -H "Authorization: Bearer $admin_token" \
        -H "Content-Type: application/json" \
        -d "$payload")

    if [ "$http_code" != "204" ]; then
        echo "Error: unable to ${action} role '${role_name}' (HTTP $http_code)" >&2
        return 1
    fi
}

# Ensures a realm role exists in Keycloak, creating it if missing.
# Usage: ensure_realm_role_exists <admin_token> <role_name>
ensure_realm_role_exists() {
    local admin_token="$1"
    local role_name="$2"

    local role_json
    role_json=$(curl -s "${CURL_HOST_RESOLVE[@]}" \
        -H "Authorization: Bearer $admin_token" \
        "${KEYCLOAK_ADMIN_URL}/roles/${role_name}")

    if echo "$role_json" | grep -q '"id"'; then
        echo "✓ Role '${role_name}' already exists"
        return 0
    fi

    echo "Creating realm role '${role_name}'..."
    local http_code
    http_code=$(curl -s "${CURL_HOST_RESOLVE[@]}" -o /dev/null -w "%{http_code}" \
        -X POST "${KEYCLOAK_ADMIN_URL}/roles" \
        -H "Authorization: Bearer $admin_token" \
        -H "Content-Type: application/json" \
        -d "{\"name\": \"${role_name}\"}")

    if [ "$http_code" = "201" ]; then
        echo "✓ Role '${role_name}' created"
    else
        echo "Error: could not create role '${role_name}' (HTTP $http_code)" >&2
        return 1
    fi
}

# Ensures the ADMIN-ONLY user exists and has ADMIN but not CUSTOMER.
ensure_admin_only_user_exists() {
    echo "Checking user '${ADMIN_ONLY_USERNAME}' in Keycloak..."

    local kc_admin_token
    kc_admin_token=$(get_keycloak_admin_token) || return 1

    local users_response
    users_response=$(curl -s "${CURL_HOST_RESOLVE[@]}" \
        -H "Authorization: Bearer $kc_admin_token" \
        "${KEYCLOAK_ADMIN_URL}/users?username=${ADMIN_ONLY_USERNAME}&exact=true")

    local user_id
    user_id=$(echo "$users_response" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)

    if [ -z "$user_id" ]; then
        echo "Creating user '${ADMIN_ONLY_USERNAME}' with ADMIN-only profile..."
        local create_code
        create_code=$(curl -s "${CURL_HOST_RESOLVE[@]}" -o /dev/null -w "%{http_code}" \
            -X POST "${KEYCLOAK_ADMIN_URL}/users" \
            -H "Authorization: Bearer $kc_admin_token" \
            -H "Content-Type: application/json" \
            -d "{
                \"username\": \"${ADMIN_ONLY_USERNAME}\",
                \"enabled\": true,
                \"credentials\": [{
                    \"type\": \"password\",
                    \"value\": \"${ADMIN_ONLY_PASSWORD}\",
                    \"temporary\": false
                }]
            }")

        if [ "$create_code" != "201" ]; then
            echo "Error creating user '${ADMIN_ONLY_USERNAME}' (HTTP $create_code)" >&2
            return 1
        fi

        users_response=$(curl -s "${CURL_HOST_RESOLVE[@]}" \
            -H "Authorization: Bearer $kc_admin_token" \
            "${KEYCLOAK_ADMIN_URL}/users?username=${ADMIN_ONLY_USERNAME}&exact=true")
        user_id=$(echo "$users_response" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
    else
        echo "✓ User '${ADMIN_ONLY_USERNAME}' already exists"
    fi

    if [ -z "$user_id" ]; then
        echo "Error: could not resolve id for '${ADMIN_ONLY_USERNAME}'" >&2
        return 1
    fi

    # Remove default composite role and CUSTOMER, then force ADMIN.
    # If some roles are not directly assigned, Keycloak may ignore removals.
    update_user_realm_role "$kc_admin_token" "$user_id" "default-roles-yas" "remove" || true
    update_user_realm_role "$kc_admin_token" "$user_id" "CUSTOMER" "remove" || true
    update_user_realm_role "$kc_admin_token" "$user_id" "ADMIN" "add" || return 1

    local effective_roles
    effective_roles=$(curl -s "${CURL_HOST_RESOLVE[@]}" \
        -H "Authorization: Bearer $kc_admin_token" \
        "${KEYCLOAK_ADMIN_URL}/users/${user_id}/role-mappings/realm/composite")

    if echo "$effective_roles" | grep -q '"name":"CUSTOMER"'; then
        echo "Error: '${ADMIN_ONLY_USERNAME}' still has CUSTOMER role. Check Keycloak role composites." >&2
        return 1
    fi

    if ! echo "$effective_roles" | grep -q '"name":"ADMIN"'; then
        echo "Error: '${ADMIN_ONLY_USERNAME}' does not have ADMIN role after update." >&2
        return 1
    fi

    echo "✓ User '${ADMIN_ONLY_USERNAME}' ready with ADMIN role only"
}

# Ensures SUPER-ADMIN role exists and the super_admin user has only that role.
ensure_super_admin_user_exists() {
    echo "Checking user '${SUPER_ADMIN_USERNAME}' in Keycloak..."

    local kc_admin_token
    kc_admin_token=$(get_keycloak_admin_token) || return 1

    ensure_realm_role_exists "$kc_admin_token" "SUPER-ADMIN" || return 1

    local users_response
    users_response=$(curl -s "${CURL_HOST_RESOLVE[@]}" \
        -H "Authorization: Bearer $kc_admin_token" \
        "${KEYCLOAK_ADMIN_URL}/users?username=${SUPER_ADMIN_USERNAME}&exact=true")

    local user_id
    user_id=$(echo "$users_response" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)

    if [ -z "$user_id" ]; then
        echo "Creating user '${SUPER_ADMIN_USERNAME}'..."
        local create_code
        create_code=$(curl -s "${CURL_HOST_RESOLVE[@]}" -o /dev/null -w "%{http_code}" \
            -X POST "${KEYCLOAK_ADMIN_URL}/users" \
            -H "Authorization: Bearer $kc_admin_token" \
            -H "Content-Type: application/json" \
            -d "{
                \"username\": \"${SUPER_ADMIN_USERNAME}\",
                \"enabled\": true,
                \"credentials\": [{
                    \"type\": \"password\",
                    \"value\": \"${SUPER_ADMIN_PASSWORD}\",
                    \"temporary\": false
                }]
            }")

        if [ "$create_code" != "201" ]; then
            echo "Error creating user '${SUPER_ADMIN_USERNAME}' (HTTP $create_code)" >&2
            return 1
        fi

        users_response=$(curl -s "${CURL_HOST_RESOLVE[@]}" \
            -H "Authorization: Bearer $kc_admin_token" \
            "${KEYCLOAK_ADMIN_URL}/users?username=${SUPER_ADMIN_USERNAME}&exact=true")
        user_id=$(echo "$users_response" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
    else
        echo "✓ User '${SUPER_ADMIN_USERNAME}' already exists"
    fi

    if [ -z "$user_id" ]; then
        echo "Error: could not resolve id for '${SUPER_ADMIN_USERNAME}'" >&2
        return 1
    fi

    update_user_realm_role "$kc_admin_token" "$user_id" "default-roles-yas" "remove" || true
    update_user_realm_role "$kc_admin_token" "$user_id" "CUSTOMER" "remove" || true
    update_user_realm_role "$kc_admin_token" "$user_id" "ADMIN" "remove" || true
    update_user_realm_role "$kc_admin_token" "$user_id" "SUPER-ADMIN" "add" || return 1

    local effective_roles
    effective_roles=$(curl -s "${CURL_HOST_RESOLVE[@]}" \
        -H "Authorization: Bearer $kc_admin_token" \
        "${KEYCLOAK_ADMIN_URL}/users/${user_id}/role-mappings/realm/composite")

    if ! echo "$effective_roles" | grep -q '"name":"SUPER-ADMIN"'; then
        echo "Error: '${SUPER_ADMIN_USERNAME}' does not have SUPER-ADMIN role after update." >&2
        return 1
    fi

    echo "✓ User '${SUPER_ADMIN_USERNAME}' ready with SUPER-ADMIN role only"
}

# Ensures USER role exists and the user_role user has only that role.
ensure_user_role_user_exists() {
    echo "Checking user '${USER_ROLE_USERNAME}' in Keycloak..."

    local kc_admin_token
    kc_admin_token=$(get_keycloak_admin_token) || return 1

    ensure_realm_role_exists "$kc_admin_token" "USER" || return 1

    local users_response
    users_response=$(curl -s "${CURL_HOST_RESOLVE[@]}" \
        -H "Authorization: Bearer $kc_admin_token" \
        "${KEYCLOAK_ADMIN_URL}/users?username=${USER_ROLE_USERNAME}&exact=true")

    local user_id
    user_id=$(echo "$users_response" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)

    if [ -z "$user_id" ]; then
        echo "Creating user '${USER_ROLE_USERNAME}'..."
        local create_code
        create_code=$(curl -s "${CURL_HOST_RESOLVE[@]}" -o /dev/null -w "%{http_code}" \
            -X POST "${KEYCLOAK_ADMIN_URL}/users" \
            -H "Authorization: Bearer $kc_admin_token" \
            -H "Content-Type: application/json" \
            -d "{
                \"username\": \"${USER_ROLE_USERNAME}\",
                \"enabled\": true,
                \"credentials\": [{
                    \"type\": \"password\",
                    \"value\": \"${USER_ROLE_PASSWORD}\",
                    \"temporary\": false
                }]
            }")

        if [ "$create_code" != "201" ]; then
            echo "Error creating user '${USER_ROLE_USERNAME}' (HTTP $create_code)" >&2
            return 1
        fi

        users_response=$(curl -s "${CURL_HOST_RESOLVE[@]}" \
            -H "Authorization: Bearer $kc_admin_token" \
            "${KEYCLOAK_ADMIN_URL}/users?username=${USER_ROLE_USERNAME}&exact=true")
        user_id=$(echo "$users_response" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
    else
        echo "✓ User '${USER_ROLE_USERNAME}' already exists"
    fi

    if [ -z "$user_id" ]; then
        echo "Error: could not resolve id for '${USER_ROLE_USERNAME}'" >&2
        return 1
    fi

    update_user_realm_role "$kc_admin_token" "$user_id" "default-roles-yas" "remove" || true
    update_user_realm_role "$kc_admin_token" "$user_id" "CUSTOMER" "remove" || true
    update_user_realm_role "$kc_admin_token" "$user_id" "USER" "add" || return 1

    local effective_roles
    effective_roles=$(curl -s "${CURL_HOST_RESOLVE[@]}" \
        -H "Authorization: Bearer $kc_admin_token" \
        "${KEYCLOAK_ADMIN_URL}/users/${user_id}/role-mappings/realm/composite")

    if ! echo "$effective_roles" | grep -q '"name":"USER"'; then
        echo "Error: '${USER_ROLE_USERNAME}' does not have USER role after update." >&2
        return 1
    fi

    echo "✓ User '${USER_ROLE_USERNAME}' ready with USER role only"
}