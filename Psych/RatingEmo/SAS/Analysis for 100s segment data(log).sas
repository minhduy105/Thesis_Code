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


/*
Get the total, mean, and frequency of the four gaze
Divide to 30.0 to get the time in second

Gaze Type ID:
Around = 1
Monitor = 2
Keyboard = 3
Face = 4
*/

/*---------------------------get the gaze data for the first 100 seconds----------------------------*/
proc sql; 
	create table Around_1_0s as
   	select Dyad, sum(log(Duration/30.0))as TotalDurationAround1_0s,
   		mean(log(Duration/30.0)) as MeanDurationAround1_0s,
   		count(*) as FrequencyAround1_0s
		from WORK.Gaze1
		where GazeType = 1 and SectionStartTime = 0
		group by Dyad;
quit;

proc sql;
	create table Monitor_1_0s as
   	select Dyad, sum(log(Duration/30.0)) as TotalDurationMonitor1_0s,
   		mean(log(Duration/30.0)) as MeanDurationMonitor1_0s,
   		count(*) as FrequencyMonitor1_0s
		from WORK.Gaze1
		where GazeType = 2 and SectionStartTime = 0
		group by Dyad;
quit;

proc sql;
	create table Keyboard_1_0s as
   	select Dyad, sum(log(Duration/30.0)) as TotalDurationKeyboard1_0s,
   		mean(log(Duration/30.0)) as MeanDurationKeyboard1_0s,
   		count(*) as FrequencyKeyboard1_0s
		from WORK.Gaze1
		where GazeType = 3 and SectionStartTime = 0
		group by Dyad;
quit;

proc sql;
	create table Face_1_0s as
   	select Dyad, sum(log(Duration/30.0)) as TotalDurationFace1_0s,
   		mean(log(Duration/30.0)) as MeanDurationFace1_0s,
   		count(*) as FrequencyFace1_0s
		from WORK.Gaze1
		where GazeType = 4 and SectionStartTime = 0
		group by Dyad;
quit;

/*---------------------------get the gaze data for the last 100 seconds----------------------------*/
proc sql; 
	create table Around_1_200s as
   	select Dyad, sum(log(Duration/30.0)) as TotalDurationAround1_200s,
   		mean(log(Duration/30.0)) as MeanDurationAround1_200s,
   		count(*) as FrequencyAround1_200s
		from WORK.Gaze1
		where GazeType = 1 and SectionStartTime = 6000
		group by Dyad;
quit;

proc sql;
	create table Monitor_1_200s as
   	select Dyad, sum(log(Duration/30.0)) as TotalDurationMonitor1_200s,
   		mean(log(Duration/30.0)) as MeanDurationMonitor1_200s,
   		count(*) as FrequencyMonitor1_200s
		from WORK.Gaze1
		where GazeType = 2 and SectionStartTime = 6000
		group by Dyad;
quit;

proc sql;
	create table Keyboard_1_200s as
   	select Dyad, sum(log(Duration/30.0)) as TotalDurationKeyboard1_200s,
   		mean(log(Duration/30.0)) as MeanDurationKeyboard1_200s,
   		count(*) as FrequencyKeyboard1_200s
		from WORK.Gaze1
		where GazeType = 3 and SectionStartTime = 6000
		group by Dyad;
quit;

proc sql;
	create table Face_1_200s as
   	select Dyad, sum(log(Duration/30.0)) as TotalDurationFace1_200s,
   		mean(log(Duration/30.0)) as MeanDurationFace1_200s,
   		count(*) as FrequencyFace1_200s
		from WORK.Gaze1
		where GazeType = 4 and SectionStartTime = 6000
		group by Dyad;
quit;


