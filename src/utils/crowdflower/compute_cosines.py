import sys, os, glob
from numpy import *
from numpy.linalg import norm

def compute_cosines(matrices_dir, in_path, ou_path):
    in_file = open(in_path, 'r')
    word_list = []
    pair_dic  = {}
    vote_dic  = {}
    for line in in_file:
	line   = line.split()
	A = line[0]
	N = line[1]
	V = line[2]
	AN = A+N
	word_list.append(A)
	word_list.append(N)
	if A in pair_dic:
	    in_list = pair_dic[A]
	    in_list.append(N)
	    pair_dic[A] = in_list
	else:
	    in_list = []
	    in_list.append(N)
	    pair_dic[A] = in_list
	vote_dic[AN] = V
    in_file.close()	
    ou_file = open(ou_path, 'w')
    for matrix_path in glob.glob(matrices_dir + '/*'):
       	matrix = {}
	F = open(matrix_path, 'r')
        matrix_name = os.path.basename(matrix_path)
	print matrix_name
 	for f_line in F:
	    #print len(f_line)
	    #print f_line
	    word = f_line.split()[0]
	    if word in word_list:
		v = array(f_line.split()[1:], dtype=float32)
		matrix[word] = v
	F.close()
	for A in pair_dic:
	    #print A
	    v = matrix[A]
	    for N in pair_dic[A]:
		w = matrix[N]
		cos = dot(v,w) / (norm(v) * norm(w))
		ou_file.write(A + ' ' + N + ' ' + vote_dic[A+N]  + ' ' + str(cos) + ' ' + matrix_name + '\n')
    ou_file.close()

if __name__ =="__main__":
    _matrices_dir = sys.argv[1]
    _in_path      = sys.argv[2]
    _ou_path      = sys.argv[3]

    compute_cosines(_matrices_dir, _in_path, _ou_path) 

