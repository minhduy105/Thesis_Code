1. There are three files total:


DiscriptiveData_5mins.csv: the descriptive data (overall time, mean, standard deviation, and frequency) for the whole conversation for each dyad


DiscriptiveData_60secs.csv: the descriptive data in each 60 second of the whole conversation for each dyad
 
DiscriptiveData_100secs.csv: the the descriptive data in each 100 second of the whole conversation for each dyad


Note: I have the genetic code working, so I can manipulate the duration of when we want to get the descriptive characteristic 


2. This is all the symbol that is on the header:


GazeType = ["Around", "Monitor", "Keyboard", "Face", "NoFace", "CompOnly"]
Note: 
NoFace: mean anytimes Shakespeare do not look at the face, which includes Monitor, Keyboard, and Around
CompOnly: mean anytimes Shakespeare look at the computer back, which included Monitor, and Keyboard


SpeakType = ["NoSpeak", "Typing", "Speaking", "SSS", "Hovering", "Sound", "NoSound"]
Note: 
Sound: when there is sound produced, which include SSS and Speaking
NoSound: when there is no sound produced, which includes NoSpeak, Typing, and Hovering


Person = ["H", "S"]
Note:
H =  Hawking 
S = Shakespeare  


Character = [“Overall_Time”, "Mean", "PopularSD", "Frequency, Max, Min"]
Note:
Overall TIme: the overall time the person is in this action, this one does not have special combine tag such as NoFace or NoSound because you can simply add them together.
PopularSD: I use popular standard deviation instead of sample standard deviation because I use all of the time 


StartFrame: this is just for the 60 seconds and 100 seconds file. This is where the frame start, you can get it to second by divide it to 30 (because 30fps)

Note:
Gaze:
Around = 1
Monitor = 2
Keyboard = 3
Face = 4

Talking: 
No speaking = 1
Typing = 2
Speaking = 3
SSS = 4
Hovering = 5