/*Join all the gaze data together*/
proc sql;
	create table Summary_1 as 
	select F0.*, M0.*, K0.*, A0.*, F2.*, M2.*, K2.*, A2.* 
		from WORK.Face_1_0s F0	
		full join WORK.Monitor_1_0s M0 on F0.Dyad = M0.Dyad
		full join WORK.Keyboard_1_0s K0 on F0.Dyad = K0.Dyad
		full join WORK.Around_1_0s A0 on F0.Dyad = A0.Dyad

		full join WORK.Face_1_200s F2 on F0.Dyad = F2.Dyad
		full join WORK.Monitor_1_200s M2 on F0.Dyad = M2.Dyad
		full join WORK.Keyboard_1_200s K2 on F0.Dyad = K2.Dyad
		full join WORK.Around_1_200s A2 on F0.Dyad = A2.Dyad;
quit;	


/* -----------------get data for conversation 2-----------------------*/
data Gaze2;
   set WORK.IMPORT (keep = Dyad Cov SectionStartTime Duration GazeType);
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

/*---------------------------get the gaze data for the first 100 seconds----------------------------*/
proc sql; 
	create table Around_2_0s as
   	select Dyad, sum(log(Duration/30.0)) as TotalDurationAround2_0s,
   		mean(log(Duration/30.0)) as MeanDurationAround2_0s,
   		count(*) as FrequencyAround2_0s
		from WORK.Gaze2
		where GazeType = 1 and SectionStartTime = 0
		group by Dyad;
quit;

proc sql;
	create table Monitor_2_0s as
   	select Dyad, sum(log(Duration/30.0)) as TotalDurationMonitor2_0s,
   		mean(log(Duration/30.0)) as MeanDurationMonitor2_0s,
   		count(*) as FrequencyMonitor2_0s
		from WORK.Gaze2
		where GazeType = 2 and SectionStartTime = 0
		group by Dyad;
quit;

proc sql;
	create table Keyboard_2_0s as
   	select Dyad, sum(log(Duration/30.0)) as TotalDurationKeyboard2_0s,
   		mean(log(Duration/30.0)) as MeanDurationKeyboard2_0s,
   		count(*) as FrequencyKeyboard2_0s
		from WORK.Gaze2
		where GazeType = 3 and SectionStartTime = 0
		group by Dyad;
quit;

proc sql;
	create table Face_2_0s as
   	select Dyad, sum(log(Duration/30.0)) as TotalDurationFace2_0s,
   		mean(log(Duration/30.0)) as MeanDurationFace2_0s,
   		count(*) as FrequencyFace2_0s
		from WORK.Gaze2
		where GazeType = 4 and SectionStartTime = 0
		group by Dyad;
quit;

/*---------------------------get the gaze data for the last 100 seconds----------------------------*/
proc sql; 
	create table Around_2_200s as
   	select Dyad, sum(log(Duration/30.0)) as TotalDurationAround2_200s,
   		mean(log(Duration/30.0)) as MeanDurationAround2_200s,
   		count(*) as FrequencyAround2_200s
		from WORK.Gaze2
		where GazeType = 1 and SectionStartTime = 6000
		group by Dyad;
quit;

proc sql;
	create table Monitor_2_200s as
   	select Dyad, sum(log(Duration/30.0)) as TotalDurationMonitor2_200s,
   		mean(log(Duration/30.0)) as MeanDurationMonitor2_200s,
   		count(*) as FrequencyMonitor2_200s
		from WORK.Gaze2
		where GazeType = 2 and SectionStartTime = 6000
		group by Dyad;
quit;

proc sql;
	create table Keyboard_2_200s as
   	select Dyad, sum(log(Duration/30.0)) as TotalDurationKeyboard2_200s,
   		mean(log(Duration/30.0)) as MeanDurationKeyboard2_200s,
   		count(*) as FrequencyKeyboard2_200s
		from WORK.Gaze2
		where GazeType = 3 and SectionStartTime = 6000
		group by Dyad;
quit;

