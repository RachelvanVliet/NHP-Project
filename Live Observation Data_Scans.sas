PROC IMPORT DATAFILE="C:\Users\rache\Desktop\Lab backups\Results\Live Observations\Data\Live Observation Data Sheet for stats.xlsx" 
DBMS=xlsx
OUT= hdir;
SHEET='PROP-scans';
run;

PROC PRINT DATA= hdir;
run;

/**** REORG DATA/COLUMNS*/

data hdir1;
set hdir;
newtime = TimeF;
if TimeF = 'Before' then newtime = 2;
if TimeF = 'During' then newtime = 4;
if TimeF = 'After' then newtime = 6;
run;

proc print data = hdir1;
run;

data hdir2;
set hdir1;
time = newtime;
if week = 1 then time = newtime;
if week = 2 then time = newtime + 10080;
if week = 3 then time = newtime + 20160;
run;

proc print data = hdir2;
run;


/***********************************************************************/
/*MODEL explanation*/

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model group_LS = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr; /*newtime week newtime*week = newtime(week) week; in some stuation it may 
not be possible to use the interaction option for instance if you apply a treatment to different trees and collect the apples for analysis then you must nest apple in tree but in the present
situation where we have 3 identical collection time in each week we can chose one or the other format so newtime week newtime*week answered best our research questions*/
Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); /*in the present situtation considering that the research question is about the effect of time, weeks can be assumed to be 
independant of one another however there is still a time relationship that needs to be accounted for and this is refleted by the random statement with a covariance statement type = */
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); /*in the present situation time levels cannot be considered independant of one another, that implies a 
correlation of the time levels (not dependant of one another) which is reflected by the repeated statement with the covariance structure type =*/   
run;

/*Covariance structure was selected by a step by step elimination process (1 to 5 below). The elimination step resulting in the best BIC was selected for analysis. This was done for each variable*/

1. 
Random monkey(treatment room species);
Random week /type=ar(1) subject=monkey(treatment room species); /*covariance structure ar(1)*/
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); /*covariance structure ar(1)*/

2.
*Random monkey(treatment room species); /*removing monkey*/
Random week /type=ar(1) subject=monkey(treatment room species); /*covariance structure ar(1)*/
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); /*covariance structure ar(1)*/

3.
*Random monkey(treatment room species); /*removing monkey*/
Random week /type=cs subject=monkey(treatment room species); /*covariance structure cs*/ 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); /*covariance structure ar(1)*/

4.
*Random monkey(treatment room species); /*removing monkey*/
*Random week /type=ar(1) subject=monkey(treatment room species); /*removing week*/
Repeated newtime /type=cs subject=week(treatment room species monkey); /*covaraince structure cs*/

5. 
*Random monkey(treatment room species); /*removing monkey*/
Random week /type=cs subject=monkey(treatment room species); /*covaraince structure cs*/
*Repeated newtime /type=cs subject=week(treatment room species monkey); /*removing monkey*/

/***********************************************************/



Title ‘Frequency of Towards;

/*STEP 1: Covariance*/

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

Title'elimination 1';
/*ar(1) & ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Towards = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
Random monkey(treatment room species);
Random week /type=ar(1) subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 2';
/*no random monkey; ar(1) & ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Towards = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=ar(1) subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 3';
/*week cs & repeated ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Towards = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 4';
/*no random monkey; week cs & repeated ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Towards = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 5';
/*no random monkey and week; repeated cs*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Towards = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
*Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=cs subject=week(treatment room species monkey); 
run;
Title'elimination 6';
/*no random monkey; week cs; no repeated*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Towards = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
*Repeated newtime /type=cs subject=week(treatment room species monkey); 
run;

/*STEP 2: Normality*/ 

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Towards = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr
outpred=normality; /*creates the variables required to test normality*/
*Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
*Repeated newtime /type=cs subject=week(treatment room species monkey); 
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;

/*STEP 3: Significance*/ 

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Towards = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
*Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week / pdiff adjust=tukey;
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week / pdiff adjust=scheffe;
run;

/*STEP 4: calculating adjusted p-values for comparisons of interest only; to be repeated for each factor*/

Title'WEEK*NEWTIME p-value adjutment';

/*Step A. Obtain ftab to insert ftab value into cd equation*/

proc print data= hdir1;
run;

proc iml;
reset print;
ndf=4;  /*get from type 3 table for your specific effect*/
ddf=29.9; /*get from type 3 table for your specific effect*/
probability=0.1; /*your establish probability %*/
ftab=finv(1-probability,ndf,ddf);
run;
quit;

/*Step B. Run your mixed model for your effect of interest to create the estit table*/

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

