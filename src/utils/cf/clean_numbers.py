import sys, re


def clean_numbers(dataset_path, output_path):
    dataset_file = open(dataset_path, 'r')
    output_file  = open(output_path, 'w')
    first_line = True
    for line in dataset_file:
        if first_line:
	    first_line = False
	    continue
	line             = line.split(',')
	if line[0] != '\n':
	    tag = line[1]
	    if re.match("^[A-Za-z]*$", tag):
	        #print potential_number
	        output_file.write(line[0] + ',' + line[1])
	        output_file.write('\n')
    dataset_file.close()
    output_file.close()


if __name__ =="__main__":
    _dataset_path = sys.argv[1]
    _output_path  = sys.argv[2]

    clean_numbers(_dataset_path, _output_path)
