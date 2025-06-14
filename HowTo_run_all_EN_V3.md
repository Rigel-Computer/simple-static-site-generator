<!-- 09.06.2025 22:20 – Static HTML export from TYPO3 using Bash script, incl. CMS limitations and usage notes -->

# TYPO3 HTML Export: New Guide with `run_all.sh`

## Language Versions

There are two variants of this script available:

-  `run_all_DE.sh` with German-language prompts
-  `run_all_EN.sh` with English-language prompts

## Important

-  Dynamically generated content created at runtime by a CMS like TYPO3 (e.g. contact forms via _powermail_, news plugins, login areas, product systems etc.) **will not work** in the static export. The result is a pure HTML snapshot without server-side functionality.
-  The script was tested with TYPO3 but should also work with other CMS-based systems or purely static websites, as long as their pages can be completely downloaded using `wget`. These cases are **not explicitly tested**.
-  This script combines HTML export and post-processing into a single operation.
-  It is intended for TYPO3 websites and works with two helper scripts:
   -  `run_all.sh`: main script with user prompts
   -  `nachbearbeiten.sh`: post-processes the exported files

## Requirements

-  SSH access to the target server
-  Bash shell available
-  Tools `wget`, `sed`, `find`, `curl` must be installed
-  The TYPO3 site must be publicly accessible

## Preparation

1. Upload `run_all.sh` and `nachbearbeiten.sh` to the web directory (e.g. `htdocs/`)
2. Connect to the server via SSH
3. Make the script executable:
   ```bash
   chmod +x run_all.sh
   ```

## Execution

Start the main script:

```bash
./run_all.sh
```

### The following inputs are required:

1. **Start URL of the TYPO3 site**  
   The URL must be entered completely and correctly.  
   It is validated. In case of errors, a retry or abort is possible.

2. **Name of the subfolder for export**  
   e.g. `projekt2025`  
   The export will be placed in `static-copy/projekt2025`.  
   If the folder already exists, a different name can be used.  
   This makes multiple runs possible without overwriting previous exports.

## Automated Processing Steps

1. `wget` downloads the site recursively and saves it in the target folder
2. `nachbearbeiten.sh` is copied into the folder and executed:
   -  Renaming of problematic files:
      -  `index.php?id=...html` → `...html`
      -  `.css?...` → `.css`
      -  `.js?...` → `.js`
   -  Content adjustments in `.html` files:
      -  Removal of `index.php%3Fid=`
      -  Cleanup of `.css%3F...` and `.js%3F...` references

## Result

The static copy is fully available under:

```
static-copy/projekt2025/
```

It can be opened locally or used for deployment.

## Notes

-  The live system is **not** modified
-  The export can be repeated with a new folder name at any time
-  Automatic deletion of existing folders is **intentionally omitted** for safety reasons
-  The URL input allows multiple attempts in case of errors

## Redirect using `.htaccess` (optional)

If the exported files are not located directly in the webroot but for example under `static-copy/projekt2025/`, you can redirect all requests there automatically – **without changing the URL**.

### Requirements

-  Your web server uses Apache
-  `.htaccess` files are allowed (`AllowOverride All`)
-  `mod_rewrite` is active

### Rule (example for `projekt2025`)

```apache
# 09.06.2025 22:20 – Created by ChatGPT (no warranty)

RewriteEngine On

# Only redirect if the target folder exists
RewriteCond %{DOCUMENT_ROOT}/static-copy/projekt2025 -d

# Only redirect if file or directory does NOT exist in the webroot
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d

# Internally redirect to static directory (URL remains unchanged)
RewriteRule ^(.*)$ static-copy/projekt2025/$1 [L]
```

This rule can be **safely** integrated into existing `.htaccess` files – provided there is no global rewrite (`^.*$`) or it is not overridden.

## Integration of the `.htaccess` rule (backup recommended)

Before inserting the redirect rule into an existing `.htaccess` file, please consider the following:

1. **Make a backup of your current `.htaccess`**:

   ```bash
   cp .htaccess .htaccess-original
   ```

2. **Check** if any of the following entries already exist:

   -  `RewriteEngine On` (must appear only once)
   -  A generic rule like `RewriteRule ^(.*)$ ... [L]`

   If such rules are present, do **not insert duplicates**.  
   Instead, insert the new block **before an existing catch-all rule**, or adjust it accordingly.

3. **Avoid duplicate `[L]` rules** matching the same pattern `^.*$`.

4. Upload your modified `.htaccess` carefully and test it using a request to a file that is not in the root directory.

## Final Steps (optional)

If the static export is intended to replace the live site, you can:

1. Rename original files like `index.php` and `index.html`:

   ```bash
   mv index.php index.php.orig
   mv index.html index.html.orig
   ```

2. Create a symbolic link to the start page:
   ```bash
   ln -s static-copy/projekt2025/start.html index.html
   ```

> Adjust `projekt2025` and `start.html` accordingly!

---

## Security Notice

### Use of this script is at your own risk.

Before executing, it is strongly recommended to:

-  Create a full backup
-  Understand how it works
-  Perform tests in a suitable environment

**Status: 2025-06-08 – Version 2.1**

<!-- 14.06.2025 21:38 – Sprachhinweis ergänzt -->