ods output estimates=estit;
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Towards = treatment room species newtime week treatment*week treatment*newtime newtime*week / s ddfm=kr; 
*Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week;
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week;
estimate	"Wk1 Nt2 vs Nt4"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	-1	0	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	-0.5	0	0.5	-0.5	0	week*newtime	1	-1	0	0	0	0	0	0	0;
estimate	"Wk1 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	0	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	0	-0.5	0.5	0	-0.5	week*newtime	1	0	-1	0	0	0	0	0	0;
estimate	"Wk 1 Nt4 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	0	1	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0	0.5	-0.5	0	0.5	-0.5	week*newtime	0	1	-1	0	0	0	0	0	0;
estimate	"Wk2 Nt2 vs Nt4"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	-1	0	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	-0.5	0	0.5	-0.5	0	week*newtime	0	0	0	1	-1	0	0	0	0;
estimate	"Wk2 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	0	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	0	-0.5	0.5	0	-0.5	week*newtime	0	0	0	1	0	-1	0	0	0;
estimate	"Wk2 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	0	1	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0	0.5	-0.5	0	0.5	-0.5	week*newtime	0	0	0	0	1	-1	0	0	0;
estimate	"Wk3 Nt2 vs Nt4"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	-1	0	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	-0.5	0	0.5	-0.5	0	week*newtime	0	0	0	0	0	0	1	-1	0;
estimate	"Wk3 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	0	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	0	-0.5	0.5	0	-0.5	week*newtime	0	0	0	0	0	0	1	0	-1;
estimate	"Wk3 Nt4 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	0	1	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0	0.5	-0.5	0	0.5	-0.5	week*newtime	0	0	0	0	0	0	0	1	-1;
estimate	"Wk1 vs Wk2, Nt2"	intercept	0	treatment	0	0	week	1	-1	0	newtime	0	0	0	treatment*week	0.5	-0.5	0	0.5	-0.5	0	treatment*newtime	0	0	0	0	0	0	week*newtime	1	0	0	-1	0	0	0	0	0;
estimate	"Wk1 vs Wk2, Nt4"	intercept	0	treatment	0	0	week	1	-1	0	newtime	0	0	0	treatment*week	0.5	-0.5	0	0.5	-0.5	0	treatment*newtime	0	0	0	0	0	0	week*newtime	0	1	0	0	-1	0	0	0	0;
estimate	"Wk1 vs Wk2, Nt6"	intercept	0	treatment	0	0	week	1	-1	0	newtime	0	0	0	treatment*week	0.5	-0.5	0	0.5	-0.5	0	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	1	0	0	-1	0	0	0;
estimate	"Wk1 vs Wk3, Nt2"	intercept	0	treatment	0	0	week	1	0	-1	newtime	0	0	0	treatment*week	0.5	0	-0.5	0.5	0	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	1	0	0	0	0	0	-1	0	0;
estimate	"Wk1 vs Wk3, Nt4"	intercept	0	treatment	0	0	week	1	0	-1	newtime	0	0	0	treatment*week	0.5	0	-0.5	0.5	0	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	1	0	0	0	0	0	-1	0;
estimate	"Wk1 vs Wk3, Nt6"	intercept	0	treatment	0	0	week	1	0	-1	newtime	0	0	0	treatment*week	0.5	0	-0.5	0.5	0	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	1	0	0	0	0	0	-1;
estimate	"Wk2 vs Wk3, Nt2"	intercept	0	treatment	0	0	week	0	1	-1	newtime	0	0	0	treatment*week	0	0.5	-0.5	0	0.5	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	0	1	0	0	-1	0	0;
estimate	"Wk2 vs Wk3, Nt4"	intercept	0	treatment	0	0	week	0	1	-1	newtime	0	0	0	treatment*week	0	0.5	-0.5	0	0.5	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	0	0	1	0	0	-1	0;
estimate	"Wk2 vs Wk3, Nt6"	intercept	0	treatment	0	0	week	0	1	-1	newtime	0	0	0	treatment*week	0	0.5	-0.5	0	0.5	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	0	0	0	1	0	0	-1;

run;

proc contents data=estit;
run;

proc print data=estit;
run;
quit;

/*Step C. Obtain your Scheffe adjusted P-value for your chosen comparisons*/

/*
cd = sqrt(n-1*ftab value)*StdErr
N = number of comparisons
Ftab value = value obtained in step 1
*/

data estit2;
set estit;
cd = sqrt(8*2.1429301)*StdErr; /*9 comparisons of interest*/
ss = '      '; 
run;

proc print data= estit2;
run;


/***********************************************************************************************/


/*LS*/
Title 'Frequency of Away';

/*STEP 1: Covariance*/

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

Title'elimination 1';
/*ar(1) & ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Away = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
Random monkey(treatment room species);
Random week /type=ar(1) subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 2';
/*no random monkey; ar(1) & ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Away = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=ar(1) subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 3';
/*week cs & repeated ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Away = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 4';
/*no random monkey; week cs & repeated ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Away = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 5';
/*no random monkey and week; repeated cs*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Away = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
*Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=cs subject=week(treatment room species monkey); 
run;
Title'elimination 6';
/*no random monkey; week cs; no repeated*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Away = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
*Repeated newtime /type=cs subject=week(treatment room species monkey); 
run;

/*STEP 2: Normality*/ 

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Away = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr
outpred=normality; /*creates the variables required to test normality*/
*Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
*Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;

/*STEP 3: Significance*/ 

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Away = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
*Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week / pdiff adjust=tukey;
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week / pdiff adjust=scheffe;
run;

/*STEP 4: calculating adjusted p-values for comparisons of interest only; to be repeated for each factor*/

Title'WEEK*NEWTIME p-value adjutment';

/*Step A. Obtain ftab to insert ftab value into cd equation*/

proc print data= hdir1;
run;

proc iml;
reset print;
ndf=4;  /*get from type 3 table for your specific effect*/
ddf=29.9; /*get from type 3 table for your specific effect*/
probability=0.1; /*your establish probability %*/
ftab=finv(1-probability,ndf,ddf);
run;
quit;

/*Step B. Run your mixed model for your effect of interest to create the estit table*/

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

