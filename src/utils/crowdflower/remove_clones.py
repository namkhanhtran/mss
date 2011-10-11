import sys



def read_report(report_path, new_file_path, out_path):
    old_tags = []
    report_file = open(report_path, 'r')
    for line in report_file:
        line  = line.strip().split(',')
	image = line[8]
	tag   = line[9]
	comb  = image + tag
	old_tags.append(comb)
    report_file.close()

    new_file = open(new_file_path, 'r')
    out_file = open(out_path, 'w')
    count = 0
    for line in new_file:
        line = line.split(',')
	if line[0] != '\n':
	    #print line[1].rstrip()
	    image = line[0]
	    tag   = line[1].rstrip()
	    comb  = image + tag
	    if comb not in old_tags:
	        out_file.write(image + ',' + tag)
		out_file.write('\n')
	    else:
	        count += 1
    print 'count: ' + str(count)	
    new_file.close()
    out_file.close()
 

if __name__ =="__main__":
    _report_path   = sys.argv[1]
    _new_file_path = sys.argv[2]
    _out_path      = sys.argv[3]

    read_report(_report_path, _new_file_path, _out_path) 
