/* Generated Code (IMPORT) */
/* Source File: DiscriptiveData_5talks_H_5mins.csv */
/* Source Path: /folders/myfolders */
/* Code generated on: 5/7/18, 11:47 AM */

libname sql 'SAS-library';

/*
Gaze Type ID
Around = 1
Monitor = 2
Keyboard = 3
Face = 4
*/


FILENAME REFFILE '/folders/myfolders/gaze analysys/DiscriptiveData_4gazes_100sec.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT1;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT1; RUN;

/*
Gaze Type ID
Around = 1
Monitor = 2
Keyboard = 3
Face = 4
*/

/* -----------------get data for conversation 1-----------------------*/
data Gaze1;
   set WORK.IMPORT1 (keep = Dyad Cov Duration GazeType);
	where Cov = 1;
run;


/*Get the total, mean, and frequency of the four gaze*/

/*divide to 30.0 to get the time in second*/
proc sql; /*Get the "Cov" column so we can add two table back together*/
	create table Around_1 as
   	select Dyad, Cov, sum(Duration) / 30.0 as TotalDurationAround,
   		mean(Duration) / 30.0 as MeanDurationAround,
   		count(*) as FrequencyAround
		from WORK.Gaze1
		where GazeType = 1
		group by Dyad, Cov;
quit;

proc sql;
	create table Monitor_1 as
   	select Dyad, sum(Duration) / 30.0 as TotalDurationMonitor,
   		mean(Duration) / 30.0 as MeanDurationMonitor,
   		count(*) as FrequencyMonitor
		from WORK.Gaze1
		where GazeType = 2
		group by Dyad;
quit;

proc sql;
	create table Keyboard_1 as
   	select Dyad, sum(Duration) / 30.0 as TotalDurationKeyboard,
   		mean(Duration) / 30.0 as MeanDurationKeyboard,
   		count(*) as FrequencyKeyboard
		from WORK.Gaze1
		where GazeType = 3
		group by Dyad;
quit;

proc sql;
	create table Face_1 as
   	select Dyad, sum(Duration) / 30.0 as TotalDurationFace,
   		mean(Duration) / 30.0 as MeanDurationFace,
   		count(*) as FrequencyFace
		from WORK.Gaze1
		where GazeType = 4
		group by Dyad;
quit;

/*Join all the gaze data together*/
proc sql;
	create table Summary_1 as 
	select A.*, M.*, K.*, F.* 
		from WORK.Around_1 A	
		full join WORK.Monitor_1 M on A.Dyad = M.Dyad
		full join WORK.Keyboard_1 K on A.Dyad = K.Dyad
		full join WORK.Face_1 F on A.Dyad = F.Dyad;
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
   set WORK.IMPORT1 (keep = Dyad Cov Duration GazeType);
	where Cov = 2;
run;


/*Get the total, mean, and frequency of the four gaze*/

proc sql;
	create table Around_2 as
   	select Dyad, Cov, sum(Duration) / 30.0 as TotalDurationAround,
   		mean(Duration) / 30.0 as MeanDurationAround,
   		count(*) as FrequencyAround
		from WORK.Gaze2
		where GazeType = 1
		group by Dyad, Cov;
quit;

proc sql;
	create table Monitor_2 as
   	select Dyad, sum(Duration) / 30.0 as TotalDurationMonitor,
   		mean(Duration) / 30.0 as MeanDurationMonitor,
   		count(*) as FrequencyMonitor
		from WORK.Gaze2
		where GazeType = 2
		group by Dyad;
quit;

proc sql;
	create table Keyboard_2 as 
   	select Dyad, sum(Duration) / 30.0 as TotalDurationKeyboard,
   		mean(Duration) / 30.0  as MeanDurationKeyboard,
   		count(*) as FrequencyKeyboard
		from WORK.Gaze2
		where GazeType = 3
		group by Dyad;
quit;

proc sql;
	create table Face_2 as
   	select Dyad, sum(Duration) / 30.0 as TotalDurationFace,
   		mean(Duration) / 30.0 as MeanDurationFace,
   		count(*) as FrequencyFace
		from WORK.Gaze2
		where GazeType = 4
		group by Dyad;
quit;

/*Join all the gaze data together*/
proc sql;
	create table Summary_2 as 
	select A.*, M.*, K.*, F.* 
		from WORK.Around_2 A	
		full join WORK.Monitor_2 M on A.Dyad = M.Dyad
		full join WORK.Keyboard_2 K on A.Dyad = K.Dyad
		full join WORK.Face_2 F on A.Dyad = F.Dyad;
quit;	

/*set all the null value to 0*/
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
proc ttest data=Summary order=data
           alpha=0.05 test=diff sides=2; /* two-sided test of diff between group means */
   class Cov;
   var TotalDurationAround;
run;


proc ttest data=Summary order=data
           alpha=0.05 test=diff sides=2; /* two-sided test of diff between group means */
   class Cov;
   var TotalDurationFace;
run;

proc ttest data=Summary order=data
           alpha=0.05 test=diff sides=2; /* two-sided test of diff between group means */
   class Cov;
   var TotalDurationMonitor;
run;

proc ttest data=Summary order=data
           alpha=0.05 test=diff sides=2; /* two-sided test of diff between group means */
   class Cov;
   var TotalDurationKeyboard;
run;

proc ttest data=Summary order=data
           alpha=0.05 test=diff sides=2; /* two-sided test of diff between group means */
   class Cov;
   var MeanDurationAround;
run;


proc ttest data=Summary order=data
           alpha=0.05 test=diff sides=2; /* two-sided test of diff between group means */
   class Cov;
   var MeanDurationFace;
run;

proc ttest data=Summary order=data
           alpha=0.05 test=diff sides=2; /* two-sided test of diff between group means */
   class Cov;
   var MeanDurationMonitor;
run;

proc ttest data=Summary order=data
           alpha=0.05 test=diff sides=2; /* two-sided test of diff between group means */
   class Cov;
   var MeanDurationKeyboard;
run;


/*------------------------Draw plot-box------------------------------------------*/

/*divide to 30.0 to get the time in second*/
/*USING THIS METHOD WILL IGNORE THE NULL VALUE, IT WILL DISAPPEARRRRRRRRRRRR, LOOK AT DYAD 8 FOR EXAMPLE*/
proc sql; /*Get the "Cov" column so we can add two table back together*/
	create table Test as
   	select Dyad, Cov,
   		CASE  
			WHEN GazeType = 1 THEN "Around"
			WHEN GazeType = 2 THEN "Monitor"
			WHEN GazeType = 3 THEN "Keyboard"
			WHEN GazeType = 4 THEN "Face"
		END as GazeType,

   		sum(Duration) / 30.0 as TotalDurationAround,
   		mean(Duration) / 30.0 as MeanDurationAround,
   		count(*) as FrequencyAround
		from WORK.IMPORT1
		group by Dyad, Cov, GazeType;
quit;


