* Stat -448 : Home work -2 ;
* NetID: bandlmd2 , Name: Jayachandu Bandlamudi;

ods pdf file='C:\Stat 448\Jayachandu Bandlamudi HW2.pdf' ;

* Excercise-1 ;
data taevals;
	length nativeEnglish $ 3 semester $ 7 scoregroup $ 6;
	* modify the file path to match the location of your data files, 
	  then change the path back before submitting your final code;
	infile "C:\Stat 448\tae.data" dlm="," missover;
	input nE instructor course smstr 
		classsize scgrp;
	if nE = 1 then nativeEnglish='yes';
		else nativeEnglish='no';
	if smstr = 1 then semester='Summer';
		else semester='Regular';
	if scgrp=1 then scoregroup='Low';
	if scgrp=2 then scoregroup='Medium';
	if scgrp=3 then scoregroup='High';
	keep nativeEnglish semester scoregroup;
run;

Title Excercise-1.a;
Proc freq data=taevals;
   tables semester*scoregroup/ nopercent norow nocol expected;
run;

ods text='';
ods text='';
ods text='From the contingency table ,we observe that the difference between the Actual counts 
and Expected counts is significant when compared with actual counts,so we can say there is
some association between "semester","scoregroup".And it is apparent that "Regular" semester has 
smaller count for "High" score group when compared with "Low","Medium" but for the "Summer" semseter
it is vice versa i.e; "High" score group has bigger count.';    
 

Title Excercise-1.b;
Proc freq data=taevals;
   tables semester*scoregroup/ nopercent norow nocol expected chisq;
   ods select chisq;
run;

ods text='';
ods text='';
ods text='From the table above , we can use chi-square test to validate the association.
From chisquare test results we have p-value(0.0018) < 0.05, so we have evidence
in support of alternate hypothesis( Ha: There is association between variables) and reject null
hypothesis(H0: There is no association between variables).
And in this case we can ignore "Mantel-Haenszel" as the variables are not ordinal,also
different coefficients(phi,contingency) were listed in the table to specify the magnitude
of association';  

*Exercise-2;
data taevals_new;
     set taevals;
     where scoregroup='Low' or scoregroup='High';
run;     
Title Excercise-2.a;
Proc freq data=taevals_new;
   tables semester*scoregroup/ nopercent norow nocol expected;
run;
ods text='';
ods text='';
ods text='From the contingency table ,we observe that the difference between the Actual counts 
and Expected counts is significant when compared with actual counts,so we can say there is
some association between "semester","scoregroup".And it is apparent that "Regular" semester has 
smaller count for "High" score group when compared with "Low" but for the "Summer" semseter
it is vice versa i.e; "High" score group has bigger count.';

Title Excercise-2.b;
Proc freq data=taevals_new;
   tables semester*scoregroup/ nopercent norow nocol exact chisq;
   ods select chisq FishersExact;
run;
ods text='';
ods text='';
ods text='From the tables above ,we can use chisquare/Fisher test to validate the association.
From both Chi-square/Fisher test results we have p-value(0.0009,0.0007) < 0.05, so we have evidence
in support of alternate hypothesis( Ha: There is association between variables) and reject null
hypothesis(H0: There is no association between variables).
And in this case we can ignore "Mantel-Haenszel" as the variables are not ordinal,also
different coefficients(phi,contingency) were listed in the table to specify the magnitude
of association';

Title Excercise-2.c;
Proc freq data=taevals_new;
   tables semester*scoregroup/ nopercent norow nocol expected riskdiff;
run;
ods text='';
ods text='';
ods text='From the tables above,the column1 risk estimates correspond to the "High" scoregroup.
And we want to test if summer session TAs have a significantly higher probability than regular 
semester TAs to be high rated.By looking at "row1" ,"row2" risk estimates correspondig
to the "Regular","Summer" semesters the difference is -0.4419 which means summer semester has
high probability to be rated "High". And the difference is significant as the confidence interval
has nonzero values(-0.62,-0.25)'; 
 
