import os
import shutil
from pathlib import Path
from policy_injector.file_handler import restore_all_backups

if __name__ == "__main__":
    start_directory = ".."
    abs_start_path = os.path.abspath(start_directory)
    
    print(f"Restoring 'application.yaml' from backups in '{abs_start_path}'...")
    count = restore_all_backups(start_directory)
    if count == 0:
        print("\nNo '.bak' files found to restore.")
    else:
        print(f"\nRestore complete. {count} file(s) restored.")