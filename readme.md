# Kubuntu/Ubuntu App Recovery Toolkit

This toolkit is designed to recover missing applications after a "fresh install" of Linux where you preserved your `/home` partition but wiped the system root (`/`).

(idk why you would ever do that but here I am 😭)

If your user data (documents, config files) is still there, but your applications (Discord, Firefox, Steam, etc.) are missing, these scripts will scan your home folder for "footprints" of old apps and reinstall them automatically.

## 🚀 Quick Start

1.  Clone this repository or download the scripts.
2.  Make the master script executable:
    ```bash
    chmod +x run_recovery.bash
    ```
3.  Run the toolkit:
    ```bash
    bash run_recovery.bash
    ```
4.  Follow the prompts. You can choose where to save the generated lists (default is the current directory).

## 📂 How It Works

This toolkit operates in three phases:

### 1. Scanning (`scanner.bash`)
It scans your Home directory for configuration folders that indicate an app was previously installed.
* **Snaps:** Checks `~/snap/` for app data.
* **Apts:** Deep scans `~/.config`, `~/.local/share`, and desktop shortcuts to guess missing packages.
* **Output:** Generates `snap-list.txt` and `apt-list-candidates.txt`.

### 2. Snap Restore (`reinstall-snaps.bash`)
Reads `snap-list.txt` and reinstalls the packages. Since Snaps are self-contained, this step usually works perfectly and instantly reconnects your existing data.

### 3. Apt Restore (`reinstall-apts.bash`)
Reads `apt-list-candidates.txt` and attempts to `apt install` each item.
* **Intelligent Skipping:** If a package is already installed, it skips it.
* **Error Handling:** If a folder name (e.g., `gtk-3.0`) is not a real package, it safely ignores it.
* **Logging:** Any real failures are logged to `install_failures.log` for you to review later.

## 🛠️ File Structure

* `run_recovery.bash`: **(Run this one)** The master orchestrator. Asks for your preferences and runs the other scripts in order.
* `scanner.bash`: Logic for detecting missing apps.
* `reinstall-snaps.bash`: Logic for bulk-installing Snaps.
* `reinstall-apts.bash`: Logic for bulk-installing Native (.deb) packages.

## 📝 Generated Files (Add to .gitignore)
The scripts create temporary files to store the list of apps to install. You should add these to your `.gitignore` to keep your repo clean:

```text
snap-list.txt
apt-list-candidates.txt
install_failures.log