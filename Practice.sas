* data for exercises 1, 2, 3, and 4;
ods rtf file="C:\Stat 448\Jayachandu Bandlamudi Midterm.rtf";
data orsalesshort;
	set sashelp.orsales;
	length half $6.;
	quarter = SUBSTR(Quarter, 5, 2);
	if Product_Line in('Outdoors', 'Sports') then OS ='Yes';
		else OS = 'No';
	if Quarter in('Q1','Q2') then half='First';
		else half = 'Second';
	ProfitPerItem = profit/quantity;
	LogProfit=log(profit);
	keep Quarter Product_Line Quantity OS Half LogProfit ProfitPerItem;
run;
* data for exercise 5;
data demoshort;
	set sashelp.demographics;
	logGNI =log(GNI);
	keep AdultLiteracyPct FemaleSchoolPct logGNI 
		MaleSchoolPct Pop PopAGR PopUrban;
run;

title 'Execercise-1';
proc sort data=orsalesshort ;
    by Product_Line;
run;
proc univariate data=orsalesshort ;
	var ProfitPerItem;
	by Product_Line;
	ods select Moments BasicMeasures;
run;
ods text=" Descriptive statistics for 'ProfitPerItem' across different levels of Product_line are as follows. We have four levels in Product_line such as Children,Clothes & Shoes,
Outdoors,Sports .For the Chidren productline has 176 observations with the mean 'ProfitPerItem' as 18.6042788,medain as 18.00034, variance as 20.2519279 ,range (which is the difference 
between minimum and maximum 'ProfitPerItem' for Chidren productline) as 18.49403 , skewness as -0.2126056 which is negative so distribution is not symmetric whereas it has longer left tail.
For the Clothes & Shoes productline has 288 observations with the mean 'ProfitPerItem' as 47.5537234,medain as 41.02876, variance as 1387.61668 ,range as 150.52083 , skewness as 1.9355664 
which is positive so distribution is not symmetric whereas it has longer right tail.For the Outdoors productline has 112 observations with the mean 'ProfitPerItem' as 64.8559313,
medain as 45.96731, variance as 2728.48357 ,range as 176.56728 , skewness as 1.36671154 which is positive so distribution is not symmetric whereas it has longer right tail.
For the Sports productline has 336 observations with the mean 'ProfitPerItem' as 51.812027,medain as 34.50453, variance as 1565.36066 ,range as 144.04510 , skewness as 0.85444248 
which is positive so distribution is not symmetric whereas it has longer right tail.";
ods text=" The Outdoors productline has the highest mean 'ProfitPerItem' and Chidren productline has the lowest mean.Also the Variance and Range for Outdoors productline are higher
 than others which says the 'ProfitPerItem' varies alot for Outdoor products, where as Chidren productline has the lowest Variance and Range so the variation in 'ProfitPerItem' is lesser";

proc univariate data=orsalesshort normal;
	var ProfitPerItem;
	histogram /normal(mu=est sigma=est);
	probplot/normal(mu=est sigma=est);
	by Product_Line;
	where Product_Line = 'Outdoors' OR Product_Line='Sports'; 
	ods select Histogram ProbPlot TestsForNormality;
run;

ods text=" In this part we will check the assumption of normality for 'ProfitPerItem' of Sports and Outdoors prdocuts.For the Outdoors product the Distribuiton of histogram,probability plots show that 
normality assumption is not obeyed beacause from the probability plot we could see all the observations are not falling in a straight line path,so visually we can say that normality assumption is not
feasible.Now we can it quantitatively based on the results of TestsforNormality, and considering significance level at 0.05 we have p-values less than 0.05 for all the tests so we can reject
Null hypothesis (H0: Distributional assumption of Normality) and we have evidence to support Alternate hypothesis(Ha:Normality assumption is not appropriate).";

ods text="In a similar way we can check normality assumption for Sports products,by observing the Distribuiton of histogram,probability plots we can see that normality assumption is not appropriate because
 from probability plot we could see all the observations are not falling in a straight line path.And from the TestsforNormality table results we have p-value(<0.05) to support Alternate 
hypothesis(Ha:Normality assumption is not appropriate).So we can say that Normality assumption is not obeyed visualyy and quantitatively.";

title 'Execercise-2';
proc univariate data=orsalesshort mu0=50;
	var ProfitPerItem;
	by Product_Line;
	where Product_Line='Sports'; 
	ods select Moments BasicMeasures TestsforLocation;
run;

