# ROBO ENV - Automated System Configuration and Setup

## Overview
The **ROBO ENV** repository is a collection of scripts and configurations designed to automate the setup of essential tools and software on Linux-based systems. It provides a modular and reusable framework for managing system configurations, installing software, and ensuring a consistent development environment across machines.

---

## Features
- **Automated Software Installation**: Scripts to install commonly used software like Google Chrome, Docker, Emacs, Brave browser, and more.
- **Cross-Distribution Support**: Supports both Debian-based and Red Hat-based Linux distributions.
- **Reusable Helper Functions**: Centralized helper functions to reduce redundancy and improve maintainability.
- **Environment Customization**: Easily configurable paths and repositories via environment variables.
- **Error Handling**: Robust error handling to ensure smooth execution and meaningful feedback.

---

## Repository Structure
```plaintext
robo-env/
├── daemons/               # Automation scripts for software installation
│   ├── setup-brave.sh     # Script to install Brave browser
│   ├── setup-chrome.sh    # Script to install Google Chrome
│   ├── setup-docker.sh    # Script to install Docker and Docker Compose
│   ├── setup-emacs.sh     # Script to set up Emacs and its configuration
│   └── helper-func.sh     # Shared helper functions for setup scripts
├── LICENSE                # License file
└── README.md              # Documentation for the repository
```

---

## Prerequisites
Before using the scripts in this repository, ensure the following:

1. **Linux Distribution**: Supported distributions include:
   - Debian-based (e.g., Ubuntu, Debian)
   - Red Hat-based (e.g., CentOS, Fedora)
2. **Administrative Privileges**: Scripts require `sudo` access to install software.
3. **Git**: Required for cloning this repository and managing configurations.

---

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/abhishekamralkar/robo-env.git
   cd robo-env
   ```

2. Run the desired setup scripts:
   ```bash
   ./daemons/setup-chrome.sh
   ./daemons/setup-docker.sh
   ./daemons/setup-emacs.sh
   ./daemons/setup-brave.sh
   ```

3. Follow the on-screen instructions for each script.

---

## Usage

### Customizing Environment Variables
Each script allows customization via environment variables. For example:

#### `setup-emacs.sh`:
- `EMACS_PATH`: Path to the Emacs binary (default: `/usr/local/bin/emacs`).
- `EMACS_HOME`: Path to the Emacs configuration directory (default: `~/.emacs.d`).
- `EMACS_REPO`: Git repository for Emacs configuration (default: `git@github.com:abhishekamralkar/myemacs.git`).

Set these variables before running the script:
```bash
export EMACS_PATH=/custom/path/to/emacs
export EMACS_HOME=~/custom-emacs-config
export EMACS_REPO=https://github.com/yourusername/your-emacs-config.git
./daemons/setup-emacs.sh
```

---

## Scripts Overview

1. **`setup-chrome.sh`**
   - Installs Google Chrome on Debian-based and Red Hat-based systems.
   - Automatically detects the OS and downloads the appropriate package (`.deb` or `.rpm`).
   - Handles dependencies and ensures a clean installation.

2. **`setup-docker.sh`**
   - Installs Docker and Docker Compose.
   - Removes old Docker versions if present.
   - Configures Docker repositories and installs the latest version of Docker.

3. **`setup-emacs.sh`**
   - Checks if Emacs is installed and sets up the Emacs configuration.
   - Clones the Emacs configuration repository to the specified directory.
   - Removes existing configurations if necessary.

4. **`setup-brave.sh`**
   - Installs the Brave browser on Debian-based and Red Hat-based systems.
   - Adds the Brave repository and imports the GPG key for secure installation.

5. **`helper-func.sh`**
   - Contains reusable functions such as:
     - `get_release`: Detects the OS release.
     - `get_date`: Fetches the current date and time.
     - `install_started` and `install_completed`: Logs the start and completion of installations.
     - `get_script_name`: Extracts the name of the script being executed.

---

## Error Handling
- Each script includes robust error handling to ensure smooth execution.
- If a command fails, the script exits with a meaningful error message.
- Temporary files (e.g., `.deb` or `.rpm` packages) are cleaned up after installation.

---

## Supported Operating Systems
- **Debian-based Systems**:
  - Ubuntu
  - Debian
- **Red Hat-based Systems**:
  - Fedora
  - CentOS
  - RHEL

---

## Contributing
Contributions are welcome! To contribute:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Submit a pull request with a detailed description of your changes.

---

## License
This repository is licensed under the MIT License. See the `LICENSE` file for details.

---

## Author
**Abhishek Anand Amralkar**  
Feel free to reach out for questions or suggestions!

