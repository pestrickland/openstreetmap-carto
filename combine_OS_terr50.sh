#!/bin/bash
for d in $(ls)
do
    cd $d
    file="${d^^}.shp"
    find . -type f -name '*.zip' -print0 | xargs -0 -r -n1 unzip
    for i in $(ls *_line.shp)
    do
        if [ -f "$file" ]
        then
            echo "Merging"
            ogr2ogr -f 'ESRI Shapefile' -update -append $file $i
        else
            echo "Creating $file"
            ogr2ogr -f 'ESRI Shapefile' $file $i
        fi
    done
    find . -type f -print0 | grep -E -z '[A-Z]{2}[0-9]{2}_' | xargs -0 -r rm -f
    find . -type f -print0 | grep -E -z 'Metadata_' | xargs -0 -r rm -f
    find . -type f -name '*.zip' -print0 | xargs -0 -r rm -f
    cd ..
done
