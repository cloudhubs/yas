import os
import random
import argparse
from pathlib import Path
from policy_injector.file_handler import find_all_config_files
from policy_injector.yaml_processor import process_and_inject_drift
from policy_injector.report_generator import generate_report

if __name__ == "__main__":

    # Parsing the arguments to obtain the percentage of microservices to modify.
    parser = argparse.ArgumentParser(description="Inject authorization drift into microservice configs.")
    parser.add_argument(
        "-p", "--percentage",
        type=int,
        required=True,
        help="The percentage of microservices to modify (e.g., 20 for 20%%)."
    )
    args = parser.parse_args()

    if not 0 < args.percentage <= 100:
        print("Error: Percentage must be between 1 and 100.")
        exit(1)

    # Scanning for microservice directories.
    start_directory = ".." 
    abs_start_path = os.path.abspath(start_directory)
    
    print(f"Starting authorization drift injection ({args.percentage}%)")
    print(f"Scanning in: {abs_start_path}")
    
    # 1. Finding all candidate application.yml files to modify.
    all_config_files = find_all_config_files(start_directory)
    if not all_config_files:
        print("No 'ts-' microservices with 'application.yml' found. Exiting.")
        exit(1)
    print(f"Found {len(all_config_files)} total 'application.yml' files.")

    # 2. Modifying microservice config files.
    num_to_modify = int(len(all_config_files) * (args.percentage / 100.0))
    if num_to_modify == 0 and args.percentage > 0:
        num_to_modify = 1 
    print(f"Randomly selecting {num_to_modify} configuration file(s) to modify.")

    files_to_modify = random.sample(all_config_files, num_to_modify)
    print("Configurations selected for modification:")
    for f in files_to_modify:
        print(f"  - {os.path.relpath(f, abs_start_path)}")

    all_changes = []
    for filepath in files_to_modify:
        change_details = process_and_inject_drift(filepath, abs_start_path)
        if change_details:
            all_changes.append(change_details)

    print("Authorization drift injection completed.")

    # Generating a report on the policy mutations that have been injected.
    if all_changes:
        generate_report(all_changes, len(all_config_files))
    else:
        print("No changes were injected.")
    
    print("To go back to the original state, run the 'main_restorer.py' script.")