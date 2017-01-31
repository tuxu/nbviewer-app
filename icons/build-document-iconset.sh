#!/bin/sh
#
# Create a document iconset for Jupyter notebook from an SVG template
#
base_icon=/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/GenericDocumentIcon.icns
target_icon_name=JupyterNotebookIcon
svg_icon_file=$(pwd)/ipynb-document.svg
iconutil --convert iconset --output "${target_icon_name}.iconset" "${base_icon}"
iconsizes="16 32 128 256 512"
for size in $iconsizes ; do
    echo $size
    inkscape ${svg_icon_file} --export-id-only --export-id=v${size} \
        --export-png=$(pwd)/${target_icon_name}.iconset/icon_${size}x${size}.png \
        --export-width=$size --export-height=$size
    inkscape ${svg_icon_file} --export-id-only --export-id=v${size}x2 \
        --export-png=$(pwd)/${target_icon_name}.iconset/icon_${size}x${size}@2x.png \
        --export-width=$(echo 2*$size | bc) --export-height=$(echo 2*$size | bc)
done
optipng ${target_icon_name}.iconset/*.png
