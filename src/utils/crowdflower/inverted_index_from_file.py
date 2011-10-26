import sys, os


"""
Given the crowdflower final report, this program returns a
inverted index <tag,image> as ouput.
    
Usage:
@param1: the final CF report (csv format)
@param2: the output directory
"""

color_counts = {}
colors       = ['black','blue','brown','grey','green','orange','pink','purple','red','white','yellow']
def read_csv(in_path, ou_path):
    #debug
    tot_count   = 0
    index       = {}
    
    # 1st file
    report_file = open(in_path, 'r')
    first_line = True
    for line in report_file:
        if first_line:
	    first_line = False
	    continue
        line  = line.strip().split(',')
	bool  = line[5]
	conf  = float(line[6])
	if (bool == 'Yes' and conf >= 1) or (bool == 'No' and conf <= 0) :
	    image = line[8]
	    image = image[+68:]
	    tag   = line[9].rstrip()
            if tag == 'gray' or tag == 'Gray':
		tag = 'grey'
	    check_color(tag)
	    tot_count += 1
            if tag in index:
	        list = index[tag]
	        list.append(image)
	        index[tag] = list
	    else:
	        list = []
	        list.append(image)
	        index[tag] = list 
    report_file.close()

    ou_file = open(ou_path, 'w')
    for tag in index:
	for image in index[tag]:
	    ou_file.write(tag + ' ' + image + '\n')
    ou_file.close()

    for color in color_counts:
        print color + ': ' + str(color_counts[color])
 
def check_color(tag):
    global color_counts
    global colors
    ctag = tag
    if ctag in colors:
	if ctag in color_counts:
	    count = color_counts[ctag]
	    count += 1
	    color_counts[ctag] = count
	else:
	    count = 1
	    color_counts[ctag] = count

if __name__ =="__main__":
    _in_path = sys.argv[1]
    _ou_path = sys.argv[2]	

    read_csv(_in_path, _ou_path)
