# Battery and System Info (XP–11 Compatible)

A lightweight `.bat` script that provides battery status, system details, and basic disk information using **only native CMD tools**, fully compatible with **Windows XP through Windows 11**.

---

## Features

- Detects Windows version automatically
- Generates `battery_report.html` (on Windows 8+)
- Displays:
  - Battery percentage and status (Charging / Discharging)
  - Computer name, OS version, architecture
  - Manufacturer, model, processor, and installed RAM
  - Approximate primary disk size in GB
- Skips unsupported features silently on older systems
- Does **not require PowerShell or WMIC replacements**

---

## Why Use This?

- Works entirely offline
- Great for diagnostics on legacy and modern systems
- Can be used from USB drives, recovery environments, or admin toolkits
- Safe for automation and deployment scripts

---

## Requirements

| Feature              | Supported OS Versions                       |
|----------------------|---------------------------------------------|
| `battery_report.html`| Windows 8, 8.1, 10, 11                      |
| `wmic` diagnostics   | Windows XP → Windows 10 (and some early 11) |
| CMD core only        | All versions XP → 11                        |

---

## Usage

1. Download or clone this repo
2. Run `battery_status_system_based.bat` as administrator
3. Battery report (if supported) will be saved to your Desktop
4. System info will be displayed in the terminal

---

## Known Limitations

- On Windows 11 22H2 and later, `wmic` is removed; only battery report will be available.
- RAM and disk size are approximated for compatibility.
- Battery features may be unavailable on desktops or virtual machines.

---

## License

This project is provided under the [MIT License](LICENSE).

---

## Contributions

Feel free to submit improvements or compatibility fixes via pull request!
