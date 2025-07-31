#!/bin/bash
# save as backup-pkgs.sh

# List explicitly installed official packages
pacman -Qe > pkglist.txt

# List installed AUR packages
pacman -Qm > aurlist.txt

echo "Package lists saved to pkglist.txt and aurlist.txt"
