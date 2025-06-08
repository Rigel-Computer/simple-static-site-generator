<!-- 08.06.2025 21:35 – Statische HTML-Erzeugung aus TYPO3 mit Bash-Skript, inkl. CMS-Einschränkungen und Anwendungshinweis -->

# Wie ein PHP-Update zum statischen TYPO3-Export führte

## Einleitung

Dieses Tool erzeugt eine statische HTML-Version einer bestehenden Website – ursprünglich entwickelt für TYPO3-Installationen, die durch ein PHP-Upgrade nicht mehr lauffähig waren.

Dabei gilt: **Alle dynamisch generierten Inhalte, die zur Laufzeit eines Content-Management-Systems (CMS) wie TYPO3 erzeugt werden**, z. B. durch Erweiterungen wie *powermail* (Kontaktformulare), *news*, *login*, *tt_products* oder andere auf PHP-Logik basierende Funktionen, **werden in einem statischen Export nicht mehr funktionsfähig sein**. Da keine serverseitige Verarbeitung mehr stattfindet, gehen alle dynamischen Interaktionen verloren. Es handelt sich ausschließlich um einen HTML-Snapshot des jeweiligen Frontend-Zustands zum Zeitpunkt des Exports.

Das Skript wurde explizit mit TYPO3 getestet, sollte jedoch prinzipiell auch mit **anderen CMS-basierten Systemen** funktionieren, sofern diese Seiten auslieferbar machen, die sich per `wget` vollständig abgreifen lassen. Ebenso ist der Einsatz bei rein **statischen Websites** grundsätzlich problemlos möglich – wurde in diesen Fällen jedoch **nicht im Detail verifiziert**.

---

## Der Auslöser: Erzwungenes PHP-Upgrade

Wenn der Hosting-Anbieter die Standard-PHP-Version aktualisiert, sind Kompatibilitätsprobleme mit älteren CMS-Plattformen vorprogrammiert. TYPO3-Installationen, die seit Jahren nicht aktualisiert wurden, können plötzlich nicht mehr geladen werden. Die Optionen sind begrenzt: kostenintensive Upgrades, Notfall-Patches – oder kreative Alternativen.

Eine davon: die dynamische TYPO3-Website in eine statische HTML-Kopie umwandeln.

---

## Ziel: Statischer Export mit sauberem HTML

Ziel war es, eine TYPO3-basierte Website zu bewahren, indem eine statische Kopie erzeugt wird – mit sauberen Dateinamen und funktionierenden Links. Das Ergebnis ist ein interaktives Bash-Skript, das:

- den Nutzer durch den Exportprozess führt,
- die Live-TYPO3-Seite mittels `wget` herunterlädt,
- Dateinamen mit Query-Strings bereinigt (`?id=...`),
- defekte oder codierte Links in HTML-Dateien korrigiert und
- alles in einem benutzerdefinierten Ordner unter `static-copy/` ablegt.

Kein PHP. Kein TYPO3 im Hintergrund. Nur HTML.

---

## Schritt für Schritt: Von der URL zur statischen Website

### 1. Umgebung vorbereiten

SSH-Zugang ist erforderlich. Sowohl `run_all.sh` als auch `nachbearbeiten.sh` müssen ins Webroot der TYPO3-Installation hochgeladen werden (`htdocs/`). Nur so stimmen interne Verlinkungen und Pfadstrukturen.

### 2. Interaktive Eingabe

Beim Start fragt `run_all.sh` interaktiv nach:

- der **Start-URL** (z. B. `https://example.org`)
- einem **individuellen Ordnernamen** für den Export (`static-copy/dein-ordner`)

Das Skript prüft die URL auf Gültigkeit und erlaubt ggf. Wiederholung oder Abbruch.  
Existiert der Exportordner bereits, wird ein neuer Name vorgeschlagen – wiederholte Exporte sind dadurch sicher und nachvollziehbar.

### 3. Website exportieren

Die Spiegelung erfolgt per `wget` im rekursiven Modus.  
Dabei werden HTML, CSS, JS, Bilder und Abhängigkeiten unter `static-copy/dein-ordner` abgelegt.

### 4. Nachbearbeitung

Im Anschluss wird `nachbearbeiten.sh` automatisch im Zielordner ausgeführt. Das Skript:

- benennt um:
   - `index.php?id=foo.html` → `foo.html`
   - `style.css?abc.css` → `style.css`
- ersetzt interne Links in `.html`-Dateien:
   - entfernt `index.php%3Fid=`
   - korrigiert `.css%3F...` und `.js%3F...`-Referenzen

Das Ergebnis: eine saubere, navigierbare Kopie, die offline oder auf jedem statischen Webhost funktioniert.

### 5. Bereit zur Veröffentlichung

Die statische Website liegt nun unter:

```
static-copy/dein-ordner/
```

Ab hier:

- lokal im Browser aufrufbar
- uploadfähig auf beliebige Server
- verwendbar als statische Landingpage

Optional kann `index.php`/`index.html` umbenannt und ein Symlink gesetzt werden:

```bash
ln -s static-copy/dein-ordner/start.html index.html
```

---

## Warum es funktioniert

Das Tool eignet sich ideal zum:

- **Archivieren** von TYPO3-Altbeständen,
- **Umgehen** akuter PHP-Kompatibilitätsprobleme,
- **Migrieren** auf statisches Hosting und
- **Zwischenspeichern**, falls das CMS vorübergehend offline ist.

Die Ursprungsinstallation bleibt unangetastet. Es werden keine Daten verändert.

---

## Skript herunterladen

Das Projekt ist auf GitHub verfügbar und enthält:

👉 [github.com/your-repo](https://github.com/your-repo)

- `run_all.sh`: Hauptskript mit Interaktivität
- `nachbearbeiten.sh`: Korrektur und Umbenennung
- HowTo-Anleitungen und README für den Einstieg

---

## ❗ Haftungsausschluss

Dieses Skript wird **ohne Gewährleistung oder Garantie** bereitgestellt.  
**Verwendung auf eigenes Risiko.**

Vor dem Einsatz:

- Vollständiges Backup anlegen
- Verständnis der Funktionsweise sicherstellen
- In Testumgebung ausprobieren

**Für Datenverlust, Dateiänderungen oder unerwartetes Verhalten wird keine Haftung übernommen.**

_Hinweis: Dieses Skript und die Anleitung wurden mit Unterstützung von ChatGPT erstellt und redaktionell überarbeitet._

_Publikation: Juni 2025 – Aktualisiert_

<!-- 08.06.2025 21:35 – Statische HTML-Erzeugung aus TYPO3 mit Bash-Skript, inkl. CMS-Einschränkungen und Anwendungshinweis -->