ods output estimates=estit;
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Away = treatment room species newtime week treatment*week treatment*newtime newtime*week / s ddfm=kr; 
*Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week;
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week;
estimate	"Wk1 Nt2 vs Nt4"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	-1	0	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	-0.5	0	0.5	-0.5	0	week*newtime	1	-1	0	0	0	0	0	0	0;
estimate	"Wk1 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	0	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	0	-0.5	0.5	0	-0.5	week*newtime	1	0	-1	0	0	0	0	0	0;
estimate	"Wk 1 Nt4 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	0	1	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0	0.5	-0.5	0	0.5	-0.5	week*newtime	0	1	-1	0	0	0	0	0	0;
estimate	"Wk2 Nt2 vs Nt4"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	-1	0	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	-0.5	0	0.5	-0.5	0	week*newtime	0	0	0	1	-1	0	0	0	0;
estimate	"Wk2 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	0	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	0	-0.5	0.5	0	-0.5	week*newtime	0	0	0	1	0	-1	0	0	0;
estimate	"Wk2 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	0	1	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0	0.5	-0.5	0	0.5	-0.5	week*newtime	0	0	0	0	1	-1	0	0	0;
estimate	"Wk3 Nt2 vs Nt4"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	-1	0	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	-0.5	0	0.5	-0.5	0	week*newtime	0	0	0	0	0	0	1	-1	0;
estimate	"Wk3 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	0	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	0	-0.5	0.5	0	-0.5	week*newtime	0	0	0	0	0	0	1	0	-1;
estimate	"Wk3 Nt4 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	0	1	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0	0.5	-0.5	0	0.5	-0.5	week*newtime	0	0	0	0	0	0	0	1	-1;
estimate	"Wk1 vs Wk2, Nt2"	intercept	0	treatment	0	0	week	1	-1	0	newtime	0	0	0	treatment*week	0.5	-0.5	0	0.5	-0.5	0	treatment*newtime	0	0	0	0	0	0	week*newtime	1	0	0	-1	0	0	0	0	0;
estimate	"Wk1 vs Wk2, Nt4"	intercept	0	treatment	0	0	week	1	-1	0	newtime	0	0	0	treatment*week	0.5	-0.5	0	0.5	-0.5	0	treatment*newtime	0	0	0	0	0	0	week*newtime	0	1	0	0	-1	0	0	0	0;
estimate	"Wk1 vs Wk2, Nt6"	intercept	0	treatment	0	0	week	1	-1	0	newtime	0	0	0	treatment*week	0.5	-0.5	0	0.5	-0.5	0	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	1	0	0	-1	0	0	0;
estimate	"Wk1 vs Wk3, Nt2"	intercept	0	treatment	0	0	week	1	0	-1	newtime	0	0	0	treatment*week	0.5	0	-0.5	0.5	0	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	1	0	0	0	0	0	-1	0	0;
estimate	"Wk1 vs Wk3, Nt4"	intercept	0	treatment	0	0	week	1	0	-1	newtime	0	0	0	treatment*week	0.5	0	-0.5	0.5	0	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	1	0	0	0	0	0	-1	0;
estimate	"Wk1 vs Wk3, Nt6"	intercept	0	treatment	0	0	week	1	0	-1	newtime	0	0	0	treatment*week	0.5	0	-0.5	0.5	0	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	1	0	0	0	0	0	-1;
estimate	"Wk2 vs Wk3, Nt2"	intercept	0	treatment	0	0	week	0	1	-1	newtime	0	0	0	treatment*week	0	0.5	-0.5	0	0.5	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	0	1	0	0	-1	0	0;
estimate	"Wk2 vs Wk3, Nt4"	intercept	0	treatment	0	0	week	0	1	-1	newtime	0	0	0	treatment*week	0	0.5	-0.5	0	0.5	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	0	0	1	0	0	-1	0;
estimate	"Wk2 vs Wk3, Nt6"	intercept	0	treatment	0	0	week	0	1	-1	newtime	0	0	0	treatment*week	0	0.5	-0.5	0	0.5	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	0	0	0	1	0	0	-1;

run;

proc contents data=estit;
run;

proc print data=estit;
run;
quit;

/*Step C. Obtain your Scheffe adjusted P-value for your chosen comparisons*/

/*
cd = sqrt(n-1*ftab value)*StdErr
N = number of comparisons
Ftab value = value obtained in step 1
*/

data estit2;
set estit;
cd = sqrt(8*2.1429301)*StdErr; /*9 comparisons of interest*/
ss = '      '; 
run;

proc print data= estit2;
run;

/*************************************************************************************************/


Title 'Frequency of Front';
/*STEP 1: Covariance*/

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

Title'elimination 1';
/*ar(1) & ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Front = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
Random monkey(treatment room species);
Random week /type=ar(1) subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 2';
/*no random monkey; ar(1) & ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Front = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=ar(1) subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 3';
/*week cs & repeated ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Front = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 4';
/*no random monkey; week cs & repeated ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Front = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 5';
/*no random monkey and week; repeated cs*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Front = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
*Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=cs subject=week(treatment room species monkey); 
run;
Title'elimination 6';
/*no random monkey; week cs; no repeated*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Front = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
*Repeated newtime /type=cs subject=week(treatment room species monkey); 
run;

/*STEP 2: Normality*/ 

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Front = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr
outpred=normality; /*creates the variables required to test normality*/
*Random monkey(treatment room species);
Random week /type=ar(1) subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;

/*STEP 3: Significance*/ 

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Front = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=ar(1) subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week / pdiff adjust=tukey;
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week / pdiff adjust=scheffe;
run;

/*STEP 4: calculating adjusted p-values for comparisons of interest only; to be repeated for each factor*/

Title'WEEK*NEWTIME p-value adjutment';

/*Step A. Obtain ftab to insert ftab value into cd equation*/

proc print data= hdir1;
run;

proc iml;
reset print;
ndf=4;  /*get from type 3 table for your specific effect*/
ddf=29.9; /*get from type 3 table for your specific effect*/
probability=0.1; /*your establish probability %*/
ftab=finv(1-probability,ndf,ddf);
run;
quit;

/*Step B. Run your mixed model for your effect of interest to create the estit table*/

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

