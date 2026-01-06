```markdown
# Smart Cleanup Utility – Design Document

## 1. Purpose

The Smart Cleanup Utility is designed to solve a common but dangerous problem: **removing duplicate files without risking data loss**.

Traditional cleanup scripts delete files immediately, which is unsafe. This tool introduces **reversible deletion** and **cryptographic verification**.

---

## 2. Design Philosophy

### Core Principles

- Safety over convenience
- Reversibility by default
- Transparency through logs
- Minimal dependencies
- Human-readable behavior

**Strong stance:**
> Any automated deletion tool must provide recovery. Anything else is irresponsible.

---

## 3. High-Level Architecture

```
[ File System ]
        ↓
[ Duplicate Detector ]
        ↓
[ Duplicate List ]
        ↓
[ Safe Delete (Trash) ]
        ↓
[ Restore System ]
```

Each component is **independent but integrated**.

---

## 4. Duplicate Detection Strategy

### Why Hashing?

Filename comparison is unreliable. Only **content-based hashing** guarantees true duplicates.

### Algorithm

1. Traverse target directory recursively
2. Exclude `.trash` directory
3. Generate SHA-256 hash for each file
4. Store first occurrence
5. Mark subsequent matches as duplicates

### Benefits

- Exact match detection
- Resistant to filename tricks
- Works across folders

---

## 5. Safe Delete Mechanism

### Trash-Based Model

Instead of deleting:
- Files are **moved** to a local `.trash` directory
- Original paths are logged
- Timestamped filenames prevent collisions

### Trash Log Format

```
<original_path>|<trash_path>
```

This allows deterministic restoration.

---

## 6. Restore System Design

### Restore Algorithm

1. Read `trash.log`
2. Recreate original directories if missing
3. Move files back to original locations
4. Clean up trash directory after restore

### Guarantees

- Exact file restoration
- Directory integrity preserved
- No data corruption

---

## 7. Failure Handling

| Scenario | Handling |
|----------|----------|
| Missing file | Skipped safely |
| Permission issues | Fails without data loss |
| Interrupted execution | Trash remains intact |
| Restore interrupted | Log still valid |

---

## 8. Security Considerations

- No elevated privileges required
- No permanent delete commands (`rm -rf`)
- No network access
- User-controlled execution only

---

## 9. Scalability & Performance

- Linear scan complexity
- Suitable for thousands of files
- Can be extended with:
  - Size-based pre-filtering
  - Parallel hashing
  - Database-backed logs

---

## 10. Future Enhancements

- Interactive TUI (fzf/dialog)
- Dry-run mode
- Configurable trash location
- Auto-clean schedules (cron/systemd)
- USB auto-detection integration
- Logging to JSON
- Unit testing framework

---

## 11. Educational Value

This project demonstrates:

- Bash scripting discipline
- Filesystem internals
- Cryptographic hashing
- Defensive programming
- Real-world automation design

---

## 12. Conclusion

Smart Cleanup Utility is intentionally conservative. It treats user data as **critical assets**, not disposable files.

This design aligns with **professional Linux administration standards**.
```
