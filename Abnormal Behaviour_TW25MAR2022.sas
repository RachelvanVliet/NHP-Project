PROC IMPORT DATAFILE="C:\Users\rache\Desktop\Lab backups\Results\Weekly Videos\Pivots\Pivot Table -Weekly Video -Abnormal Behaviour_RV07OCT2021_RV18JAN2022.xlsx"
DBMS=xlsx
OUT=abs;
SHEET='Data';
run;

PROC PRINT DATA=abs;
run;

/*data abs1;
set abs;
newweek = week;
if phase = 'PRE' then newweek = week;
if phase = 'EXP' then newweek = 3 + week;
if phase = 'POST' then newweek = 6 + week;
run;

proc print data = abs1;
run;*/

data abs1;
set abs;
newphase = phase;
if phase = 'PRE' then newphase = 1;
if phase = 'EXP' then newphase = 2;
if phase = 'POST' then newphase = 3;
run;

proc print data = abs1;
run;

/*beginning with groups only, individual behaviour analysis TBD*/

Title 'Frequency of Cage-Directed behaviours';

/*STEP 1 Covariance structure*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Freq_Cage_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Freq_Cage_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Freq_Cage_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*BEST STRUCTURE = CS*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Freq_Cage_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*Relatively normal from visual assessment of graph, but tendency to skew to the left. Shapiro-Wilk result confirms the skew.*/

/*STEP 3 Stats*/ 

proc sort data=abs1;
by treatment room week newphase; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Freq_Cage_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=scheffe; 
run;

/*************************************************/

Title 'Frequency of Self-Directed Behaviour';

/*STEP 1 Covariance structure*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Freq_Self_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Freq_Self_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Freq_Self_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*BEST STRUCTURE = CS*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Freq_Self_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*Distribution appears normal upon visual assessment.*/

/*STEP 3 Stats*/ 

proc sort data=abs1;
by treatment room week newphase; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Freq_Self_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=scheffe; 
run;

/*************************************************/

Title 'Frequency of Stereotypic Behaviour';

/*STEP 1 Covariance structure*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Freq_Stereotypic = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Freq_Stereotypic = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Freq_Stereotypic = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*BEST STRUCTURE = CS*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Freq_Stereotypic = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*Upon visual assessment, distribution appears normal.*/


/*STEP 3 Stats*/ 

proc sort data=abs1;
by treatment room week newphase; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Freq_Stereotypic = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=scheffe; 
run;

/*************************************************/

Title 'Frequency of Locomotive Behaviour';

/*STEP 1 Covariance structure*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Freq_Locomotive = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Freq_Locomotive = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Freq_Locomotive = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*BEST STRUCTURE = CS*/


/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Freq_Locomotive = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*Relatively normal with left-skew tendency*/

/*STEP 3 Stats*/ 

proc sort data=abs1;
by treatment room week newphase; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Freq_Locomotive = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=scheffe; 
run;

/*************************************************/

Title 'Duration of Cage-Directed Behaviour';


/*STEP 1 Covariance structure*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Seconds_Cage_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Seconds_Cage_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Seconds_Cage_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*BEST = CS*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Seconds_Cage_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*Relatively normal but left-skew tendency*/


/*STEP 3 Stats*/ 

proc sort data=abs1;
by treatment room week newphase; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Seconds_Cage_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=scheffe; 
run;

/*************************************************/

Title 'Duration of Self-Directed Behaviour';


/*STEP 1 Covariance structure*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Seconds_Self_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Seconds_Self_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Seconds_Self_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*Best = CS*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Seconds_Self_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*VIsual assessment: normal with slight tendency to skew to the left*/

/*STEP 3 Stats*/ 

proc sort data=abs1;
by treatment room week newphase; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Seconds_Self_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=scheffe; 
run;

/*************************************************/


Title 'Duration of Stereotypic Behaviour';


/*STEP 1 Covariance structure*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Seconds_Stereotypic = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Seconds_Stereotypic = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Seconds_Stereotypic = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*Best = CS*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Seconds_Stereotypic = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*Visual assessment: appears normally distributed*/

/*STEP 3 Stats*/ 

proc sort data=abs1;
by treatment room week newphase; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Seconds_Stereotypic = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=scheffe; 
run;

/*************************************************/

Title 'Duration of Locomotive Behaviour';

/*STEP 1 Covariance structure*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Seconds_Locomotive = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Seconds_Locomotive = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Seconds_Locomotive = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*Best = CS*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Seconds_Locomotive = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/* Visual assessment : relatively normal with left-skew tendency*/

/*STEP 3 Stats*/ 

proc sort data=abs1;
by treatment room week newphase; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Seconds_Locomotive = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=scheffe; 
run;

/*************************************************/

Title 'Frequency Proportion of Cage-Directed Behaviour';

/*STEP 1 Covariance structure*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_freq_Cage_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_freq_Cage_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_freq_Cage_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*Best = CS*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_freq_Cage_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*Normally-distributed*/

/*STEP 3 Stats*/ 

proc sort data=abs1;
by treatment room week newphase; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_freq_Cage_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=scheffe; 
run;

