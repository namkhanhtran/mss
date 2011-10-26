this is a howto for the EACL paper:

0. code to combine the 2 CF jobs

1. inverted_index_from_file.py (to be readapted to work only with a final result): 
   --> outputs an inverted index file <word image> (needed by marco)

2. pos_map_from_file.py
   --> add pos to words in the inverted_index.
   
3. create_labels_from_inverted_index.py
   --> from the inverted index, all the labels are created

4. common_with_cleaned_labels.py
   --> from the labels and original images, creates
       an image directory with only those images
       for whci a label is provided

3+4. TODO: merge file in 3. and file in 4, to
           have images and labels dir form inv. index
	   at once

5.  words_with_images.py
    --> ceates 'preprocessed' dir with uuid names

6. features extraction

7. generate_VM.sh
   --> merge the mat matrices and creates the visual-feature file
       for each feature extracted

8. normalize_vectors.py
   --> normalize the feature vectors [v/norm(v)],
       necessary for concatenation

9. combine_feature.py
   --> combine the given feature matrices

10. filter_from_list.py (here the first ~700 words as input)
    --> each resulting matrix has to be filtered, retaining only
      words for eacl tests

11. filter_from_list.py (here the litnonlit file)

12. compute_cosines.py
    --> compute the cosines for the given list of words,
        with all the given matrices

13. filter_thresh.py
    --> from the ouput in 12, retains just words
        occurring threshold time in the visual data set

3.0.3 compute_wordsim.sh



