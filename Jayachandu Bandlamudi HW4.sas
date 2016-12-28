* Stat -448 : Home work -4 ;
* NetID: bandlmd2 , Name: Jayachandu Bandlamudi;

ods rtf file='C:\Stat 448\Jayachandu Bandlamudi HW4.rtf' ;
 
*Exercise-1;
proc import datafile="C:\Stat 448\Indian Liver Patient Dataset (ILPD).csv"
	out= liver
	dbms = csv
	replace;
	getnames=no;
run;
/* after importing, rename the variables to match the data description */
data liver;
	set liver;
	Age=VAR1; Gender=VAR2; TB=VAR3;	DB=VAR4; Alkphos=VAR5;
	Alamine=VAR6; Aspartate=VAR7; TP=VAR8; ALB=VAR9; AGRatio=VAR10;
	if VAR11=1 then LiverPatient='Yes';
		Else LiverPatient='No';
	drop VAR1--VAR11;
run;
* now only keep the adult observations;
data liver;
	set liver;
	where age>17;
run;
title 'Exercise-1-a';
data liver_female;
     set liver;
     where Gender="Female";
run;
data liver_male ;
     set liver;
     where Gender="Male";
run;
 
*Back ward model selection;   
proc logistic data=liver_female;
  model LiverPatient=Age TB DB Alkphos Alamine Aspartate TP ALB AGRatio/selection=backward iplots;
  output out=liver_female Cbar= cbar;
  ods select ModelBuildingSummary;;
run;
ods text="For this part we will consider only female observations, and we used backward selection
for choosing the best set of predictors.From the above table for backward elimination summary we removed
all the variables except 'Aspartate' which is significant considering 0.05 as significance level.
Also from the Influence Diagnostic panel, 'Cbar' measure plot we observe few influential points so we remove 
one observation that is most influential.At first we removed observation which has 'Cbar' measure greater 
than 0.15 and we calculated the 'Cbar' measure again for the remaining observations.And for the second time
we removed observation that has 'Cbar' greater than 0.10,similarly during the third time we removed the observation
that has 'Cbar' greater than 0.05.So we removed three most influential observations that have high 'Cbar'
measure.";  
*removing above 0.15;
proc logistic data=liver_female noprint;
  model LiverPatient=Aspartate/iplots;
  where cbar < 0.15;
  output out=liver_female Cbar= cbar;
  *ods exclude ModelInfo GlobalTests;
run;

*removing above 0.10;
proc logistic data=liver_female noprint;
  model LiverPatient=Aspartate /iplots;
  where cbar2 < 0.10;
  output out=liver_female Cbar= cbar;
  *ods exclude ModelInfo GlobalTests;
run;
*removing above 0.05;
proc logistic data=liver_female noprint;
  model LiverPatient= Aspartate /iplots;
  where cbar3 < 0.05;
  output out=liver_female Cbar= cbar;
  *ods exclude ModelInfo GlobalTests;
run;

*best set after removing influential points;
proc logistic data=liver_female;
  model LiverPatient=Age TB DB Alkphos Alamine Aspartate TP ALB AGRatio/selection=backward iplots;
  *output out=liver_female Cbar= cbar;
  ods select ModelBuildingSummary;
run;

ods text="Now for the best set predictor model, we just have 'Aspartate' as the predictor and we removed
extreme influential points.After removing the influential points we perform best set model selection again 
with all the predictors using backward elimination.Again from backward elimination table for the best set selection 
we just have'Asparate' as the predictor.So we consider the model with just 'Aspartate' as the final model for this case";

title 'Exercise 1.b';
proc logistic data=liver_female plots=influence ;
  model LiverPatient=Aspartate/lackfit iplots;
  ods exclude Globaltests  ModelInfo NObs OddsRatios ResponseProfile ConvergenceStatus;
run;

ods text="From the previous step we have our final model with just 'Asparate' predictor and for this model
it seems we dont have any highly influential points to remove , and for the sigificance of
parameter estimates the 'Aspartate' is significant with p-value 0.0067<0.05 (significance level) ";
ods text="By observing the Hosmer and Lemeshow Goodness-of-Fit Test p-value which is 0.3054>0.05 so we 
have evidence in support of Null Hypothesis(H0: Model fit is okay) against the Alternate hypothesis
(Ha: Model fit is poor and there is lack of fit),so we don't have lack of fit.";
ods text="And from the dignostic plots we observe that the residual plot are flat so we can say that the 
assumed fitted model is correct as well as the variance is constant/flat, so we can assume homoscedastcitiy 
and even the influential points are taken care in the previous steps so there are no remaining diagnostic issues"; 