ods output estimates=estit;
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Front = treatment room species newtime week treatment*week treatment*newtime newtime*week / s ddfm=kr; 
*Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week;
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week;
estimate	"Wk1 Nt2 vs Nt4"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	-1	0	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	-0.5	0	0.5	-0.5	0	week*newtime	1	-1	0	0	0	0	0	0	0;
estimate	"Wk1 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	0	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	0	-0.5	0.5	0	-0.5	week*newtime	1	0	-1	0	0	0	0	0	0;
estimate	"Wk 1 Nt4 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	0	1	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0	0.5	-0.5	0	0.5	-0.5	week*newtime	0	1	-1	0	0	0	0	0	0;
estimate	"Wk2 Nt2 vs Nt4"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	-1	0	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	-0.5	0	0.5	-0.5	0	week*newtime	0	0	0	1	-1	0	0	0	0;
estimate	"Wk2 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	0	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	0	-0.5	0.5	0	-0.5	week*newtime	0	0	0	1	0	-1	0	0	0;
estimate	"Wk2 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	0	1	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0	0.5	-0.5	0	0.5	-0.5	week*newtime	0	0	0	0	1	-1	0	0	0;
estimate	"Wk3 Nt2 vs Nt4"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	-1	0	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	-0.5	0	0.5	-0.5	0	week*newtime	0	0	0	0	0	0	1	-1	0;
estimate	"Wk3 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	0	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	0	-0.5	0.5	0	-0.5	week*newtime	0	0	0	0	0	0	1	0	-1;
estimate	"Wk3 Nt4 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	0	1	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0	0.5	-0.5	0	0.5	-0.5	week*newtime	0	0	0	0	0	0	0	1	-1;
estimate	"Wk1 vs Wk2, Nt2"	intercept	0	treatment	0	0	week	1	-1	0	newtime	0	0	0	treatment*week	0.5	-0.5	0	0.5	-0.5	0	treatment*newtime	0	0	0	0	0	0	week*newtime	1	0	0	-1	0	0	0	0	0;
estimate	"Wk1 vs Wk2, Nt4"	intercept	0	treatment	0	0	week	1	-1	0	newtime	0	0	0	treatment*week	0.5	-0.5	0	0.5	-0.5	0	treatment*newtime	0	0	0	0	0	0	week*newtime	0	1	0	0	-1	0	0	0	0;
estimate	"Wk1 vs Wk2, Nt6"	intercept	0	treatment	0	0	week	1	-1	0	newtime	0	0	0	treatment*week	0.5	-0.5	0	0.5	-0.5	0	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	1	0	0	-1	0	0	0;
estimate	"Wk1 vs Wk3, Nt2"	intercept	0	treatment	0	0	week	1	0	-1	newtime	0	0	0	treatment*week	0.5	0	-0.5	0.5	0	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	1	0	0	0	0	0	-1	0	0;
estimate	"Wk1 vs Wk3, Nt4"	intercept	0	treatment	0	0	week	1	0	-1	newtime	0	0	0	treatment*week	0.5	0	-0.5	0.5	0	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	1	0	0	0	0	0	-1	0;
estimate	"Wk1 vs Wk3, Nt6"	intercept	0	treatment	0	0	week	1	0	-1	newtime	0	0	0	treatment*week	0.5	0	-0.5	0.5	0	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	1	0	0	0	0	0	-1;
estimate	"Wk2 vs Wk3, Nt2"	intercept	0	treatment	0	0	week	0	1	-1	newtime	0	0	0	treatment*week	0	0.5	-0.5	0	0.5	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	0	1	0	0	-1	0	0;
estimate	"Wk2 vs Wk3, Nt4"	intercept	0	treatment	0	0	week	0	1	-1	newtime	0	0	0	treatment*week	0	0.5	-0.5	0	0.5	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	0	0	1	0	0	-1	0;
estimate	"Wk2 vs Wk3, Nt6"	intercept	0	treatment	0	0	week	0	1	-1	newtime	0	0	0	treatment*week	0	0.5	-0.5	0	0.5	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	0	0	0	1	0	0	-1;

run;

proc contents data=estit;
run;

proc print data=estit;
run;
quit;

/*Step C. Obtain your Scheffe adjusted P-value for your chosen comparisons*/

/*
cd = sqrt(n-1*ftab value)*StdErr
N = number of comparisons
Ftab value = value obtained in step 1
*/

data estit2;
set estit;
cd = sqrt(8*2.1429301)*StdErr; /*9 comparisons of interest*/
ss = '      '; 
run;

proc print data= estit2;
run;

/*********************************************************************************************/



Title 'Frequency of Mid';
/*STEP 1: Covariance*/

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

Title'elimination 1';
/*ar(1) & ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Mid = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
Random monkey(treatment room species);
Random week /type=ar(1) subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 2';
/*no random monkey; ar(1) & ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Mid = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=ar(1) subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 3';
/*week cs & repeated ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Mid = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 4';
/*no random monkey; week cs & repeated ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Mid = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 5';
/*no random monkey and week; repeated cs*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Mid = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
*Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=cs subject=week(treatment room species monkey); 
run;
Title'elimination 6';
/*no random monkey; week cs; no repeated*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Mid = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
*Repeated newtime /type=cs subject=week(treatment room species monkey); 
run;

/*STEP 2: Normality*/ 

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Mid = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr
outpred=normality; /*creates the variables required to test normality*/
*Random monkey(treatment room species);
Random week /type=ar(1) subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;

/*STEP 3: Significance*/ 

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Mid = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=ar(1) subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week / pdiff adjust=tukey;
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week / pdiff adjust=scheffe;
run;

/*STEP 4: calculating adjusted p-values for comparisons of interest only; to be repeated for each factor*/

Title'WEEK*NEWTIME p-value adjutment';

/*Step A. Obtain ftab to insert ftab value into cd equation*/

proc print data= hdir1;
run;

proc iml;
reset print;
ndf=4;  /*get from type 3 table for your specific effect*/
ddf=29.9; /*get from type 3 table for your specific effect*/
probability=0.1; /*your establish probability %*/
ftab=finv(1-probability,ndf,ddf);
run;
quit;

/*Step B. Run your mixed model for your effect of interest to create the estit table*/

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

