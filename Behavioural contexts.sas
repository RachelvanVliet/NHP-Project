/*import data from excel*/

PROC IMPORT DATAFILE="C:\Users\rache\Desktop\Lab backups\Results\Weekly Videos\Pivots\Pivot Table -Weekly Video -Behavioural Contexts_RV23AUG2021_RV03MAR2022.xlsx"
DBMS=xlsx
OUT=bcons;
SHEET='Data';
run;

PROC PRINT DATA=bcons;
run;
/*We must first reorganize the data. period must become numerical and weeks must be chronological continuously for sorting purposes*/

/*data bcon1;
set bcons;
newweek = week;
if phase = 'PRE' then newweek = week;
if phase = 'EXP' then newweek = 3 + week;
if phase = 'POST' then newweek = 6 + week;
run;

proc print data = bcon1;
run;*/

data bcon2;
set bcons;
newphase = phase;
if phase = 'PRE' then newphase = 1;
if phase = 'EXP' then newphase = 2;
if phase = 'POST' then newphase = 3;
run;

proc print data = bcon2;
run;

/*We will begin by looking at Abnormal Behaviour -freq, duration, proportion*/

/*first we will test the covariance structure of the model -looking at abnormal behaviour first -freq*/

Title 'Frequency of Abnormal Behaviour';

/*covariance*/

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_AB = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

/*test ar(1) */

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_AB = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
repeated week(newphase)/type=ar(1) subject=monkey(treatment room species);
run;

/* test un*/

proc mixed data=bcon2 lognote;
class Treatment Room Monkey newphase week Species;
model Fre_AB= Treatment Species Room newphase week(newphase) treatment*newphase/ s 
ddfm=kr;
random monkey(treatment room species);
repeated week(newphase)/type=un subject=monkey(treatment room species);
run;
/*cs had best BIC*/ 

/*Step 2: normality*/ 

proc sort data=bcon2;
by treatment room monkey week;  
run;


Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_AB = treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr outpred=normality; /*creates the variables  required to test normality*/
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

proc contents data=normality;
run;

proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W normal; hist looks normal*/

/*step 3: statistical tests*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_AB = treatment Species Room newphase week(newphase) treatment*newphase/ s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;


Title 'Duration of Abnormal behaviour -one effect removed';

/*covariance*/

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__AB = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

/*test ar(1) */

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__AB = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
repeated week(newphase)/type=ar(1) subject=monkey(treatment room species);
run;

/* test un*/

proc mixed data=bcon2 lognote;
class Treatment Room Monkey newphase week Species;
model Seconds__AB= Treatment Species Room newphase week(newphase) treatment*newphase/ s ddfm=kr;
random monkey(treatment room species);
repeated week(newphase)/type=un subject=monkey(treatment room species);
run;
/*cs had best BIC*/ 

/*Step 2: normality*/ 

proc sort data=bcon2;
by treatment room monkey week;  
run;


Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__AB = treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr outpred=normality; /*creates the variables  required to test normality*/
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

proc contents data=normality;
run;

proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W not normal; hist looks normal*/

/*step 3: statistical tests*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__AB = treatment Species Room newphase week(newphase) treatment*newphase/ s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;

Title 'Proportion of Abnormal behaviour -one effect removed';

/*covariance*/

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model AB_ = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

/*test ar(1) */

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model AB_ = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
repeated week(newphase)/type=ar(1) subject=monkey(treatment room species);
run;

/* test un*/

proc mixed data=bcon2 lognote;
class Treatment Room Monkey newphase week Species;
model AB_= Treatment Species Room newphase week(newphase) treatment*newphase/ s ddfm=kr;
random monkey(treatment room species);
repeated week(newphase)/type=un subject=monkey(treatment room species);
run;
/*cs had best BIC*/ 

/*Step 2: normality*/ 

proc sort data=bcon2;
by treatment room monkey week;  
run;


Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model AB_ = treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr outpred=normality; /*creates the variables  required to test normality*/
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

proc contents data=normality;
run;

proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W not normal; hist looks normal*/

/*step 3: statistical tests*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model AB_ = treatment Species Room newphase week(newphase) treatment*newphase/ s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;

Title 'Frequency of Self-Grooming behaviour -one effect removed';

/*covariance*/

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_SG = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

/*test ar(1) */

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_SG = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
repeated week(newphase)/type=ar(1) subject=monkey(treatment room species);
run;

/* test un*/

proc mixed data=bcon2 lognote;
class Treatment Room Monkey newphase week Species;
model Fre_SG= Treatment Species Room newphase week(newphase) treatment*newphase/ s ddfm=kr;
random monkey(treatment room species);
repeated week(newphase)/type=un subject=monkey(treatment room species);
run;
/*cs had best BIC*/ 

/*Step 2: normality*/ 

proc sort data=bcon2;
by treatment room monkey week;  
run;


Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_SG = treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr outpred=normality; /*creates the variables  required to test normality*/
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

proc contents data=normality;
run;

proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W not normal; hist looks normal*/