proc sql;
	create table Face_2_200s as
   	select Dyad, sum(log(Duration/30.0)) as TotalDurationFace2_200s,
   		mean(log(Duration/30.0)) as MeanDurationFace2_200s,
   		count(*) as FrequencyFace2_200s
		from WORK.Gaze2
		where GazeType = 4 and SectionStartTime = 6000
		group by Dyad;
quit;


/*Join all the gaze data together*/
proc sql;
	create table Summary_2 as 
	select F0.*, M0.*, K0.*, A0.*, F2.*, M2.*, K2.*, A2.* 
		from WORK.Face_2_0s F0	
		full join WORK.Monitor_2_0s M0 on F0.Dyad = M0.Dyad
		full join WORK.Keyboard_2_0s K0 on F0.Dyad = K0.Dyad
		full join WORK.Around_2_0s A0 on F0.Dyad = A0.Dyad

		full join WORK.Face_2_200s F2 on F0.Dyad = F2.Dyad
		full join WORK.Monitor_2_200s M2 on F0.Dyad = M2.Dyad
		full join WORK.Keyboard_2_200s K2 on F0.Dyad = K2.Dyad
		full join WORK.Around_2_200s A2 on F0.Dyad = A2.Dyad;
quit;	


/*Combine dyad 1 and dyad 2 together*/

proc sql;
	create table Summary as 
	select D1.*, D2.* 
		from WORK.Summary_1 D1	
		full join WORK.Summary_2 D2 on D1.Dyad = D2.Dyad;
quit;	

/*--------------------------------------Summary of the data-------------------------------------------*/

proc means data=Summary n mean max min range std fw=8; /*fw is field width, which is how big the table is gonna be*/
   var TotalDurationAround1_0s TotalDurationAround1_200s TotalDurationAround2_0s TotalDurationAround2_200s 
   		TotalDurationFace1_0s TotalDurationFace1_200s TotalDurationFace2_0s TotalDurationFace2_200s;
   title 'Summary of Total gaze time in 4 categories and 2 conversation';
run;

proc means data=Summary n mean max min range std fw=8; /*fw is field width, which is how big the table is gonna be*/
   var MeanDurationAround1_0s MeanDurationAround1_200s MeanDurationAround2_0s MeanDurationAround2_200s 
   		MeanDurationFace1_0s MeanDurationFace1_200s MeanDurationFace2_0s MeanDurationFace2_200s;
   title 'Summary of Mean gaze time in 4 categories and 2 conversation';
run;

proc means data=Summary n mean max min range std fw=8; /*fw is field width, which is how big the table is gonna be*/
   var FrequencyAround1_0s FrequencyAround1_200s FrequencyAround2_0s FrequencyAround2_200s 
   		FrequencyFace1_0s FrequencyFace1_200s FrequencyFace2_0s FrequencyFace2_200s;
   title 'Summary of Frequency of gaze in 4 categories and 2 conversation';
run;

/*-------------------------Running the Paired T-Test for gazes between conversation------------------------------------------*/
proc ttest data=Summary order=data
           alpha=0.05 test=diff sides=2; /* two-sided test of diff between group means */
   paired TotalDurationAround1_0s*TotalDurationAround1_200s
   			TotalDurationAround2_0s*TotalDurationAround2_200s
   			TotalDurationAround1_0s*TotalDurationAround2_0s
			TotalDurationAround1_200s*TotalDurationAround2_0s
   			TotalDurationAround1_200s*TotalDurationAround2_200s
   		
   			TotalDurationFace1_0s*TotalDurationFace1_200s
   			TotalDurationFace2_0s*TotalDurationFace2_200s
   			TotalDurationFace1_0s*TotalDurationFace2_0s
   			TotalDurationFace1_200s*TotalDurationFace2_0s
   			TotalDurationFace1_200s*TotalDurationFace2_200s
   			
			MeanDurationAround1_0s*MeanDurationAround1_200s 
			MeanDurationAround2_0s*MeanDurationAround2_200s
			MeanDurationAround1_0s*MeanDurationAround2_0s
			MeanDurationAround1_200s*MeanDurationAround2_0s
			MeanDurationAround1_200s*MeanDurationAround2_200s
			
			MeanDurationFace1_0s*MeanDurationFace1_200s
			MeanDurationFace2_0s*MeanDurationFace2_200s
			MeanDurationFace1_0s*MeanDurationFace2_0s
			MeanDurationFace1_200s*MeanDurationFace2_0s
			MeanDurationFace1_200s*MeanDurationFace2_200s
			
			FrequencyAround1_0s*FrequencyAround1_200s 
			FrequencyAround2_0s*FrequencyAround2_200s
			FrequencyAround1_0s*FrequencyAround2_0s
			FrequencyAround1_200s*FrequencyAround2_0s
			FrequencyAround1_200s*FrequencyAround2_200s
			
			FrequencyFace1_0s*FrequencyFace1_200s 
			FrequencyFace2_0s*FrequencyFace2_200s
			FrequencyFace1_0s*FrequencyFace2_0s
			FrequencyFace1_200s*FrequencyFace2_0s
			FrequencyFace1_200s*FrequencyFace2_200s
			;
