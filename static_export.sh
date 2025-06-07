#!/bin/bash

# Zielverzeichnis für die statische Kopie
ZIELORDNER="static-copy"

# Start-URL (z. B. Startseite deiner TYPO3-Installation)
STARTURL="http://www.gerd-gailing.de/index.php?id=1"

# Benutzeragent (optional, um Blockierungen zu vermeiden)
USERAGENT="Mozilla/5.0"

# Wget-Befehl: Lädt die Webseite rekursiv herunter und speichert sie im Zielordner
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

# Ausgabe einer Nachricht, dass die statische Kopie gespeichert wurde
echo "Statische Kopie wurde in '$ZIELORDNER' gespeichert."

# Hinweis: Mach das Skript ausführbar mit chmod +x typo3_static_export.sh
