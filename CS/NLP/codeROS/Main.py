#!/usr/bin/env python

import sys, time, subprocess
import rospy
import numpy as np
import ChunkingSentence as CS
import random
from std_msgs.msg import String

class Controll():
	def __init__(self):
		rospy.init_node("chunkPharse")
		word_sub = rospy.Subscriber('word', String, self.word_callback)
		self.start = time.time()
		self.end = time.time()
		self.wait = 10
		self.words = []
		self.filler = ["wait a second", "uh", "um", "like", "okay", "you know", "right", "okay, so", "you see"]
	
	def word_callback(self,word):
		self.words.append(word.data)
	
	def chunk_pharse(self):
		self.end = time.time()
		if (self.end - self.start > self.wait):
			pharse = ' '.join(self.words)
			self.words = []
			chunks = CS.get_chunks(pharse)
			print (chunks)
			self.words.insert(0,chunks[len(chunks)-1])
			chunks.pop()
			sayOut = ' '.join(chunks)
			if not sayOut:
				sayOut = random.choice(self.filler)
				
			self.say_male(sayOut)	
			print (sayOut)
			self.start = time.time()

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