run;

/*------------------------------Running the Correlation Test------------------------------------------*/
proc corr data=Summary;
	var TotalDurationAround1_0s TotalDurationAround1_200s TotalDurationAround2_0s TotalDurationAround2_200s ;
run;

proc corr data=Summary;
	var TotalDurationFace1_0s TotalDurationFace1_200s TotalDurationFace2_0s TotalDurationFace2_200s ;
run;

proc corr data=Summary;
	var MeanDurationAround1_0s MeanDurationAround1_200s MeanDurationAround2_0s MeanDurationAround2_200s ;
run;

proc corr data=Summary;
	var MeanDurationFace1_0s MeanDurationFace1_200s MeanDurationFace2_0s MeanDurationFace2_200s ;
run;

proc corr data=Summary;
	var FrequencyAround1_0s FrequencyAround1_200s FrequencyAround2_0s FrequencyAround2_200s ;
run;

proc corr data=Summary;
	var FrequencyFace1_0s FrequencyFace1_200s FrequencyFace2_0s FrequencyFace2_200s ;
run;


/*--------------------------------Draw plot-box -----------------------------------------------------*/
/*create new column in order to create new table for doing box-plot */
proc sql; /*adding new column*/
      alter table Summary
      ADD AroundID char format = $6.
      ADD FaceID char format = $4.
      ADD MonitorID char format = $7.
      ADD KeyboardID char format = $3.
      ADD Cov1 char format = $4.
      ADD Cov2 char format = $4.
      ADD TimeStart0 char format = $2.
      ADD TimeStart2 char format = $4.;
   update Summary
   set AroundID='Around', FaceID='Face', MonitorID='Monitor', KeyboardID='Key',
	   Cov1 = 'Con1', Cov2 = 'Con2',
	   TimeStart0 = '0s', TimeStart2 = '200s' ; /*set initial values for those column*/
quit;

proc sql;/*create new table for box-plot*/
create table Summary_box_plot as 
	select AroundID as GazeType, Cov1 as Conversation, TimeStart0 as TimeStart,
			TotalDurationAround1_0s as TotalDuration, MeanDurationAround1_0s as MeanDuration,
			FrequencyAround1_0s as Frequency from Summary
	union
	select AroundID, Cov1, TimeStart2, TotalDurationAround1_200s, MeanDurationAround1_200s, FrequencyAround1_200s  from Summary
	union
	select AroundID, Cov2, TimeStart0, TotalDurationAround2_0s, MeanDurationAround2_0s, FrequencyAround2_0s  from Summary
	union
	select AroundID, Cov2, TimeStart2, TotalDurationAround2_200s, MeanDurationAround2_200s, FrequencyAround2_200s  from Summary
	union

	select FaceID,Cov1, TimeStart0, TotalDurationFace1_0s , MeanDurationFace1_0s, FrequencyFace1_0s  from Summary
	union
	select FaceID,Cov1, TimeStart2, TotalDurationFace1_200s , MeanDurationFace1_200s, FrequencyFace1_200s  from Summary
	union
	select FaceID,Cov2, TimeStart0, TotalDurationFace2_0s , MeanDurationFace2_0s, FrequencyFace2_0s  from Summary
	union
	select FaceID,Cov2, TimeStart2, TotalDurationFace2_200s , MeanDurationFace2_200s, FrequencyFace2_200s  from Summary
