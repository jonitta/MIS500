LIBNAME MEPS "/folders/myfolders/sasuser.v94";                                                                                                                                                                                                                         
FILENAME IN1 '/folders/myfolders/sasuser.v94/h189.ssp';                                                                                                                                                   
PROC XCOPY IN=IN1 OUT=MEPS IMPORT;                                                           
RUN;                                                                                           
           
*set format for the data using sas proc format;  
PROC FORMAT;
  VALUE SEX
     . = 'TOTAL'
     1 = 'MALE'
     2 = 'FEMALE'
       ;
  VALUE YESNO
     . = 'TOTAL'
     1 = 'YES'
     2 = 'NO'
       ;
RUN;

*Summary Analysis;

proc format;
value fsa
1="Often true"
2="Somtimes true"
3="Never true"
;
proc format;
value yesno
1="Yes"
2="No"
;
*how often balance meal is not affordable;
proc freq data=MEPS.H189;
        tables FSAFRD42;
        where FSAFRD42= 1 or FSAFRD42=2 or FSAFRD42=3;
        format FSAFRD42 fsa.;
run;

*skip meal summary statistics;
proc freq data=MEPS.H189;
        tables FSSKIP42;
        where FSSKIP42= 1 or FSSKIP42=2;
        format FSSKIP42 yesno.;
run;

*How many days were skip meals;
proc means data=Meps.h189 mean std min max;
var FSSKDY42;
where FSSKDY42>0;
run;

*Ever eat less;
proc freq data=MEPS.H189;
        tables FSLESS42;
        where FSLESS42= 1 or FSLESS42=2;
        format FSLESS42 yesno.;
run;

*Ever go hungry;
proc freq data=MEPS.H189;
        tables FSHGRY42;
        where FSHGRY42= 1 or FSHGRY42=2;
        format FSHGRY42 yesno.;
run;

*Low food money cause weight loss;
proc freq data=MEPS.H189;
        tables FSWTLS42;
        where FSWTLS42= 1 or FSWTLS42=2;
        format FSWTLS42 yesno.;
run;

*How many days you did not eat;
proc means data=Meps.h189 mean std min max;
var FSNEDY42;
where FSNEDY42>0;
run;

*Paired t-test;
proc ttest data=MEPS.h189 sides=2 h0=0 plots(showh0);
        paired FSSKDY42*FSNEDY42;
        where FSNEDY42>0 and FSSKDY42>0;
run;

*Two sample t-test;
proc ttest data=MEPS.H189 sides=2 h0=0 plots(showh0);
        class FSHGRY42;
        var FSNEDY42;
        where FSNEDY42>0 and FSHGRY42>0;
        format FSHGRY42 yesno.;
run;


