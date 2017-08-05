#!/usr/bin/python
import nltk
import CRFPP
import sys

#Input: the string that you want to chunk
#Output: the tagger data that contain all of the chunking information
#this is the program that set up the CRF++ and nltk
def parse_sentence(pharse):
	try:
		text = nltk.word_tokenize(pharse)
		POS = nltk.pos_tag(text)#get the POS for CRF++
		tagger = CRFPP.Tagger("-m model_file -v 3 -n2")
		# clear internal context
		tagger.clear()

		for i in range (0,len(POS)):
			word = (POS[i][0]+ ' ' + POS[i][1]) # add the word and its POS together
			tagger.add(word)
		tagger.parse()# parse the sentence
	except RuntimeError, e:
		print "RuntimeError: ", e,
	return tagger

#Input: the string that you want to chunk
#Output: the list of all the chunks from the input
#this is the program that chunk the sentence
def get_chunks(pharse): 
	tagger = parse_sentence(pharse)
	size = tagger.size()
	word = tagger.x(0,0)
	chunks = []
	# x is for the input. 
	# EX: x(i,z), i is index, z==0 is the word, z ==1 is POS of the word
	# y is the chunking tag
	for i in range(1, (size)):
		if (tagger.y2(i)[0].upper() == 'I'):
			word = word + ' ' + str(tagger.x(i,0))
		#elif (tagger.y2(i)[0].upper() == 'B'):
		else:	
			chunks.append(word)
			word = tagger.x(i,0)
	chunks.append(word) #add the last pharse

	return chunks

# THIS IS AN EXAMPLE FOR THE CODE
# pharse = "Confidnece in the pound is widely expected to take another sharp dive if trade figures for September ."
# chunks = get_chunks(pharse)
# print (chunks)
# print (' '.join(chunks))
# print "Done"
	

