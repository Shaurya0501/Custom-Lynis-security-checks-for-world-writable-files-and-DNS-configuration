# Custom Lynis Security Audits

Two custom security checks for [Lynis](https://cisofy.com/lynis/), implemented and tested on Ubuntu 24.04 running under WSL.

## Features

### CUST-0010: World-Writable Files Audit
Scans selected directories (`/etc`, `/usr`, `/opt`, and `/home`) for regular files with world-write permissions. Reports a warning if matching files are found.

### CUST-0020: DNS Configuration and Resolution Audit
Checks whether `/etc/resolv.conf` contains a nameserver entry and whether the system can resolve `google.com`.

## Environment

- Ubuntu 24.04 on WSL
- Lynis 3.0.9
- POSIX-compatible shell scripting


## Installation

1. Install Lynis using your distribution's package manager if it is not already installed.
2. Back up the existing custom test file, if one exists.
3. Copy the project's custom tests into the Lynis include directory:

   ```bash
   sudo cp /usr/share/lynis/include/tests_custom \
       /usr/share/lynis/include/tests_custom.backup
   ```

   Run this backup command only if you have not already made a backup.

4. Install the project script:

   ```bash
   sudo cp scripts/tests_custom \
       /usr/share/lynis/include/tests_custom
   ```

5. Set readable permissions:

   ```bash
   sudo chmod 644 /usr/share/lynis/include/tests_custom
   ```

## Run the Audit

```bash
sudo lynis audit system --quick
```

To display only the world-writable-files result:

```bash
sudo lynis audit system --quick 2>&1 \
    | grep -A 2 "Checking for world-writable files"
```

To display only the DNS check results:

```bash
sudo lynis audit system --quick 2>&1 \
    | grep -A 3 "Checking DNS configuration"
```

These filtered commands still execute the full audit; they only filter what is displayed.

## Validation

The checks were validated on Ubuntu 24.04 under WSL.

- CUST-0010 returned `[ OK ]` when no matching world-writable files were found in the scanned locations.
- A temporary file with permissions `666` caused CUST-0010 to return `[ WARNING ]`.
- After the temporary file was removed, CUST-0010 returned `[ OK ]` again.
- CUST-0020 returned `[ OK ]` for both nameserver configuration and hostname resolution.
- Both custom test IDs and their results were confirmed in `/var/log/lynis.log`.

## Limitations

- The world-writable-files check scans selected directories and reports whether matching files exist; it does not print each matching path.
- A world-writable permission does not automatically mean a file is malicious. Detected files should be reviewed before changing permissions.
- The DNS check verifies a nameserver entry and resolution of one hostname. It does not validate DNS server trustworthiness, encrypted DNS, or resolution of all domains.
- WSL results may differ from those of a standalone Linux installation.

