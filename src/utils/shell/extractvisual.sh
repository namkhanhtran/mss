#$ -wd /home/gtran/top_n/
#$ -j y
#$ -S /bin/bash
#$ -m bea
#$ -l vf=8G
#$ -M gtran@l3s.de
echo "begin"
matlab phow_alg_fast_color_1250.m
perl tuple_to_link_word_vector.pl typedm.txt.k64.txt word_list_k64 zip word_list_k64.zip word_list_k64/*
python mapping.py
echo "done"

