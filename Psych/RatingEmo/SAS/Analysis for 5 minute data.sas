/*For the boxplot, need to be version 9.3 or above to run*/

libname sql 'SAS-library';
FILENAME REFFILE '/folders/myfolders/gaze analysys/DiscriptiveData_4gazes_100sec.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT1;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT1; RUN;

/* -----------------get data for conversation 1-----------------------*/
data Gaze1;
   set WORK.IMPORT1 (keep = Dyad Cov Duration GazeType);
	where Cov = 1;
run;


/*
Get the total, mean, and frequency of the four gaze
Divide to 30.0 to get the time in second

Gaze Type ID:
Around = 1
Monitor = 2
Keyboard = 3
Face = 4
*/


proc sql; /*Get the "Cov" column so we can add two table back together*/
	create table Around_1 as
   	select Dyad, sum(Duration) / 30.0 as TotalDurationAround1,
   		mean(Duration) / 30.0 as MeanDurationAround1,
   		count(*) as FrequencyAround1
		from WORK.Gaze1
		where GazeType = 1
		group by Dyad;
quit;

proc sql;
	create table Monitor_1 as
   	select Dyad, sum(Duration) / 30.0 as TotalDurationMonitor1,
   		mean(Duration) / 30.0 as MeanDurationMonitor1,
   		count(*) as FrequencyMonitor1
		from WORK.Gaze1
		where GazeType = 2
		group by Dyad;
quit;

proc sql;
	create table Keyboard_1 as
   	select Dyad, sum(Duration) / 30.0 as TotalDurationKeyboard1,
   		mean(Duration) / 30.0 as MeanDurationKeyboard1,
   		count(*) as FrequencyKeyboard1
		from WORK.Gaze1
		where GazeType = 3
		group by Dyad;
quit;

proc sql;
	create table Face_1 as
   	select Dyad, sum(Duration) / 30.0 as TotalDurationFace1,
   		mean(Duration) / 30.0 as MeanDurationFace1,
   		count(*) as FrequencyFace1
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

/*
Get the total, mean, and frequency of the four gaze
Divide to 30.0 to get the time in second

Gaze Type ID:
Around = 1
Monitor = 2
Keyboard = 3
Face = 4
*/


proc sql;
	create table Around_2 as
   	select Dyad, sum(Duration) / 30.0 as TotalDurationAround2,
   		mean(Duration) / 30.0 as MeanDurationAround2,
   		count(*) as FrequencyAround2
		from WORK.Gaze2
		where GazeType = 1
		group by Dyad;
quit;

proc sql;
	create table Monitor_2 as
   	select Dyad, sum(Duration) / 30.0 as TotalDurationMonitor2,
   		mean(Duration) / 30.0 as MeanDurationMonitor2,
   		count(*) as FrequencyMonitor2
		from WORK.Gaze2
		where GazeType = 2
		group by Dyad;
quit;

proc sql;
	create table Keyboard_2 as 
   	select Dyad, sum(Duration) / 30.0 as TotalDurationKeyboard2,
   		mean(Duration) / 30.0  as MeanDurationKeyboard2,
   		count(*) as FrequencyKeyboard2
		from WORK.Gaze2
		where GazeType = 3
		group by Dyad;
quit;

proc sql;
	create table Face_2 as
   	select Dyad, sum(Duration) / 30.0 as TotalDurationFace2,
   		mean(Duration) / 30.0 as MeanDurationFace2,
   		count(*) as FrequencyFace2
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

proc sql;/*This is used for correlation test*/
	create table Summary as 
	select D1.*, D2.* 
		from WORK.Summary_1 D1	
		full join WORK.Summary_2 D2 on D1.Dyad = D2.Dyad;
quit;	

/*--------------------------------------Summary of the data-------------------------------------------*/

proc means data=Summary n mean max min range std fw=8; /*fw is field width, which is how big the table is gonna be*/
   var TotalDurationAround1 TotalDurationAround2 TotalDurationFace1 TotalDurationFace2
		TotalDurationMonitor1 TotalDurationMonitor2 TotalDurationKeyboard1 TotalDurationKeyboard2;
   title 'Summary of Total gaze time in 4 categories and 2 conversation';
run;

proc means data=Summary n mean max min range std fw=8; /*fw is field width, which is how big the table is gonna be*/
   var MeanDurationAround1 MeanDurationAround2 MeanDurationFace1 MeanDurationFace2
		MeanDurationMonitor1 MeanDurationMonitor2 MeanDurationKeyboard1 MeanDurationKeyboard2;
   title 'Summary of Mean gaze time in 4 categories and 2 conversation';
run;

proc means data=Summary n mean max min range std fw=8; /*fw is field width, which is how big the table is gonna be*/
   var FrequencyAround1 FrequencyAround2 FrequencyFace1 FrequencyFace2
		FrequencyMonitor1 FrequencyMonitor2 FrequencyKeyboard1 FrequencyKeyboard2;
   title 'Summary of Frequency of gaze in 4 categories and 2 conversation';
