# TYPO3 HTML-Export: Anleitung zur Nutzung des Skripts `typo3_export_clean.sh`

## ⚠️ Wichtig

❗ Das Skript **muss im Webroot-Verzeichnis ausgeführt werden**, z. B. in `htdocs/`  
❗ Nur dort ist sichergestellt, dass TYPO3-Inhalte und Verlinkungen richtig verarbeitet werden  
❗ Bei falschem Pfad können Dateien fehlen oder nicht korrekt umbenannt/verknüpft werden  
❗ Vor dem Start in das Verzeichnis mit dem Skript wechseln:
```bash
cd /pfad/zum/htdocs
```

---

## Voraussetzungen

- SSH-Zugang zum Zielserver
- Bash-Shell verfügbar
- Tools `wget`, `sed`, `find` vorhanden (Standard unter Linux)
- Die ID oder der Alias der TYPO3-Startseite muss bekannt sein

---

## Vorbereitung

1. Skript-Datei `typo3_export_clean.sh` auf den Server übertragen (z. B. per `scp` oder FTP)
2. SSH-Verbindung zum Server herstellen
3. Skript ausführbar machen:
   ```bash
   chmod +x typo3_export_clean.sh
   ```

---

## Ausführung

Skript starten mit:
```bash
./typo3_export_clean.sh
```

Folgende Eingaben werden abgefragt:

1. **ID oder Alias der TYPO3-Startseite**  
   (z. B. `1`)  
   Diese Angabe ist erforderlich für den Startpunkt des HTML-Exports.

2. **Dateiname für die erzeugte HTML-Datei**  
   (z. B. `startseite.html`)  
   Erleichtert die Wiedererkennung im Exportverzeichnis.

3. **Name des Unterordners für die Exportdateien**  
   (z. B. `projekt2025`)  
   Der Export erfolgt in das Verzeichnis `static-copy/projekt2025`.

4. **Domain inklusive Protokoll**  
   (z. B. `https://www.example.de`)  
   Daraus wird die Start-URL erzeugt: `https://www.example.de/index.php?id=...`

---

## Automatische Verarbeitungsschritte

1. HTML-Export mit `wget` in das angegebene Verzeichnis unterhalb `static-copy`
2. Wechsel in das Exportverzeichnis
3. Umbenennung problematischer Dateien:
   - `index.php?id=...html` → benutzerdefinierter Name
   - `.css?...` → `.css`
   - `.js?...` → `.js`
4. Anpassung der Inhalte aller `.html`-Dateien:
   - Entfernen von `index.php%3Fid=`
   - Bereinigung von `.css%3F...`- und `.js%3F...`-Verweisen

---

## Ergebnis

Alle Dateien befinden sich anschließend im Verzeichnis:
```
static-copy/ORDNERNAME/
```
Die statische Kopie kann lokal im Browser geöffnet und überprüft werden.

---

## Hinweise

- Keine Veränderungen am Live-System
- Arbeitsverzeichnis ist vollständig auf `static-copy` begrenzt
- Wiederholbarer Vorgang mit neuem Verzeichnisnamen

---

Status: 2025-06-07 – Version 1.0


---

## Final Steps Before Using in the Browser

Before accessing the static copy in a browser, two actions are required in the TYPO3 root directory:

### 1. Rename original files

TYPO3 usually uses `index.php` as its entry point. If an `index.html` also exists, the web server might prioritize it.

To avoid conflicts, rename both files:
```bash
mv index.php index.php.orig
mv index.html index.html.orig
```

> **Caution:** TYPO3 will no longer function normally after this change. This step only makes sense if the static export is intended to replace the live site.

### 2. Create a symlink to the new start page

Create a symbolic link in the root directory pointing to the new start page inside the export folder. Example:

```bash
ln -s static-copy/project2025/home.html index.html
```

> Replace `project2025` with the name of your chosen export folder  
> and `home.html` with the actual filename of your exported start page

This makes the web server serve your static site when accessing `/` in the browser.

## ❗ Disclaimer and Safety Notice

This script is provided **without any warranty or guarantee**.  
**Use at your own risk.**

Before running the script:

- Make a complete backup of all relevant files and directories on the server
- Understand what the script does and its effects
- Ensure the script is executed in a safe and appropriate environment

**No responsibility is taken for data loss, file changes, or unexpected behavior.**

**Note:** This HowTo and the Bash script were automatically generated with the help of ChatGPT and editorially refined.