title 'Exercise 1.c';
proc logistic data=liver_female ;
  model LiverPatient=Aspartate;
  ods select OddsRatios;
run;
ods text="From the odds ratio estimate above the confidence interval of odds ratio for 'Aspartate' does not
inlcude 'one' so it is significant .But the odds ratio estimate is close to 1 which means P(NO)/P(Yes) is equal
to 1 so we can say that the probability of an adult female being a liver patient is approximately equal 
to probability of not being a liver patient, P(Yes) is slightly higher";




title 'Exercise-2.a';
*Back ward model selection;   
proc logistic data=liver_male;
  model LiverPatient=Age TB DB Alkphos Alamine Aspartate TP ALB AGRatio/selection=backward iplots;
  output out=liver_male Cbar= cbar;
  ods select ModelBuildingSummary;
run;
  
*removing above 0.6;
proc logistic data=liver_male noprint;
  model LiverPatient=Age DB Alamine TP ALB /iplots;
  where cbar < 0.6;
  output out=liver_male Cbar= cbar;
  ods exclude ModelInfo GlobalTests;
run;

*removing above 0.30;
proc logistic data=liver_male noprint;
  model LiverPatient=Age DB Alamine TP ALB /iplots;
  where cbar2 < 0.30;
  output out=liver_male Cbar= cbar;
  ods exclude ModelInfo GlobalTests;
run;
*removing above 0.31;
proc logistic data=liver_male noprint;
  model LiverPatient=Age DB Alamine TP ALB /iplots;
  where cbar3 < 0.31;
  output out=liver_male Cbar= cbar;
 run;

ods text="For this part we will consider only male observations, and similar to previous excercise
we used backward selection for choosing the best set of predictors.From the above table for backward elimination 
summary we removed four variables which are indicated in the table above,now the model has five variables
as follows 'Age','DB','Alamine','TP','ALB' by considering 0.05 as significance level.Now we will check
for the highly influential points like before and we remove one observation at a time based on 'Cbar' measure.
At first we removed observation which has 'Cbar' measure greater than 0.6 and we calculated the 'Cbar' measure 
again for the remaining observations.And for the second time we removed observation that has 'Cbar' greater than
 0.30,similarly during the third time we removed the observation that has 'Cbar' greater than 0.31.
So we removed three most influential observations that has high 'Cbar' measure.";

*best set after removing influential points;
proc logistic data=liver_male;
  model LiverPatient=Age TB DB Alkphos Alamine Aspartate TP ALB AGRatio/selection=backward iplots;
  *output out=liver_male Cbar= cbar;
  ods select ModelBuildingSummary;
run;
 
ods text="From previous part we have removed extreme influential points .After removing the influential 
points we perform best set model selection again with all the predictors using backward elimination.And 
this time backward selection removed different set of variables as shown in the table above
So the model now has four varaibales 'Age','DB','Alkphos','Alamine' as the predictors and this 
is the final model"; 

title 'Excercise-2.b';
*refit after removing the backward elimination;
proc logistic data=liver_male noprint;
  model LiverPatient=Age DB Alkphos Alamine/lackfit iplots;
  output out=liver_male Cbar= cbar;
  ods exclude ModelInfo GlobalTests;
run;
* removing points above 0.3;
proc logistic data=liver_male noprint;
  model LiverPatient=Age DB Alkphos Alamine/lackfit iplots;
  where cbar5 < 0.3;
  output out=liver_male Cbar= cbar;
  ods exclude ModelInfo GlobalTests;
run;
proc logistic data=liver_male noprint;
  model LiverPatient=Age DB Alkphos Alamine/lackfit iplots;
  where cbar6 < 0.3;
  output out=liver_male Cbar= cbar;
  ods exclude ModelInfo GlobalTests;
run;


proc logistic data=liver_male plots=influence ;
  model LiverPatient=Age DB Alkphos Alamine/lackfit iplots;
  ods exclude Globaltests  ModelInfo NObs OddsRatios ResponseProfile ConvergenceStatus;
run;

ods text="From the previous part we have the final model, by looking at the influence diagnostics
we observe few extreme influential points.So we consider the removing the influential points one 
at a time that is most influential.At first we remove observation that has 'Cbar' measure
greater than 0.3 and we find 'Cbar' measure for the remaiing observtaions.
And for the second time we removed observation that has 'Cbar' greater than
0.3, after this there seems no highly influential points.So we removed two most influential 
observations that has high 'Cbar' measure for the final model.";

