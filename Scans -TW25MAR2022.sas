/************************************************************************************************************************/

/*import data from excel*/

PROC IMPORT DATAFILE="C:\Users\rache\Desktop\Lab backups\Results\Weekly Videos\Pivots\Pivot Table - Weekly Videos - Scans_SP03JUN2020.xlsx" /*change to accurate data file*/
DBMS=xlsx
OUT=scans;
SHEET='Data';
run;

PROC PRINT DATA=scans;
run;

/**** REORG DATA/COLUMNS*/

/*data scans1;
set scans;
newweek = week;
if phase = 'PRE' then newweek = week;
if phase = 'EXP' then newweek = 3 + week;
if phase = 'POST' then newweek = 6 + week;
run;

proc print data = scans1;
run;*/

data scans1;
set scans;
newphase = phase;
if phase = 'PRE' then newphase = 1;
if phase = 'EXP' then newphase = 2;
if phase = 'POST' then newphase = 3;
run;

proc print data = scans1;
run;


Title'Frequency of GR';


/*STEP 1 Covariance structure*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Gr = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Gr = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Gr = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room);    
run;
/*ar(1) had the best BIC*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Gr = treatment species room newphase week(newphase)  treatment*newphase   / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
/*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;

/*STEP 3 Stats*/ 

proc sort data=scans1;
by treatment room week newphase; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Gr = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=scheffe; 
run;



Title'Frequency of SG';


/*STEP 1 Covariance structure*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model SG = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model SG = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model SG = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room);    
run;
/*cs had the best BIC*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model SG = treatment species room newphase week(newphase)  treatment*newphase   / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
/*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W not normal; graph looks a little skewed to the left*/

/*STEP 3 Stats*/ 

proc sort data=scans1;
by treatment room week newphase; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model SG = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=scheffe; 
run;




Title'Frequency of Soc';


/*STEP 1 Covariance structure*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Soc = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Soc = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Soc = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room);    
run;
/*cs had the best BIC*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Soc = treatment species room newphase week(newphase)  treatment*newphase   / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs) subject=monkey(treatment room species);    
/*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W normal; graph looks normal*/

/*STEP 3 Stats*/ 

proc sort data=scans1;
by treatment room week newphase; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Soc = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=scheffe; 
run;



Title'Frequency of Ab';


/*STEP 1 Covariance structure*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Ab = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Ab = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Ab = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room);    
run;
/*cs had the best BIC*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Ab = treatment species room newphase week(newphase)  treatment*newphase   / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
/*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W not normal; graph looks normal*/

/*STEP 3 Stats*/ 

proc sort data=scans1;
by treatment room week newphase; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Ab = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=scheffe; 
run;



Title'Frequency of In';


/*STEP 1 Covariance structure*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model In = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model In = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model In = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room);    
run;
/*ar(1) had the best BIC*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model In = treatment species room newphase week(newphase)  treatment*newphase   / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
/*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W normal; graph looks normal*/

/*STEP 3 Stats*/ 

proc sort data=scans1;
by treatment room week newphase; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model In = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=scheffe; 
run;



Title'Frequency of Ea';


/*STEP 1 Covariance structure*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Ea = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Ea = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Ea = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room);    
run;
/*cs had the best BIC*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Ea = treatment species room newphase week(newphase)  treatment*newphase   / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
/*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W normal; graph looks normal*/

/*STEP 3 Stats*/ 

proc sort data=scans1;
by treatment room week newphase; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Ea = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=scheffe; 
run;


Title'Frequency of NV';


/*STEP 1 Covariance structure*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model NV = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model NV = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model NV = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room);    
run;
/*cs had the best BIC*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model NV = treatment species room newphase week(newphase)  treatment*newphase   / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
/*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W normal; graph looks normal*/

/*STEP 3 Stats*/ 

proc sort data=scans1;
by treatment room week newphase; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model NV = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=scheffe; 
run;



Title'Frequency of Sc';


/*STEP 1 Covariance structure*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Sc = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Sc = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Sc = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room);    
run;
/*cs had the best BIC*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Sc = treatment species room newphase week(newphase)  treatment*newphase   / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
/*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W not normal; graph looks relatively normal - little skewed to the left*/

/*STEP 3 Stats*/ 

proc sort data=scans1;
by treatment room week newphase; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Sc = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=scheffe; 
run;



Title'Frequency of MO';


/*STEP 1 Covariance structure*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model MO = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model MO = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model MO = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room);    
run;
/*ar1 had the best BIC*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model MO = treatment species room newphase week(newphase)  treatment*newphase   / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
/*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W not normal; graph looks normal */

/*STEP 3 Stats*/ 

proc sort data=scans1;
by treatment room week newphase; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model MO = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=scheffe; 
run;



Title'Frequency of Lo';


/*STEP 1 Covariance structure*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Lo = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Lo = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Lo = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room);    
run;
/*cs had the best BIC*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Lo = treatment species room newphase week(newphase)  treatment*newphase   / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
/*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W normal; graph looks normal */

/*STEP 3 Stats*/ 

proc sort data=scans1;
by treatment room week newphase; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Lo = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=scheffe; 
run;


/**************************************************************/


Title'Proportion of Gr';


/*STEP 1 Covariance structure*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Gr__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Gr__ = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Gr__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room);    
run;
/*cs had the best BIC*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Gr__ = treatment species room newphase week(newphase)  treatment*newphase   / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
/*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W not normal; graph looks relatively normal - little skewed to the left */

