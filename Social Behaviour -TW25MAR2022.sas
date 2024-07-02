/*import data from excel*/

PROC IMPORT DATAFILE="C:\Users\rache\Desktop\Lab backups\Results\Weekly Videos\Pivots\Pivot Table -Weekly Video -Behavioural Contexts_RV23AUG2021_RV03MAR2022.xlsx"
DBMS=xlsx
OUT=bcons;
SHEET='Data';
run;

PROC PRINT DATA=bcons;
run;
/*We must first reorganize the data. period must become numerical and weeks must be chronological continuously 
for sorting purposes*/

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

Title 'Frequency of Affiliative Behaviour';

/*Step 1: covariance structure*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_Affil = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_Affil = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);       
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_Affil = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*ar(1) had the best BIC*/


/*Step 2: Normality*/

proc sort data=bcon2;
by treatment room monkey week; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_Affil = treatment Species Room newphase week(newphase)  treatment*newphase  / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Random monkey(treatment room species);
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
/*W not normal, hist looks relatively normal*/


/*Step 3: significance*/

proc sort data=bcon2;
by treatment room week newphase; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_Affil = treatment Species Room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);    
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;


Title 'Duration of Affiliative Behaviour -one effect removed';

/*Step 1: covariance structure*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__Affil = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__Affil = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);       
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__Affil = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*cs had the best BIC*/


/*Step 2: Normality*/

proc sort data=bcon2;
by treatment room monkey week; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__Affil = treatment Species Room newphase week(newphase)  treatment*newphase  / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
*Random monkey(treatment room species);
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
/*W not normal, hist looks relatively normal*/


/*Step 3: significance*/

proc sort data=bcon2;
by treatment room week newphase; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__Affil = treatment Species Room newphase week(newphase)  treatment*newphase / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);     
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;


Title 'Proportion of Affiliative behaviours -one effect removed';

/*Step 1: covariance structure*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Affil_ = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Affil_ = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);       
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Affil_ = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*cs had the best BIC*/


/*Step 2: Normality*/

proc sort data=bcon2;
by treatment room monkey week; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Affil_ = treatment Species Room newphase week(newphase)  treatment*newphase  / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
*Random monkey(treatment room species);
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
/*W not normal, hist looks skewed to the left*/


/*Step 3: significance*/

proc sort data=bcon2;
by treatment room week newphase; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Affil_ = treatment Species Room newphase week(newphase)  treatment*newphase / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);     
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;


Title 'Frequency of Aggressive Behaviour -one effect removed';


/*Step 1: covariance structure*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_Ag = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_Ag = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);       
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_Ag = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*cs had the best BIC*/


/*Step 2: Normality*/

proc sort data=bcon2;
by treatment room monkey week; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_Ag = treatment Species Room newphase week(newphase)  treatment*newphase  / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
*Random monkey(treatment room species);
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
/*W not normal, hist looks normal*/


/*Step 3: significance*/

proc sort data=bcon2;
by treatment room week newphase; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_Ag = treatment Species Room newphase week(newphase)  treatment*newphase / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);     
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;


Title 'Duration of Aggressive behaviour -one effect removed';


/*Step 1: covariance structure*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__Ag = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__Ag = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);       
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__Ag = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*cs had the best BIC*/


/*Step 2: Normality*/

proc sort data=bcon2;
by treatment room monkey week; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__Ag = treatment Species Room newphase week(newphase)  treatment*newphase  / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
*Random monkey(treatment room species);
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
/*W not normal, hist looks relatively normal*/


/*Step 3: significance*/

proc sort data=bcon2;
by treatment room week newphase; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__Ag = treatment Species Room newphase week(newphase)  treatment*newphase / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);     
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;


Title 'Proportiong of Aggressive behaviour -one effect removed';

/*Step 1: covariance structure*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Ag_ = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Ag_ = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);       
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Ag_ = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*cs had the best BIC*/


/*Step 2: Normality*/

proc sort data=bcon2;
by treatment room monkey week; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Ag_ = treatment Species Room newphase week(newphase)  treatment*newphase  / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
*Random monkey(treatment room species);
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
/*W not normal, hist looks relatively normal*/


