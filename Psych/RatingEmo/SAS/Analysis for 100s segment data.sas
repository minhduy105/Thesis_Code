FILENAME REFFILE '/folders/myfolders/gaze analysys/DiscriptiveData_4gazes_100sec.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;


/* -----------------get data for conversation 1-----------------------*/
data Gaze1;
   set WORK.IMPORT (keep = Dyad Cov SectionStartTime Duration GazeType);
	where Cov = 1;
run;


/*Get the total, mean, and frequency of the four gaze*/

/*divide to 30.0 to get the time in second*/
proc sql; /*Get the "Cov" column so we can add two table back together*/
	create table Around_1 as
   	select Dyad, SectionStartTime /30.0 as SectionStartTime,
   		sum(Duration) / 30.0 as TotalDurationAround,
   		mean(Duration) / 30.0 as MeanDurationAround,
   		count(*) as FrequencyAround
		from WORK.Gaze1
		where GazeType = 1
		group by Dyad, SectionStartTime;
quit;

proc sql;
	create table Monitor_1 as
   	select Dyad, SectionStartTime /30.0 as SectionStartTime,
		sum(Duration) / 30.0 as TotalDurationMonitor,
   		mean(Duration) / 30.0 as MeanDurationMonitor,
   		count(*) as FrequencyMonitor
		from WORK.Gaze1
		where GazeType = 2
		group by Dyad, SectionStartTime;
quit;

proc sql;
	create table Keyboard_1 as
   	select Dyad, SectionStartTime /30.0 as SectionStartTime,
		sum(Duration) / 30.0 as TotalDurationKeyboard,
   		mean(Duration) / 30.0 as MeanDurationKeyboard,
   		count(*) as FrequencyKeyboard
		from WORK.Gaze1
		where GazeType = 3
		group by Dyad, SectionStartTime;
quit;

proc sql;
	create table Face_1 as
   	select Dyad, Cov, SectionStartTime /30.0 as SectionStartTime,
		sum(Duration) / 30.0 as TotalDurationFace,
   		mean(Duration) / 30.0 as MeanDurationFace,
   		count(*) as FrequencyFace
		from WORK.Gaze1
		where GazeType = 4
		group by Dyad, Cov, SectionStartTime;
quit;

/*Join all the gaze data together*/
proc sql;
	create table Summary_1 as 
	select F.*, M.*, K.*, A.* 
		from WORK.Face_1 F	
		full join WORK.Monitor_1 M on (F.Dyad = M.Dyad and F.SectionStartTime = M.SectionStartTime) 
		full join WORK.Keyboard_1 K on (F.Dyad = K.Dyad and F.SectionStartTime = K.SectionStartTime)
		full join WORK.Around_1 A on (F.Dyad = A.Dyad and F.SectionStartTime = A.SectionStartTime);
quit;	

/*set all the null value to 0, such as Hawking do not look at the keyboard the whole time in dyad 8 and 44*/
data Summary_1;
	set Summary_1;
	array a(*) _numeric_;
	do i=1 to dim(a);
	if a(i) = . then a(i) = 0;
	end;
	drop i;

/* -----------------get data for conversation 2-----------------------*/
data Gaze2;
   set WORK.IMPORT (keep = Dyad Cov SectionStartTime Duration GazeType);
	where Cov = 2;
run;


/*Get the total, mean, and frequency of the four gaze*/

/*divide to 30.0 to get the time in second*/
proc sql; /*Get the "Cov" column so we can add two table back together*/
	create table Around_2 as
   	select Dyad, SectionStartTime /30.0 as SectionStartTime,
   		sum(Duration) / 30.0 as TotalDurationAround,
   		mean(Duration) / 30.0 as MeanDurationAround,
   		count(*) as FrequencyAround
		from WORK.Gaze2
		where GazeType = 1
		group by Dyad, SectionStartTime;
quit;

proc sql;
	create table Monitor_2 as
   	select Dyad, SectionStartTime /30.0 as SectionStartTime,
		sum(Duration) / 30.0 as TotalDurationMonitor,
   		mean(Duration) / 30.0 as MeanDurationMonitor,
   		count(*) as FrequencyMonitor
		from WORK.Gaze2
		where GazeType = 2
		group by Dyad, SectionStartTime;
quit;