run;
/*------------------------------Running the T-Test------------------------------------------*/
proc ttest data=Summary order=data
           alpha=0.05 test=diff sides=2; /* two-sided test of diff between group means */
   paired TotalDurationAround1*TotalDurationAround2 TotalDurationFace1*TotalDurationFace2
		TotalDurationMonitor1*TotalDurationMonitor2 TotalDurationKeyboard1*TotalDurationKeyboard2
		MeanDurationAround1*MeanDurationAround2 MeanDurationFace1*MeanDurationFace2
		MeanDurationMonitor1*MeanDurationMonitor2 MeanDurationKeyboard1*MeanDurationKeyboard2;
run;

/*------------------------------Running the Correlation Test------------------------------------------*/
proc corr data=Summary;
	var TotalDurationAround1 TotalDurationFace1 TotalDurationMonitor1 TotalDurationKeyboard1;
	with TotalDurationAround2 TotalDurationFace2 TotalDurationMonitor2 TotalDurationKeyboard2;
run;

proc corr data=Summary;
	var MeanDurationAround1 MeanDurationFace1 MeanDurationMonitor1 MeanDurationKeyboard1;
	with MeanDurationAround2 MeanDurationFace2 MeanDurationMonitor2 MeanDurationKeyboard2;
run;


/*------------------------Draw plot-box (TESTING)------------------------------------------*/
/*create new column in order to create new table for doing box-plot */
proc sql; /*adding new column*/
      alter table Summary
      ADD AroundID char format = $6.
      ADD FaceID char format = $4.
      ADD MonitorID char format = $7.
      ADD KeyboardID char format = $3.
      ADD Cov1 char format = $4.
      ADD Cov2 char format = $4.;
   update Summary
   set AroundID='Around', FaceID='Face', MonitorID='Monitor', KeyboardID='Key',
	   Cov1 = 'Con1', Cov2 = 'Con2';
quit;

proc sql;/*create new table for box-plot*/
create table Summary_box_plot as 
	select AroundID as GazeType, Cov1 as Conversation,TotalDurationAround1 as TotalDuration, MeanDurationAround1 as MeanDuration from Summary
	union
	select AroundID,Cov2, TotalDurationAround2 , MeanDurationAround2  from Summary
	union
	select FaceID,Cov1, TotalDurationFace1 , MeanDurationFace1  from Summary
	union
	select FaceID,Cov2, TotalDurationFace2 , MeanDurationFace2  from Summary
	union
	select MonitorID, Cov1, TotalDurationMonitor1 , MeanDurationMonitor1  from Summary
	union
	select MonitorID, Cov2, TotalDurationMonitor2 , MeanDurationMonitor2  from Summary
	union
	select KeyboardID, Cov1, TotalDurationKeyboard1 , MeanDurationKeyboard1  from Summary
	union
	select KeyboardID, Cov2, TotalDurationKeyboard2 , MeanDurationKeyboard2  from Summary;
quit;

title 'Box Plot for Total Duration of Gazes in Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
  vbox TotalDuration / category=Conversation group=GazeType groupdisplay=cluster;
  YAXIS LABEL = 'Total Duration (seconds)';
  run;


title 'Box Plot for Mean Duration of Gazes in Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
  vbox MeanDuration / category=Conversation group=GazeType groupdisplay=cluster;
  YAXIS LABEL = 'Total Duration (seconds)';
  run;


/*-------------------------Draw histogram plot----------------------------------*/
title 'Histogram for Total Around Gaze with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around");       /* restrict to two groups */
	histogram TotalDuration / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density TotalDuration / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Total Face Gaze with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face");       /* restrict to two groups */
	histogram TotalDuration / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density TotalDuration / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Total Around Gaze and Total Face Gaze with kernel fitting in Conversation 1';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around","Face") and Conversation in ("Con1");       /* restrict to two groups */
	histogram TotalDuration / group=GazeType transparency=0.5;       /* SAS 9.4m2 */
	density TotalDuration / type= kernel group=GazeType;/* overlay density estimates */
run;

title 'Histogram for Total Around Gaze and Total Face Gaze with kernel fitting in Conversation 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around","Face") and Conversation in ("Con1");       /* restrict to two groups */
	histogram TotalDuration / group=GazeType transparency=0.5;       /* SAS 9.4m2 */
	density TotalDuration / type= kernel group=GazeType;/* overlay density estimates */
run;

title 'Histogram for Mean Around Gaze with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around");       /* restrict to two groups */
	histogram MeanDuration / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density MeanDuration / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Mean Face Gaze with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face");       /* restrict to two groups */
	histogram MeanDuration / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density MeanDuration / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Mean Around Gaze and Mean Face Gaze with kernel fitting in Conversation 1';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around","Face") and Conversation in ("Con1");       /* restrict to two groups */
	histogram MeanDuration / group=GazeType transparency=0.5;       /* SAS 9.4m2 */
	density MeanDuration / type= kernel group=GazeType;/* overlay density estimates */
run;

title 'Histogram for Mean Around Gaze and Mean Face Gaze with kernel fitting in Conversation 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around","Face") and Conversation in ("Con1");       /* restrict to two groups */
	histogram MeanDuration / group=GazeType transparency=0.5;       /* SAS 9.4m2 */
	density MeanDuration / type= kernel group=GazeType;/* overlay density estimates */
run;

