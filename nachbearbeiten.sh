# 09.06.2025 21:02 – ersetzt Links mit &amp;L=0&amp;type=98.html durch neue Dateinamen (_L_0_type_98.html)

#!/bin/bash

echo "Block A – Dateien mit ? im Namen umbenennen…"

# HTML: index.php?id=... → ...html
find . -type f -name 'index.php?id=*.html' | while read -r f; do
  zielname=$(echo "$f" | sed 's|.*/index\.php?id=||')
  echo "→ $f → $zielname"
  mv "$f" "$zielname"
done

# CSS: xyz.css?version.css → xyz.css
find . -type f -name '*.css?*.css' | while read -r f; do
  zielname=$(echo "$f" | sed -E 's|\?.*\.css$||')
  echo "→ $f → $zielname"
  mv "$f" "$zielname"
done

# JS: xyz.js?abc.js → xyz.js
find . -type f -name '*.js?*.js' | while read -r f; do
  zielname=$(echo "$f" | sed -E 's|\?.*\.js$||')
  echo "→ $f → $zielname"
  mv "$f" "$zielname"
done

# Erweiterung: Dateien mit Sonderzeichen (&, =, ?, %) im Namen umbenennen
find . -type f | grep -E '[&=%?]' | while read -r f; do
  zielname=$(echo "$f" | sed -e 's|&|_|g' -e 's|=|_|g' -e 's|%|_|g' -e 's|\?|_|g')
  if [ "$f" != "$zielname" ]; then
    echo "→ $f → $zielname"
    mv "$f" "$zielname"
  fi
done

echo "Block A abgeschlossen."

echo ""
echo "Block B – Inhalte in Dateien anpassen…"

# HTML-Links: index.php%3Fid= → (entfernen)
find . -type f -name '*.html' -exec sed -i 's/index\.php%3Fid=//g' {} +

# CSS-Link-Pfade: xyz.css%3F... → xyz.css
find . -type f -name '*.html' -exec sed -i 's/\.css%3F[^"]*\.css/.css/g' {} +

# JS-Link-Pfade: xyz.js%3F... → xyz.js
find . -type f -name '*.html' -exec sed -i 's/\.js%3F[^"]*\.js/.js/g' {} +

echo "Block B abgeschlossen."

echo ""
echo "Block C – Links in HTML-Dateien an neue Dateinamen anpassen"

find . -type f -name '*.html' | while read -r file; do
  # index.php?id=...&L=0&type=98.html
  sed -i -E 's|index\.php\?id=([^"&]+)&L=0&type=98\.html|\1_L_0_type_98.html|g' "$file"

  # ...&L=0&type=98.html
  sed -i -E 's|([^"&]+)&L=0&type=98\.html|\1_L_0_type_98.html|g' "$file"

  # ...&amp;L=0&amp;type=98.html
  sed -i -E 's|([^"]+)&amp;L=0&amp;type=98\.html|\1_L_0_type_98.html|g' "$file"
done

echo "Block C abgeschlossen."

# 09.06.2025 21:02 – ersetzt Links mit &amp;L=0&amp;type=98.html durch neue Dateinamen (_L_0_type_98.html)