ods output estimates=estit;
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Mid = treatment room species newtime week treatment*week treatment*newtime newtime*week / s ddfm=kr; 
*Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week;
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week;
estimate	"Wk1 Nt2 vs Nt4"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	-1	0	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	-0.5	0	0.5	-0.5	0	week*newtime	1	-1	0	0	0	0	0	0	0;
estimate	"Wk1 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	0	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	0	-0.5	0.5	0	-0.5	week*newtime	1	0	-1	0	0	0	0	0	0;
estimate	"Wk 1 Nt4 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	0	1	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0	0.5	-0.5	0	0.5	-0.5	week*newtime	0	1	-1	0	0	0	0	0	0;
estimate	"Wk2 Nt2 vs Nt4"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	-1	0	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	-0.5	0	0.5	-0.5	0	week*newtime	0	0	0	1	-1	0	0	0	0;
estimate	"Wk2 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	0	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	0	-0.5	0.5	0	-0.5	week*newtime	0	0	0	1	0	-1	0	0	0;
estimate	"Wk2 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	0	1	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0	0.5	-0.5	0	0.5	-0.5	week*newtime	0	0	0	0	1	-1	0	0	0;
estimate	"Wk3 Nt2 vs Nt4"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	-1	0	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	-0.5	0	0.5	-0.5	0	week*newtime	0	0	0	0	0	0	1	-1	0;
estimate	"Wk3 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	0	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	0	-0.5	0.5	0	-0.5	week*newtime	0	0	0	0	0	0	1	0	-1;
estimate	"Wk3 Nt4 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	0	1	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0	0.5	-0.5	0	0.5	-0.5	week*newtime	0	0	0	0	0	0	0	1	-1;
estimate	"Wk1 vs Wk2, Nt2"	intercept	0	treatment	0	0	week	1	-1	0	newtime	0	0	0	treatment*week	0.5	-0.5	0	0.5	-0.5	0	treatment*newtime	0	0	0	0	0	0	week*newtime	1	0	0	-1	0	0	0	0	0;
estimate	"Wk1 vs Wk2, Nt4"	intercept	0	treatment	0	0	week	1	-1	0	newtime	0	0	0	treatment*week	0.5	-0.5	0	0.5	-0.5	0	treatment*newtime	0	0	0	0	0	0	week*newtime	0	1	0	0	-1	0	0	0	0;
estimate	"Wk1 vs Wk2, Nt6"	intercept	0	treatment	0	0	week	1	-1	0	newtime	0	0	0	treatment*week	0.5	-0.5	0	0.5	-0.5	0	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	1	0	0	-1	0	0	0;
estimate	"Wk1 vs Wk3, Nt2"	intercept	0	treatment	0	0	week	1	0	-1	newtime	0	0	0	treatment*week	0.5	0	-0.5	0.5	0	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	1	0	0	0	0	0	-1	0	0;
estimate	"Wk1 vs Wk3, Nt4"	intercept	0	treatment	0	0	week	1	0	-1	newtime	0	0	0	treatment*week	0.5	0	-0.5	0.5	0	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	1	0	0	0	0	0	-1	0;
estimate	"Wk1 vs Wk3, Nt6"	intercept	0	treatment	0	0	week	1	0	-1	newtime	0	0	0	treatment*week	0.5	0	-0.5	0.5	0	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	1	0	0	0	0	0	-1;
estimate	"Wk2 vs Wk3, Nt2"	intercept	0	treatment	0	0	week	0	1	-1	newtime	0	0	0	treatment*week	0	0.5	-0.5	0	0.5	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	0	1	0	0	-1	0	0;
estimate	"Wk2 vs Wk3, Nt4"	intercept	0	treatment	0	0	week	0	1	-1	newtime	0	0	0	treatment*week	0	0.5	-0.5	0	0.5	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	0	0	1	0	0	-1	0;
estimate	"Wk2 vs Wk3, Nt6"	intercept	0	treatment	0	0	week	0	1	-1	newtime	0	0	0	treatment*week	0	0.5	-0.5	0	0.5	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	0	0	0	1	0	0	-1;

run;

proc contents data=estit;
run;

proc print data=estit;
run;
quit;

/*Step C. Obtain your Scheffe adjusted P-value for your chosen comparisons*/

/*
cd = sqrt(n-1*ftab value)*StdErr
N = number of comparisons
Ftab value = value obtained in step 1
*/

data estit2;
set estit;
cd = sqrt(8*2.1429301)*StdErr; /*9 comparisons of interest*/
ss = '      '; 
run;

proc print data= estit2;
run;

/********************************************************************************************************/




Title 'Frequency of Back';
/*STEP 1: Covariance*/

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

Title'elimination 1';
/*ar(1) & ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Back = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
Random monkey(treatment room species);
Random week /type=ar(1) subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 2';
/*no random monkey; ar(1) & ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Back = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=ar(1) subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 3';
/*week cs & repeated ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Back = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 4';
/*no random monkey; week cs & repeated ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Back = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 5';
/*no random monkey and week; repeated cs*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Back = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
*Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=cs subject=week(treatment room species monkey); 
run;
Title'elimination 6';
/*no random monkey; week cs; no repeated*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Back = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
*Repeated newtime /type=cs subject=week(treatment room species monkey); 
run;

/*STEP 2: Normality*/ 

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Back = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr
outpred=normality; /*creates the variables required to test normality*/
*Random monkey(treatment room species);
Random week /type=ar(1) subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;

/*STEP 3: Significance*/ 

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Back = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=ar(1) subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week / pdiff adjust=tukey;
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week / pdiff adjust=scheffe;
run;

/*STEP 4: calculating adjusted p-values for comparisons of interest only; to be repeated for each factor*/

Title'WEEK*NEWTIME p-value adjutment';

/*Step A. Obtain ftab to insert ftab value into cd equation*/

proc print data= hdir1;
run;

proc iml;
reset print;
ndf=4;  /*get from type 3 table for your specific effect*/
ddf=29.9; /*get from type 3 table for your specific effect*/
probability=0.1; /*your establish probability %*/
ftab=finv(1-probability,ndf,ddf);
run;
quit;

/*Step B. Run your mixed model for your effect of interest to create the estit table*/

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

