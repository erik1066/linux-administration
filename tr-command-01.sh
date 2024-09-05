echo "David 23 Atlanta" >> people.txt
echo "Maria 37 Chicago" >> people.txt

tr ' ' ',' < people.txt > people.csv
cat people.csv

OLDIFS="$IFS"
IFS=','
while read name age city; do
    echo $name
    echo $age
    echo $city
done < people.csv
IFS="$OLDIFS"

# cleanup files that were created as part of this script
rm people.txt 
rm people.csv