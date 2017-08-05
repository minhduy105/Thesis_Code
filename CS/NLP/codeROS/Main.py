#!/usr/bin/env python

import sys, time, subprocess
import rospy
import numpy as np
import ChunkingSentence as CS
import random
from std_msgs.msg import String

# this program supposes to get the words from GUI, chunks them, and speak out either comprehensive portions of those words or filler words after certain wait time
class Controll():
	def __init__(self):
		rospy.init_node("chunkPharse")
		word_sub = rospy.Subscriber('word', String, self.word_callback)
		self.start = time.time()
		self.end = time.time()
		self.wait = 10 # the wait time until it speaks the next pharse
		self.words = [] # the list of words
		self.filler = ["wait a second", "uh", "um", "like", "okay", "you know", "right", "okay, so", "you see"]
	
	#add the data into the list of word
	def word_callback(self,word):
		self.words.append(word.data)
	
	#chunk the data and speak out the pharse
	def chunk_pharse(self):
		self.end = time.time()
		if (self.end - self.start > self.wait):
			pharse = ' '.join(self.words)
			self.words = []
			chunks = CS.get_chunks(pharse)
			print (chunks)
			self.words.insert(0,chunks[len(chunks)-1])
			chunks.pop()# get rid of the last chunk because it might be an incomplete chunk
			sayOut = ' '.join(chunks)
			if not sayOut: #if there is no word then say the filter word
				sayOut = random.choice(self.filler)
			self.say_male(sayOut)	
			print (sayOut)
			self.start = time.time()

	#female or male voice using festival
	def say_male(self,text):
		voice = 'voice_cmu_us_rms_arctic_clunits'
		command = '({0})\n(SayText \\"{1}\\")'.format(voice, text)
		subprocess.call('echo "{0}" | festival --pipe'.format(command), shell=True)
	def say_female(self,text):
		voice = 'voice_cmu_us_slt_arctic_clunits'
		command = '({0})\n(SayText \\"{1}\\")'.format(voice, text)
		subprocess.call('echo "{0}" | festival --pipe'.format(command), shell=True)

if __name__ == '__main__':

	con = Controll()
	while not rospy.is_shutdown():
		con.chunk_pharse()
	# try:
	# 	rospy.spin()
	# except KeyboardInterrupt:
	# 	print("Shutting down")