;
quit;

data Summary_box_plot;
   set Summary_box_plot;
   ConvTime=catx('_at_', of Conversation, TimeStart );
run;


title 'Box Plot for Total Duration of Face Gaze and Around Gaze in Conversation 1 and 2 (v1)';
proc sgplot data=Summary_box_plot;
  vbox TotalDuration / category=ConvTime group=GazeType groupdisplay=cluster;
  YAXIS LABEL = 'Total Duration (seconds)';
  run;


title 'Box Plot for Mean Duration of Face Gaze and Around Gaze in Conversation 1 and 2 (v1)';
proc sgplot data=Summary_box_plot;
  vbox MeanDuration / category=ConvTime group=GazeType groupdisplay=cluster;
  YAXIS LABEL = 'Total Duration (seconds)';
  run;
  
title 'Box Plot for Frequency of Face Gaze and Around Gaze in Conversation 1 and 2 (v1)';
proc sgplot data=Summary_box_plot;
  vbox Frequency / category=ConvTime group=GazeType groupdisplay=cluster;
  YAXIS LABEL = 'Frequency';
  run;  

title 'Box Plot for Total Duration of Face Gaze and Around Gaze in Conversation 1 and 2 (v2)';
proc sgplot data=Summary_box_plot;
  vbox TotalDuration / category=GazeType group=ConvTime groupdisplay=cluster;
  YAXIS LABEL = 'Total Duration (seconds)';
  run;


title 'Box Plot for Mean Duration of Face Gaze and Around Gaze in Conversation 1 and 2 (v2)';
proc sgplot data=Summary_box_plot;
  vbox MeanDuration / category=GazeType group=ConvTime groupdisplay=cluster;
  YAXIS LABEL = 'Total Duration (seconds)';
  run;
  

title 'Box Plot for Frequency of Face Gaze and Around Gaze in Conversation 1 and 2 (v2)';
proc sgplot data=Summary_box_plot;
  vbox Frequency / category=GazeType group=ConvTime groupdisplay=cluster;
  YAXIS LABEL = 'Frequency';
  run;  
  
/*--------------------------------------Draw histogram plot-------------------------------------------*/

/*-------------------------------------Total Around------------------------------------*/
title 'Histogram for Total Around Gaze of the 1st interaction between the first 100s and the last 100s with kernel fitting';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and Conversation in ("Con1");       /* restrict to two groups */
	histogram TotalDuration / group=TimeStart transparency=0.5;       /* SAS 9.4m2 */
	density TotalDuration / type= kernel group=TimeStart;/* overlay density estimates */
run;

title 'Histogram for Total Around Gaze of the 2nd interaction between the first 100s and the last 100s with kernel fitting';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and Conversation in ("Con2");       /* restrict to two groups */
	histogram TotalDuration / group=TimeStart transparency=0.5;       /* SAS 9.4m2 */
	density TotalDuration / type= kernel group=TimeStart;/* overlay density estimates */
run;

title 'Histogram for Total Around Gaze in the first 100s with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and TimeStart in ("0s");       /* restrict to two groups */
	histogram TotalDuration / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density TotalDuration / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Total Around Gaze in the last 100s with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and TimeStart in ("200s");       /* restrict to two groups */
	histogram TotalDuration / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density TotalDuration / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Total Around Gaze in the last 100s of the 1st interaction and the first 100s of the 2nd interaction with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and((TimeStart in ("200s") and Conversation in ("Con1"))
								or (TimeStart in ("0s") and Conversation in ("Con2")));       /* restrict to two groups */
	histogram TotalDuration / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density TotalDuration / type= kernel group=Conversation;/* overlay density estimates */
