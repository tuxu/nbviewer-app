#!/bin/sh
#
# Create an App iconset for Jupyter Notebook Viewer from an SVG template
#
target_folder="$(pwd)/../Jupyter Notebook Viewer/Images.xcassets/AppIcon.appiconset"
svg_icon_file=$(pwd)/viewer-app.svg
iconsizes="16 32 128 256 512"
for size in $iconsizes ; do
    echo $size

    output_name="${target_folder}/icon_${size}x${size}.png"
    inkscape ${svg_icon_file} \
        --export-png="${output_name}" \
        --export-width=$(echo 4*$size | bc) --export-height=$(echo 4*$size | bc)
    convert "${output_name}" -colorspace RGB +sigmoidal-contrast "6.5,50%" \
        -filter Lanczos -resize "${size}x${size}" \
        -sigmoidal-contrast "6.5,50%" -colorspace sRGB "${output_name}"

    output_name="${target_folder}/icon_${size}x${size}@2x.png"
    inkscape ${svg_icon_file} \
        --export-png="${output_name}" \
        --export-width=$(echo 4*$size | bc) --export-height=$(echo 4*$size | bc)
    convert "${output_name}" -colorspace RGB +sigmoidal-contrast "6.5,50%" \
        -filter Lanczos -resize $(echo 2*$size | bc)x$(echo 2*$size | bc) \
        -sigmoidal-contrast "6.5,50%" -colorspace sRGB "${output_name}"
done
pushd "${target_folder}"
optipng *.png
popd
