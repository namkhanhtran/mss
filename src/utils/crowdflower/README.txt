this is a howto for the EACL paper:

0. code to combine the 2 CF jobs

1. inverted_index_from_file.py (to be readapted to work only with a final result): 
   --> outputs an inverted index file <word image> (needed by marco)

2. pos_map_from_file.py
   --> outputs images and labels dir.

3.0.0 pos_mapper.py in preprocess dir
   --> outputs pos-tagged labels
3.0.1 compute all the visual features
3.0.2 generate_VM.sh 
  --> outputs a visual feature vector for each word
3.0.3 compute_wordsim.sh



