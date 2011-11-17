"""
"""
import sys
from nltk.corpus import wordnet as wn
POS = {'n':'n', 'v':'v', 'j':'a', 'r':'r'}

def calc_distance(lemma1, pos1, lemma2, pos2):
    """
    """
    global POS
    synset1 = wn.synsets(lemma1, pos=POS[pos1])
    synset2 = wn.synsets(lemma2, pos=POS[pos2])
    shortest_distance = 10000
    for s1 in synset1:
        for s2 in synset2:
            distance = s1.shortest_path_distance(s2)
            if distance < shortest_distance:
                shortest_distance = distance

    return shortest_distance

if __name__ == "__main__":
    if len(sys.argv) < 5:
        print "\n Usage: python wn_dist.py [word1][pos1][word2][pos2]"
        sys.exit(1)

    _lemma1 = sys.argv[1]
    _pos1 = sys.argv[2]
    _lemma2 = sys.argv[3]
    _pos2 = sys.argv[4]
    print calc_distance(_lemma1, _pos1, _lemma2, _pos2)
