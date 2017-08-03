#!/usr/bin/env python

import sys
import rospy
import numpy as np
from std_msgs.msg import String

class Controll():
	def __init__(self):
		rospy.init_node("chunkPharse")
		word_sub = rospy.Subscriber('word', String, self.word_callback)

	
	def word_callback(self,word):
		print (word)
		


if __name__ == '__main__':

	con = Controll()
	try:
		rospy.spin()
	except KeyboardInterrupt:
		print("Shutting down")