ods text=" In this step we are going to test the hypothesis such that Null hypothesis (H0:'ProfitPerItem' for Sports products is more than 50) against the Alternate hypotheis (Ha:'ProfitPerItem' for Sports products 
is not greater than 50).And from the previous part we checked the normality assumption for Sports products is not appropriate and also the distribution is skewed so we could use sign test to check the hypothesis.
The results for the sign test are in the table above and we have a p-value (0.0102) < 0.05 so we have evidence in support of Alternate hypothesis and we reject Null hypothesis. we can conclude from the hypothesis
test results that the profit goal for typical Sports is not met considering the median of 'ProfitPerItem' and 'ProfitPerItem' is not more than 50.";

proc npar1way data=orsalesshort wilcoxon;
  class Product_Line;
  var ProfitPerItem;
  where Product_Line='Sports' or Product_Line = 'Outdoors';
  ods exclude KruskalWallisTest;
run;

ods text="Now we are going test the hypothesis such that Null hypothesis (H0: Sports products generally tend to have greater profit than Outdoors Product) against the Alternate hypotheis (Ha:Sports products generally 
does not tend to have greater profit than Outdoors Product). From the previous step we can not make normality assumption for 'ProfitPerItem' both Sports and Outdoors products,so in order to compare the two samples
we could use wilcoxn two sample-test for checking the hypothesis. And we have the test results above ,we observed the test statistic to be high (27294)which is the sum of the Wilcoxon scores.
This sum is greater than 25144, which is the expected value under the null hypothesis of no difference between the two samples and we can also consider the one-sided p-value for approximated
normal and t distributions which are less than <0.05 (significnae level).Hence we have evidence in support of Alternate hypothesis which is to say that we can reject the claim that sports products generally 
does tend to have greater profit than Outdoors Product.";

title 'Execercise-3';
proc freq data=orsalesshort;
    table  Product_Line*Quarter/norow nocol nopercent expected chisq;
    weight Quantity;
run;

ods text="In the above results we have a contigency table for Quarter,Product_line considering the Quantity sold.In the contigency table we have actual Quantity sold as well as Expected Quantity sold and we observe 
that there is difference between actual and expected values for some of the cells in the table(like Q-1,Children has some difference in Actual,Expected values).Hence there is some apparent association between
Quarter, Product_line and the independence of Quarter and Porduct_lines sales quantity is not reasonable.But we have to test the association using appropriate test for confirming that independence is not reasonable."
;
ods text=" We can use Chi-square test/Likelihood Ratio test to check the association between Quarter and Product_line. Here the Null hypothesis(H0: there is no association) and Alternate hypotheis (Ha: There is some association) and 
we have the statistical test results above and we have p-value (<0.001) which is less than 0.05(significane level) so we have evidence in support of Alternate hypothesis and we reject Null hypothesis.We can conclude that there is 
some association between Quarter and Product_line.";
proc freq data=orsalesshort;
	table  Half*OS/norow nocol nopercent expected chisq riskdiff;
	weight Quantity;
	ods exclude FishersExact RiskDiffcol1;
run;
ods text="Now we have a contigency table for OS,Half considering the Quantity sold which is based on the half year sales and by products in Sports,Outdoord or not in two categories.In the contigency table we 
have actual Quantity sold as well as Expected Quantity sold and we observe that there is difference between actual and expected values which is approximately 10,000 in quantity for each cell of the table.
And considering the magnitude of actual value this difference is not high.But we have to test the association using appropriate test for confirming independence.";

ods text="To check the association between OS,Half We can use Chi-square test/Likelihood Ratio Chi-Square test. Here the Null hypothesis(H0: there is no association) and Alternate hypotheis (Ha: There is some association) and 
we have the statistical test results above and we have p-value (<0.0001) which is less than 0.05(significane level) so we have evidence in support of Alternate hypothesis and we reject Null hypothesis.We can conclude that there is 
some association between OS,Half.";

ods text="In this part we can use coulmns risk table above to check if the perecntage of sale for Sports,Outdoors products are higher in the first half than second half. From the table column2 risk estimates
refers to the Sports,Outdoors products and Row 1,2 are for first and second half of the year. There is significant difference between risks for Row1,Row2 by observing the confidence intervals and difference is 
positive so Row1 has larger value than Row2.Hence we can say that Percentage of sales Sports,Outdoors product is significantly higher in the first half than in the second half.";

title 'Execercise-4';
Proc glm data=orsalesshort;
    class Product_Line Quarter;
	model LogProfit = Quarter|Product_Line;
	ods select ModelAnova;
run;

ods text="In this part we have a linear model for LogProfit with Product_Line,Quarter and inetraction term Product_Line*Quarter as predictors.The above shows the type I,III sumof scores for the model in this step
and considering the significance level (0.05) the interaction term is not significant in the model.So we can consider deleting the interaction term from the model,now the model has only main effect variables 
Product_Line,Quarter and both are significant in the model so we consider this mdoel as our final model with just main effects.";