ods text="From the paramter estimates table considering 0.05 significance level, variables
'Age','DB','Alkpho','Alamine' are significant in the model beacuse all these variables have the p-values 
less than 0.05";
ods text="Also from the table for Hosmer and Lemeshow Goodness-of-Fit Test p-value which is 0.9487>0.05 
so we have strong evidence in support of Null Hypothesis(H0: Model fit is okay) against the Alternate hypothesis
(Ha: Model fit is poor and there is lack of fit),so we conclude no lack of fit.";
ods text="And there are no issues with dianostics plots and the fitted mean model is good and constant 
variance assumption holds good by looking at the residual plots";

title 'Exercise-2.c';
proc logistic data=liver_male ;
  model LiverPatient=Age DB Alkphos Alamine;
  ods select OddsRatios;
run;

ods text="By looking at the odds ratio table for the predictors we observe that for none of
variables the confidence interval includes 'one' so the odds ratios are significant for every predictor. But
for variables 'Age','Alphos','Alamine' odds ratio is close to one which means P(NO)/P(Yes) is equal to '1'
so the probability that an adult male being liver patient and not being a liver patient are approximately same.
,P(Yes) is slightly higher .Where as based on predictor 'DB' the odds ratio is close to 0.5 so P(No)/P(Yes) is 
equal to 0.5 which means the probability of an adult male being a liver patient is twice the probablitiy of not being 
a liver patient";

ods text="For excercise-1 we considered only female observations and in exercise-2 we have
only male observations.And the final models in both cases are different from each other, in
case of female observations 'Aspartate' is the only predictor that is significant in predicting
the 'Liverpatient'.Where-as in case of male observations four predictors 'Age','Alphos','Alamine',
and 'DB' are significant in the final model.Also both the genders does not have any common predictors 
that are significant for predicting 'LiverPatient'.";



*Excercise-3;
data bupa;
	infile "C:\Stat 448\bupa.data" dlm="," missover;
	input mcv alkphos sgpt sgot gammagt drinks selector;
	four_oz = drinks*2;
	keep mcv alkphos sgot gammagt four_oz;
run;

title 'Exercise-3.a';

proc genmod data=bupa;
  model four_oz=mcv sgot gammagt alkphos / dist=gamma 
		link=log type1 type3;
  ods select Type1 Type3;
run;

ods text="At first we have four varaibles 'mcv','sgot','gammagt','alkphos' in the model, and
we consider type1,type3 analysis for the best set selection.By looking at the table above
we observe that 'alkphos' is the variable is the most insignificant variable in the model
with p-value 0.6639 >0.05 significance level.So by considering type3 analysis we remove
'alkphos' from the model and do the best set selection again and considering type 1 analysis
by ordering the variables we observe that 'alkphos' has the p-value 0.6639 >0.05 so we remove this
variable from the model.";
* remove alkphos;
proc genmod data=bupa;
  model four_oz=mcv sgot gammagt/ dist=gamma 
		link=log type1 type3;
  ods select Type1 Type3;
run;
ods text="After removing 'alkphos' from the model we observe from the above tables that
three variables 'mcv','sgot','gammagt' are significant with p-values less than 0.05
significance level.So we consider the model with these three predcitors as our best set
final model";

Title 'Exercise-3.b';  
proc genmod data=bupa plots=(stdreschi stdresdev);
  model four_oz=mcv sgot gammagt / dist=gamma 
		link=log type1 type3;
  output out=bupa pred=predval stdreschi=presids	
		stdresdev=dresids;
ods select ParameterEstimates;
run;

ods text=" From the parameter estimate table ,we obsereve that the variables 'mcv','sgot','gammagt'
 are significant because they all have p-value less than 0.05(significane level). 
we interpret parameter estimates such that we have '-3.2055' for the intercept,'0.0512' for 'mcv',
'0.0130' for 'sgot','0.0040' for 'gammagt' and we can write the equaiton as
log(four_oz)=-3.2055+(0.0512*mcv)+(0.0130*sgot)+(0.0040*gammagt).Based on the equation we
say that for constant 'sgot','gammagt' one point increase in 'mcv' will increase the
'four_oz' quantity multiplied by exp(0.0512).Similarly one point increase in 'sgot' keeping the
other variables constant will increase 'four_oz' quantity multiplied by exp(0.0130).And
one point increase in'gammagt' will increase the 'four_oz' quantity multiplied by exp(0.0040).
Since all the parameter estimates in are positive and the increase in any one of the 
parameters will multiply the exp(paramterestimate) times the expected number of four_oz 
drinks consumed.";

