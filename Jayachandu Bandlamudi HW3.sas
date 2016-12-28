* Stat -448 : Home work -3 ;
* NetID: bandlmd2 , Name: Jayachandu Bandlamudi;

ods rtf file='C:\Stat 448\HW3Jayachandu Bandlamudi HW3.rtf' ;
/* The raw data in imports-85.data is from
   http://archive.ics.uci.edu/ml/datasets/Automobile 
   Bache, K. & Lichman, M. (2013). UCI Machine Learning Repository 
   [http://archive.ics.uci.edu/ml]. Irvine, CA: University of California, 
   School of Information and Computer Science.
*/
data imports;
	* modify the file path to match the location of your data files, 
	  then change the path back before submitting your final code;
	length x7 $ 9;
	infile "C:\Stat 448\imports-85.data" dlm="," missover;
	input x1-x2 $ x3 $ x4 $ x5 $ x6 $ x7 $ x8 $ x9 $ x10-x14 x15 $ x16 $ x17 x18 $ x19-x26;
	numdoors = x6;
	bodystyle = x7;
	drivewheels = x8;
	cylinders = x16;
	hp = x22;
	price = x26;
	keep numdoors drivewheels cylinders bodystyle hp price;	
data imports;
	set imports;
	where cylinders in("four", "six") and numdoors in("four", "two")
		and bodystyle in ("sedan", "hatchback")
		and drivewheels ne "4wd";
run;
title Exercise-1.a;
proc glm data=imports;
	class bodystyle cylinders numdoors drivewheels;
	model price = bodystyle cylinders numdoors drivewheels/ ss1 ss3;
	lsmeans bodystyle cylinders numdoors drivewheels/pdiff=all cl;
	ods select OverallANOVA FitStatistics ModelANOVA LSMeans LSMeanDiffCL;
run;

ods text="From the  GLM procedure table ,we observe the F-test statistic as 58.65 and 
corresponding p-value <0.0001 ,so we have evidence in support of Alternate hypothesis
(Ha: consider Main effects model) and reject the Null hypothesis(H0: consider error only model).
Also we have SS1,SS3 type sum of squares tables in the output ,and we can consider the SS3
type and based on the results .'numdoors' variable has the least F-statistic value with 
p-value 0.2443 > 0.05 (significance) level so we have evidence in support of Null hypothesis
(H0:Main effect is not significant) so we can remove the 'numdoors' from the main effects in the
model.And after removing 'numdoors' considering SS3 type sum of squares remaining variables
have significant main effects so we keep them";
ods text="For this four way ANOVA main effects model,in the tables above we have Tukey-kramer
test for mean difference in price for all four categorical variables.The Mean price difference
based on 'bodystyle' is not significant based on the p-value 0.2403,also the confidence interval
of mean difference in price includes 'zero' so mean price difference is not significant.
Similar analysis can be extended to other varaibles, mean difference in price based on
'cylinders' is significant and based on 'numdoors' is not significant and based on 'drivewheels'
is significant.";

title Exercise-1.b;   
proc glm data=imports;
	class bodystyle cylinders drivewheels;
	model price = bodystyle cylinders drivewheels/ ss1 ss3;
	ods select OverallANOVA FitStatistics ModelANOVA;
run;

ods text= "In the previous part we removed 'numdoors' from main effects model because it 
is not significant and after removal the remaining main effects are significant in the model.
The results of the reduced model with 'bodystyle','cylinders','drivewheels' are above,and for
the reduced model we have the F-test statistic as 77.54 and Corresponding p-value <0.0001 ,
so we have evidence in support of Alternate hypothesis(Ha: consider Main effects model) 
and reject the Null hypothesis(H0: consider error only model).Also from the SS3 sum of squares
results we observe all the F-statistic values are significant with p-value >0.05, so we keep
three variables in the main effects model. And this model described 62.7636 percent of variance in price.";


title Exercise-1.c;   
proc glm data=imports;
	class bodystyle cylinders drivewheels;
	model price = bodystyle cylinders drivewheels;
	lsmeans bodystyle cylinders drivewheels/pdiff=all cl;
	ods select LSMeans LSMeanDiffCL;
run;

ods text= "From the main effects model in the previous step, we have 'bodystyle','cylinders',
'drivewheels' in the model.And from tukey-kramer tables above the mean difference in price based on all
three variables is significant with p-value(0.05) and even the confidence intervels of 
mean difference does not include 'zero'";
ods text="Based on 'bodystyle' the sedan type costs more than the hatchback type and mean price 
difference would be 1890$, based on 'cylinders the six cylinders variant is expensive than four cylinders
variant by mean difference 8509$ and considering 'drivewheels' rwd type is costly than fwd
type and the price differece would be 5991$.";

title Exercise-2.a;
proc glm data=imports;
	class bodystyle cylinders drivewheels;
	model price = bodystyle cylinders drivewheels bodystyle*cylinders cylinders*drivewheels/ ss3;
	ods select OverallANOVA FitStatistics ModelANOVA;
run;

ods text="For the reduced main effects model with 'bodystyle','cylinders','drivewheels' we now add
interaction effects between the three varaiables.And considering SS3 type sum of squares
the interaction term  'bodystyle*drivewheel' is not significant in the model beacuse it
has smaller F-statistic value with p-value (0.1912)>0.05, so we can drop this interaction from
the model.Now the model has 'bodystyle', 'cylinders', 'drivewheels', 'bodystyle*cylinders',
 'cylinders*drivewheels' terms.And this model described 68.4833 percent of variance in the data, adding
 the interaction terms increased the percent of variance explained."; 

