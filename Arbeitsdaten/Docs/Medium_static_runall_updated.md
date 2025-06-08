# How a PHP Update Turned into a Static TYPO3 Export Tool

## The Trigger: Forced PHP Upgrade

When a hosting provider upgrades the default PHP version, compatibility issues with older CMS platforms are inevitable. TYPO3 installations that haven't been updated in years may suddenly fail, leaving site owners with limited options: costly upgrades, emergency patches — or creative alternatives.

One of those alternatives: converting a dynamic TYPO3 site into a static HTML snapshot.

---

## A Clear Goal: Static Export with Clean Output

The objective: preserve a TYPO3-based site by creating a static copy that can be hosted anywhere — with clean filenames and working links. The result is an interactive Bash script that:

-  Guides the user through the export process
-  Downloads the live TYPO3 site using `wget`
-  Cleans up filenames with query strings (`?id=...`)
-  Fixes broken or encoded links inside HTML files
-  Saves everything into a custom-named folder under `static-copy/`

No PHP. No TYPO3 runtime. Just HTML.

---

## Step-by-Step: From URL to Static Site

### 1. Preparing the Environment

SSH access is required. Both `run_all.sh` and `nachbearbeiten.sh` must be uploaded to the TYPO3 webroot (`htdocs/`). There, the structure matches the expectations of internal links and file paths.

### 2. Guided Input

When launched, `run_all.sh` interactively asks the user for:

-  The **start URL** (e.g. `https://example.org)
-  A **custom folder name** for the export (`static-copy/your-folder`)

The script checks if the URL is valid. If not, it lets you retry or cancel.  
If the folder name already exists, it offers to choose a new one — making repeat exports easy and safe.

### 3. Exporting the Site

`wget` is used to create a recursive mirror of the provided URL.  
Assets like HTML, CSS, JS, images, and dependencies are collected under `static-copy/your-folder`.

### 4. Postprocessing & Cleaning

Once downloaded, `nachbearbeiten.sh` is automatically run inside the export folder. It:

-  Renames:
   -  `index.php?id=foo.html` → `foo.html`
   -  `style.css?abc.css` → `style.css`
-  Rewrites internal links in `.html` files:
   -  Removes `index.php%3Fid=`
   -  Fixes `.css%3F...` and `.js%3F...` references

This ensures a clean, navigable output that works offline or on any static web host.

### 5. Ready to Deploy

The static result lives in:

```
static-copy/your-folder/
```

You can now:

-  Open it in a browser
-  Upload it to a web server
-  Use it as a static landing page

Optionally, you can rename `index.php`/`index.html` and create a symlink:

```bash
ln -s static-copy/your-folder/start.html index.html
```

---

## Why It Works

This tool is ideal for:

-  **Archiving** legacy TYPO3 content
-  **Bypassing** urgent PHP upgrade issues
-  **Migrating** content to static hosting
-  **Staging** content temporarily while the CMS is offline

No data is modified. The original system remains untouched.

---

## Get the Script

The project lives on GitHub and includes everything you need:

👉 [github.com/your-repo](https://github.com/your-repo)

-  `run_all.sh`: main interactive script
-  `nachbearbeiten.sh`: renames and cleans up HTML content
-  HowTo guides and README for step-by-step help

---

## ❗ Disclaimer and Safety Warning

This script is provided **without any warranty or guarantee**.  
**Use at your own risk.**

Before running it:

-  Make a full backup
-  Understand what it does
-  Run in a safe test environment

**No responsibility is taken for data loss, file changes, or unexpected behavior.**

**Note:** This script and guide were generated with help from ChatGPT and editorially refined.

_Published: June 2025 – Updated_
