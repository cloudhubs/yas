#!/usr/bin/env bash
# setup-auth.sh — seed Keycloak users for YAS synthetic test data
# Keycloak v26 — accepts "id" in POST body
# Usage: bash setup-auth.sh [KC_BASE_URL] [REALM] [ADMIN_USER] [ADMIN_PASS]

set -euo pipefail

KC_BASE="${1:-http://identity.yas.local}"
REALM="${2:-Yas}"
ADMIN_USER="${3:-admin}"
ADMIN_PASS="${4:-admin}"
CUSTOMER_PASS="customer123"
ADMIN_KC_PASS="admin123"

echo "==> Keycloak: $KC_BASE  realm: $REALM"

# ---------- 1. Admin token ----------
TOKEN=$(curl -s -X POST \
  "$KC_BASE/realms/master/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=password&client_id=admin-cli&username=$ADMIN_USER&password=$ADMIN_PASS" \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['access_token'])")

echo "==> Token acquired"

# ---------- helper functions ----------
create_user() {
  local UUID="$1" USERNAME="$2" EMAIL="$3" PASS="$4"
  HTTP=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
    "$KC_BASE/admin/realms/$REALM/users" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{
      \"id\": \"$UUID\",
      \"username\": \"$USERNAME\",
      \"email\": \"$EMAIL\",
      \"enabled\": true,
      \"emailVerified\": true,
      \"credentials\": [{\"type\": \"password\", \"value\": \"$PASS\", \"temporary\": false}]
    }")
  if [[ "$HTTP" != "201" && "$HTTP" != "409" ]]; then
    echo "  WARN: $USERNAME → HTTP $HTTP"
  fi
}

assign_role() {
  local UUID="$1" ROLE_NAME="$2"
  ROLE_JSON=$(curl -s \
    "$KC_BASE/admin/realms/$REALM/roles/$ROLE_NAME" \
    -H "Authorization: Bearer $TOKEN")
  ROLE_ID=$(echo "$ROLE_JSON" | python3 -c "import sys,json; print(json.load(sys.stdin)['id'])")
  curl -s -o /dev/null -X POST \
    "$KC_BASE/admin/realms/$REALM/users/$UUID/role-mappings/realm" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "[{\"id\": \"$ROLE_ID\", \"name\": \"$ROLE_NAME\"}]"
}

# ---------- 2. Group 2 — CUSTOMER users (aaaaaaaa prefix) ----------
echo "==> Creating group 2 CUSTOMER users (aaaaaaaa)..."
NAMES_A=(nguyen_customer tran_customer le_customer pham_customer hoang_customer
         vo_customer bui_customer do_customer vu_customer dang_customer
         ngo_customer ly_customer mai_customer cao_customer dinh_customer
         trinh_customer dao_customer truong_customer luong_customer phan_customer
         ha_customer tien_customer hung_customer duc_customer hai_customer
         thanh_customer khanh_customer son_customer minh_customer long_customer
         nam_customer tuan_customer hieu_customer an_customer binh_customer
         cuong_customer hoa_customer thu_customer oanh_customer kim_customer
         lan_customer bich_customer huyen_customer thuy_customer nga_customer
         linh_customer thao_customer phuong_customer ngoc_customer hang_customer)
IDX=1
for NAME in "${NAMES_A[@]}"; do
  N=$(printf "%04d" $IDX)
  UUID="aaaaaaaa-${N}-4000-a000-$(printf "%012d" $IDX)"
  create_user "$UUID" "$NAME" "${NAME}@yas.local" "$CUSTOMER_PASS"
  assign_role "$UUID" "CUSTOMER"
  IDX=$((IDX+1))
done

# ---------- 3. Group 3 — CUSTOMER users (bbbbbbbb prefix) ----------
echo "==> Creating group 3 CUSTOMER users (bbbbbbbb)..."
NAMES_B=(a_addr b_addr c_addr d_addr e_addr f_addr g_addr h_addr i_addr j_addr
         k_addr l_addr m_addr n_addr o_addr p_addr q_addr r_addr s_addr t_addr
         u_addr v_addr w_addr x_addr y_addr z_addr aa_addr bb_addr cc_addr dd_addr
         ee_addr ff_addr gg_addr hh_addr ii_addr jj_addr kk_addr ll_addr mm_addr nn_addr
         oo_addr pp_addr qq_addr rr_addr ss_addr tt_addr uu_addr vv_addr ww_addr xx_addr)
IDX=1
for NAME in "${NAMES_B[@]}"; do
  N=$(printf "%04d" $IDX)
  UUID="bbbbbbbb-${N}-4000-a000-$(printf "%012d" $IDX)"
  create_user "$UUID" "${NAME}" "${NAME}@yas.local" "$CUSTOMER_PASS"
  assign_role "$UUID" "CUSTOMER"
  IDX=$((IDX+1))
done

# ---------- 4. Group 4 — CUSTOMER users (cccccccc prefix) ----------
echo "==> Creating group 4 CUSTOMER users (cccccccc)..."
IDX=1
while [ $IDX -le 50 ]; do
  N=$(printf "%04d" $IDX)
  UUID="cccccccc-${N}-4000-a000-$(printf "%012d" $IDX)"
  create_user "$UUID" "order_customer_${IDX}" "order_customer_${IDX}@yas.local" "$CUSTOMER_PASS"
  assign_role "$UUID" "CUSTOMER"
  IDX=$((IDX+1))
done

# ---------- 5. Group 5 — CUSTOMER users (dddddddd prefix) ----------
echo "==> Creating group 5 CUSTOMER users (dddddddd)..."
IDX=1
while [ $IDX -le 50 ]; do
  N=$(printf "%04d" $IDX)
  UUID="dddddddd-${N}-4000-a000-$(printf "%012d" $IDX)"
  create_user "$UUID" "rating_customer_${IDX}" "rating_customer_${IDX}@yas.local" "$CUSTOMER_PASS"
  assign_role "$UUID" "CUSTOMER"
  IDX=$((IDX+1))
done

# ---------- 6. Group 6 — ADMIN users (eeeeeeee prefix) ----------
echo "==> Creating group 6 ADMIN users (eeeeeeee)..."
NAMES_E=(nguyen_admin tran_admin le_admin pham_admin hoang_admin
         vo_admin bui_admin do_admin vu_admin dang_admin
         ngo_admin ly_admin mai_admin cao_admin dinh_admin
         trinh_admin dao_admin truong_admin luong_admin phan_admin
         ha_admin tien_admin hung_admin duc_admin hai_admin
         thanh_admin khanh_admin son_admin minh_admin long_admin
         nam_admin tuan_admin hieu_admin an_admin binh_admin
         cuong_admin hoa_admin thu_admin oanh_admin kim_admin
         lan_admin bich_admin huyen_admin thuy_admin nga_admin
         linh_admin thao_admin phuong_admin ngoc_admin hang_admin)
IDX=1
for NAME in "${NAMES_E[@]}"; do
  N=$(printf "%04d" $IDX)
  UUID="eeeeeeee-${N}-4000-a000-$(printf "%012d" $IDX)"
  create_user "$UUID" "$NAME" "${NAME}@yas.local" "$ADMIN_KC_PASS"
  assign_role "$UUID" "ADMIN"
  IDX=$((IDX+1))
done

echo "==> Done. 250 users created (200 CUSTOMER + 50 ADMIN)."
