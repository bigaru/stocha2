#!/bin/bash

file=$1
page_count=$(pdfinfo $file | awk '/^Pages:/ {print $2}')
filename="${file%.*}"


for (( i=1 ; i<=$page_count ; i++ ));  
do
    inkscape --pdf-poppler --export-type=svg -n $i -o ./$filename/page_no$i.svg $file  
done

inkscape --batch-process --actions='select-all;path-simplify;export-plain-svg'  --export-type=svg --export-overwrite ./$filename/*.svg &&
python3 svg_stack.py --direction=v --margin=50 $(ls $filename/*.svg | sort -V) > $filename.svg &&
rm -Rf ./$filename/
echo "completed"