run;


/*-------------------------------------Total Face------------------------------------*/
title 'Histogram for Total Face Gaze of the 1st interaction between the first 100s and the last 100s with kernel fitting';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and Conversation in ("Con1");       /* restrict to two groups */
	histogram TotalDuration / group=TimeStart transparency=0.5;       /* SAS 9.4m2 */
	density TotalDuration / type= kernel group=TimeStart;/* overlay density estimates */
run;

title 'Histogram for Total Face Gaze of the 2nd interaction between the first 100s and the last 100s with kernel fitting';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and Conversation in ("Con2");       /* restrict to two groups */
	histogram TotalDuration / group=TimeStart transparency=0.5;       /* SAS 9.4m2 */
	density TotalDuration / type= kernel group=TimeStart;/* overlay density estimates */
run;

title 'Histogram for Total Face Gaze in the first 100s with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and TimeStart in ("0s");       /* restrict to two groups */
	histogram TotalDuration / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density TotalDuration / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Total Face Gaze in the last 100s with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and TimeStart in ("200s");       /* restrict to two groups */
	histogram TotalDuration / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density TotalDuration / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Total Face Gaze in the last 100s of the 1st interaction and the first 100s of the 2nd interaction with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and((TimeStart in ("200s") and Conversation in ("Con1"))
								or (TimeStart in ("0s") and Conversation in ("Con2")));       /* restrict to two groups */
	histogram TotalDuration / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density TotalDuration / type= kernel group=Conversation;/* overlay density estimates */
run;


/*-------------------------------------Mean Around------------------------------------*/
title 'Histogram for Mean Around Gaze of the 1st interaction between the first 100s and the last 100s with kernel fitting';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and Conversation in ("Con1");       /* restrict to two groups */
	histogram MeanDuration / group=TimeStart transparency=0.5;       /* SAS 9.4m2 */
	density MeanDuration / type= kernel group=TimeStart;/* overlay density estimates */
run;

title 'Histogram for Mean Around Gaze of the 2nd interaction between the first 100s and the last 100s with kernel fitting';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and Conversation in ("Con2");       /* restrict to two groups */
	histogram MeanDuration / group=TimeStart transparency=0.5;       /* SAS 9.4m2 */
	density MeanDuration / type= kernel group=TimeStart;/* overlay density estimates */
run;

title 'Histogram for Mean Around Gaze in the first 100s with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and TimeStart in ("0s");       /* restrict to two groups */
	histogram MeanDuration / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density MeanDuration / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Mean Around Gaze in the last 100s with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and TimeStart in ("200s");       /* restrict to two groups */
	histogram MeanDuration / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density MeanDuration / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Mean Around Gaze in the last 100s of the 1st interaction and the first 100s of the 2nd interaction with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and((TimeStart in ("200s") and Conversation in ("Con1"))
								or (TimeStart in ("0s") and Conversation in ("Con2")));       /* restrict to two groups */
	histogram MeanDuration / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density MeanDuration / type= kernel group=Conversation;/* overlay density estimates */
run;


/*-------------------------------------Mean Face------------------------------------*/
title 'Histogram for Mean Face Gaze of the 1st interaction between the first 100s and the last 100s with kernel fitting';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and Conversation in ("Con1");       /* restrict to two groups */
	histogram MeanDuration / group=TimeStart transparency=0.5;       /* SAS 9.4m2 */
	density MeanDuration / type= kernel group=TimeStart;/* overlay density estimates */
run;

