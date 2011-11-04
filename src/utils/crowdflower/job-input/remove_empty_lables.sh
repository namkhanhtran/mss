#$ -wd /mnt/8tera/test-marco/image-and-text/elia/mirflickr/dataset/data/meta/all_tags
#$-q *@compute-0-*
#$ -j y
#$ -S /bin/bash
#$ -m bea
#$ -M elia.bruni@gmail.com


# This script removes empty files
echo "begin"

find . -type f -size 0k -exec rm {} \; | awk '{ print $8 }'

echo "done"
