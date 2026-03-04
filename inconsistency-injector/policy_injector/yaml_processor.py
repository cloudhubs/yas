import os
import random
from ruamel.yaml import YAML
from .file_handler import backup_file
from .mutation_engine import get_new_authorities

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

    # 1. Dynamic Schema Detection
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

    if not rules:
        print("  [i] No rules found to mutate. Skipping.")
        return None

    # Select random rule
    rule_index = random.randint(0, len(rules) - 1)
    rule_to_mutate = rules[rule_index]
    
    # 2 & 3. Authority Extraction & Prefixing
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

    # Apply mutation
    new_authorities = get_new_authorities(original_authorities)
    
    # 4. Injection and Re-formatting
    path_info = "(no path)"
    
    if schema_type == "FORMAT_1":
        path_info = rule_to_mutate.get("path", "(no path)")
        # Strip prefixes and update list
        cleaned_roles = [r.replace("ROLE_", "") for r in new_authorities if "ROLE_" in r]
        # In Format 1, we only mutate the roles list (ignoring if it drifts to permit-all for safety in this scope)
        if cleaned_roles:
            rule_to_mutate["roles"] = yaml.load(str(cleaned_roles))
            
    elif schema_type == "FORMAT_2":
        path_info = rule_to_mutate.get("patterns", ["(no path)"])[0]
        
        # Clear existing access flags
        for key in ["roles", "permit-all", "authenticated"]:
            if key in rule_to_mutate:
                del rule_to_mutate[key]
                
        # Re-apply based on mutation result
        if "permit-all" in new_authorities:
            rule_to_mutate["permit-all"] = True
        elif "authenticated" in new_authorities:
            rule_to_mutate["authenticated"] = True
        else:
            cleaned_roles = [r.replace("ROLE_", "") for r in new_authorities]
            rule_to_mutate["roles"] = yaml.load(str(cleaned_roles))

    print(f"  [+] Injected drift in rule {rule_index} (path: {path_info}...):")
    print(f"      Original: {original_authorities}")
    print(f"      New:      {new_authorities}")
    
    change_details = {
        "service_file": os.path.relpath(filepath, base_path),
        "rule_index": rule_index,
        "endpoint_path": path_info,
        "original_roles": original_authorities,
        "new_roles": new_authorities
    }

    try:
        with open(filepath, 'w') as f:
            yaml.dump(data, f)
        print(f"  [+] Successfully injected drift into: {filepath}")
        return change_details
    except Exception as e:
        print(f"  [!] Error writing modified YAML: {e}")
        return None