proc sgscatter data=bupa;
	compare y= (presids dresids) x=predval;
run;
proc sgscatter data=bupa;
	compare y= (presids dresids) x=predval;
	where predval<25;
run;
ods text="By looking at First set of residual plots we observe that they are not flat and we have few extreme predicted
values so we remove them .And second set of residual plots are after removing extreme ponits ,now the plots
are flat so the assumed logit link function and gamma distribution are okay for the fit but we still 
have problem with the constant variance is not reasonable"; 


Title 'Exercise-4.a';

proc genmod data=bupa;
  model four_oz=mcv alkphos sgot gammagt / dist=poisson 
		link=log type1 type3;
  ods select ModelFit;
run;
ods text= "Now we will work on poisson loglinear model,and similar to exercise-3 intially we have four
variables 'mcv','alkphos','sgot' and 'gammagt' in our model.And we use type-1,type-3 analysis to choose
best set of predictor variables.But if we observe the Model fit table above we have scale deviance(5.0175)
 measure high so we need to scale the deviance before proceeding with type-1,type-3 analysis";

proc genmod data=bupa ;
  model four_oz= mcv  gammagt sgot alkphos / dist=poisson 
		link=log type1 type3 scale=deviance;
  ods select ModelFit Type1 Type3;
run;
proc genmod data=bupa ;
  model four_oz=mcv sgot gammagt / dist=poisson 
		link=log type1 type3 scale=deviance;
  ods select none;
run;
proc genmod data=bupa;
  model four_oz=mcv gammagt / dist=poisson 
		link=log type1 type3 scale=deviance;
  ods select Type1 Type3;
run;
ods text="IN this step we have scaled the deviance measure, and from the Type-1,Type-3 analysis tables above
we observe that 'alkphos' is the most in-significant varaible with p-value (0.244)>0.05 so we remove it and 
do best set selection again.For the second time we remove variable 'sgot' because it has p-value (0.112)>0.05
and do best set selection one more time.Now we just have'mcv' and 'gammagt' in the model and both the 
variables are significant considering the 0.05 level.So we have two varibales 'mcv','gammagt' in the final model";

Title 'Exercise-4.b';
 proc genmod data=bupa plots=(stdreschi stdresdev);
  model four_oz=mcv gammagt / dist=poisson 
		link=log type1 type3;
  output out=bupa pred=predval1 stdreschi=presids1	
		stdresdev=dresids1;
	ods select ParameterEstimates ;
 run;
ods text=" From the parameter estimate table ,we obsereve that the variables 'mcv','gammagt'
 are significant because they all have p-value less than 0.05(significane level). 
we interpret parameter estimates such that we have '-3.3887' for the intercept,'0.0564' for 'mcv',
'0.0045' for 'gammagt' and we can write the equaiton as
log(four_oz)=-3.3887+(0.0564*mcv)+(0.0045*gammagt).Based on the equation we
say that for constant 'gammagt' one point increase in 'mcv' will increase the
'four_oz' quantity multiplied by exp(0.0564).Similarly one point increase in 'gammagt' keeping the
other variables constant will increase 'four_oz' quantity multiplied by exp(0.0045).So increase in any 
one of the parameter will multiply expected number of four_oz 
drinks consumed with a factor of exp(paramterestimate) times.";

proc sgscatter data=bupa;
	compare y= (presids1 dresids1) x=predval1;
run;
proc sgscatter data=bupa;
	compare y= (presids1 dresids1) x=predval1;
	where predval1<25;
run;

ods text="Similar to the residuals analysis in exercise-3 ,and by looking at First set of residual plots we observe that they 
are flat and we have few extreme predicted values so we remove them.And second set of residual plots are after removing 
extreme ponits ,now the plots  flat so the assumed logit link function and poisson distribution are okay 
also in this case the constant variance assumption is okay"; 
ods text=" Now we compare two models with distributions gamma,poisson. The model with poisson model is a
good choice becasue from the residual plots for both poisson distribution fits the data better and even the 
constant variance assumption is resonable for the fit but for gamma distribution the constant variance assumption
is not okay";


ods rtf close;
