title 'Histogram for Mean Face Gaze of the 2nd interaction between the first 100s and the last 100s with kernel fitting';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and Conversation in ("Con2");       /* restrict to two groups */
	histogram MeanDuration / group=TimeStart transparency=0.5;       /* SAS 9.4m2 */
	density MeanDuration / type= kernel group=TimeStart;/* overlay density estimates */
run;

title 'Histogram for Mean Face Gaze in the first 100s with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and TimeStart in ("0s");       /* restrict to two groups */
	histogram MeanDuration / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density MeanDuration / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Mean Face Gaze in the last 100s with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and TimeStart in ("200s");       /* restrict to two groups */
	histogram MeanDuration / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density MeanDuration / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Mean Face Gaze in the last 100s of the 1st interaction and the first 100s of the 2nd interaction with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and((TimeStart in ("200s") and Conversation in ("Con1"))
								or (TimeStart in ("0s") and Conversation in ("Con2")));       /* restrict to two groups */
	histogram MeanDuration / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density MeanDuration / type= kernel group=Conversation;/* overlay density estimates */
run;

/*-------------------------------------Frequency Around------------------------------------*/
title 'Histogram for Frequency Around Gaze of the 1st interaction between the first 100s and the last 100s with kernel fitting';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and Conversation in ("Con1");       /* restrict to two groups */
	histogram Frequency / group=TimeStart transparency=0.5;       /* SAS 9.4m2 */
	density Frequency / type= kernel group=TimeStart;/* overlay density estimates */
run;

title 'Histogram for Frequency Around Gaze of the 2nd interaction between the first 100s and the last 100s with kernel fitting';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and Conversation in ("Con2");       /* restrict to two groups */
	histogram Frequency / group=TimeStart transparency=0.5;       /* SAS 9.4m2 */
	density Frequency / type= kernel group=TimeStart;/* overlay density estimates */
run;

title 'Histogram for Frequency Around Gaze in the first 100s with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and TimeStart in ("0s");       /* restrict to two groups */
	histogram Frequency / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density Frequency / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Frequency Around Gaze in the last 100s with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and TimeStart in ("200s");       /* restrict to two groups */
	histogram Frequency / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density Frequency / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Frequency Around Gaze in the last 100s of the 1st interaction and the first 100s of the 2nd interaction with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and((TimeStart in ("200s") and Conversation in ("Con1"))
								or (TimeStart in ("0s") and Conversation in ("Con2")));       /* restrict to two groups */
	histogram Frequency / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density Frequency / type= kernel group=Conversation;/* overlay density estimates */
run;


/*-------------------------------------Frequency Face------------------------------------*/
title 'Histogram for Frequency Face Gaze of the 1st interaction between the first 100s and the last 100s with kernel fitting';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and Conversation in ("Con1");       /* restrict to two groups */
	histogram Frequency / group=TimeStart transparency=0.5;       /* SAS 9.4m2 */
	density Frequency / type= kernel group=TimeStart;/* overlay density estimates */
run;

title 'Histogram for Frequency Face Gaze of the 2nd interaction between the first 100s and the last 100s with kernel fitting';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and Conversation in ("Con2");       /* restrict to two groups */
	histogram Frequency / group=TimeStart transparency=0.5;       /* SAS 9.4m2 */
	density Frequency / type= kernel group=TimeStart;/* overlay density estimates */
run;

title 'Histogram for Frequency Face Gaze in the first 100s with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and TimeStart in ("0s");       /* restrict to two groups */
	histogram Frequency / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density Frequency / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Frequency Face Gaze in the last 100s with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and TimeStart in ("200s");       /* restrict to two groups */
	histogram Frequency / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density Frequency / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Frequency Face Gaze in the last 100s of the 1st interaction and the first 100s of the 2nd interaction with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and((TimeStart in ("200s") and Conversation in ("Con1"))
								or (TimeStart in ("0s") and Conversation in ("Con2")));       /* restrict to two groups */
	histogram Frequency / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density Frequency / type= kernel group=Conversation;/* overlay density estimates */
run;
