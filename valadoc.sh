#!/bin/bash
valadoc --package-name=pluie-echo-0.1 --verbose --force -o ./doc --pkg glib-2.0 ./src/*.vala ./build/install.vala
rm doc/*.png
cp resources/doc-scripts.js ./doc/scripts.js
cp resources/doc-style.css ./doc/style.css
