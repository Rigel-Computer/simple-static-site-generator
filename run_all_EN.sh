# 14.06.2025 13:15 – English version with translated user-facing messages only

#!/bin/bash

# Loop to request a valid URL

while true; do
echo
echo "Note:"
echo "Please enter the full URL including protocol and subdomain if applicable."
echo "Example: https://www.example.com or https://sub.example.com"
echo "Without a subdomain (e.g. just example.com), the call may fail!"
echo

read -p "Enter the start URL of the TYPO3 site: " STARTURL

# Ensure protocol is present

if [[! "$STARTURL" =~ ^https?://]]; then
echo "Error: Please enter the full URL including http:// or https://."
continue
fi

if curl --head --silent --fail "$STARTURL" > /dev/null; then
    break
  else
    echo "Invalid URL or server not reachable: $STARTURL"
    read -p "Enter a new URL? (y/n): " RETRY
    if [ "$RETRY" != "y" ]; then
echo "Aborted by user."
exit 1
fi
fi
done

# Determine target subfolder

while true; do
read -p "Enter the name of the subfolder in static-copy (e.g. run1): " SUBFOLDER
TARGETFOLDER="static-copy/$SUBFOLDER"

if [ -d "$TARGETFOLDER" ]; then
echo "Folder $TARGETFOLDER already exists."
    read -p "Enter a different folder name? (y/n): " NEWCHOICE
    if [ "$NEWCHOICE" != "y" ]; then
echo "Aborted by user."
exit 1
fi
else
break
fi
done

# Website export with wget (without host subdirectories)

echo "Starting static export from $STARTURL to $TARGETFOLDER ..."

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
 -P "$TARGETFOLDER" \
  "$STARTURL"

echo "Static export completed."

# Copy and run postprocessing script

if [ -f nachbearbeiten.sh ]; then
cp nachbearbeiten.sh "$TARGETFOLDER"/
  chmod +x "$TARGETFOLDER"/nachbearbeiten.sh
else
echo "Error: nachbearbeiten.sh not found."
exit 1
fi

echo "Starting postprocessing in folder $TARGETFOLDER ..."
(cd "$TARGETFOLDER" && ./nachbearbeiten.sh)

if [ $? -ne 0 ]; then
echo "Error while executing nachbearbeiten.sh"
exit 1
fi

echo "Process completed. Static copy is available under $TARGETFOLDER."

# 14.06.2025 13:15 – English version with translated user-facing messages only
