#!/bin/bash

# Schleife zur Abfrage einer gültigen URL
# Falls die URL nicht erreichbar ist, kann der Benutzer eine neue eingeben oder den Vorgang abbrechen
while true; do
  read -p "Gib die Start-URL der TYPO3-Seite ein: " STARTURL

  # Prüft, ob die URL erreichbar ist (HEAD-Request)
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

# Schleife für die Eingabe eines Zielunterordners unterhalb von static-copy
# Falls der Ordner existiert, wird der Benutzer gefragt, ob ein anderer Name gewählt werden soll
# Auf automatisches Löschen vorhandener Ordner wird aus Sicherheitsgründen verzichtet
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

# Startet den statischen Website-Export mit wget
# --mirror: rekursiv + Zeitstempel + Linkanpassung
# --convert-links: Links in heruntergeladenen Seiten konvertieren
# --adjust-extension: Dateierweiterungen anpassen (z. B. .html)
# --page-requisites: CSS, JS, Bilder usw. einbeziehen
# --no-parent: keine übergeordneten Verzeichnisse crawlen
# --wait / --limit-rate: Server schonen
# --user-agent: setzt Browserkennung
# -P: Zielverzeichnis

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
  -P "$ZIELORDNER" \
  "$STARTURL"

echo "Statischer Export abgeschlossen."

# Kopiert das Nachbearbeitungsskript in das Zielverzeichnis, falls vorhanden
if [ -f nachbearbeiten.sh ]; then
  cp nachbearbeiten.sh "$ZIELORDNER"/
  chmod +x "$ZIELORDNER"/nachbearbeiten.sh
else
  echo "Fehler: nachbearbeiten.sh wurde nicht gefunden."
  exit 1
fi

# Führt die Nachbearbeitung aus (Umbenennung & Link-Korrektur)
echo "Starte Nachbearbeitung im Ordner $ZIELORDNER ..."
(cd "$ZIELORDNER" && ./nachbearbeiten.sh)

# Prüft, ob das Nachbearbeitungsskript erfolgreich war
if [ $? -ne 0 ]; then
  echo "Fehler beim Ausführen von nachbearbeiten.sh"
  exit 1
fi

# Abschlussmeldung
echo "Vorgang abgeschlossen. Statische Kopie liegt unter $ZIELORDNER vor."
