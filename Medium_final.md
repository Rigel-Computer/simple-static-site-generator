# How a PHP Update Turned into a Static TYPO3 Export Tool

## The Trigger: Forced PHP Upgrade

When a hosting provider upgrades the default PHP version, compatibility issues with older CMS platforms are inevitable. TYPO3 installations that haven't been updated in years may suddenly fail, leaving site owners with limited options: costly upgrades, emergency patches — or creative alternatives.

One of those alternatives: converting a dynamic TYPO3 site into a static HTML snapshot.

---

## A Simple Goal: Static Export + Clean Links

The objective was clear: preserve a TYPO3-based site by creating a static copy that can be hosted anywhere — with clean filenames and working links. The result is a single Bash script that:

-  Exports the live TYPO3 site using `wget`
-  Cleans up filenames containing query strings like `?id=...`
-  Fixes broken links inside HTML files
-  Structures all output in a simple folder hierarchy

No server-side execution needed, no active PHP — just plain HTML.

---

## The Flow, Step by Step

### 1. Preparing the Environment

Before running the export, access to the server via SSH is required. The script is meant to run directly inside the TYPO3 webroot (typically `htdocs/`). That’s where TYPO3’s `index.php` lives — and where relative links make sense.

### 2. Asking the Right Questions

To make the process reusable and adaptable, the script asks for three pieces of input:

-  The **page ID or alias** that TYPO3 uses to identify the start page
-  The **desired name for the resulting HTML file** (e.g. `home.html`)
-  A **custom folder name** for the export (placed under `static-copy/`)

Additionally, the domain of the live site is needed, including `http` or `https`.

### 3. Exporting the Site

With the user input, the script builds a full URL like:

```
https://example.com/index.php?id=1
```

Then it runs a recursive `wget` mirror download. All pages, images, CSS, JS, and assets are collected and saved under the defined folder.

### 4. Cleaning the Mess

TYPO3 URLs often include query parameters. These lead to filenames like:

```
index.php?id=1.html
main.css?version=5.css
```

The script detects and renames them to:

```
home.html
main.css
```

It also opens every downloaded `.html` file and removes remnants like `index.php%3Fid=` or encoded JS/CSS references.

### 5. Result: Portable Static Website

The final output resides in:

```
static-copy/your-folder/
```

It can be opened in any browser — offline or from any basic web server. Clean, fast, and dependency-free.

---

## Why This Matters

This approach can serve as:

-  A **bridge solution** while rebuilding or upgrading TYPO3
-  A **lightweight archive** of legacy content
-  A **migration tool** to decouple from PHP hosting

The Bash script is open and transparent. It doesn’t modify the live TYPO3 site. All operations are local and reversible.

---

## Get the Script

The full script, including instructions and usage examples, is available on GitHub:

👉 [github.com/your-repo](https://github.com/your-repo)

Use it, adapt it, improve it.

👉 In addition to the Bash script, a detailed **HowTo guide** is included in the repository to explain each step.

---

## ❗ Disclaimer and Safety Warning

This script is provided **without any warranty or guarantee** of any kind.  
**Use at your own risk.**

Before running the script:

-  Make a complete backup of all relevant files and directories on the server
-  Verify you understand what the script does
-  Ensure it is executed in a safe and appropriate environment

## **No responsibility is taken for data loss, file changes, or unexpected behavior.**

**Note:** This HowTo and the Bash script were automatically generated with the help of ChatGPT and editorially refined.


_Published: June 2025_
