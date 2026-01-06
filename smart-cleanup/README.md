# Smart Cleanup Utility

### Duplicate File Detector with Safe Delete & Restore System

Smart Cleanup Utility is a safety-first Linux command-line tool designed to detect duplicate files and remove them without permanent data loss. It uses cryptographic hashing, a trash-based delete mechanism, and full restore support.

This project follows enterprise-grade principles: auditability, reversibility, and user control.

---

## Features

- **Hash-based duplicate detection** using SHA-256 for accurate identification
- **Safe delete system** that moves files to trash instead of permanent deletion
- **Full restore capability** to recover any deleted files
- **Complete logging** for audit trails and rollback support
- **Prevents accidental data loss** through careful design
- **Cross-distribution compatibility** works on any Linux system
- **Lightweight implementation** using pure Bash with no external dependencies

---

## Project Structure

```
smart-cleanup/
├── README.md
├── docs/
│   └── design.md
└── src/
    ├── duplicate-detector.sh
    ├── safe-delete.sh
    └── restore-trash.sh
```

---

## Requirements

- Linux operating system
- Bash (version 4 or higher recommended)
- Standard utilities: `find`, `sha256sum`, `awk`, `mv`, `mkdir`

No additional dependencies required.

---

## Installation

Clone the repository and set up the scripts:

```bash
git clone <your-repo-url>
cd smart-cleanup/src
chmod +x *.sh
```

---

## How It Works

The utility follows a simple, transparent workflow:

1. Files are scanned recursively and hashed using SHA-256
2. Exact duplicates are identified by matching hash values
3. Duplicate files are listed for review (nothing happens automatically)
4. Selected files are moved to a local `.trash` directory
5. Original file paths are logged for restoration
6. Files can be restored at any time with a single command

---

## Usage Guide

### Step 1: Detect Duplicate Files

Run the detector on any directory:

```bash
./duplicate-detector.sh /path/to/scan
```

This generates:
- `.duplicates.list` containing all duplicate file paths
- `.duplicate_hashes.log` with hash values for audit purposes

### Step 2: Review the Results

Always review before deleting:

```bash
cat .duplicates.list
```

### Step 3: Safely Delete Duplicates

Move duplicates to trash:

```bash
./safe-delete.sh
```

Files are moved to the `.trash/` directory. This operation is completely reversible.

### Step 4: Restore Files (If Needed)

Recover all deleted files:

```bash
./restore-trash.sh
```

All files return to their original locations with directory structure intact.

---

## Safety Guarantees

| Feature | Description |
|---------|-------------|
| No permanent deletion | Files are moved, never removed |
| Hash verification | Only exact duplicates are identified |
| Full restore support | Complete rollback capability |
| Comprehensive logging | Every operation is recorded |

---

## Use Cases

- Cleaning cluttered Downloads folders
- Managing backup directories efficiently
- Optimizing server storage space
- Learning Linux filesystem automation
- Demonstrating safe scripting practices

---

## Tested Distributions

- Ubuntu
- Kali Linux
- Arch Linux
- Debian and derivatives

---

## License

MIT License — free to use, modify, and distribute.

---

## Contributing

Pull requests and improvements are welcome. This project is intentionally designed to be extended and enhanced.

---

## Philosophy

This tool prioritizes data safety over speed. Any deletion system without recovery mechanisms is considered unsafe by design. Smart Cleanup treats your data as critical assets, not disposable files.