/*Step 3: significance*/

proc sort data=bcon2;
by treatment room week newphase; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Ag_ = treatment Species Room newphase week(newphase)  treatment*newphase / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);     
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;

Title 'Frequency of Submissive Behaviour -one effect removed';

/*Step 1: covariance structure*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_Sub = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_Sub = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);       
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_Sub = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*cs had the best BIC*/


/*Step 2: Normality*/

proc sort data=bcon2;
by treatment room monkey week; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_Sub = treatment Species Room newphase week(newphase)  treatment*newphase  / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
*Random monkey(treatment room species);
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
/*W not normal, hist looks relatively normal*/


/*Step 3: significance*/

proc sort data=bcon2;
by treatment room week newphase; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_Sub = treatment Species Room newphase week(newphase)  treatment*newphase / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species);     
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;

Title 'Duration of Submissive Behaviour -one effect removed';

/*Step 1: covariance structure*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__Sub = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__Sub = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);       
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__Sub = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*ar1 had the best BIC*/


/*Step 2: Normality*/

proc sort data=bcon2;
by treatment room monkey week; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__Sub = treatment Species Room newphase week(newphase)  treatment*newphase  / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Random monkey(treatment room species);
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
/*W not normal, hist looks relatively normal*/


/*Step 3: significance*/

proc sort data=bcon2;
by treatment room week newphase; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__Sub = treatment Species Room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;


Title 'Proportion of Submissive Behaviour -one interaction removed';

/*Step 1: covariance structure*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Sub_ = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Sub_ = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);       
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Sub_ = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*ar1 had the best BIC*/


/*Step 2: Normality*/

proc sort data=bcon2;
by treatment room monkey week; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Sub_ = treatment Species Room newphase week(newphase)  treatment*newphase  / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Random monkey(treatment room species);
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
/*W not normal, hist looks relatively normal*/


/*Step 3: significance*/

proc sort data=bcon2;
by treatment room week newphase; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Sub_ = treatment Species Room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;


Title 'Frequency of Grooming behaviour -one effect removed';

/*Step 1: covariance structure*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_Gr = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_Gr = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);       
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_Gr = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*cs had the best BIC*/


/*Step 2: Normality*/

proc sort data=bcon2;
by treatment room monkey week; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_Gr = treatment Species Room newphase week(newphase)  treatment*newphase  / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
*Random monkey(treatment room species);
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
/*W not normal, hist looks normal*/


/*Step 3: significance*/

proc sort data=bcon2;
by treatment room week newphase; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Fre_Gr = treatment Species Room newphase week(newphase)  treatment*newphase / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;


Title 'Duration of Grooming Behaviour -one effect removed';

/*Step 1: covariance structure*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__Gr = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__Gr = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);       
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__Gr = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*cs had the best BIC*/


/*Step 2: Normality*/

proc sort data=bcon2;
by treatment room monkey week; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__Gr = treatment Species Room newphase week(newphase)  treatment*newphase  / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
*Random monkey(treatment room species);
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
/*W not normal, hist looks normal*/


/*Step 3: significance*/

proc sort data=bcon2;
by treatment room week newphase; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds__Gr = treatment Species Room newphase week(newphase)  treatment*newphase / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;


Title 'Proportion of Grooming behaviour -one effect removed';

/*Step 1: covariance structure*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Gr_ = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Gr_ = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);       
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Gr_ = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*cs had the best BIC*/


/*Step 2: Normality*/

proc sort data=bcon2;
by treatment room monkey week; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Gr_ = treatment Species Room newphase week(newphase)  treatment*newphase  / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
*Random monkey(treatment room species);
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
/*W not normal, hist looks normal*/


/*Step 3: significance*/

proc sort data=bcon2;
by treatment room week newphase; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Gr_ = treatment Species Room newphase week(newphase)  treatment*newphase / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;



Title 'Frequency of Positive Behaviour -one effect';

/*Step 1: covariance structure*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model FRE_POS = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model FRE_POS = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);       
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model FRE_POS = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*ar1 had the best BIC*/


