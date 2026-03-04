import os
import shutil
import re
from pathlib import Path

def backup_file(filepath):
    backup_path = filepath + ".bak"
    if not os.path.exists(backup_path):
        try:
            shutil.copy(filepath, backup_path)
            print(f"  [+] Backed up original file to: {backup_path}")
        except Exception as e:
            print(f"  [!] Error backing up file: {e}")
    else:
        print(f"  [i] Backup file already exists: {backup_path}")

def find_all_config_files(root_dir):
    config_files = []
    start_path = Path(root_dir)
    for service_dir in start_path.iterdir():
        if service_dir.is_dir():
            config_path = service_dir / "src" / "main" / "resources" / "application.yaml"
            if config_path.exists():
                config_files.append(str(config_path.resolve()))
    return config_files

def restore_all_backups(root_dir):
    restored_count = 0
    start_path = Path(root_dir)
    for service_dir in start_path.iterdir():
        if service_dir.is_dir():
            backup_path = service_dir / "src" / "main" / "resources" / "application.yaml.bak"
            if backup_path.exists():
                original_path = backup_path.with_suffix('') 
                try:
                    shutil.move(str(backup_path), str(original_path))
                    print(f"  [+] Restored: {original_path.relative_to(start_path)}")
                    restored_count += 1
                except Exception as e:
                    print(f"  [!] Error restoring {backup_path}: {e}")
    return restored_count

def extract_endpoints_from_controllers(service_dir_path):
    endpoints = []
    # Find the controller directory robustly
    java_src = Path(service_dir_path) / "src" / "main" / "java"
    
    if not java_src.exists():
        return endpoints

    for java_file in java_src.rglob('controller/*.java'):
        try:
            with open(java_file, 'r', encoding='utf-8') as f:
                content = f.read()
                
                # 1. Extract class-level @RequestMapping base path
                class_mapping = re.search(r'@RequestMapping\s*\(\s*(?:value\s*=\s*|path\s*=\s*)?["\']([^"\']+)["\']', content)
                base_path = class_mapping.group(1) if class_mapping else ""
                
                # 2. Extract method-level mappings
                method_mappings = re.findall(r'@(?:Get|Post|Put|Delete|Patch|Request)Mapping\s*\(\s*(?:value\s*=\s*|path\s*=\s*)?["\']([^"\']+)["\']', content)
                
                for mapping in method_mappings:
                    # Combine base path and method path
                    full_path = (base_path + mapping).replace('//', '/')
                    
                    # Convert Spring path variables like {id} to yaml wildcards **
                    full_path = re.sub(r'\{[^}]+\}', '**', full_path)
                    endpoints.append(full_path)
        except Exception as e:
            print(f"  [!] Could not parse {java_file.name}: {e}")
            
    return list(set(endpoints)) 