proc glm data=orsalesshort;
    class Product_Line Quarter;
	model LogProfit = Product_Line Quarter;
	lsmeans Product_Line Quarter/pdiff =all cl;
	ods select OverallANOVA FitStatistics ModelANOVA LSMeans diff LSMeanDiffCL;
run;

ods text="From the previous step we have only main effects in the final model and this model explained '21.5242 percent' variance in the LogProfit. We can check the imporatnce of this final model w.r.to to error only model,
here the Alternate hypothesis (Ha: Model with Main effects is signficant) against the Null hypothesis(H0: Model with error terms is sufficient) and based on the p-value of ANOVA test which is (<0.001) less than 0.05
so we evidence in support of Main effects is significant.";

ods text="Our final model has only main effects and we can check the mean difference based on the  Product_Line,Quarter main effects.Above we have Tukey-Kramer test for pairwise mean comparision of LogProfit ,considering 
the Product_Line main effect we have significant mean difference in LogProfit across different pairs of Product_line such as (1-2,1-3,1-4,2-3,2-4,3-4) this because the confidence interval for mean difference of all
levels doesnot contain zero.So there is significant mean difference.Also we have a table for p-values indicating the significnat mean difference ,considering 0.05 significane level all the pairwise mean differences are
significant";

ods text="Now we can move on to Quarter main effect,by observing the p-value table with significance level 0.05 we observe that the mean difference between pairs 2-3,2-4,,3-4 is not significant and for pairs 1-2,1-3,1-4 is 
significant.And we check the confidence intervals for mean difference, pairs 2-3,2-4,3-4 have no significant difference beacuse confidence interval includes 'zero' where as pairs 1-2,1-3,1-4 have significant difference beacuse 
confidence intervals do not include 'zero'.";
 
title 'Execercise-5';
proc reg data=demoshort;
	model logGNI = AdultLiteracyPct FemaleSchoolPct MaleSchoolPct Pop PopAGR PopUrban/ selection=stepwise sle=0.05 sls=0.05;
	ods select selectionSummary;
run;

ods text=" In this step initially we have a linear model for logGNI with AdultLiteracyPct,FemaleSchoolPct,MaleSchoolPct,Pop,PopAGR,PopUrban as predcitors.In order to choose best predcitors we used stepwise
variable selection with significane level 0.05.And the above table shows the slection summary of stepwise algorithm for varaible selection, so we have FemaleSchoolPct,PopAGR,PopUrban only three varaibles which are
significant.Hence best predictors model will have only  FemaleSchoolPct,PopAGR,PopUrban as predictors in the regression model for logGNI.";
proc reg data=demoshort;
	model logGNI = FemaleSchoolPct PopAGR PopUrban;
	ods select ANOVA FitStatistics ParameterEstimates DiagnosticsPanel;
run;
ods text="From the previous step we have best predictors model and we can examine the regression diagnostics for this model.By looking at the Residual Vs Predicted value plot we observe that
the plot is flat and we can assume constatnt varaince(homoscedasticity) for logGNI, also the logGNI( log tranform of GNI) non linear tranform fits the data well.The Residual Vs Quantile plot 
shows that assumption of normality is obeyed becuase all the observations are falling in a straight line path.From the Cooks distnace plot we observe no highly influential observations with
cooks distance greater than '1'.So our best predictors model is good interms of model assumptions and it doesn't have influential points.Hence we consider best predictors model as the final 
model.";
ods text="Now we have final model with FemaleSchoolPct,PopAGR,PopUrban as predictors for logGNI and  this model explained '73.63 percent' variance in the logGNI. We can check the significance of
this final model w.r.to to error only model,here the Alternate hypothesis (Ha: Final model is signficant) against the Null hypothesis(H0: Model with just error terms)
and based on the p-value of ANOVA test which is (<0.001) less than 0.05 so we have evidence in support of Final model is significant.";
ods text="For the final model the parameters estimates of all the variables i:e;FemaleSchoolPct,PopAGR,PopUrban are significant with p-values less than 0.05, and the intrepretation of
parameters can be explained by formulating the linear equation such that logGNI= 5.27385+ (2.44499*FemaleSchoolpct)-(15.36832*popAGR)+(2.75072*popUrban). In this formula FemaleSchoolpct
has parameter estimate as '2.44499', it means 1 point increment in FemaleSchoolpct will raise the quantity of logGNI by 2.44499 keeping all other parameters constant.In a similar way 
popAGR has parameter estimate as '-15.36832' so 1 point increment in popAGR will decrease the quantity of logGNI by '15.36832' keeping all other parameters constant, and popUrban
parameter estimate as '2.75072' so 1 point increment in popUrban will raise the quantity of logGNI by '2.75072' keeping all other parameters constant.";
ods rtf close;
