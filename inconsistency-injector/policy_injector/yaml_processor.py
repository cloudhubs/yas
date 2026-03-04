import os
import random
from pathlib import Path
from ruamel.yaml import YAML
from .file_handler import backup_file, extract_endpoints_from_controllers
from .mutation_engine import get_new_authorities

def mutate_path_wildcard(path_string):
    """Simulates a developer messing up Spring Security wildcards."""
    if path_string.endswith("/**"):
        return path_string[:-3] + "/*"  # Restricts too much (causes 403s on subpaths)
    elif path_string.endswith("/*"):
        return path_string[:-2] + "/**" # Exposes too much (accidental deep exposure)
    elif not path_string.endswith("*") and not path_string.endswith("/"):
        return path_string + "/**"      # Accidental wildcard addition
    return path_string

def process_and_inject_drift(filepath, base_path):
    print(f"\nProcessing file: {filepath}")
    backup_file(filepath)

    yaml = YAML()
    yaml.preserve_quotes = True
    yaml.indent(mapping=2, sequence=4, offset=2)
    
    try:
        with open(filepath, 'r') as f:
            data = yaml.load(f)
    except Exception as e:
        print(f"  [!] Error loading YAML, skipping: {e}")
        return None

    # Determine service root directory to find controllers
    service_dir = Path(filepath).parents[3] 
    discovered_endpoints = extract_endpoints_from_controllers(service_dir)

    schema_type = None
    rules = None
    
    if "app" in data and "security" in data["app"] and "rules" in data["app"]["security"]:
        schema_type = "FORMAT_2"
        rules = data["app"]["security"]["rules"]
    elif "security" in data and "path-roles" in data["security"]:
        schema_type = "FORMAT_1"
        rules = data["security"]["path-roles"]
    else:
        print("  [i] Unrecognized YAML security format. Skipping.")
        return None

    if rules is None:
        rules = []

    # DECISION: Mutate existing rule OR Inject new rule?
    if discovered_endpoints and (not rules or random.random() < 0.5):
        action = "NEW_RULE"
        target_endpoint = random.choice(discovered_endpoints)
        original_authorities = ["(None - Endpoint was open)"]
        
        # --- Context-Aware Flaw Injection ---
        target_lower = target_endpoint.lower()
        if "admin" in target_lower or "backoffice" in target_lower:
            # Mistakenly allowing standard users into admin, or locking strictly to super-admin
            random_new_state = random.choice(["ROLE_USER", "ROLE_SUPER-ADMIN"])
        elif "profile" in target_lower or "user" in target_lower:
            # Accidentally making user profiles public, or locking to customer specifically
            random_new_state = random.choice(["permit-all", "ROLE_CUSTOMER"])
        else:
            # Generic endpoint errors
            random_new_state = random.choice(["permit-all", "authenticated", "ROLE_CUSTOMER"])
            
        new_authorities = [random_new_state]
        
        new_rule = {}
        if schema_type == "FORMAT_1":
            new_rule["path"] = target_endpoint
            if "ROLE_" in random_new_state:
                new_rule["roles"] = yaml.load(str([random_new_state.replace("ROLE_", "")]))
            else:
                 new_rule["roles"] = yaml.load(str([random_new_state]))
            rules.append(new_rule)
            
        elif schema_type == "FORMAT_2":
            new_rule["patterns"] = yaml.load(str([target_endpoint]))
            if random_new_state == "permit-all":
                new_rule["permit-all"] = True
            elif random_new_state == "authenticated":
                new_rule["authenticated"] = True
            else:
                new_rule["roles"] = yaml.load(str([random_new_state.replace("ROLE_", "")]))
            rules.insert(0, new_rule) # Insert at top so it takes precedence
            
        rule_index = "NEW"
        path_info = target_endpoint

    else:
        # Standard Mutation Logic
        action = "MUTATE"
        if not rules:
            print("  [i] No rules found and no endpoints discovered. Skipping.")
            return None

        rule_index = random.randint(0, len(rules) - 1)
        rule_to_mutate = rules[rule_index]
        original_authorities = []
        
        if schema_type == "FORMAT_1":
            if "roles" in rule_to_mutate:
                original_authorities = ["ROLE_" + r for r in rule_to_mutate["roles"]]
        elif schema_type == "FORMAT_2":
            if "roles" in rule_to_mutate:
                original_authorities = ["ROLE_" + r for r in rule_to_mutate["roles"]]
            elif rule_to_mutate.get("permit-all") is True:
                original_authorities = ["permit-all"]
            elif rule_to_mutate.get("authenticated") is True:
                original_authorities = ["authenticated"]

        if not original_authorities:
            print(f"  [i] Rule {rule_index} has no recognized authorities. Skipping.")
            return None

        # --- DECISION: Role Shift or Wildcard Slip ---
        # 80% chance to mutate the role, 20% chance to mess up the path
        mutation_type = random.choices(["role", "path"], weights=[80, 20], k=1)[0]

        if mutation_type == "path":
            new_authorities = original_authorities # Authorities remain unchanged
            
            if schema_type == "FORMAT_1":
                old_path = rule_to_mutate.get("path", "(no path)")
                new_path = mutate_path_wildcard(old_path)
                rule_to_mutate["path"] = new_path
                path_info = f"{old_path} -> {new_path}"
                
            elif schema_type == "FORMAT_2":
                patterns = rule_to_mutate.get("patterns", ["(no path)"])
                old_path = patterns[0]
                new_path = mutate_path_wildcard(old_path)
                rule_to_mutate["patterns"][0] = new_path
                path_info = f"{old_path} -> {new_path}"
                
            print(f"  [!] Path Wildcard Slip applied: {path_info}")

        else:
            # Standard role mutation
            new_authorities = get_new_authorities(original_authorities)
            path_info = "(no path)"
            
            if schema_type == "FORMAT_1":
                path_info = rule_to_mutate.get("path", "(no path)")
                cleaned_roles = [r.replace("ROLE_", "") for r in new_authorities if "ROLE_" in r]
                if cleaned_roles:
                    rule_to_mutate["roles"] = yaml.load(str(cleaned_roles))
                    
            elif schema_type == "FORMAT_2":
                path_info = rule_to_mutate.get("patterns", ["(no path)"])[0]
                for key in ["roles", "permit-all", "authenticated"]:
                    if key in rule_to_mutate:
                        del rule_to_mutate[key]
                if "permit-all" in new_authorities:
                    rule_to_mutate["permit-all"] = True
                elif "authenticated" in new_authorities:
                    rule_to_mutate["authenticated"] = True
                else:
                    cleaned_roles = [r.replace("ROLE_", "") for r in new_authorities]
                    rule_to_mutate["roles"] = yaml.load(str(cleaned_roles))

    print(f"  [+] {action} applied to endpoint {path_info}:")
    print(f"      Original: {original_authorities}")
    print(f"      New:      {new_authorities}")
    
    change_details = {
        "service_file": os.path.relpath(filepath, base_path),
        "rule_index": rule_index,
        "endpoint_path": path_info,
        "action": action,
        "original_roles": original_authorities,
        "new_roles": new_authorities
    }

    try:
        with open(filepath, 'w') as f:
            yaml.dump(data, f)
        print(f"  [+] Successfully saved YAML: {filepath}")
        return change_details
    except Exception as e:
        print(f"  [!] Error writing modified YAML: {e}")
        return None