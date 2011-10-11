#$ -wd /home/elia.bruni/code/sh-filess
#$-l vf=8G
#$ -j y
#$ -S /bin/bash
#$ -m bea

echo "begin"
python2.6 /home/elia.bruni/src/s2m/vsm/cosine_similarity.py /home/elia.bruni/test-set/repo/cleaned-wordsim_similarity_goldstandard.txt /mnt/8tera/test-marco/image-and-text/elia/esp/features/new-feat/canny.txt /mnt/8tera/test-marco/image-and-text/elia/esp/dataset/esp_50k/ESP-ImageSet/eval/only-vision/wordsim/sim.txt 



echo "done"
