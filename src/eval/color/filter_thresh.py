import sys

"""
This program retain those words occurring threshold time in
the first file (in_path) and ouputs a filtered version of the
second file (me_path) using them.

Usage:
@param1: first file, where we count word occurrences
@param2: second file with the word pairs we want to filter
@param3: output path

"""


def filter(in_path, me_path, ou_path):
    in_file = open(in_path, 'r')
    counts = {}
    dic    = {}
    for line in in_file:
    	line = line.split()
	if len(line) != 0:
	    word = line[0]
	    imag = line[1]
	    if word in counts:
	        count = counts[word]
		count += 1
		counts[word] = count
	    else:
	        count = 1
		counts[word] = count
    in_file.close()		
    me_file = open(me_path, 'r')
    ou_file = open(ou_path, 'w')
    for line in me_file:
        line = line.split()
	if len(line) != 0:
	    word1 = line[0]
	    word2 = line[1]
	    lits  = line[2]
	    cos   = line[3]
	    mod   = line[4]
	    if int(counts[word2]) >= 5:
	        ou_file.write(word1 + ' ' + word2 + ' ' + lits + ' ' + cos  + ' ' + mod + '\n')
    me_file.close()
    ou_file.close()
    		

if __name__ =="__main__":
    _in_path = sys.argv[1]
    _me_path = sys.argv[2]
    _ou_path = sys.argv[3]
    
    filter(_in_path, _me_path, _ou_path)

