# 2025-06-07 21:27 MESZ – Kombiniertes Export- und Nachbearbeitungs-Skript für TYPO3-HTML-Export

#!/bin/bash

# Benutzerabfragen
read -p "Gib die ID oder den Alias der Startseite ein: " ID
read -p "Wie soll die erzeugte HTML-Datei heißen (ohne .html, z. B. startseite)? " HTMLBASENAME
HTMLNAME="${HTMLBASENAME%.html}.html"
read -p "Gib den Namen des Ziel-Unterordners ein (z. B. meinprojekt): " ORDNERNAME

# Zielverzeichnis setzen (immer unter static-copy)
ZIELORDNER="static-copy/$ORDNERNAME"

# Start-URL zusammensetzen (https:// muss der Benutzer mitliefern)
read -p "Gib die Domain inkl. http(s) an (z. B. https://example.com): " DOMAIN
STARTURL="$DOMAIN/index.php?id=$ID"

# Benutzeragent setzen
USERAGENT="Mozilla/5.0"

# Website herunterladen
wget \
  --mirror \
  --convert-links \
  --adjust-extension \
  --page-requisites \
  --no-parent \
  --wait=1 \
  --limit-rate=100k \
  --user-agent="$USERAGENT" \
  -P "$ZIELORDNER" \
  "$STARTURL"

echo "Statische Kopie wurde in '$ZIELORDNER' gespeichert."

# In das Zielverzeichnis wechseln
cd "$ZIELORDNER"/* || { echo "Fehler: Ziel-Unterverzeichnis nicht gefunden."; exit 1; }

# Block A – Dateien mit ? im Namen umbenennen
echo "Block A – Dateien mit ? im Namen umbenennen..."

counter=0
find . -type f -name 'index.php?id=*.html' | while read -r f; do
  if [ $counter -eq 0 ]; then
    zielname="$HTMLNAME"
  else
    zielname=$(echo "$f" | sed 's|.*/index\.php?id=||')
  fi
  echo "$f → $zielname"
  mv "$f" "$zielname"
  counter=$((counter + 1))
done

# CSS: xyz.css?version.css → xyz.css
find . -type f -name '*.css?*.css' | while read -r f; do
  zielname=$(echo "$f" | sed -E 's|\?.*\.css$||')
  echo "$f → $zielname"
  mv "$f" "$zielname"
done

# JS: xyz.js?abc.js → xyz.js
find . -type f -name '*.js?*.js' | while read -r f; do
  zielname=$(echo "$f" | sed -E 's|\?.*\.js$||')
  echo "$f → $zielname"
  mv "$f" "$zielname"
done

echo "Block A abgeschlossen."

# Block B – Inhalte in HTML-Dateien anpassen
echo "Block B – Inhalte in HTML-Dateien anpassen..."

# HTML-Links: index.php%3Fid= → (entfernen)
find . -type f -name '*.html' -exec sed -i 's/index\.php%3Fid=//g' {} +

# CSS-Link-Pfade: xyz.css%3F... → xyz.css
find . -type f -name '*.html' -exec sed -i 's/\.css%3F[^"]*\.css/.css/g' {} +

# JS-Link-Pfade: xyz.js%3F... → xyz.js
find . -type f -name '*.html' -exec sed -i 's/\.js%3F[^"]*\.js/.js/g' {} +

echo "Block B abgeschlossen."