/*Step 2: Normality*/

proc sort data=bcon2;
by treatment room monkey week; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model FRE_POS = treatment Species Room newphase week(newphase)  treatment*newphase  / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Random monkey(treatment room species);
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
/*W normal, hist looks normal*/


/*Step 3: significance*/

proc sort data=bcon2;
by treatment room week newphase; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model FRE_POS = treatment Species Room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;


Title 'Duration of Positive Behaviour -one effect';

/*Step 1: covariance structure*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds_POS = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds_POS = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);       
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds_POS = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*cs had the best BIC*/


/*Step 2: Normality*/

proc sort data=bcon2;
by treatment room monkey week; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds_POS = treatment Species Room newphase week(newphase)  treatment*newphase  / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
*Random monkey(treatment room species);
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
/*W not normal, hist looks normal*/


/*Step 3: significance*/

proc sort data=bcon2;
by treatment room week newphase; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds_POS = treatment Species Room newphase week(newphase)  treatment*newphase / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;

Title 'Proportion of Positive Behaviour -one effect';

/*Step 1: covariance structure*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model POS_ = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model POS_ = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);       
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model POS_ = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*cs had the best BIC*/


/*Step 2: Normality*/

proc sort data=bcon2;
by treatment room monkey week; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model POS_ = treatment Species Room newphase week(newphase)  treatment*newphase  / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
*Random monkey(treatment room species);
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
/*W not normal, hist looks normal*/


/*Step 3: significance*/

proc sort data=bcon2;
by treatment room week newphase; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model POS_ = treatment Species Room newphase week(newphase)  treatment*newphase / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;


Title 'Frequency of Negative Behaviour -one effect';

/*Step 1: covariance structure*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model FRE_NEG = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model FRE_NEG = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);       
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model FRE_NEG = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*cs had the best BIC*/


/*Step 2: Normality*/

proc sort data=bcon2;
by treatment room monkey week; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model FRE_NEG = treatment Species Room newphase week(newphase)  treatment*newphase  / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
*Random monkey(treatment room species);
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
/*W normal, hist looks normal*/


/*Step 3: significance*/

proc sort data=bcon2;
by treatment room week newphase; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model FRE_NEG = treatment Species Room newphase week(newphase)  treatment*newphase / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;


Title 'Duration of Negative Behaviour -one effect';

/*Step 1: covariance structure*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds_NEG = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds_NEG = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);       
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds_NEG = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*cs had the best BIC*/


/*Step 2: Normality*/

proc sort data=bcon2;
by treatment room monkey week; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds_NEG = treatment Species Room newphase week(newphase)  treatment*newphase  / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
*Random monkey(treatment room species);
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
/*W not normal, hist looks relatively normal*/


/*Step 3: significance*/

proc sort data=bcon2;
by treatment room week newphase; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Seconds_NEG = treatment Species Room newphase week(newphase)  treatment*newphase / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;


Title 'Proportion of Negative Behaviour -one effect';

/*Step 1: covariance structure*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model NEG_ = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model NEG_ = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);       
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model NEG_ = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*cs had the best BIC*/


/*Step 2: Normality*/

proc sort data=bcon2;
by treatment room monkey week; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model NEG_ = treatment Species Room newphase week(newphase)  treatment*newphase  / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
*Random monkey(treatment room species);
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
/*W not normal, hist looks normal*/


/*Step 3: significance*/

proc sort data=bcon2;
by treatment room week newphase; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model NEG_ = treatment Species Room newphase week(newphase)  treatment*newphase / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;


Title 'Social Proportion of Affiliative Behaviour -one effect';

/*Step 1: covariance structure*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_Affil = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_Affil = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);       
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_Affil = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*ar1 had the best BIC*/


/*Step 2: Normality*/

proc sort data=bcon2;
by treatment room monkey week; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_Affil = treatment Species Room newphase week(newphase)  treatment*newphase  / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Random monkey(treatment room species);
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
/*W normal, hist looks normal*/


/*Step 3: significance*/

