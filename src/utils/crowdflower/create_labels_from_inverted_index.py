import sys


def create_labels_from_inverted_index(inverted_index_path, out_path):
    index_file = open(inverted_index_path, 'r')
    index = {}
    for line in index_file:
	line = line.split(' ')
	if line[0] != '\n':
            tag = line[0]
	    ima = line[1]
	    lab = 'tags' + ima[+2:-5] + '.txt'
	    if lab in index:
		tags = index[lab]
		tags.append(tag)
		index[lab] = tags
	    else:
		tags = []
		tags.append(tag)
		index[lab] = tags
    for lab in index:
	lab_file = open(out_path + '/' + lab, 'w')
	for tag in index[lab]:
	    lab_file.write(tag + '\n')	
	lab_file.close()
    index_file.close()

if __name__ =="__main__":
    _inverted_index_path = sys.argv[1]
    _out_path            = sys.argv[2]

    create_labels_from_inverted_index(_inverted_index_path, _out_path)