title Exercise-2.b;
proc glm data=imports;
	class bodystyle cylinders drivewheels;
	model price = bodystyle cylinders drivewheels bodystyle*cylinders cylinders*drivewheels;
    lsmeans bodystyle cylinders drivewheels bodystyle*cylinders cylinders*drivewheels/pdiff=all cl;
	ods select LSMeans LSMeanDiffCL;
run;

ods text="The tables above show tukey-kramer tests for the mean difference in price for main
effects and interaction effects.Considering the main effects 'bodystyle', 'cylinders', 'drivewheels'
the mean difference in price is significant as the p-values(<0.05).Cars of sedan type with six cylinders 
and rwd drivewheel will be expensive than the cars with hatchback type with four cylinders and 
fwd drivewheel.The mean price difference and confidence intervals for main effects are listed in 
the table";
ods text=" Now we consider the interaction effects, for 'bodystyle'*'cylinders' the mean difference
for groups 'hatchback-six','sedan-six' has significant mean price difference based on the
tukey paired confidence intervals does not inlcude 'zero' and for remaining groups mean price difference
is not significant. Moving on to interaction effect 'cylinders'*'drivewheels' the mean price
difference for groups 'four-rwd','six-rwd' has significant mean price difference based on confidence
intervals where-as for the other groups the mean price difference is not significant.";
 

title Exercise-3.a;
proc reg data=imports noprint;
	model price = hp;
	output out=imports cookd= cd;
run;
* look at points with Cook distance greater than 1;
proc print data=imports;
	where cd > 1;
run;

ods text="In this step we fit a linear model for 'price' based on 'hp' ,we calculated 
cook's distance for the observations and there are no influential points with greater than
distnace '1', so we don't have to remove any observatios and consider the linear model as usual";

title2 Exercise-3.b;
proc reg data=imports;
	model price = hp ;
	ods select Anova FitStatistics ParameterEstimates;* DiagnosticsPanel;
run;

ods text=" The linear regression model in this step has no influential points, and from the
Anova table above we have F-statistic value of 230.90 with p-value (0.0001)<0.05 .We have evidence
in support of alternate hypothesis (Ha: Model with 'hp' is significant) and reject null
hypothesis(H0: Model with only intercept is sufficient).Hence the linear model for 
'price' as a fucntion 'hp' is significant.And this model described 62.42 percent variation in the
price.";
ods text=" From the coefficient estimates we can write the linear model as
'price=-2849.36725+(hp*148.19623)' which means 'hp' has positive coefficient so as we increase
the value for 'hp' the 'price' also increases.And this model is consistent with the customer
belief that the car with more horsepower will cost more";

title Exercise-3.c;
proc reg data=imports;
	model price = hp ;
	ods select DiagnosticsPanel;
run;

ods text=" Above plot shows the fit diagnostics for price from the previous model, and we can observe
several issues.By looking at the 'residual-predicted value' plot , it is not flat and assumption
of homoscedasticity is not reasonable which means variance is not constant also the linear
relation doesn't fit well which suggets a nonlinear realation is needed for the fit .And from the 
'residual-quantile' plot all the observations are not falling into a straight line ,so the normlaity
assumpiton is deviated and also we can identify some outliers which are falling very apart from the straight
line. Where-as the 'cooks D- observation' plot shows that there are no influential points with distance
greater than '1'.";

title Exercise-4.a;
data imports_log;
     set imports;
     price=log(price);
run;
proc reg data=imports_log noprint;
	model price = hp;
	output out=imports_log cookd= cd;
run;
* look at points with Cook distance greater than 1;
proc print data=imports_log;
	where cd > 1;
run; 

ods text="In the previous step there are some possible issues with the diagonsitic plots.
so in this step we fit a linear model for 'log(price)' based on 'hp' by considering non linear
transform/relation ,and cook's distance is calculated for the observations and there are no influential 
points with greater than distnace '1', so we don't have to remove any observatios and consider the 
linear model with log(price) as usual";

title Exercise-4.b;
proc reg data=imports_log;
	model price = hp;
	ods select Anova FitStatistics ParameterEstimates DiagnosticsPanel;
run;

ods text="From the Anova table above we have F-statistic value of 294.74 with p-value (0.0001)<0.05 .
We have evidence in support of alternate hypothesis (Ha: Model with 'hp' is significant) and reject null
hypothesis(H0: Model with only intercept is sufficient).Hence the linear model for 
'log(price)' as a fucntion 'hp' is significant.And this model described 67.95 percent variation in the
log(price).So the model with log(price) has more variance explianed compared to the model with 'price' as
as response";
ods text=" We can check the diagnostic plots after the applying log transform for price.
By looking at the 'residual-predicted value' plot , it is flat now and  we can assume
of homoscedasticity(constant variance) also the non linear log transformation fits the data.
.And from the'residual-quantile' plot all the observations are now falling into a straight line ,
so the normlaity assumpiton is obeyed and but we can identify some outliers which are falling 
very apart from the straight line at the extremities. In the 'cooks D- observation' plot 
there are no influential points with distance greater than '1'.";
ods text="In this step we can write the linear model as' log(price)=8.17749+(hp*0.01095)' which means 
'hp' has positive coefficient so as we increase the value for 'hp' the 'log(price)' also 
increases and once we obtain log(price) we can get original 'price' by it's exponent. And 
even after the log transformation the model is consistent with customer belief which is
the car with more horsepower will cost more";


title2 Exercise-4.c;
ods text="We can compare the model from exercise-3 with model from exercise-4.Model in excercise-3
has some issues with assumptions of homoscedasticity ,normality and also the linear relation 
between 'price','hp' does not fit data well.So in Exercise-4 we considered non linear transform
for 'log(price)' and this solved the issues from Exercise-3, also the model with 'log(price)'
explained more variation in the price. So the model from Exercise-4 is considered better than 
the model from Exercise-3.";

ods rtf close;