proc sql;
	create table Keyboard_2 as
   	select Dyad, SectionStartTime /30.0 as SectionStartTime,
		sum(Duration) / 30.0 as TotalDurationKeyboard,
   		mean(Duration) / 30.0 as MeanDurationKeyboard,
   		count(*) as FrequencyKeyboard
		from WORK.Gaze2
		where GazeType = 3
		group by Dyad, SectionStartTime;
quit;

proc sql;
	create table Face_2 as
   	select Dyad, Cov, SectionStartTime /30.0 as SectionStartTime,
		sum(Duration) / 30.0 as TotalDurationFace,
   		mean(Duration) / 30.0 as MeanDurationFace,
   		count(*) as FrequencyFace
		from WORK.Gaze2
		where GazeType = 4
		group by Dyad, Cov, SectionStartTime;
quit;

/*Join all the gaze data together*/
proc sql;
	create table Summary_2 as 
	select F.*, M.*, K.*, A.* 
		from WORK.Face_2 F	
		full join WORK.Monitor_2 M on (F.Dyad = M.Dyad and F.SectionStartTime = M.SectionStartTime) 
		full join WORK.Keyboard_2 K on (F.Dyad = K.Dyad and F.SectionStartTime = K.SectionStartTime)
		full join WORK.Around_2 A on (F.Dyad = A.Dyad and F.SectionStartTime = A.SectionStartTime);
quit;	

/*set all the null value to 0, such as Hawking do not look at the keyboard the whole time in dyad 8 and 44*/
data Summary_2;
	set Summary_2;
	array a(*) _numeric_;
	do i=1 to dim(a);
	if a(i) = . then a(i) = 0;
	end;
	drop i;
	

/*Combine dyad 1 and dyad 2 together*/

proc sql;
   create table Summary as
      select * from Summary_1
      union
      select * from Summary_2;
quit;

/*------------------------------Running the T-Test------------------------------------------*/

/*rename the collumn so it is less confused in the result section*/
data Summary_1;
	set WORK.Summary_1;
	rename TotalDurationAround = TotalDurationAround1
			TotalDurationFace = TotalDurationFace1
			MeanDurationAround = MeanDurationAround1
			MeanDurationFace = MeanDurationFace1;			
run;

data Summary_2;
	set WORK.Summary_2;
	rename TotalDurationAround = TotalDurationAround2
			TotalDurationFace = TotalDurationFace2
			MeanDurationAround = MeanDurationAround2
			MeanDurationFace = MeanDurationFace2;
run;

data Summary_at_0s;
	set WORK.Summary;
	rename TotalDurationAround = TotalDurationAround_at0
			TotalDurationFace = TotalDurationFace_at0
			MeanDurationAround = MeanDurationAround_at0
			MeanDurationFace = MeanDurationFace_at0;			
run;

data Summary_at_200s;
	set WORK.Summary;
	rename TotalDurationAround = TotalDurationAround_at2
			TotalDurationFace = TotalDurationFace_at2
			MeanDurationAround = MeanDurationAround_at2
			MeanDurationFace = MeanDurationFace_at2;			
run;

/*Running the ttest between 0th start point and 200th start point for conversation 1*/

proc ttest data=Summary_1 order=data
           alpha=0.05 test=diff sides=2; /* two-sided test of diff between group means */
   where SectionStartTime in (0,200);
   class SectionStartTime;
   var TotalDurationAround1 TotalDurationFace1 MeanDurationAround1 MeanDurationFace1;
run;

/*Running the ttest between 0th start point and 200th start point for conversation 2*/

proc ttest data=Summary_2 order=data
           alpha=0.05 test=diff sides=2; /* two-sided test of diff between group means */
   where SectionStartTime in (0,200);
   class SectionStartTime;
   var TotalDurationAround2 TotalDurationFace2 MeanDurationAround2 MeanDurationFace2;
run;


/*Running the ttest between conversation 1 and conversation 2*/

proc ttest data=Summary_at_0s order=data
           alpha=0.05 test=diff sides=2; /* two-sided test of diff between group means */
   where SectionStartTime = 0;
   class Cov;
   var TotalDurationAround_at0 TotalDurationFace_at0 MeanDurationAround_at0 MeanDurationFace_at0;
run;


proc ttest data=Summary_at_200s order=data
           alpha=0.05 test=diff sides=2; /* two-sided test of diff between group means */
   where SectionStartTime = 200;
   class Cov;
   var TotalDurationAround_at2 TotalDurationFace_at2 MeanDurationAround_at2 MeanDurationFace_at2;
run;


/*IDEA: Multiple Regression with the difference between 0s and 200s in both conversation*/