/*STEP 3 Stats*/ 

proc sort data=scans1;
by treatment room week newphase; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Gr__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=scheffe; 
run;




Title'Proportion of SG';


/*STEP 1 Covariance structure*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model SG__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model SG__ = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model SG__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room);    
run;
/*cs had the best BIC*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model SG__ = treatment species room newphase week(newphase)  treatment*newphase   / s ddfm=kr outpred=normality; /*creates the variables required to test normality*/
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
/*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W not normal; graph looks relatively normal - little skewed to the left */

/*STEP 3 Stats*/ 

proc sort data=scans1;
by treatment room week newphase; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model SG__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=scheffe; 
run;




Title'Proportion of Soc';


/*STEP 1 Covariance structure*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Soc__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Soc__ = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Soc__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room);    
run;
/*cs had the best BIC*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Soc__ = treatment species room newphase week(newphase)  treatment*newphase   / s ddfm=kr outpred=normality; /*creates the variables required to test normality*/
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
/*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W not normal; graph looks relatively normal - little skewed to the left */

/*STEP 3 Stats*/ 

proc sort data=scans1;
by treatment room week newphase; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Soc__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=scheffe; 
run;



Title'Proportion of Ab';


/*STEP 1 Covariance structure*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Ab__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Ab__ = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Ab__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room);    
run;
/*cs had the best BIC*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Ab__ = treatment species room newphase week(newphase)  treatment*newphase   / s ddfm=kr outpred=normality; /*creates the variables required to test normality*/
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
/*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W not normal; graph looks relatively normal */

/*STEP 3 Stats*/ 

proc sort data=scans1;
by treatment room week newphase; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Ab__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=scheffe; 
run;



Title'Proportion of In';


/*STEP 1 Covariance structure*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model In__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model In__ = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model In__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room);    
run;
/*ar1 had the best BIC*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model In__ = treatment species room newphase week(newphase)  treatment*newphase   / s ddfm=kr outpred=normality; /*creates the variables required to test normality*/
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
/*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W normal; graph looks normal */

/*STEP 3 Stats*/ 

proc sort data=scans1;
by treatment room week newphase; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model In__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=scheffe; 
run;



Title'Proportion of Ea';


/*STEP 1 Covariance structure*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Ea__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Ea__ = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Ea__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room);    
run;
/*cs had the best BIC*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Ea__ = treatment species room newphase week(newphase)  treatment*newphase   / s ddfm=kr outpred=normality; /*creates the variables required to test normality*/
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
/*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W normal; graph looks normal */

/*STEP 3 Stats*/ 

proc sort data=scans1;
by treatment room week newphase; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Ea__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=scheffe; 
run;



Title'Proportion of NV';


/*STEP 1 Covariance structure*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model NV__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model NV__ = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model NV__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room);    
run;
/*cs had the best BIC*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model NV__ = treatment species room newphase week(newphase)  treatment*newphase   / s ddfm=kr outpred=normality; /*creates the variables required to test normality*/
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
/*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W normal; graph looks normal */

/*STEP 3 Stats*/ 

proc sort data=scans1;
by treatment room week newphase; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model NV__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=scheffe; 
run;



Title'Proportion of Sc';


/*STEP 1 Covariance structure*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Sc__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Sc__ = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Sc__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room);    
run;
/*cs had the best BIC*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Sc__ = treatment species room newphase week(newphase)  treatment*newphase   / s ddfm=kr outpred=normality; /*creates the variables required to test normality*/
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
/*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W not normal; graph looks skewed to the left */

/*STEP 3 Stats*/ 

proc sort data=scans1;
by treatment room week newphase; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Sc__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=scheffe; 
run;


Title'Proportion of MO';

/*STEP 1 Covariance structure*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model MO__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model MO__ = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model MO__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room);    
run;
/*ar1 had the best BIC*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model MO__ = treatment species room newphase week(newphase)  treatment*newphase   / s ddfm=kr outpred=normality; /*creates the variables required to test normality*/
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
/*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W not normal; graph looks relatively normal */

/*STEP 3 Stats*/ 

proc sort data=scans1;
by treatment room week newphase; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model MO__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=scheffe; 
run;



Title'Proportion of Lo';

/*STEP 1 Covariance structure*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Lo__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /** for type=cs, drop random factor from model */   
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Lo__ = treatment species room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
run;

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Lo__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room);    
run;
/*cs had the best BIC*/

/*STEP 2 Normality*/ 

/*Test each of your outcome measures for normality*/

proc sort data=scans1;
by treatment room monkey week; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Lo__ = treatment species room newphase week(newphase)  treatment*newphase   / s ddfm=kr outpred=normality; /*creates the variables required to test normality*/
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
/*Do not forget to change the covariance structure type chosen in STEP 1*/    
run;

proc contents data = normality; /*creates the table with the variables required to test normality*/
run;

/*testing normality*/
proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W normal; graph looks normal */

/*STEP 3 Stats*/ 

proc sort data=scans1;
by treatment room week newphase; 
run;

Proc mixed data= scans1 lognote;
Class treatment room monkey newphase week species;
Model Lo__ = treatment species room newphase week(newphase)  treatment*newphase  / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=tukey; 
lsmeans treatment newphase week(newphase)treatment*newphase / pdiff adjust=scheffe; 
run;