*Exercise-3;
data taevals_summer;
     length scoregroup $ 10;
     set taevals;
     if scoregroup NE "High" then scoregroup='Not High';
     where semester='Summer';
run;     
Title Excercise-3.a;
Proc freq data=taevals_summer;
   tables nativeEnglish*scoregroup/ nopercent norow nocol expected ;
run;

ods text='';
ods text='';
ods text='From the contingency table ,we observe that the difference between the Actual counts 
and Expected counts is not significant when compared with actual counts,so we can say there is
no apparent association between "NativeEnglish","scoregroup" so nativeEnglish speaking ability
has no association with High rating but we have to test it for validation';

Title Excercise-3.b;
Proc freq data=taevals_summer;
   tables nativeEnglish*scoregroup/ nopercent norow nocol expected exact chisq;
run;

ods text='';
ods text='';
ods text='From the table above we have the chisquare and Fishers exact test results ,
And in this case some of the expected counts in the contigency table are below "5" so we will go with 
Fisher Exact test to test the association.From Fisher test results we have p-value(apparently 1) > 0.05, 
so we have strong evidence in support of null hypothesis(H0: There is no association between variables)against the
alternate hypothesis( Ha: There is association between variables).So there is no association
between NativeEnglish,ScoreGroup, we conclude that its not resonable to use native English
speaking ability to choose a course based on the TA.';

*Exercise-4;
data seeds;
	* modify the file path to match the location of your data files, 
	  then change the path back before submitting your final code;
	infile 'C:\Stat 448\seeds_dataset.txt' expandtabs;
	input area perimeter compactness length width 
		asymmetry groovelength variety $;
	if variety = '1' then variety = 'Kama';
	if variety = '2' then variety = 'Rosa';
 	if variety = '3' then variety = 'Canadian';
run;
Title Excercise-4.a,b;
proc anova data=seeds;
  class variety;
  model compactness = variety;
  means variety / hovtest welch;
run;

ods text='';
ods text='From the Anova results above,we can test the assumptions of balanced data,homoginity of
variance for different variety of seeds.The data is balanced because each of the three varieties
has equal number of observations(70).To test the Homoginity of varaiance, we can use the
"hovtest" with "welch" adujustment and the resluts are resulting p-value(0.0001<0.05) has evidence in
 support of alternate hypothesis (Ha: There is difference is varaiance of compactness across varieties) against the null hypothesis
(H0: Homoginity of varaiance)';

ods text='';
ods text="                  Excercise-4.b                        ";
ods text=' From the above one-way ANOVA results, the model with "Variety" is significant beacuse the 
p-value( 0.0001)< 0.05 and the variance explained by the model is "0.422".And there is significant 
variance expained in the Compactness by the "Variety" of seeds.we observe the Mean differences
in the boxplots, as "Kama","Rosa" have approximatley same "Mean" where as "Canadian" variety 
has lower "Mean" than the others, which specifies there is "Mean difference" across varieties 
of seed.With "Rosa" having high mean compactness followed by "Kama","Canadian"';

Title Excercise-4.c;
proc anova data=seeds;
  class variety;
  model compactness = variety;
  means variety / tukey cldiff;
run;
ods text='';
ods text='';
ods text='We can use the tukey test for comparing pairwise Mean difference for "Compactness"
across varieties,and from the Tukey HSD table above there is Mean difference between
"Rosa-Canadian","Kama-Canadian" pairs because the conifdence interval of mean difference does
not include zero so difference is significant,but "Rosa-Kama" pair mean difference can be zero.
Also difference between "Rosa-Canadian" is 0.0034 which means Rosa variety has Larger mean 
than Canadian Variety and  "Kama-canadian" is 0.030 so Kama has larger mean than canadian.';

ods pdf close;