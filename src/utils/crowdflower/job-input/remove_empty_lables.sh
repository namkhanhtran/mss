#$ -wd <labels-dir>
#$-q *@compute-0-*
#$ -j y
#$ -S /bin/bash
#$ -m bea
#$ -M <account>


# This script removes empty files
echo "begin"

find . -type f -size 0k -exec rm {} \; | awk '{ print $8 }'

echo "done"