/*step 3: statistical tests*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_SG = treatment Species Room newphase week(newphase) treatment*newphase/ s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;

Title 'Duration of Self-Grooming Behaviour -one effect removed';

/*covariance*/

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__SG = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

/*test ar(1) */

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__SG = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
repeated week(newphase)/type=ar(1) subject=monkey(treatment room species);
run;

/* test un*/

proc mixed data=bcon2 lognote;
class Treatment Room Monkey newphase week Species;
model Seconds__SG= Treatment Species Room newphase week(newphase) treatment*newphase/ s ddfm=kr;
random monkey(treatment room species);
repeated week(newphase)/type=un subject=monkey(treatment room species);
run;
/*cs had best BIC*/ 

/*Step 2: normality*/ 

proc sort data=bcon2;
by treatment room monkey week;  
run;


Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__SG = treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr outpred=normality; /*creates the variables  required to test normality*/
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

proc contents data=normality;
run;

proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W not normal; hist skewed to left*/

/*step 3: statistical tests*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__SG = treatment Species Room newphase week(newphase) treatment*newphase/ s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;

Title 'Proportion of Self-Grooming Behaviour -one effect removed';

/*covariance*/

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model SG_  = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

/*test ar(1) */

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model SG_  = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
repeated week(newphase)/type=ar(1) subject=monkey(treatment room species);
run;

/* test un*/

proc mixed data=bcon2 lognote;
class Treatment Room Monkey newphase week Species;
model SG_ = Treatment Species Room newphase week(newphase) treatment*newphase/ s ddfm=kr;
random monkey(treatment room species);
repeated week(newphase)/type=un subject=monkey(treatment room species);
run;
/*cs had best BIC*/ 

/*Step 2: normality*/ 

proc sort data=bcon2;
by treatment room monkey week;  
run;


Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model SG_  = treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr outpred=normality; /*creates the variables  required to test normality*/
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

proc contents data=normality;
run;

proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W not normal; hist skewed to left*/

/*step 3: statistical tests*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model SG_  = treatment Species Room newphase week(newphase) treatment*newphase/ s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);    
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;

Title 'Frequency of Social Behaviour -one effect';

/*covariance*/

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_Soc   = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

/*test ar(1) */

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_Soc   = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
repeated week(newphase)/type=ar(1) subject=monkey(treatment room species);
run;

/* test un*/

proc mixed data=bcon2 lognote;
class Treatment Room Monkey newphase week Species;
model Fre_Soc  = Treatment Species Room newphase week(newphase) treatment*newphase/ s ddfm=kr;
random monkey(treatment room species);
repeated week(newphase)/type=un subject=monkey(treatment room species);
run;
/*ar1 had best BIC*/ 

/*Step 2: normality*/ 

proc sort data=bcon2;
by treatment room monkey week;  
run;


Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_Soc   = treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr outpred=normality; /*creates the variables  required to test normality*/
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species); 
run;

proc contents data=normality;
run;

proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W normal; hist looks normal*/

/*step 3: statistical tests*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_Soc   = treatment Species Room newphase week(newphase) treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species); 
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;

Title 'Duration of Social Behaviour -one effect';

/*covariance*/

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds_Soc   = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

/*test ar(1) */

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds_Soc   = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
repeated week(newphase)/type=ar(1) subject=monkey(treatment room species);
run;

/* test un*/

proc mixed data=bcon2 lognote;
class Treatment Room Monkey newphase week Species;
model Seconds_Soc  = Treatment Species Room newphase week(newphase) treatment*newphase/ s ddfm=kr;
random monkey(treatment room species);
repeated week(newphase)/type=un subject=monkey(treatment room species);
run;
/*cs had best BIC*/ 

/*Step 2: normality*/ 

proc sort data=bcon2;
by treatment room monkey week;  
run;


Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds_Soc   = treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr outpred=normality; /*creates the variables  required to test normality*/
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

proc contents data=normality;
run;

proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W not normal; hist looks normal*/

/*step 3: statistical tests*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds_Soc   = treatment Species Room newphase week(newphase) treatment*newphase/ s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;

Title 'Proportion of Social Behaviour -one effect';

/*covariance*/

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_    = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

/*test ar(1) */

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_    = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
repeated week(newphase)/type=ar(1) subject=monkey(treatment room species);
run;

/* test un*/

proc mixed data=bcon2 lognote;
class Treatment Room Monkey newphase week Species;
model Soc_   = Treatment Species Room newphase week(newphase) treatment*newphase/ s ddfm=kr;
random monkey(treatment room species);
repeated week(newphase)/type=un subject=monkey(treatment room species);
run;
/*cs had best BIC*/ 

/*Step 2: normality*/ 

proc sort data=bcon2;
by treatment room monkey week;  
run;


Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_    = treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr outpred=normality; /*creates the variables  required to test normality*/
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

proc contents data=normality;
run;

proc univariate data = normality NORMAL; 
var resid;
histogram / normal;
qqplot / normal (mu=est sigma=est);
run;
/*W not normal; hist looks normal*/

/*step 3: statistical tests*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_    = treatment Species Room newphase week(newphase) treatment*newphase/ s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;
