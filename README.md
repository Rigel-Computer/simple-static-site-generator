# Simple Static Site Generator

A tool to create static HTML versions of websites. Thoroughly tested with TYPO3 installations, but should be applicable to any dynamic, CMS-based system with a crawlable frontend.

## Overview

### This tool creates a static HTML version of an existing website — originally developed for TYPO3 installations that became non-functional after a PHP upgrade. The result is a complete static copy that can be hosted anywhere without PHP dependencies.

**Important:** Dynamic content generated at runtime by a CMS (forms, news plugins, login mechanisms, shopping carts, or other PHP-based logic) will not function in a static export. What remains is a frozen HTML snapshot of the site's frontend.

## The Problem

When hosting providers upgrade their default PHP version, compatibility issues with older CMS platforms can arise. TYPO3 installations that haven't been updated may suddenly fail, leaving site owners with limited options:

-  Costly upgrades
-  Emergency patches
-  Converting to a static site (this tool's approach)

## Features

-  Interactive Bash script with guided process
-  Downloads the live site using `wget`
-  Cleans up filenames with query strings (`?id=...`)
-  Fixes broken or encoded links inside HTML files
-  Creates a self-contained static site ready for deployment

## Key Advantages

1. The site remains accessible online in its current state
2. You can work locally with the CMS/PHP version (e.g., using Docker or DDEV) by:
   -  Deleting the symlink pointing to `index.php`
   -  Commenting out the new lines added in `.htaccess`

## Requirements

-  SSH access to your web server
-  Bash shell environment
-  `wget` utility installed

## Installation

Upload both scripts to your TYPO3 webroot (`htdocs/`):

-  `run_all.sh` - main interactive script
-  `nachbearbeiten.sh` - post-processing script

## Usage

1. Connect to your server via SSH
2. Navigate to your TYPO3 webroot
3. Run the script:
   ```
   bash run_all.sh
   ```
4. Follow the interactive prompts:
   -  Enter the start URL (e.g., `https://example.org`)
   -  Provide a custom folder name for the export

The script will:

-  Validate your inputs
-  Export the site using `wget`
-  Process the files to fix links and filenames
-  Save everything to `static-copy/your-folder/`

## Deployment

After export, your static site will be in `static-copy/your-folder/`.

For optimal functionality:

1. Identify your original homepage in the exported folder (e.g., "1.html" or "Startseite.html")
2. Rename your original `index.php` to `index.php_orig`
3. Create a symlink to your static homepage:
   ```
   ln -s static-copy/your-folder/start.html index.html
   ```

## Use Cases

-  Archiving legacy TYPO3 content
-  Bypassing urgent PHP upgrade issues
-  Migrating content to static hosting
-  Temporary solution while the CMS is offline

## Limitations

-  No dynamic content functionality
-  One-time snapshot of the site
-  No CMS admin access after conversion

## Get the Script

The repository includes everything you need:

-  `run_all.sh`: main interactive script
-  `nachbearbeiten.sh`: renames and cleans up HTML content
-  HowTo guides and README for step-by-step help

**❗❗❗ Be sure to read and follow the HowTo! ❗❗❗**

## Disclaimer and Safety Warning

This script is provided **without any warranty or guarantee**.  
**Use at your own risk.**

Before running it:

-  ⚠️ Make a full backup
-  📚 Understand what it does
-  🧪 Run in a safe test environment

**No responsibility is taken for data loss, file changes, or unexpected behavior.**

**Note:** This script and guide were generated with help from ChatGPT / Claude and editorially refined.

## License

MIT - License

---

_This tool was created in June 2025. Last updated: June 2025._
