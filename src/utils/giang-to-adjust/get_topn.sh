#$ -wd /home/binhgiang.tran/top_n/
#$ -j y
#$ -S /bin/bash
#$ -m bea
#$ -M binhgiang.tran@unitn.it
echo "begin"
#perl tuple_to_link_word_vector.pl typedm.txt.k64.txt word_list_k64/
zip word_list_k64.zip word_list_k64/*
echo "done"

