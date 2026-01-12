# Strict Mode Validator for Bash Scripts

## 📌 Problem Statement

### Background

Bash scripts often fail silently due to unsafe defaults such as:

- Ignoring command failures  
- Using uninitialized variables  
- Broken pipelines  
- Word splitting and globbing issues  
- Missing cleanup and signal handling  

To reduce these risks, **Bash strict mode** is widely recommended. A typical strict-mode setup includes:

```bash
set -euo pipefail
IFS=$'\n\t'
trap 'cleanup' EXIT
```

However, in real-world projects, scripts often:

- Enable only part of strict mode
- Disable strict mode mid-script
- Forget to define safe IFS
- Miss critical trap handlers

This leads to fragile scripts that are difficult to debug and unsafe in production environments.

## 🎯 Objective

Develop a Strict Mode Validator — a Bash utility that statically analyzes another Bash script and verifies whether it follows recommended strict-mode best practices.

The validator must not execute the target script. Instead, it should inspect the script text and report missing, incomplete, or unsafe configurations with clear feedback.

# Functional Requirements — Strict Mode Validator

This document defines the **functional requirements** for the `strict_mode_validator.sh` tool.

---

## FR-1: Strict Mode Detection

The validator **must detect** whether the target Bash script enables strict mode using any of the following:

- `set -e`
- `set -u`
- `set -o pipefail`
- Combined forms such as:
  ```bash
  set -euo pipefail
  ```

Each flag must be validated independently.

---

## FR-2: Safe IFS Configuration

The validator **must check** whether the script explicitly sets a safe `IFS`, typically:

```bash
IFS=$'\n\t'
```

If `IFS` is not set or is overridden unsafely, the validator must report a warning.

---

## FR-3: Trap Configuration Validation

The validator **must detect** whether the script defines traps for:

### Mandatory
- `EXIT`
- `ERR`

### Recommended (Optional)
- `INT`
- `TERM`

Each detected trap should be reported individually.

---

## FR-4: Detection of Strict Mode Disablement

The validator **must detect and report** any usage of:

- `set +e`
- `set +u`
- `set +o pipefail`

Disabling strict mode must be treated as a **critical violation**.

---

## FR-5: Cleanup Function Verification

If the script uses:

```bash
trap <handler> EXIT
```

The validator **must verify** that:
- The referenced cleanup function exists
- The function is defined before script termination

Missing cleanup definitions should be reported as warnings.

---

## FR-6: Shebang Validation

The validator **must verify** that the script starts with a valid Bash shebang:

Accepted values:
```bash
#!/usr/bin/env bash
#!/bin/bash
```

Missing or invalid shebangs must be reported.

---

## FR-7: Comment and Whitespace Safety

The validator **must ignore**:
- Commented-out code
- Inline comments
- Extra whitespace and indentation

Checks must apply only to executable statements.

---

## FR-8: Non-Execution Guarantee

The validator **must not**:
- Execute
- Source
- Modify

the target script in any form.

---

## FR-9: Structured Result Reporting

The validator **must produce** structured output with:
- PASS / WARN / FAIL indicators
- A final summary with counts

---

## FR-10: Exit Code Contract

The validator **must exit** with:

| Code | Meaning |
|----|----|
| 0 | All checks passed |
| 1 | One or more warnings |
| 2 | One or more critical failures |

---

# Strict Mode Validator — Input & Output Specification

## 📥 Input Specification

### Description
The Strict Mode Validator accepts a **single Bash script file** as input.  
The file is **not executed**; it is only analyzed statically.

---

### Input Format

```bash
./strict_mode_validator.sh <path-to-bash-script>
```

---

### Input Parameters

| Parameter | Type | Required | Description |
|---------|------|----------|-------------|
| `<path-to-bash-script>` | String | Yes | Path to the Bash script to be validated |

---

### Valid Input Examples

```bash
./strict_mode_validator.sh script.sh
./strict_mode_validator.sh ./scripts/backup.sh
./strict_mode_validator.sh /home/user/tools/deploy.sh
```

---

### Invalid Input Examples

```bash
./strict_mode_validator.sh
./strict_mode_validator.sh file.txt
./strict_mode_validator.sh nonexistent.sh
```

---

### Input Validation Rules

- File must exist
- File must be readable
- File must be a Bash script (`.sh` or valid shebang)
- Directories are not allowed

---

## 📤 Output Specification

### Description
The validator produces a **human-readable report** indicating whether the script follows Bash strict-mode best practices.

---

### Output Format

Each check produces one of the following statuses:

- `[PASS]` – Requirement satisfied
- `[WARN]` – Recommended but missing
- `[FAIL]` – Critical violation
- `[INFO]` – Informational message

---

### Sample Output (Mixed Results)

```text
[PASS] set -e enabled
[PASS] set -u enabled
[FAIL] Missing: set -o pipefail
[WARN] IFS not explicitly set
[PASS] trap EXIT configured
[INFO] Valid bash shebang detected

Summary:
✔ Passed: 3
⚠ Warnings: 1
✘ Failed: 1
```

---

### Sample Output (All Checks Passed)

```text
[PASS] set -euo pipefail enabled
[PASS] Safe IFS configured
[PASS] trap ERR configured
[PASS] trap EXIT configured
[PASS] Cleanup handler detected
[INFO] Valid bash shebang detected

Summary:
✔ Passed: 6
⚠ Warnings: 0
✘ Failed: 0
```

---

### Sample Output (Critical Failure)

```text
[FAIL] Missing strict mode configuration
[FAIL] Strict mode disabled using set +e
[FAIL] No trap handlers defined

Summary:
✔ Passed: 0
⚠ Warnings: 0
✘ Failed: 3
```

---

## 🚦 Exit Codes

| Exit Code | Meaning |
|---------|--------|
| `0` | All checks passed |
| `1` | One or more warnings |
| `2` | One or more critical failures |

---

## 📌 Notes

- Output order must remain consistent
- Summary must always be printed
- Script should be suitable for CI/CD usage
- Optional JSON output may be added later

---

## 🏁 Deliverable

A consistent input/output contract enabling:
- Automation
- CI integration
- Predictable validation behavior

