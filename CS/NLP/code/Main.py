#!/usr/bin/env python

import sys, time, subprocess
import rospy
import numpy as np
import ChunkingSentence as CS
from std_msgs.msg import String

class Controll():
	def __init__(self):
		rospy.init_node("chunkPharse")
		word_sub = rospy.Subscriber('word', String, self.word_callback)
		self.start = time.time()
		self.end = time.time()
		self.wait = 10
		self.words = []
	
	def word_callback(self,word):
		self.words.append(word.data)
	
	def chunk_pharse(self):
		self.end = time.time()
		if (self.end - self.start > self.wait):
			pharse = ' '.join(self.words)
			self.words = []
			chunks = CS.get_chunks(pharse)
			self.words.insert(0,chunks[len(chunks)-1])
			chunks.pop()
			sayOut = ' '.join(chunks)
			self.sayStuff(sayOut)
			print (sayOut)
			self.start = time.time()

	def sayStuff(self,word):
		cmd = ["rosrun sound_play say.py " + '"'+ word+'"']
		subprocess.Popen(cmd,shell=True)		


if __name__ == '__main__':

	con = Controll()
	while not rospy.is_shutdown():
		con.chunk_pharse()
	try:
		rospy.spin()
	except KeyboardInterrupt:
		print("Shutting down")

