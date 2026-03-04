import random

# --- Configuration: Define possible "drifts" ---

# A simple set of drifts that mimic common errors.
# We'll map what an authority *was* to what it *can become*.
DRIFT_MUTATIONS = {
    # 1. Accidental Restriction: Public endpoint gets locked down
    "permit-all": ["authenticated", "ROLE_CUSTOMER"],
    
    # 2. Accidental Exposure or Slight Restriction
    "authenticated": ["permit-all", "ROLE_CUSTOMER", "ROLE_USER"],
    
    # 3. Privilege Escalation or Downgrade for Customer
    "ROLE_CUSTOMER": ["authenticated", "ROLE_USER"],
    
    # 4. Privilege Escalation or Downgrade for standard User
    "ROLE_USER": ["ROLE_CUSTOMER", "authenticated", "ROLE_ADMIN"],
    
    # 5. Privilege Escalation or Downgrade for Admin
    "ROLE_ADMIN": ["ROLE_USER", "ROLE_SUPER-ADMIN"],
    
    # 6. Severe Privilege Downgrade (Super Admin locked out or reduced to Admin)
    "ROLE_SUPER-ADMIN": ["ROLE_ADMIN", "ROLE_USER"]
}

# A list of common multi-role authorities and how they can drift
# (e.g., a rule that should be for ADMIN *and* USER is reduced to just USER)
MULTI_ROLE_DRIFT = {
    "ROLE_CUSTOMER,ROLE_USER": [["ROLE_CUSTOMER"], ["ROLE_USER"]],
    "ROLE_ADMIN,ROLE_USER": [["ROLE_ADMIN"], ["ROLE_USER"]],
    "ROLE_ADMIN,ROLE_SUPER-ADMIN": [["ROLE_ADMIN"], ["ROLE_SUPER-ADMIN"]]
}

def get_new_authorities(original_auths):
    """
    Applies a random mutation to a list of authorities.
    This is the core "drift" logic simulating authorization inconsistencies.
    """
    if not original_auths:
        # Default for an empty list: accidentally restrict it to authenticated users
        return ["authenticated"]  

    # Ensure consistent sorting so multi-role keys match reliably
    original_auths.sort()
    original_key = ",".join(original_auths)

    # 1. Check for multi-role drift first
    if original_key in MULTI_ROLE_DRIFT:
        new_auths = random.choice(MULTI_ROLE_DRIFT[original_key])
        print(f"    [!] Mutation: Multi-role drift '{original_key}' -> {new_auths}")
        return new_auths

    # 2. Check for single-role drift
    if len(original_auths) == 1 and original_auths[0] in DRIFT_MUTATIONS:
        new_auths = [random.choice(DRIFT_MUTATIONS[original_auths[0]])]
        print(f"    [!] Mutation: Single-role drift '{original_auths[0]}' -> {new_auths[0]}")
        return new_auths

    # 3. Default fallback: If no specific drift is defined,
    # swap it to a generic 'authenticated' state or downgrade to 'ROLE_CUSTOMER'.
    fallback_auth = random.choice([["authenticated"], ["ROLE_CUSTOMER"]])
    print(f"    [!] Mutation: Fallback drift {original_auths} -> {fallback_auth}")
    return fallback_auth