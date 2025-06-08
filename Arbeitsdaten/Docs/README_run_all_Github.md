# typo3-static-export

📦 Export TYPO3 pages as static HTML with corrected filenames and links – interactively and safely.

---

## ⚙️ What it does

This toolset uses `run_all.sh` to perform a complete, guided export of TYPO3 content as static HTML. It:

- Downloads a full page tree using `wget`
- Renames problematic files (with `?` in the name)
- Fixes broken or encoded paths inside HTML files
- Saves each run in a separate folder under `static-copy/`

---

## ✅ Requirements

- SSH access to the TYPO3 web server
- Tools installed: `bash`, `wget`, `sed`, `find`, `curl`
- The target TYPO3 page must be publicly accessible

---

## 🚀 Quick Start

1. Upload both scripts to your web root (e.g. `htdocs/`):
   - `run_all.sh`
   - `nachbearbeiten.sh`
2. SSH into the server and make the script executable:
   ```bash
   chmod +x run_all.sh
   ```
3. Launch the export:
   ```bash
   ./run_all.sh
   ```

---

## 🧩 You will be asked to enter:

- A **full TYPO3 URL** to the start page (e.g. `https://example.org/index.php?id=1`)
- A **name for the export folder** (e.g. `projekt2025`) under `static-copy/`
  - If the folder exists, you can choose a different one
  - This allows safe multiple runs without overwriting

---

## 🔄 What happens

1. A full recursive export is created with `wget`
2. Files are placed in `static-copy/your_folder/`
3. `nachbearbeiten.sh` is copied into the folder and run
   - It renames files like:
     - `index.php?id=abc.html` → `abc.html`
     - `styles.css?xyz.css` → `styles.css`
   - It also edits all `.html` files to clean internal paths:
     - Removes `index.php%3Fid=`
     - Replaces `.css%3F...` and `.js%3F...`

---

## 📁 Result

A clean static HTML copy is created in:

```
static-copy/YOUR_FOLDER/
```

You can open it locally or deploy it elsewhere.

---

## 🧷 Optional: Replace your live TYPO3 front page

If you want to use the exported static HTML as a landing page:

1. Rename TYPO3's `index.php` and `index.html`:
   ```bash
   mv index.php index.php.orig
   mv index.html index.html.orig
   ```
2. Create a symlink:
   ```bash
   ln -s static-copy/projekt2025/start.html index.html
   ```

> Adjust the folder and file name to your actual setup.

---

## 🔐 Safe by design

- No changes are made to the TYPO3 system
- All work happens inside `static-copy/`
- Existing folders are never deleted automatically

---

## ⚠️ Disclaimer

This script is provided **as-is** without warranty. Use at your own risk.

Before use:

- Make a full backup of your system
- Understand what the script does
- Test in a controlled environment

**Created: 2025-06-08 — Version 2.0**
