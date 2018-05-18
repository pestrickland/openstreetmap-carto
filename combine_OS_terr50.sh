#!/bin/bash
for d in $(ls)
do
    cd $d
    file="${d^^}.shp"
    find . -type f -name '*.zip' -exec unzip {} \;
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
    find . -type f | grep -E '[A-Z]{2}[0-9]{2}_' | xargs rm
    find . -type f | grep -E 'Metadata_' | xargs rm
    cd ..
done
