#!/usr/bin/env python

# Because it uses tty and termios, the program only works on Unix
import sys, select, tty, termios
import rospy
import numpy as np
from std_msgs.msg import String

class GUI(object):
	def __init__(self):
		self.key_pub = rospy.Publisher('word', String, queue_size = 1)
		rospy.init_node("send_word")
		self.buf = []
		self.whole_sentence = []
		self.seen_space = False
			

	def print_to_screen(self):
		sen = ''.join(self.whole_sentence)
		print(chr(27) + "[2J")
		print (sen)

	def publish_word(self):
		word = ''.join(self.buf)
		self.key_pub.publish(word)
		self.buf = []

	def read_letter(self,char):
		if char == '\x08' or char == '\x7f': #for backspace/delete the character
			if self.buf: #just to prevent the people from hitting the backspace at the beginning
				self.whole_sentence.pop()
				self.buf.pop()
		else:
			self.whole_sentence.append(char)
			if char in ['.', ',','!','?',':',';']:
				self.buf.append(char)
				self.publish_word()
			else:	
				if char and self.seen_space: #publish the word when you see a char after a space
					self.publish_word()
					self.buf.append(char)
					self.seen_space = False
				else:
					self.seen_space = (char == ' ')
					self.buf.append(char)
		self.print_to_screen()

if __name__ == '__main__':
	gui = GUI()
	rate = rospy.Rate(10)
	old_attr = termios.tcgetattr(sys.stdin)
	tty.setcbreak(sys.stdin.fileno()) 
	while not rospy.is_shutdown():
		if select.select([sys.stdin],[],[],0)[0] == [sys.stdin]:
			char = sys.stdin.read(1)
			gui.read_letter(char)			
		rate.sleep()
	termios.tcsetattr(sys.stdin, termios.TCSADRAIN, old_attr)