ods output estimates=estit;
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Back = treatment room species newtime week treatment*week treatment*newtime newtime*week / s ddfm=kr; 
*Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week;
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week;
estimate	"Wk1 Nt2 vs Nt4"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	-1	0	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	-0.5	0	0.5	-0.5	0	week*newtime	1	-1	0	0	0	0	0	0	0;
estimate	"Wk1 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	0	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	0	-0.5	0.5	0	-0.5	week*newtime	1	0	-1	0	0	0	0	0	0;
estimate	"Wk 1 Nt4 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	0	1	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0	0.5	-0.5	0	0.5	-0.5	week*newtime	0	1	-1	0	0	0	0	0	0;
estimate	"Wk2 Nt2 vs Nt4"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	-1	0	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	-0.5	0	0.5	-0.5	0	week*newtime	0	0	0	1	-1	0	0	0	0;
estimate	"Wk2 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	0	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	0	-0.5	0.5	0	-0.5	week*newtime	0	0	0	1	0	-1	0	0	0;
estimate	"Wk2 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	0	1	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0	0.5	-0.5	0	0.5	-0.5	week*newtime	0	0	0	0	1	-1	0	0	0;
estimate	"Wk3 Nt2 vs Nt4"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	-1	0	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	-0.5	0	0.5	-0.5	0	week*newtime	0	0	0	0	0	0	1	-1	0;
estimate	"Wk3 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	0	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	0	-0.5	0.5	0	-0.5	week*newtime	0	0	0	0	0	0	1	0	-1;
estimate	"Wk3 Nt4 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	0	1	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0	0.5	-0.5	0	0.5	-0.5	week*newtime	0	0	0	0	0	0	0	1	-1;
estimate	"Wk1 vs Wk2, Nt2"	intercept	0	treatment	0	0	week	1	-1	0	newtime	0	0	0	treatment*week	0.5	-0.5	0	0.5	-0.5	0	treatment*newtime	0	0	0	0	0	0	week*newtime	1	0	0	-1	0	0	0	0	0;
estimate	"Wk1 vs Wk2, Nt4"	intercept	0	treatment	0	0	week	1	-1	0	newtime	0	0	0	treatment*week	0.5	-0.5	0	0.5	-0.5	0	treatment*newtime	0	0	0	0	0	0	week*newtime	0	1	0	0	-1	0	0	0	0;
estimate	"Wk1 vs Wk2, Nt6"	intercept	0	treatment	0	0	week	1	-1	0	newtime	0	0	0	treatment*week	0.5	-0.5	0	0.5	-0.5	0	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	1	0	0	-1	0	0	0;
estimate	"Wk1 vs Wk3, Nt2"	intercept	0	treatment	0	0	week	1	0	-1	newtime	0	0	0	treatment*week	0.5	0	-0.5	0.5	0	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	1	0	0	0	0	0	-1	0	0;
estimate	"Wk1 vs Wk3, Nt4"	intercept	0	treatment	0	0	week	1	0	-1	newtime	0	0	0	treatment*week	0.5	0	-0.5	0.5	0	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	1	0	0	0	0	0	-1	0;
estimate	"Wk1 vs Wk3, Nt6"	intercept	0	treatment	0	0	week	1	0	-1	newtime	0	0	0	treatment*week	0.5	0	-0.5	0.5	0	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	1	0	0	0	0	0	-1;
estimate	"Wk2 vs Wk3, Nt2"	intercept	0	treatment	0	0	week	0	1	-1	newtime	0	0	0	treatment*week	0	0.5	-0.5	0	0.5	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	0	1	0	0	-1	0	0;
estimate	"Wk2 vs Wk3, Nt4"	intercept	0	treatment	0	0	week	0	1	-1	newtime	0	0	0	treatment*week	0	0.5	-0.5	0	0.5	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	0	0	1	0	0	-1	0;
estimate	"Wk2 vs Wk3, Nt6"	intercept	0	treatment	0	0	week	0	1	-1	newtime	0	0	0	treatment*week	0	0.5	-0.5	0	0.5	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	0	0	0	1	0	0	-1;

run;

proc contents data=estit;
run;

proc print data=estit;
run;
quit;

/*Step C. Obtain your Scheffe adjusted P-value for your chosen comparisons*/

/*
cd = sqrt(n-1*ftab value)*StdErr
N = number of comparisons
Ftab value = value obtained in step 1
*/

data estit2;
set estit;
cd = sqrt(8*2.1429301)*StdErr; /*9 comparisons of interest*/
ss = '      '; 
run;

proc print data= estit2;
run;

/****************************************************************************************************************/





Title 'Frequency of Encl';
/*STEP 1: Covariance*/

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

Title'elimination 1';
/*ar(1) & ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Encl = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
Random monkey(treatment room species);
Random week /type=ar(1) subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 2';
/*no random monkey; ar(1) & ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Encl = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=ar(1) subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 3';
/*week cs & repeated ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Encl = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 4';
/*no random monkey; week cs & repeated ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Encl = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 5';
/*no random monkey and week; repeated cs*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Encl = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
*Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=cs subject=week(treatment room species monkey); 
run;
Title'elimination 6';
/*no random monkey; week cs; no repeated*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Encl = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
*Repeated newtime /type=cs subject=week(treatment room species monkey); 
run;

/*STEP 2: Normality*/ 

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Encl = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr
outpred=normality; /*creates the variables required to test normality*/
*Random monkey(treatment room species);
Random week /type=ar(1) subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;

/*STEP 3: Significance*/ 

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Encl = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=ar(1) subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week / pdiff adjust=tukey;
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week / pdiff adjust=scheffe;
run;

/*STEP 4: calculating adjusted p-values for comparisons of interest only; to be repeated for each factor*/

Title'WEEK*NEWTIME p-value adjutment';

/*Step A. Obtain ftab to insert ftab value into cd equation*/

proc print data= hdir1;
run;

