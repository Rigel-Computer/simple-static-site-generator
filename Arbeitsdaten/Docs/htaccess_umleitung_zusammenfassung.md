<!-- 09.06.2025 21:56 – Zusammenfassung zur sicheren Verwendung von .htaccess-Umleitungen -->

# Einsatz von `.htaccess` für interne Umleitungen auf Unterverzeichnisse

## Ziel:
Alle Webanfragen, bei denen keine Datei oder kein Ordner im Webroot existiert, sollen intern an ein Unterverzeichnis weitergeleitet werden – etwa `static-copy/TestFinal/`.

## Sicherheit & Failsafe:
Damit eine solche Regel **nicht bestehende Konfigurationen beschädigt**, sind folgende Punkte unbedingt zu beachten:

### 1. `RewriteEngine On` nur einmal
Falls diese Zeile bereits in der Datei existiert: nicht erneut setzen.

### 2. Bestehende Regeln nicht überschreiben
Nur auf Anfragen anwenden, bei denen keine Datei/Verzeichnis existiert (`!-f`, `!-d`). So wird vermieden, dass z. B. ein CMS wie TYPO3, Laravel o. ä. beeinträchtigt wird.

### 3. Relativer Pfad muss passen
Der Pfad `static-copy/TestFinal/` muss relativ zur `.htaccess` korrekt angegeben sein.

### 4. Optionale Sicherheit: Existenzprüfung des Zielordners
Durch zusätzliche RewriteCond auf das Zielverzeichnis (`-d`) wird verhindert, dass Anfragen ins Leere laufen.

### 5. Kommentar & Haftung
Die Regel kann universell eingesetzt werden – **aber auf eigene Verantwortung**. Ein Hinweis wie *„Erstellt durch ChatGPT – keine Gewährleistung“* wird empfohlen.

---

**Empfohlene Regel:**

```apache
RewriteEngine On
RewriteCond %{DOCUMENT_ROOT}/static-copy/PROJECT-DIR -d
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ static-copy/PROJECT-DIR/$1 [L]
```

> `PROJECT-DIR` durch das tatsächliche Unterverzeichnis ersetzen.

<!-- 09.06.2025 21:56 – Ende der Zusammenfassung -->
