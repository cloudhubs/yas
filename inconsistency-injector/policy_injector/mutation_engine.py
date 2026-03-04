import random

# --- Configuration: Define possible "drifts" ---
WEIGHTED_DRIFT_MUTATIONS = {
    # 1. Accidental Restriction/Exposure for Public endpoints
    "permit-all": [
        (["authenticated"], 70),       # Very common: accidentally requiring login
        (["ROLE_CUSTOMER"], 30)        # Less common: locking to a specific role
    ],
    
    # 2. Accidental Exposure or Slight Restriction for Authenticated endpoints
    "authenticated": [
        (["ROLE_USER"], 60),           # Common: locking it down too tightly
        (["ROLE_CUSTOMER"], 30),
        (["permit-all"], 10)           # Rare but catastrophic: accidental exposure
    ],
    
    # 3. Privilege Escalation or Downgrade for Customer
    "ROLE_CUSTOMER": [
        (["ROLE_USER"], 60),           # Common: confusing customer and internal user
        (["authenticated"], 40)        # Common: forgetting the specific role
    ],
    
    # 4. Privilege Escalation or Downgrade for standard User
    "ROLE_USER": [
        (["ROLE_CUSTOMER"], 50),       # Common: confusing the two standard roles
        (["authenticated"], 40),       # Common: forgetting to require the specific role
        (["ROLE_ADMIN"], 10)           # Rare: massive privilege escalation
    ],
    
    # 5. Privilege Escalation or Downgrade for Admin
    "ROLE_ADMIN": [
        (["ROLE_SUPER-ADMIN"], 60),    # Common: confusing admin tiers
        (["ROLE_USER"], 35),           # Common: copy-paste error from another route
        (["permit-all"], 5)            # Very rare catastrophic copy-paste
    ],
    
    # 6. Severe Privilege Downgrade (Super Admin locked out or reduced to Admin)
    "ROLE_SUPER-ADMIN": [
        (["ROLE_ADMIN"], 80),          # Extremely common restriction
        (["ROLE_USER"], 20)            # Rare massive downgrade
    ]
}

# A list of common multi-role authorities and how they can drift
MULTI_ROLE_DRIFT = {
    "ROLE_CUSTOMER,ROLE_USER": [["ROLE_CUSTOMER"], ["ROLE_USER"]],
    "ROLE_ADMIN,ROLE_USER": [["ROLE_ADMIN"], ["ROLE_USER"]],
    "ROLE_ADMIN,ROLE_SUPER-ADMIN": [["ROLE_ADMIN"], ["ROLE_SUPER-ADMIN"]]
}

def get_new_authorities(original_auths):
    """
    Applies a weighted random mutation to a list of authorities.
    This simulates realistic human error frequencies.
    """
    if not original_auths:
        return ["authenticated"]  

    original_auths.sort()
    original_key = ",".join(original_auths)

    # 1. Check for multi-role drift first
    if original_key in MULTI_ROLE_DRIFT:
        new_auths = random.choice(MULTI_ROLE_DRIFT[original_key])
        print(f"    [!] Mutation: Multi-role drift '{original_key}' -> {new_auths}")
        return new_auths

    # 2. Check for single-role weighted drift
    if len(original_auths) == 1 and original_auths[0] in WEIGHTED_DRIFT_MUTATIONS:
        options = WEIGHTED_DRIFT_MUTATIONS[original_auths[0]]
        mutations = [opt[0] for opt in options]
        weights = [opt[1] for opt in options]
        
        # random.choices returns a list, so we take the first element ([0])
        new_auths = random.choices(mutations, weights=weights, k=1)[0]
        print(f"    [!] Weighted Mutation: '{original_auths[0]}' -> {new_auths}")
        return new_auths

    # 3. Default fallback
    fallback_auth = random.choice([["authenticated"], ["ROLE_CUSTOMER"]])
    print(f"    [!] Mutation: Fallback drift {original_auths} -> {fallback_auth}")
    return fallback_auth