"""
This program is to found a ranked feature list from the several list of features
"""
import sys

featureDic = {}
"""
Assign all of the features listed in the file to a value
@param: fname: file name, each feature is in a line
@param: value
"""

def assign(fname, value):
    global featureDic
    F = open(fname, 'r')
    for line in F:
        line = line.strip()
        if not featureDic.has_key(line):
            featureDic[line] = value
    F.close()

if __name__ =="__main__":
    assign("featurelist.k4.txt", '1')
    assign("featurelist.k8.txt", '2')
    assign("featurelist.k12.txt", '3')
    assign("featurelist.k16.txt", '4')
    assign("featurelist.k20.txt", '5')
    assign("featurelist.k24.txt", '6')
    assign("featurelist.k28.txt", '7')
    assign("featurelist.k32.txt", '8')
    assign("featurelist.k36.txt", '9')
    assign("featurelist.k40.txt", '10')
    assign("featurelist.k44.txt", '11')
    assign("featurelist.k48.txt", '12')
    assign("featurelist.k52.txt", '13')
    #print the feature list assigned value
    Fout = open("52kfeatureValue.txt", 'w')
    for key, value in featureDic.iteritems():
        Fout.write(key + ' ' + value + '\n')
    Fout.close()
