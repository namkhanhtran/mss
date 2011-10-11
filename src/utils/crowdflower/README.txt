this is a howto for the EACL paper:

0. code to combine the 2 CF jobs

1. inverted_index_from_files.py (to be readapted to work only with a final result): 
   --> outputs images and labels dir.

2.0.0 pos_mapper.py in preprocess dir
   --> outputs pos-tagged labels
2.0.1 compute all the visual features
2.0.2 generate_VM.sh 
  --> outputs a visual feature vector for each word
2.0.3 compute_wordsim.sh

2.1.0 
