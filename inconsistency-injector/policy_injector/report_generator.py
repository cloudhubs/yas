import datetime
import os

def generate_report(all_changes, total_files_scanned):
    report_lines = []
    timestamp_str = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    report_lines.append("Report on the Injection of Authorization Drifts")
    report_lines.append(f"Report Time: {timestamp_str}")
    report_lines.append("\nSummary")
    report_lines.append(f"Total Microservices Scanned: {total_files_scanned}")
    report_lines.append(f"Total Microservices Modified: {len(all_changes)}")
    
    report_lines.append("\nInjections/Mutations")

    for i, change in enumerate(all_changes):
        report_lines.append(f"\n{i+1}. Service: {change['service_file']}")
        report_lines.append(f"   - Rule Index: {change['rule_index']}")
        report_lines.append(f"   - Endpoint:   {change['endpoint_path']}")
        report_lines.append(f"   - Method:     {change['method']}")
        report_lines.append(f"   - Role Drift: {change['original_roles']} -> {change['new_roles']}")

    report_lines.append("\n--- End of Report ---")
    
    report_content = "\n".join(report_lines)
    
    # Save report to a timestamped file
    file_timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"drift_report_{file_timestamp}.txt"
    
    try:
        with open(filename, 'w') as f:
            f.write(report_content)
        print(f"\n[+] Report successfully saved to: {filename}")
    except Exception as e:
        print(f"\n[!] Error saving report file: {e}")
        
    print("\n" + report_content)