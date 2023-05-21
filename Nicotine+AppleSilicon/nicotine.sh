#!/bin/bash

# This is a script to package Nicotine+ for macOS on Apple Silicon.
# Currently export settings produces a crash, and some internal icons don't display properly.
# If not already installed, follow the instructions on installing Homebrew: https://brew.sh/
# Likewise, then install git if needed with 'brew install git'

# Clone the nicotine-plus Git repository and install dependencies:

git clone https://github.com/nicotine-plus/nicotine-plus && \
cd nicotine-plus && \
export NICOTINE_GTK_VERSION=4 && \
brew install python gsettings-desktop-schemas && \
python3 packaging/macos/dependencies.py && \

# Create loaders.cache and gschemas.compiled references in the expected locations:

if [[ ! -d "/usr/local/lib/gdk-pixbuf-2.0/2.10.0" ]] ; then
	sudo mkdir -p /usr/local/lib/gdk-pixbuf-2.0/2.10.0 && \
	if [[ ! -f "/usr/local/lib/gdk-pixbuf-2.0/2.10.00/loaders.cache" ]]; then
		sudo touch /usr/local/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache
	fi
fi
sudo sh -c 'gdk-pixbuf-query-loaders > \
	/usr/local/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache' && \

if [[ ! -d "/usr/local/share/glib-2.0/schemas/" ]] ; then
	sudo mkdir -p /usr/local/share/glib-2.0/schemas/
fi
sudo glib-compile-schemas \
	--targetdir=/usr/local/share/glib-2.0/schemas/ \
	/opt/homebrew/Cellar/gsettings-desktop-schemas/44.0/share/glib-2.0/schemas \

# Build the application:

python3 packaging/macos/setup.py bdist_dmg

# When the application has finished building, it is located in the packaging/macos/build/ 
# subfolder as a .dmg file.