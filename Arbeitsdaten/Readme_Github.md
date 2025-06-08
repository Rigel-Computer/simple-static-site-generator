# typo3-static-export-cleaner

📦 Export TYPO3 pages as static HTML and fix filenames and links in one automated process.

---

## ⚙️ What it does

This script helps generate static copies of TYPO3 websites using `wget`, and then automatically:

-  Renames HTML, CSS, and JS files that contain query strings (e.g. `?id=123`)
-  Cleans up encoded URLs and broken link paths inside HTML files
-  Stores everything neatly under `static-copy/YOUR_FOLDER`

---

## ✅ Requirements

-  Access to the server via SSH
-  `bash`, `wget`, `sed`, `find` available (default on most Linux systems)
-  The **ID or alias of the TYPO3 start page** must be known

---

## 🚀 How to use

👉 In addition to the Bash script, a detailed **HowTo guide** is included in the repository to explain each step.

1. Upload `typo3_export_clean.sh` to the TYPO3 server
2. Connect via SSH and switch to the TYPO3 root directory (e.g. `htdocs`)
3. Make the script executable:
   ```bash
   chmod +x typo3_export_clean.sh
   ```
4. Run the script:
   ```bash
   ./typo3_export_clean.sh
   ```

---

## 🧩 What you will be asked

-  ID or alias of your TYPO3 start page (e.g. `1`)
-  Desired name for the resulting HTML file (e.g. `home.html`)
-  A custom name for the export folder (under `static-copy/`)
-  Your full domain URL including `http` or `https`

---

## 🛠️ What happens next

1. A full static mirror is created with `wget`
2. Files are saved in `static-copy/YOUR_FOLDER`
3. The script changes into that folder and:
   -  Renames HTML, CSS, JS files with `?` in their names
   -  Updates HTML contents to use clean file paths

---

## 📁 Result

A browsable, static HTML snapshot will be available in:

```
static-copy/YOUR_FOLDER/
```

Open the HTML file in any browser — links and resources will work offline.

---

## ⚠️ Important

❗ The script must be run from within the TYPO3 root directory (usually `htdocs/`)  
❗ Incorrect paths can lead to missing files or broken links

---

## 🔒 Safe to use

-  No changes are made to the live TYPO3 system
-  Everything happens locally in `static-copy/`

---

Created: 2025-06-07 — Version 1.0

---

## ❗ Disclaimer and Safety Warning

This script is provided **without any warranty or guarantee** of any kind.  
**Use at your own risk.**

Before running the script:

-  Make a complete backup of all relevant files and directories on the server
-  Verify you understand what the script does
-  Ensure it is executed in a safe and appropriate environment

**No responsibility is taken for data loss, file changes, or unexpected behavior.**

---

**Note:** This HowTo and the Bash script were automatically generated with the help of ChatGPT and editorially refined.
