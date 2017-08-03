#!/usr/bin/env python

# Because it uses tty and termios, the program only works on Unix
import sys, select, tty, termios
import rospy
import numpy as np
from std_msgs.msg import String

def printToScreen(whole_sentence):
	sen = ''.join(whole_sentence)
	print(chr(27) + "[2J")
	print (sen)

if __name__ == '__main__':

	key_pub = rospy.Publisher('word', String, queue_size = 1)
	rospy.init_node("send_word")
	rate = rospy.Rate(10)
	old_attr = termios.tcgetattr(sys.stdin)
	tty.setcbreak(sys.stdin.fileno()) 
	buf = []
	whole_sentence = []
	seen_space = False
	while not rospy.is_shutdown():
		if select.select([sys.stdin],[],[],0)[0] == [sys.stdin]:
			char = sys.stdin.read(1)
			if char == '\x08' or char == '\x7f': #for backspace/delete the character
				if buf: #just to prevent the people from hitting the backspace at the beginning
					whole_sentence.pop()
					buf.pop()
			else:
				whole_sentence.append(char)
				if char and seen_space: #publish the word when you see a char after a space
					buf.pop() # chop the last space
					word = ''.join(buf)
					key_pub.publish(word)
					buf = []
					buf.append(char)
					seen_space = False
				else:
					seen_space = (char == ' ')
					buf.append(char)
			printToScreen(whole_sentence)		
		rate.sleep()
	termios.tcsetattr(sys.stdin, termios.TCSADRAIN, old_attr)

