# TYPO3 HTML-Export: Anleitung zur Nutzung des Skripts `typo3_export_clean.sh`

## ⚠️ Wichtig

❗ Das Skript **muss im Webroot-Verzeichnis ausgeführt werden**, z. B. in `htdocs/`  
❗ Nur dort ist sichergestellt, dass TYPO3-Inhalte und Verlinkungen richtig verarbeitet werden  
❗ Bei falschem Pfad können Dateien fehlen oder nicht korrekt umbenannt/verknüpft werden  
❗ Vor dem Start in das entsprechende Verzeichnis auf dem Server wechseln (falls nötig)

```bash
cd /pfad/zum/htdocs
```

---

## Voraussetzungen

-  SSH-Zugang zum Zielserver
-  Bash-Shell verfügbar
-  Tools `wget`, `sed`, `find` vorhanden (Standard unter Linux)
-  Die ID oder der Alias der TYPO3-Startseite muss bekannt sein

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
   -  `index.php?id=...html` → benutzerdefinierter Name
   -  `.css?...` → `.css`
   -  `.js?...` → `.js`
4. Anpassung der Inhalte aller `.html`-Dateien:
   -  Entfernen von `index.php%3Fid=`
   -  Bereinigung von `.css%3F...`- und `.js%3F...`-Verweisen

---

## Ergebnis

Alle Dateien befinden sich anschließend im Verzeichnis:

```
static-copy/ORDNERNAME/
```

Die statische Kopie kann lokal im Browser geöffnet und überprüft werden.

---

## Hinweise

-  Keine Veränderungen am Live-System
-  Arbeitsverzeichnis ist vollständig auf `static-copy` begrenzt
-  Wiederholbarer Vorgang mit neuem Verzeichnisnamen

---

Stand: 2025-06-07 – Version 1.0