proc iml;
reset print;
ndf=4;  /*get from type 3 table for your specific effect*/
ddf=29.9; /*get from type 3 table for your specific effect*/
probability=0.1; /*your establish probability %*/
ftab=finv(1-probability,ndf,ddf);
run;
quit;

/*Step B. Run your mixed model for your effect of interest to create the estit table*/

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

ods output estimates=estit;
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Encl = treatment room species newtime week treatment*week treatment*newtime newtime*week / s ddfm=kr; 
*Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week;
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week;
estimate	"Wk1 Nt2 vs Nt4"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	-1	0	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	-0.5	0	0.5	-0.5	0	week*newtime	1	-1	0	0	0	0	0	0	0;
estimate	"Wk1 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	0	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	0	-0.5	0.5	0	-0.5	week*newtime	1	0	-1	0	0	0	0	0	0;
estimate	"Wk 1 Nt4 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	0	1	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0	0.5	-0.5	0	0.5	-0.5	week*newtime	0	1	-1	0	0	0	0	0	0;
estimate	"Wk2 Nt2 vs Nt4"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	-1	0	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	-0.5	0	0.5	-0.5	0	week*newtime	0	0	0	1	-1	0	0	0	0;
estimate	"Wk2 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	0	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	0	-0.5	0.5	0	-0.5	week*newtime	0	0	0	1	0	-1	0	0	0;
estimate	"Wk2 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	0	1	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0	0.5	-0.5	0	0.5	-0.5	week*newtime	0	0	0	0	1	-1	0	0	0;
estimate	"Wk3 Nt2 vs Nt4"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	-1	0	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	-0.5	0	0.5	-0.5	0	week*newtime	0	0	0	0	0	0	1	-1	0;
estimate	"Wk3 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	0	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	0	-0.5	0.5	0	-0.5	week*newtime	0	0	0	0	0	0	1	0	-1;
estimate	"Wk3 Nt4 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	0	1	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0	0.5	-0.5	0	0.5	-0.5	week*newtime	0	0	0	0	0	0	0	1	-1;
estimate	"Wk1 vs Wk2, Nt2"	intercept	0	treatment	0	0	week	1	-1	0	newtime	0	0	0	treatment*week	0.5	-0.5	0	0.5	-0.5	0	treatment*newtime	0	0	0	0	0	0	week*newtime	1	0	0	-1	0	0	0	0	0;
estimate	"Wk1 vs Wk2, Nt4"	intercept	0	treatment	0	0	week	1	-1	0	newtime	0	0	0	treatment*week	0.5	-0.5	0	0.5	-0.5	0	treatment*newtime	0	0	0	0	0	0	week*newtime	0	1	0	0	-1	0	0	0	0;
estimate	"Wk1 vs Wk2, Nt6"	intercept	0	treatment	0	0	week	1	-1	0	newtime	0	0	0	treatment*week	0.5	-0.5	0	0.5	-0.5	0	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	1	0	0	-1	0	0	0;
estimate	"Wk1 vs Wk3, Nt2"	intercept	0	treatment	0	0	week	1	0	-1	newtime	0	0	0	treatment*week	0.5	0	-0.5	0.5	0	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	1	0	0	0	0	0	-1	0	0;
estimate	"Wk1 vs Wk3, Nt4"	intercept	0	treatment	0	0	week	1	0	-1	newtime	0	0	0	treatment*week	0.5	0	-0.5	0.5	0	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	1	0	0	0	0	0	-1	0;
estimate	"Wk1 vs Wk3, Nt6"	intercept	0	treatment	0	0	week	1	0	-1	newtime	0	0	0	treatment*week	0.5	0	-0.5	0.5	0	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	1	0	0	0	0	0	-1;
estimate	"Wk2 vs Wk3, Nt2"	intercept	0	treatment	0	0	week	0	1	-1	newtime	0	0	0	treatment*week	0	0.5	-0.5	0	0.5	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	0	1	0	0	-1	0	0;
estimate	"Wk2 vs Wk3, Nt4"	intercept	0	treatment	0	0	week	0	1	-1	newtime	0	0	0	treatment*week	0	0.5	-0.5	0	0.5	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	0	0	1	0	0	-1	0;
estimate	"Wk2 vs Wk3, Nt6"	intercept	0	treatment	0	0	week	0	1	-1	newtime	0	0	0	treatment*week	0	0.5	-0.5	0	0.5	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	0	0	0	1	0	0	-1;

run;

proc contents data=estit;
run;

proc print data=estit;
run;
quit;

/*Step C. Obtain your Scheffe adjusted P-value for your chosen comparisons*/

/*
cd = sqrt(n-1*ftab value)*StdErr
N = number of comparisons
Ftab value = value obtained in step 1
*/

data estit2;
set estit;
cd = sqrt(8*2.1429301)*StdErr; /*9 comparisons of interest*/
ss = '      '; 
run;

proc print data= estit2;
run;

/******************************************************************************************************************/





Title 'Frequency of Int';
/*STEP 1: Covariance*/

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

Title'elimination 1';
/*ar(1) & ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Int = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
Random monkey(treatment room species);
Random week /type=ar(1) subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 2';
/*no random monkey; ar(1) & ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Int = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=ar(1) subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 3';
/*week cs & repeated ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Int = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 4';
/*no random monkey; week cs & repeated ar(1)*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Int = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;
Title'elimination 5';
/*no random monkey and week; repeated cs*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Int = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
*Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=cs subject=week(treatment room species monkey); 
run;
Title'elimination 6';
/*no random monkey; week cs; no repeated*/
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Int = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
*Repeated newtime /type=cs subject=week(treatment room species monkey); 
run;

/*STEP 2: Normality*/ 

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Int = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr
outpred=normality; /*creates the variables required to test normality*/
*Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;

/*STEP 3: Significance*/ 

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Int = treatment room species newtime week newtime*week treatment*newtime treatment*week  / s ddfm=kr;
*Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week / pdiff adjust=tukey;
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week / pdiff adjust=scheffe;
run;

