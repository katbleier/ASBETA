#!/bin/bash
# Build script for Berliner Tagebuch edition
# Run from the ASBETA root: ./tools/build.sh

set -e

# Paths
SAXON=tools/saxon9he.jar
INPUT=tei/berliner-tagebuch.xml
XSLT=xslt/build.xsl
OUT=/dev/null

# Ensure output folders exist
mkdir -p diary facsimiles persons works places organizations

# Run Saxon
java -jar "$SAXON" -s:"$INPUT" -xsl:"$XSLT" -o:"$OUT"

echo "✅ Build complete. HTML pages are in diary/ (and later other folders)."