/*************************************************/

Title 'Frequency Proportion of Self-Directed Behaviour';

/*STEP 1 Covariance structure*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Freq_Self_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Freq_Self_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Freq_Self_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*BEST = AR(1)*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Freq_Self_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*Visual assessment: relatively normal. Slight bit of a tendency to skew to the left (yes, I mean those extra words ;P*/

/*STEP 3 Stats*/ 

proc sort data=abs1;
by treatment room week newphase; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Freq_Self_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=scheffe; 
run;

/*************************************************/

Title 'Frequency Proportion of Stereotypic Behaviour';

/*STEP 1 Covariance structure*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Freq_Stereotypic = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Freq_Stereotypic = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Freq_Stereotypic = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*BEST = CS*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Freq_Stereotypic = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*Visual assessment: normal distribution with slight left-skew tendency*/

/*STEP 3 Stats*/ 

proc sort data=abs1;
by treatment room week newphase; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Freq_Stereotypic = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=scheffe; 
run;

/*************************************************/


Title 'Frequency Proportion of Locomotive Behaviour';

/*STEP 1 Covariance structure*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Freq_Locomotive = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Freq_Locomotive = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Freq_Locomotive = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*Best = CS*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Freq_Locomotive = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*Normal distribution*/

/*STEP 3 Stats*/ 

proc sort data=abs1;
by treatment room week newphase; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Freq_Locomotive = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=scheffe; 
run;

/*************************************************/



Title 'Abnormal Proportion of Cage-Directed Behaviour';

/*STEP 1 Covariance structure*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_AB__Cage_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_AB__Cage_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_AB__Cage_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*Best = CS*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_AB__Cage_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*Normal distribution*/

/*STEP 3 Stats*/ 

proc sort data=abs1;
by treatment room week newphase; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_AB__Cage_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=scheffe; 
run;

/*************************************************/

Title 'Abnormal Proportion of Self-Directed Behaviour';

/*STEP 1 Covariance structure*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_AB__Self_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_AB__Self_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_AB__Self_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*Best = ar(1)*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_AB__Self_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*Visual assessment : distribution appears normal*/

/*STEP 3 Stats*/ 

proc sort data=abs1;
by treatment room week newphase; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_AB__Self_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=scheffe; 
run;

/*************************************************/

Title 'Abnormal Proportion of Stereotypic Behaviour';

/*STEP 1 Covariance structure*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_AB__Stereotypic = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_AB__Stereotypic = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_AB__Stereotypic = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*Best = ar(1)*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_AB__Stereotypic = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*Appears relatively normal, with a slight tendency to skew to the left*/

/*STEP 3 Stats*/ 

proc sort data=abs1;
by treatment room week newphase; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_AB__Stereotypic = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=scheffe; 
run;

/*************************************************/


Title 'Abnormal Proportion of Locomotive Behaviour';

/*STEP 1 Covariance structure*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_AB__Locomotive = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_AB__Locomotive = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_AB__Locomotive = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*Best = CS*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_AB__Locomotive = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*Normal*/

/*STEP 3 Stats*/ 

proc sort data=abs1;
by treatment room week newphase; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_AB__Locomotive = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=scheffe; 
run;

/*************************************************/

Title 'Time Proportion of Cage-Directed Behaviour';

/*STEP 1 Covariance structure*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Time__Cage_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Time__Cage_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Time__Cage_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*Best = CS*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Time__Cage_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*Visually normal with left-skew tendency*/

/*STEP 3 Stats*/ 

proc sort data=abs1;
by treatment room week newphase; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Time__Cage_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=scheffe; 
run;

/*************************************************/


Title 'Time Proportion of Self-Directed Behaviour';

/*STEP 1 Covariance structure*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Time_Self_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Time_Self_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Time_Self_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*Best = CS*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Time_Self_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*Visually, appears normal but slight skew to the left*/

/*STEP 3 Stats*/ 

proc sort data=abs1;
by treatment room week newphase; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Time_Self_Directed = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=scheffe; 
run;

/*************************************************/


Title 'Time Proportion of Stereotypic Behaviour';


/*STEP 1 Covariance structure*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Time__Stereotypic = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Time__Stereotypic = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Time__Stereotypic = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*Best = CS*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Time__Stereotypic = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*Visually, appears normal*/

/*STEP 3 Stats*/ 

proc sort data=abs1;
by treatment room week newphase; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Time__Stereotypic = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=scheffe; 
run;

/*************************************************/


Title 'Time Proportion of Locomotive Behaviour';

/*STEP 1 Covariance structure*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Time_Locomotive = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Time_Locomotive = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Time_Locomotive = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*Best = CS*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=abs1;
by treatment room monkey week; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Time_Locomotive = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*Visually, appears normal with slight left skew*/

/*STEP 3 Stats*/ 

proc sort data=abs1;
by treatment room week newphase; 
run;

Proc mixed data= abs1 lognote;
Class treatment room monkey newphase week species;
Model Prop_Time_Locomotive = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment week(newphase) newphase treatment*newphase / pdiff adjust=scheffe; 
run;

/*************************************************/


