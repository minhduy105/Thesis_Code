#!/usr/bin/ruby
import nltk
import CRFPP
import sys

class ChunkingSentence:

	def parseSentence(self,pharse):
		try:
			text = nltk.word_tokenize(pharse)
			POS = nltk.pos_tag(text)
			tagger = CRFPP.Tagger("-m model_file -v 3 -n2")
			# clear internal context
			tagger.clear()

			for i in range (0,len(POS)):
				word = (POS[i][0]+ ' ' + POS[i][1])
				tagger.add(word)
			tagger.parse()
		except RuntimeError, e:
			print "RuntimeError: ", e,
		return tagger

	def getChunks(self,pharse): #ignore all special character

		tagger = self.parseSentence(pharse)
		size = tagger.size()
		word = tagger.x(0,0)
		chunks = []
		# x is for the input. 
		# EX: x(i,z), i is index, z==0 is the word, z ==1 is POS of the word
		# y is the chunking tag
		for i in range(1, (size)):
			if (tagger.y2(i)[0].upper() == 'I'):
				word = word + ' ' + str(tagger.x(i,0))
			elif (tagger.y2(i)[0].upper() == 'B'):
				chunks.append(word)
				word = tagger.x(i,0)
		chunks.append(word) #add the last pharse

		return chunks

# if __name__ == "__main__":
# 	CS = ChunkingSentence()
# 	pharse = "Confidnece in the pound is widely expected to take another sharp dive if trade figures for September"
# 	chunks = CS.getChunks(pharse)
# 	print (chunks)
# 	print "Done"
	