proc sort data=bcon2;
by treatment room week newphase; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_Affil = treatment Species Room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;

Title 'Social Proportion of Aggressive Behaviour -one effect'; 

/*Step 1: covariance structure*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_Ag = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_Ag = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);       
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_Ag = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*cs had the best BIC*/


/*Step 2: Normality*/

proc sort data=bcon2;
by treatment room monkey week; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_Ag = treatment Species Room newphase week(newphase)  treatment*newphase  / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
*Random monkey(treatment room species);
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
/*W not normal, hist looks normal*/


/*Step 3: significance*/

proc sort data=bcon2;
by treatment room week newphase; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_Ag = treatment Species Room newphase week(newphase)  treatment*newphase / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;

Title 'Social Proportion of Submissive Behaviour -one effect';

/*Step 1: covariance structure*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_Sub = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_Sub = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);       
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_Sub = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*cs had the best BIC*/


/*Step 2: Normality*/

proc sort data=bcon2;
by treatment room monkey week; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_Sub = treatment Species Room newphase week(newphase)  treatment*newphase  / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
*Random monkey(treatment room species);
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
/*W not normal, hist looks normal*/


/*Step 3: significance*/

proc sort data=bcon2;
by treatment room week newphase; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_Sub = treatment Species Room newphase week(newphase)  treatment*newphase / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;

Title 'Social Proportion of Grooming Behaviour -one effect';

/*Step 1: covariance structure*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_Gr  = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_Gr  = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);       
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_Gr  = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*ar1 had the best BIC*/


/*Step 2: Normality*/

proc sort data=bcon2;
by treatment room monkey week; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_Gr  = treatment Species Room newphase week(newphase)  treatment*newphase  / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
Random monkey(treatment room species);
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
/*W normal, hist looks normal*/


/*Step 3: significance*/

proc sort data=bcon2;
by treatment room week newphase; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_Gr  = treatment Species Room newphase week(newphase)  treatment*newphase / s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;

Title 'Social Proportion of Positive Behaviour -one effect'; 

/*Step 1: covariance structure*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_POS  = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_POS  = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);       
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_POS  = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*cs had the best BIC*/


/*Step 2: Normality*/

proc sort data=bcon2;
by treatment room monkey week; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_POS  = treatment Species Room newphase week(newphase)  treatment*newphase  / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
*Random monkey(treatment room species);
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
/*W normal, hist looks normal*/


/*Step 3: significance*/

proc sort data=bcon2;
by treatment room week newphase; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_POS  = treatment Species Room newphase week(newphase)  treatment*newphase / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;

Title 'Social Proportion of Negative Behaviour -one effect';

/*Step 1: covariance structure*/

proc sort data=bcon2;
by treatment room monkey week;  
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_NEG  = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Repeated week(newphase) /type=cs subject=monkey(treatment room species); 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_NEG  = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=ar(1) subject=monkey(treatment room species);       
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_NEG  = Treatment Species Room newphase week(newphase)  treatment*newphase/ s ddfm=kr;
Random monkey(treatment room species);
Repeated week(newphase) /type=un subject=monkey(treatment room species);    
run;
/*cs had the best BIC*/


/*Step 2: Normality*/

proc sort data=bcon2;
by treatment room monkey week; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_NEG  = treatment Species Room newphase week(newphase)  treatment*newphase  / s ddfm=kr outpred=normality; /*creates the variables 
required to test normality*/
*Random monkey(treatment room species);
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
/*W normal, hist looks normal*/


/*Step 3: significance*/

proc sort data=bcon2;
by treatment room week newphase; 
run;

Proc mixed data= bcon2 lognote;
Class treatment room monkey newphase week species;
Model Soc_NEG  = treatment Species Room newphase week(newphase)  treatment*newphase / s ddfm=kr;
*Random monkey(treatment room species);
Repeated week(newphase) /type=cs subject=monkey(treatment room species); /*Do not forget to change the covariance structure type chosen in STEP 1*/    
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Tukey;
lsmeans treatment newphase week(newphase) treatment*newphase / pdiff adjust=Scheffe;
run;
