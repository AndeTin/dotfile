#!/bin/bash

cut -d ' ' -f 1 pkglist.txt | xargs sudo pacman -S --

cut -d ' ' -f 1 aurlist.txt | xargs yay -S --
