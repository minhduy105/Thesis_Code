#!/usr/bin/env python
import sys, select, tty, termios, time, subprocess, random
import rospy
import numpy as np
import ChunkingSentence as CS
from multiprocessing import Process, Value, Array, Pipe, Queue

# this program supposes to get the words from GUI, chunks them, and speak out either comprehensive portions of those words or filler words after certain wait time

#add the data into the list of word

#chunk the data and speak out the pharse
def chunk_pharse(Q):
	wait = 10
	filler = ["wait a second", "uh", "um", "like", "okay", "you know", "right", "okay, so", "you see"]
	words = []
	start  = time.time()
	end = time.time()
	while True:
		end = time.time()
		word = Q.get()
		words.append(word)
		if (end - start > wait):
			pharse = ' '.join(words)
			words = []
			chunks = CS.get_chunks(pharse)
			words.insert(0,chunks[len(chunks)-1])
			chunks.pop()# get rid of the last chunk because it might be an incomplete chunk
			sayOut = ' '.join(chunks)
			if not sayOut: #if there is no word then say the filter word
				sayOut = random.choice(self.filler)
			say_male(sayOut)	
			print (sayOut)
			start = time.time()

#female or male voice using festival
def say_male(self,text):
	voice = 'voice_cmu_us_rms_arctic_clunits'
	command = '({0})\n(SayText \\"{1}\\")'.format(voice, text)
	subprocess.call('echo "{0}" | festival --pipe'.format(command), shell=True)
def say_female(self,text):
	voice = 'voice_cmu_us_slt_arctic_clunits'
	command = '({0})\n(SayText \\"{1}\\")'.format(voice, text)
	subprocess.call('echo "{0}" | festival --pipe'.format(command), shell=True)

		
#Display the whole string to the terminal
def print_to_screen(whole_sentence):
	sen = ''.join(whole_sentence)
	print(chr(27) + "[2J")
	print (sen)

#publish the word to 
def publish_word(buf,Q):
	word = ''.join(buf)
	Q.put(word)

#this supposes to read input and publish single word 
def read_letter(char,Q):
	buf = []
	whole_sentence = []
	seen_space = False
	if char == '\x08' or char == '\x7f': #for backspace/delete the character
		if buf: #just to prevent the people from hitting the backspace at the beginning
			whole_sentence.pop()
			buf.pop()
	else:
		whole_sentence.append(char)
		if char in ['.', ',','!','?',':',';']: #publish when you see comma or period
			buf.append(char)
			publish_word(buf,Q)
			buf = []
		else:	
			if char and seen_space: #publish the word when you see a char after a space
				publish_word(buf,Q)
				buf = []
				buf.append(char)
				seen_space = False
			else:
				seen_space = (char == ' ')
				buf.append(char)
	print_to_screen(whole_sentence)


def runGUI(Q):
	old_attr = termios.tcgetattr(sys.stdin)
	tty.setcbreak(sys.stdin.fileno()) 
	while True:
		if select.select([sys.stdin],[],[],0)[0] == [sys.stdin]:
			char = sys.stdin.read(1)
			read_letter(char,Q)			
	termios.tcsetattr(sys.stdin, termios.TCSADRAIN, old_attr)


if __name__ == '__main__':
	# parent_conn, child_conn = Pipe()
	Q = Queue()
	GUI = Process(target = runGUI,args = (Q,))
	Chunk= Process(target = chunk_pharse,args = (Q,))
	GUI.start()
	Chunk.start()
	GUI.join()
	Chunk.join()