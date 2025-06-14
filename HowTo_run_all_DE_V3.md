<!-- 08.06.2025 21:35 – Statische HTML-Erzeugung aus TYPO3 mit Bash-Skript, inkl. CMS-Einschränkungen und Anwendungshinweis -->

# TYPO3 HTML-Export: Neue Anleitung mit `run_all.sh`

## Sprachversionen

Für dieses Skript stehen zwei Varianten zur Verfügung:

-  `run_all_DE.sh` mit deutscher Benutzerführung
-  `run_all_EN.sh` mit englischer Benutzerführung

## Wichtig

-  Dynamisch generierte Inhalte, die zur Laufzeit eines CMS wie TYPO3 erzeugt werden (z. B. Kontaktformulare per _powermail_, News-Plugins, Loginbereiche, Produktsysteme etc.), **werden im statischen Export nicht mehr funktionieren**. Das Ergebnis ist ein reines HTML-Abbild ohne serverseitige Funktionen.
-  Das Skript wurde mit TYPO3 getestet, sollte aber prinzipiell auch mit anderen CMS-basierten Systemen oder rein statischen Websites funktionieren, sofern deren Seiten per `wget` vollständig abrufbar sind. Diese Fälle sind **nicht explizit getestet**.
-  Dieses Skript kombiniert HTML-Export und Nachbearbeitung in einem Ablauf.
-  Es ist für TYPO3-Websites gedacht und arbeitet mit zwei Hilfsskripten:
   -  `run_all.sh`: Hauptskript mit Benutzerführung
   -  `nachbearbeiten.sh`: Nachbearbeitung der Exportdateien

## Voraussetzungen

-  SSH-Zugang zum Zielserver
-  Bash-Shell verfügbar
-  Tools `wget`, `sed`, `find`, `curl` müssen installiert sein
-  Die TYPO3-Seite muss öffentlich erreichbar sein

## Vorbereitung

1. Dateien `run_all.sh` und `nachbearbeiten.sh` ins Webverzeichnis (z. B. `htdocs/`) hochladen
2. Per SSH auf den Server verbinden
3. Skript ausführbar machen:
   ```bash
   chmod +x run_all.sh
   ```

## Ausführung

Starte das Hauptskript:

```bash
./run_all.sh
```

### Folgende Eingaben sind erforderlich:

1. **Start-URL der TYPO3-Seite**  
   Die Seite muss vollständig und korrekt eingegeben werden.  
   Die URL wird geprüft. Bei Fehlern kann eine neue eingegeben oder abgebrochen werden.

2. **Name des Unterordners für den Export**  
   z. B. `projekt2025`  
   Der Export erfolgt nach `static-copy/projekt2025`.  
   Falls der Ordner existiert, kann ein anderer Name gewählt werden.  
   So sind auch mehrere Durchläufe problemlos möglich, ohne bestehende Exporte zu überschreiben.

## Automatische Verarbeitungsschritte

1. `wget` lädt die Seite rekursiv herunter und speichert sie im Zielordner
2. `nachbearbeiten.sh` wird in den Ordner kopiert und ausgeführt:
   -  Umbenennung problematischer Dateien:
      -  `index.php?id=...html` → `...html`
      -  `.css?...` → `.css`
      -  `.js?...` → `.js`
   -  Anpassung der Inhalte in `.html`-Dateien:
      -  Entfernen von `index.php%3Fid=`
      -  Bereinigung von `.css%3F...`- und `.js%3F...`-Links

## Ergebnis

Die statische Kopie liegt vollständig unter:

```
static-copy/ORDNERNAME/
```

Sie kann lokal geöffnet oder für Deployment verwendet werden.

## Hinweise

-  Das Live-System wird **nicht** verändert
-  Der Export ist jederzeit wiederholbar mit neuem Ordnernamen
-  Auf automatisches Löschen vorhandener Ordner wird aus Sicherheitsgründen **verzichtet**
-  Die URL-Eingabe erlaubt mehrere Versuche bei Fehlern

## Weiterleitung mit `.htaccess` (optional)

Wenn die erzeugten Dateien nicht direkt im Webroot liegen, sondern z. B. unter `static-copy/projekt2025/`, können Sie alle Aufrufe automatisch dorthin umleiten – **ohne die URL zu verändern**.

### Voraussetzung

-  Ihr Webserver nutzt Apache
-  `.htaccess`-Dateien sind erlaubt (`AllowOverride All`)
-  `mod_rewrite` ist aktiv

### Regel (Beispiel für `projekt2025`)

```apache
# 09.06.2025 22:13 – Erstellt von ChatGPT (keine Gewährleistung)

RewriteEngine On

# Nur weiterleiten, wenn der Zielordner existiert
RewriteCond %{DOCUMENT_ROOT}/static-copy/projekt2025 -d

# Nur weiterleiten, wenn Datei oder Verzeichnis im Webroot NICHT existiert
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d

# Intern umleiten auf statisches Verzeichnis (URL bleibt erhalten)
RewriteRule ^(.*)$ static-copy/projekt2025/$1 [L]
```

Diese Regel kann **sicher** in bestehende `.htaccess`-Dateien eingebaut werden – vorausgesetzt, es existiert noch keine allgemeine Weiterleitung (`^.*$`) oder diese wird nicht überschrieben.

## Integration der `.htaccess`-Regel (Sicherheitskopie empfohlen)

Bevor Sie die Weiterleitungsregel in eine bestehende `.htaccess`-Datei einfügen, beachten Sie Folgendes:

1. **Erstellen Sie eine Sicherheitskopie Ihrer aktuellen `.htaccess`**:

   ```bash
   cp .htaccess .htaccess-original
   ```

2. **Überprüfen Sie**, ob bereits folgende Einträge vorhanden sind:

   -  `RewriteEngine On` (darf nur einmal vorkommen)
   -  Eine allgemeine Regel wie `RewriteRule ^(.*)$ ... [L]`

   Falls solche Regeln bereits vorhanden sind, dürfen sie **nicht doppelt eingefügt werden**.  
   Der neue Block sollte **vor einer vorhandenen Catch-All-Regel eingefügt** oder mit ihr kombiniert werden.

3. **Vermeiden Sie doppelte `[L]`-Regeln**, die denselben Ausdruck `^.*$` abdecken.

4. Laden Sie die angepasste `.htaccess` vorsichtig hoch und testen Sie die Funktion z. B. mit einer bewusst aufgerufenen Datei, die nicht im Webroot liegt.

## Letzte Schritte (optional)

Falls der statische Export die Website ersetzen soll, können Sie:

1. Originaldateien wie `index.php` und `index.html` umbenennen:

   ```bash
   mv index.php index.php.orig
   mv index.html index.html.orig
   ```

2. Einen symbolischen Link zur Startseite setzen:
   ```bash
   ln -s static-copy/projekt2025/start.html index.html
   ```

> `projekt2025` und `start.html` anpassen!

---

## Sicherheitshinweis

### Die Nutzung des Skripts erfolgt auf eigenes Risiko.

Vor der Ausführung wird dringend empfohlen:

-  Ein vollständiges Backup zu erstellen
-  Die Funktionsweise zu verstehen
-  Tests in einer geeigneten Umgebung durchzuführen

**Stand: 2025-06-08 – Version 2.1**

<!-- 14.06.2025 21:38 – Sprachhinweis ergänzt -->
