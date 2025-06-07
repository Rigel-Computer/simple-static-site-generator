#!/bin/bash
# 2025-06-06 21:20 MESZ – Umbenennung & Link-Korrektur für HTML, CSS, JS (nur bei ? im Namen)

echo "🅰️ Block A – Dateien mit ? im Namen umbenennen…"

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

echo "✅ Block A abgeschlossen."

echo ""
echo "🅱️ Block B – Inhalte in Dateien anpassen…"

# HTML-Links: index.php%3Fid= → (entfernen)
find . -type f -name '*.html' -exec sed -i 's/index\.php%3Fid=//g' {} +

# CSS-Link-Pfade: xyz.css%3F... → xyz.css
find . -type f -name '*.html' -exec sed -i 's/\.css%3F[^"]*\.css/.css/g' {} +

# JS-Link-Pfade: xyz.js%3F... → xyz.js
find . -type f -name '*.html' -exec sed -i 's/\.js%3F[^"]*\.js/.js/g' {} +

echo "✅ Block B abgeschlossen."
