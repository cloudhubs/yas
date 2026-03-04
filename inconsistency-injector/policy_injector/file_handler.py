import os
import shutil
from pathlib import Path

def backup_file(filepath):
    # Creating a .bak file of the original policy file.
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
    
    # Iterating over all directories from the start_path.
    for service_dir in start_path.iterdir():
        if service_dir.is_dir():
            config_path = service_dir / "src" / "main" / "resources" / "application.yaml"
            if config_path.exists():
                config_files.append(str(config_path.resolve()))
                
    return config_files

def restore_all_backups(root_dir):
    # Restoring the original policy files where .bak files exist.
    restored_count = 0
    start_path = Path(root_dir)

    # Iterating over all directories from the start_path.
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