/*STEP 4: calculating adjusted p-values for comparisons of interest only; to be repeated for each factor*/

Title'WEEK*NEWTIME p-value adjutment';

/*Step A. Obtain ftab to insert ftab value into cd equation*/

proc print data= hdir1;
run;

proc iml;
reset print;
ndf=4;  /*get from type 3 table for your specific effect*/
ddf=29.9; /*get from type 3 table for your specific effect*/
probability=0.1; /*your establish probability %*/
ftab=finv(1-probability,ndf,ddf);
run;
quit;

/*Step B. Run your mixed model for your effect of interest to create the estit table*/

proc sort data=hdir1;
by treatment room species monkey week newtime; 
run;

ods output estimates=estit;
Proc mixed data= hdir1 lognote;
Class treatment room monkey week newtime species;
Model Int = treatment room species newtime week treatment*week treatment*newtime newtime*week / s ddfm=kr; 
*Random monkey(treatment room species);
Random week /type=cs subject=monkey(treatment room species); 
Repeated newtime /type=ar(1) subject=week(treatment room species monkey); 
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week;
lsmeans newtime treatment week newtime*week treatment*newtime treatment*week;
estimate	"Wk1 Nt2 vs Nt4"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	-1	0	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	-0.5	0	0.5	-0.5	0	week*newtime	1	-1	0	0	0	0	0	0	0;
estimate	"Wk1 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	0	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	0	-0.5	0.5	0	-0.5	week*newtime	1	0	-1	0	0	0	0	0	0;
estimate	"Wk 1 Nt4 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	0	1	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0	0.5	-0.5	0	0.5	-0.5	week*newtime	0	1	-1	0	0	0	0	0	0;
estimate	"Wk2 Nt2 vs Nt4"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	-1	0	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	-0.5	0	0.5	-0.5	0	week*newtime	0	0	0	1	-1	0	0	0	0;
estimate	"Wk2 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	0	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	0	-0.5	0.5	0	-0.5	week*newtime	0	0	0	1	0	-1	0	0	0;
estimate	"Wk2 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	0	1	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0	0.5	-0.5	0	0.5	-0.5	week*newtime	0	0	0	0	1	-1	0	0	0;
estimate	"Wk3 Nt2 vs Nt4"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	-1	0	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	-0.5	0	0.5	-0.5	0	week*newtime	0	0	0	0	0	0	1	-1	0;
estimate	"Wk3 Nt2 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	1	0	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0.5	0	-0.5	0.5	0	-0.5	week*newtime	0	0	0	0	0	0	1	0	-1;
estimate	"Wk3 Nt4 vs Nt6"	intercept	0	treatment	0	0	week	0	0	0	newtime	0	1	-1	treatment*week	0	0	0	0	0	0	treatment*newtime	0	0.5	-0.5	0	0.5	-0.5	week*newtime	0	0	0	0	0	0	0	1	-1;
estimate	"Wk1 vs Wk2, Nt2"	intercept	0	treatment	0	0	week	1	-1	0	newtime	0	0	0	treatment*week	0.5	-0.5	0	0.5	-0.5	0	treatment*newtime	0	0	0	0	0	0	week*newtime	1	0	0	-1	0	0	0	0	0;
estimate	"Wk1 vs Wk2, Nt4"	intercept	0	treatment	0	0	week	1	-1	0	newtime	0	0	0	treatment*week	0.5	-0.5	0	0.5	-0.5	0	treatment*newtime	0	0	0	0	0	0	week*newtime	0	1	0	0	-1	0	0	0	0;
estimate	"Wk1 vs Wk2, Nt6"	intercept	0	treatment	0	0	week	1	-1	0	newtime	0	0	0	treatment*week	0.5	-0.5	0	0.5	-0.5	0	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	1	0	0	-1	0	0	0;
estimate	"Wk1 vs Wk3, Nt2"	intercept	0	treatment	0	0	week	1	0	-1	newtime	0	0	0	treatment*week	0.5	0	-0.5	0.5	0	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	1	0	0	0	0	0	-1	0	0;
estimate	"Wk1 vs Wk3, Nt4"	intercept	0	treatment	0	0	week	1	0	-1	newtime	0	0	0	treatment*week	0.5	0	-0.5	0.5	0	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	1	0	0	0	0	0	-1	0;
estimate	"Wk1 vs Wk3, Nt6"	intercept	0	treatment	0	0	week	1	0	-1	newtime	0	0	0	treatment*week	0.5	0	-0.5	0.5	0	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	1	0	0	0	0	0	-1;
estimate	"Wk2 vs Wk3, Nt2"	intercept	0	treatment	0	0	week	0	1	-1	newtime	0	0	0	treatment*week	0	0.5	-0.5	0	0.5	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	0	1	0	0	-1	0	0;
estimate	"Wk2 vs Wk3, Nt4"	intercept	0	treatment	0	0	week	0	1	-1	newtime	0	0	0	treatment*week	0	0.5	-0.5	0	0.5	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	0	0	1	0	0	-1	0;
estimate	"Wk2 vs Wk3, Nt6"	intercept	0	treatment	0	0	week	0	1	-1	newtime	0	0	0	treatment*week	0	0.5	-0.5	0	0.5	-0.5	treatment*newtime	0	0	0	0	0	0	week*newtime	0	0	0	0	0	1	0	0	-1;

run;

proc contents data=estit;
run;

proc print data=estit;
run;
quit;

/*Step C. Obtain your Scheffe adjusted P-value for your chosen comparisons*/

/*
cd = sqrt(n-1*ftab value)*StdErr
N = number of comparisons
Ftab value = value obtained in step 1
*/

data estit2;
set estit;
cd = sqrt(8*2.1429301)*StdErr; /*9 comparisons of interest*/
ss = '      '; 
run;

proc print data= estit2;
run;

