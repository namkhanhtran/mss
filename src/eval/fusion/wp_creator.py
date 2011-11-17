"""
"""

import sys
import re
import wn_dist
from operator import itemgetter

def read_text_file(text_path):
    """
    """
    out_res = list()
    with open(text_path, 'r') as fin:
        for line in fin.read().split("\n"):
            if len(line) > 0:
                out_res.append(line)

    return out_res

def read_image_file(image_path):
    """
    """
    out_res = dict()
    with open(image_path, 'r') as fin:
        for line in fin.read().split("\n"):
            if len(line) == 0:
                continue
            tmp = re.split("\s+", line)
            if out_res.has_key(tmp[0]):
                out_res[tmp[0]].append(tmp[1])
            else:
                out_res[tmp[0]] = [tmp[1]]
    
    return out_res

def init_word_pair(txt_word, img_word, threshold):
    """
    """
    word_list = list()
    word_pair = set()
    for word in txt_word:
        if img_word.has_key(word) and len(img_word[word]) > threshold:
            word_list.append(word)

    for w1 in word_list:
        for w2 in word_list:
            if w1 != w2 and (w2,w1) not in word_pair:
                word_pair.add((w1,w2))

    return word_pair

def calc_wordnet_path(word1, word2):
    """
    """
    lemma1 = word1[:word1.rfind('-')]
    pos1 = word1[word1.rfind('-')+1:]
    lemma2 = word2[:word2.rfind('-')]
    pos2 = word2[word2.rfind('-')+1:]
    return wn_dist.calc_distance(lemma1, pos1, lemma2, pos2)

def filter_word_pair(word_pair):
    """
    """
    print len(word_pair)
    score = dict()
    for wp in word_pair:
        pair_score = calc_wordnet_path(wp[0], wp[1])
        score[wp] = pair_score

    sorted_wp = sorted(score.iteritems(), key=itemgetter(1), reverse=False)
    print sorted_wp
    return word_pair

def create_word_pairs(text_path, image_path, out_path, threshold):
    """
    """
    txt_word = read_text_file(text_path)
    img_word = read_image_file(image_path)
    initial_word_pair = init_word_pair(txt_word, img_word, threshold)
    filtered_word_pair = filter_word_pair(initial_word_pair)
    with open(out_path, 'w') as fout:
        for (w1,w2) in filtered_word_pair:
            fout.write("%s %s\n" % (w1, w2))

if __name__ == "__main__":
    if len(sys.argv) < 5:
        print "\n Usage: python [text_word_file] [image_word_file] [out_file] \
threshold"
        sys.exit(1)

    _text_path = sys.argv[1]
    _image_path = sys.argv[2]
    _out_path = sys.argv[3]
    _threshold = int(sys.argv[4])
    create_word_pairs(_text_path, _image_path, _out_path, _threshold)
