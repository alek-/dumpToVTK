#! /bin/bash

#get x y z coords by assinging line 6,7,8 to variables - q;d - quit before deleting line
for file in "$@"
do

timestep=$(sed '2q;d' $file)
atoms=$(sed '4q;d' $file)
x=$(sed '6q;d' $file)
y=$(sed '7q;d' $file)
z=$(sed '8q;d' $file)

cp $file "$file.tmp"
tmpfile="$file.tmp"

#delete first 9 lines
sed -i '1,9d' $tmpfile
datafile="$file.vtk"
#insert 1st line to the file, use double quotes to expand variables
printf "# vtk DataFile Version 2.0\n" > $datafile
printf "Generated by dumpToVTK\n" >> $datafile
printf "ASCII\n" >> $datafile
printf "DATASET POLYDATA\n" >> $datafile

# Dump data structure
#  1  2   3 4 5  6  7  8  9 10 11 12 13 14   15    16     17     18
# id type x y z ix iy iz vx vy vz fx fy fz omegax omegay omegaz radius 

#coordinates
printf "POINTS $atoms float\n" >> $datafile

#echo "Writing coordinates"
awk '{print $3, $4, $5}' $tmpfile >> $datafile

#echo "Vertices"
let atoms2=$atoms*2
printf "VERTICES $atoms $atoms2\n" >> $datafile
awk '{print $2, NR-1}' $tmpfile >> $datafile

#echo "Point data"
printf "POINT_DATA $atoms\n" >> $datafile
printf "VECTORS i float\n" >> $datafile
awk '{print $6, $7, $8}' $tmpfile >> $datafile

#echo "Forces"
printf "VECTORS f float\n" >> $datafile
awk '{print $12, $13, $14}' $tmpfile >> $datafile

#echo "Omega"
printf "VECTORS omega float\n" >> $datafile
awk '{print $15, $16, $17}' $tmpfile >> $datafile

#echo "Velocities"
printf "VECTORS v float\n" >> $datafile
awk '{print $9, $10, $11}' $tmpfile >> $datafile

#echo "Radius"
printf "SCALARS radius float 1\n" >> $datafile
printf "LOOKUP_TABLE default\n" >> $datafile
awk '{print $18}' $tmpfile >> $datafile

#echo "Type"
printf "SCALARS type float 1\n" >> $datafile
printf "LOOKUP_TABLE default\n" >> $datafile
awk '{print $2}' $tmpfile >> $datafile

#echo "id"
printf "SCALARS id float 1\n" >> $datafile
printf "LOOKUP_TABLE default\n" >> $datafile
awk '{print $1}' $tmpfile >> $datafile

rm $tmpfile

done

echo "Done"
notify-send "DUMP TO VTK FINISHED" -t 3000
