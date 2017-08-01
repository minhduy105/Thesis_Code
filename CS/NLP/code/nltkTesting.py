#!/usr/bin/ruby
import nltk
import CRFPP
import sys

try:

	# -v 3: access deep information like alpha,beta,prob
	# -nN: enable nbest output. N should be >= 2
	pharse = "Confidnece in the pound is widely expected to take another sharp dive if trade figures for September"
	text = nltk.word_tokenize(pharse)
	POS = nltk.pos_tag(text)

	
	tagger = CRFPP.Tagger("-m model_file -v 3 -n2")
	# clear internal context
	tagger.clear()

	for i in range (0,len(POS)):
		word = (POS[i][0]+ ' ' + POS[i][1])
		tagger.add(word)
		

	# print "column size: " , tagger.xsize()
	# print "token size: " , tagger.size()
	# print "tag size: " , tagger.ysize()

	# print "tagset information:"
	# ysize = tagger.ysize()
	# for i in range(0, ysize-1):
	# 	print "tag " , i , " " , tagger.yname(i)

		
	# parse and change internal stated as 'parsed'
	tagger.parse()

	# print "conditional prob=" , tagger.prob(), " log(Z)=" , tagger.Z()
	# print ("HELLO")
	# print (tagger)

	size = tagger.size()
	xsize = tagger.xsize()
	for i in range(0, (size)):
		# print tagger.prob(i)
		print tagger.x(i,0) , "\t", #0 is for word, 1 is for POS
		print tagger.y2(i) , "\n", #for the tag of pharse chunking
		
		# print "\nDetails",
		# for j in range(0, (ysize-1)):
		# 	print "\t" , tagger.yname(j) , "/prob=" , tagger.prob(i,j),"/alpha=" , tagger.alpha(i, j),"/beta=" , tagger.beta(i, j),
		# print "\n",


	print "Done"

except RuntimeError, e:
	print "RuntimeError: ", e,
