pharse = "Confidnece in the pound is widely expected to take another sharp dive if trade figures for September"
chunks = getChunks(pharse)

print "Done"
	

# def read_until_minus_one():
#     buf = []
#     seen_minus = False
#     while True:
#         char = sys.stdin.read(1) 
#         if not char: # EOF
#             break 
#         if char == '1' and seen_minus:
#             buf.pop() # chop the last minus
#             break # seen -1
#         else:
#             seen_minus = (char == '-')
#             buf.append(char)
#     return ''.join(buf)

# print(read_until_minus_one())
# #this is read letter, need to read character, add to the sentence, out put out for the text file


# # Backspace is at codepoint 0008; delete is at 007F. (Notice how the image that you posted says "7F" in the text. That is the delete character.)

# # Try this:

# character = some_function_that_gets_a_character_from_stdin()
# if character == '\x08' or character == '\x7f': 
#   do_smth()
