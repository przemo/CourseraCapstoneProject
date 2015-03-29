# -*- coding: utf-8 -*-

# This script process the source files to extract and count words
# and generate bigrams and trigrams.
# The text processign is based on NLTK framework.
# output files are save later in the 'data' folder
# the script need more refinig with os paths etc.

import nltk, re, pprint, collections, codecs
from nltk.book import *
from itertools import tee, islice
from collections import Counter


names = ['twitter', 'news', 'blogs']


def ngrams(lst, n):
    tlst = lst
    while True:
        a, b = tee(tlst)
        l = tuple(islice(a, n))
        if len(l) == n:
            yield l
            next(b)
            tlst = b
        else:
            break

for n in names:
    # reading input files - mind the path it may be different
    input_filename = '/final/en_US/en_US.'+n+'.txt'
    f = codecs.open(input_filename, 'r', 'utf-8')
    # f.close()
    # with open(input_filename) as myfile:
    # head = list(islice(myfile, 100))
    text = f.read()
    # text = "".join(head)
    f.close()
    pattern = r'''(?x)([A-Z]\.)+|\w+(['-]\w+)*'''
    
    tknz = nltk.regexp_tokenize(text.lower(), pattern)
    
    # reading bad words file, to clean the processed text
    f = codecs.open('bw.txt', 'r', 'utf-8')
    bw = f.read()
    f.close()
    
    filtered_words = [w for w in tknz if not w in bw]
  
    
    fdist = FreqDist(filtered_words)
    
    # saving output files
    output_filename = n+'.csv'
    with codecs.open(output_filename, 'w', 'utf-8') as f:
        [f.write('{0},{1}\n'.format(key, value)) for key, value in fdist.items()]
    
    ngr = Counter(ngrams(filtered_words, 2))
    output_filename = "bigram_"+n+'.csv'
    with codecs.open(output_filename, 'w', 'utf-8') as f:
        [f.write('{0},{1}\n'.format(" ".join(key), value)) for key, value in ngr.items() if value > 1]

    ngr = Counter(ngrams(filtered_words, 3))
    output_filename = "trigram_"+n+'.csv'
    with codecs.open(output_filename, 'w', 'utf-8') as f:
        [f.write('{0},{1}\n'.format(" ".join(key), value)) for key, value in ngr.items() if value > 1]
