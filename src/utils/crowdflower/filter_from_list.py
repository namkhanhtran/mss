import sys

"""
   
Given two matrices <word feat-1, ... , feat-n>, the first to be filtered
retaining only those words contained in the second, it returns that filtered matrix. 
 
Usage:
@param1: the matrix to be filtered
@param2: the matrix to use as filter
@param3: output path

"""

def clean_matrix(matrix_to_filter, filter_list, ou_path):
    filter_file    = open(filter_list, 'r')
    filter                = []
    for line in filter_file:
	line = line.split()
	word = line[0]
	if word not in filter:
	    filter.append(word)
    filter_file.close()
    matrix_to_filter_file = open(matrix_to_filter, 'r')
    hash                  = {}
    count                 = 0
    for line in matrix_to_filter_file:
	line = line.strip()
	sep  = line.find(' ', 0)
	word = line[0:sep]
	feat = line[sep:]
	if word in filter:
	    count += 1
	    hash[word] = feat
    matrix_to_filter_file.close()
    filter.sort()
    ou_file  = open(ou_path, 'w')
    for word in filter:
        feat = hash[word]
        ou_file.write(word + ' ' + feat + '\n')
    ou_file.close()
    print 'words in filter: ' + str(len(filter)) + '\n'
    print 'words in ou_file: ' + str(count)


if __name__ =="__main__":
    _matrix_to_filter = sys.argv[1]
    _filter_list    = sys.argv[2]
    _ou_path          = sys.argv[3]

    clean_matrix(_matrix_to_filter, _filter_list, _ou_path)
