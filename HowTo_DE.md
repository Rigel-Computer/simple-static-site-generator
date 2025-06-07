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

Stand: 2025-06-07 – Version 1.0


---

## Letzte Schritte vor der Nutzung im Browser

Bevor Sie die statische Kopie im Browser aufrufen können, sind zwei Maßnahmen im TYPO3-Root-Verzeichnis notwendig:

### 1. Originale Dateien umbenennen

TYPO3 verwendet in der Regel eine `index.php` als Einstiegspunkt. Wenn zusätzlich eine `index.html` vorhanden ist, wird diese ggf. vom Webserver bevorzugt geladen.

Um Konflikte zu vermeiden, benennen Sie beide Dateien um:
```bash
mv index.php index.php.orig
mv index.html index.html.orig
```

> **Achtung:** TYPO3 funktioniert nach dieser Änderung nicht mehr wie gewohnt. Diese Maßnahme ist **nur sinnvoll, wenn der statische Export das neue Zielsystem ist**.

### 2. Symlink zur neuen Startseite erstellen

Erstellen Sie einen symbolischen Link im Root-Verzeichnis, der auf die neue Startseite im Exportverzeichnis zeigt. Beispiel:

```bash
ln -s static-copy/projekt2025/startseite.html index.html
```

> Ersetzen Sie `projekt2025` durch den Namen des von Ihnen gewählten Exportordners  
> und `startseite.html` durch den tatsächlichen Namen Ihrer exportierten Startdatei

Damit zeigt der Webserver beim Aufruf von `/` im Browser automatisch auf die neue statische Seite.

## ❗ Haftungsausschluss und Sicherheitshinweis

Dieses Skript wird **ohne jegliche Garantie oder Gewährleistung** bereitgestellt.  
**Die Nutzung erfolgt auf eigenes Risiko.**

Vor der Ausführung des Skripts unbedingt:

- Eine vollständige Sicherung aller relevanten Dateien und Verzeichnisse auf dem Server erstellen
- Den Ablauf und die Auswirkungen des Skripts verstehen
- Die Ausführung nur in einer geeigneten Umgebung durchführen

**Es wird keine Verantwortung für Datenverlust, Dateiveränderungen oder unerwartetes Verhalten übernommen.**

**Hinweis:** Dieses HowTo und das Bash-Skript wurden automatisiert mithilfe von ChatGPT erstellt und redaktionell angepasst.

