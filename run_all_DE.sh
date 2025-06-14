# 09.06.2025 14:09 – Fügt Benutzerhinweis für vollständige URLs hinzu (inkl. Protokoll/Subdomain) zur Vermeidung fehlerhafter Aufrufe

#!/bin/bash

# Schleife zur Abfrage einer gültigen URL
while true; do
  echo
  echo "Hinweis:"
  echo "Bitte gib die vollständige URL mit Protokoll und ggf. Subdomain an."
  echo "Beispiel: https://www.example.com oder https://sub.example.com"
  echo "Ohne Subdomain (z. B. nur example.com) funktioniert der Aufruf evtl. nicht!"
  echo

  read -p "Gib die Start-URL der TYPO3-Seite ein: " STARTURL

  # Sicherstellen, dass ein Protokoll vorhanden ist
  if [[ ! "$STARTURL" =~ ^https?:// ]]; then
    echo "Fehler: Bitte gib die vollständige URL inklusive http:// oder https:// an."
    continue
  fi

  if curl --head --silent --fail "$STARTURL" > /dev/null; then
    break
  else
    echo "Ungültige URL oder Server nicht erreichbar: $STARTURL"
    read -p "Neue URL eingeben? (j/n): " NEUVERSUCH
    if [ "$NEUVERSUCH" != "j" ]; then
      echo "Abbruch durch Benutzer."
      exit 1
    fi
  fi
done

# Zielunterordner bestimmen
while true; do
  read -p "Gib den Namen des Unterordners in static-copy ein (z. B. lauf1): " UNTERORDNER
  ZIELORDNER="static-copy/$UNTERORDNER"

  if [ -d "$ZIELORDNER" ]; then
    echo "Ordner $ZIELORDNER existiert bereits."
    read -p "Anderen Ordnernamen eingeben? (j/n): " NEUWAHL
    if [ "$NEUWAHL" != "j" ]; then
      echo "Abbruch durch Benutzer."
      exit 1
    fi
  else
    break
  fi
done

# Website-Export mit wget (ohne Host-Unterordner)
echo "Starte statischen Export von $STARTURL nach $ZIELORDNER ..."

wget \
  --mirror \
  --convert-links \
  --adjust-extension \
  --page-requisites \
  --no-parent \
  --wait=1 \
  --limit-rate=100k \
  --user-agent="Mozilla/5.0" \
  --no-host-directories \
  -P "$ZIELORDNER" \
  "$STARTURL"

echo "Statischer Export abgeschlossen."

# Nachbearbeitungsskript kopieren und ausführen
if [ -f nachbearbeiten.sh ]; then
  cp nachbearbeiten.sh "$ZIELORDNER"/
  chmod +x "$ZIELORDNER"/nachbearbeiten.sh
else
  echo "Fehler: nachbearbeiten.sh wurde nicht gefunden."
  exit 1
fi

echo "Starte Nachbearbeitung im Ordner $ZIELORDNER ..."
(cd "$ZIELORDNER" && ./nachbearbeiten.sh)

if [ $? -ne 0 ]; then
  echo "Fehler beim Ausführen von nachbearbeiten.sh"
  exit 1
fi

echo "Vorgang abgeschlossen. Statische Kopie liegt unter $ZIELORDNER vor."

# 09.06.2025 14:09 – Fügt Benutzerhinweis für vollständige URLs hinzu (inkl. Protokoll/Subdomain) zur Vermeidung fehlerhafter Aufrufe
