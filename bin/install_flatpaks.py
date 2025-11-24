import os
import subprocess
import sys
import threading
import time


def spinner_task(stop_event, prefix):
    spinner = ["|", "/", "-", "\\"]
    idx = 0
    while not stop_event.is_set():
        sys.stdout.write(f"\r{prefix} Installing... {spinner[idx % len(spinner)]}")
        sys.stdout.flush()
        idx += 1
        time.sleep(0.1)
    sys.stdout.write("\r" + " " * (len(prefix) + 20) + "\r")


def install_flatpakrefs(folder):
    if not os.path.isdir(folder):
        print(f"Error: The folder '{folder}' does not exist.")
        sys.exit(1)

    flatpakrefs = [f for f in os.listdir(folder) if f.endswith(".flatpakref")]
    total = len(flatpakrefs)
    if total == 0:
        print(f"No .flatpakref files found in '{folder}'.")
        return

    print(f"Found {total} .flatpakref files in '{folder}'.")
    installed, skipped, failed = 0, 0, 0
    failed_apps = []

    for idx, ref in enumerate(flatpakrefs, 1):
        app_name = ref.replace(".flatpakref", "")
        ref_path = os.path.join(folder, ref)
        prefix = f"[{idx}/{total}] {app_name}"

        # Start spinner
        stop_event = threading.Event()
        spinner_thread = threading.Thread(
            target=spinner_task, args=(stop_event, prefix)
        )
        spinner_thread.start()

        # Run install and stream output
        process = subprocess.Popen(
            ["flatpak", "install", "--noninteractive", ref_path],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
        )

        already_installed = False
        error_output = ""
        while True:
            line = process.stdout.readline()
            if not line:
                break
            if "is already installed" in line:
                already_installed = True
            error_output += line

        process.wait()
        stop_event.set()
        spinner_thread.join()

        # Print final status for this app
        if process.returncode == 0 and not already_installed:
            installed += 1
            print(f"{prefix} Installed successfully.")
        elif already_installed:
            skipped += 1
            print(f"{prefix} Already installed (skipped).")
        else:
            failed += 1
            failed_apps.append(app_name)
            print(f"{prefix} Failed to install.\nOutput:\n{error_output.strip()}\n")

    print("\nSummary:")
    print(f"  Successfully installed: {installed}")
    print(f"  Already installed (skipped): {skipped}")
    print(f"  Failed: {failed}")
    if failed_apps:
        print("  Failed apps:", ", ".join(failed_apps))


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 install_flatpaks_live.py <your_folder_name>")
        sys.exit(1)
    folder = sys.argv[1]
    install_flatpakrefs(folder)
