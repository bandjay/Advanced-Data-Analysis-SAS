* Stat -448 : Home work -6 ;
* NetID: bandlmd2 , Name: Jayachandu Bandlamudi;

ods rtf file='C:\Stat 448\Jayachandu Bandlamudi HW6.rtf';

/* The raw data in glass.data is from the UCI Machine Learning Repository
Lichman, M. (2013). UCI Machine Learning Repository [http://archive.ics.uci.edu/ml]. 
Irvine, CA: University of California, School of Information and Computer Science. 

The data, variables and original source are described on the following URL
http://archive.ics.uci.edu/ml/datasets/Glass+Identification
*/
data glassid;
	infile "C:\Stat 448\glass.data" dlm=',' missover;
	input id RI Na Mg Al Si K Ca Ba Fe type;
	groupedtype = "buildingwindow";
	if type in(3,4) then groupedtype="vehiclewindow";
	if type in(5,6) then groupedtype="glassware";
	if type = 7 then groupedtype="headlamps";
	drop id type;
run;

*Excercise-1;
title 'Excercise-1.a';
proc cluster data=glassid method=average plots(maxpoints=300) standard ccc pseudo print=15;
   var Na Mg Al Si K Ca Ba Fe;
   copy RI groupedtype;
   ods exclude EigenvalueTable ClusterHistory;
run;

ods text="Above we have dendrogram plot for the clustering using average linkage and
from the diagram we observe that the distance between clusters is minimum, also we have
many cluster groups with very few observations.We can choose number of clusters as 7
based on the dendrogram plot.";
ods text="From the Criteria for number of clusters plot, for CCC statistic maximum is observed
at 11 ,so the number of clusters is 11.Considering pseudo-F stattic maximum is observed at
11, so even in this choice of clusters would be 11.Where-as for pseudo-t square static we 
will check for the minimum and it is observed at 9  and 11 ,since we have chosen 11 clusters
from both CCC,Pseudo-F statistic and even for the pseudo-t square 11 is choice so we will consider
11 clusters.";
title 'Excercise-1.b';
* try 4 clusters from dendrogram;
proc tree noprint ncl=11 out=out11;
   copy RI Na Mg Al Si K Ca Ba Fe groupedtype;
run;
proc freq data=out11;
  tables cluster*groupedtype/ nopercent norow nocol;
run;
*proc print data=out11;
*run;

ods text="From the previous step ,we have grouped the observations into 11 clusters and now 
we compare the clusterings results with glass type.Above we have frequency table, we observe
that cluster-1 has 174 observations,cluster-2 has 22 observations and the remaining 9 clusters
have very few observations.Cluster-1 has 140 observations of building glass type (146 in total),all
17 observations of  vehicle window glass type,and 15 observations of galssware type(22 in total)
so cluster-1 didn't group different types of glass in a good manner and three types of glass
are clustered together,and it well matches glass types 'building window','vehicle window' .
Where-as Cluster-2 has 22 observations out of which 21 observations
are of headlamps glass type,so cluster-2 well macthes for the headlamps type.Remaining clusters are
of small size ,and they have observations of only one type of glass";
ods text="By observing the clustering results,cluster-1 has three types.So it can be inferred
that types 'building window','vehicle window' and 'glassware' have similar chemical composition";
*Excercise-2;
title 'Excercise-2.a';
data aov_data;
     set out11;
     where cluster=1 or cluster=2;
     keep RI cluster;
run;

proc sort data=aov_data;
by cluster;
run;
*proc print data=aov_data;
*run;
proc univariate data=aov_data normal;
 var RI;
  histogram /normal ;
  probplot / normal(mu=est sigma=est) ;
  ods select TestsForNormality Histogram ProbPlot;
run; 


ods text="In this step we consider clusters with 5 or more observations,So we have chosen
only the first two clusters(cluster-1,2).Now we perform ANOVA for the RI variable based on cluster
assignment.And we test for the Noramlity assumption,homoginity of variance of RI variable";
ods text="Above we have results from normality test,we have p-values less then 0.05 so we have
evidence in support of alternate hypothesis(Ha:Normality assumption is not valid) over
null hypothesis(H0:Normality assumption is valid).Also we can check the Normality assumption visually 
by observing the probability plot, and in the plot observations did not fall in a straight line.Hence we
confirm Normality assumption is not valid both quantitatively and visually.";
proc anova data=aov_data;
  class cluster;
  model RI=cluster;
  means cluster/ hovtest ;
  ods select HOVFTest;
run; 
ods text="Now we perform homoginity of variance test for RI variables based on cluster assignment,
we have the results in the table above and we have p-value (0.1253)>0.05 so we have evidence in
support of Null hypothesis (H0: Equal sample/cluster variances) over the alternate hypothesis
(Variances are not equal).";
proc anova data=aov_data;
  class cluster;
  model RI=cluster;
  *means cluster/ hovtest ;
  ods select OverallANOVA FitStatistics ModelANOVA;
run; 
ods text="From the Avova table above, we p-value (<0.001) less than 0.05 so we have evidence in support 
of alternate hypothesis and the model with clusters is better than error only model.And the cluster
variable is significant in the model with p-value less than 0.05 and this model described
7.65 percent of total variation in RI. ";

title 'Excercise-2.b';

proc anova data=aov_data;
  class cluster;
  model RI=cluster;
  means cluster/ cldiff tukey;
  ods select CLDiffs ;
run;
ods text="We preform Studentized's Tukey test for comparing the mean differences in RI across
clusters.The results from the table above indicate that there is significant mean difference
considering the 0.05 level, also the confidence interval for mean differences doesn't
contain zero in the range,so there is mean difference in RI between the two clusters. Actually
the mean difference between cluster-1 and cluster-2 is '0.0020184',so cluster-1 has larger mean
value for RI than the cluster-2.So the glass types 'building window','vehicle window' and 'glassware' 
have larger mean RI than the 'glassware' type.Finally, from fit statistics in the previous 
the model though it is better than error only model it just explained meager amount of variance
(7.65 percent) and mean differences are small though they are significant,so using this model for 
predicting the RI is not useful."; 

*Excercise-3;
title 'Excercise-3.a';
proc stepdisc data=glassid sle=.05 sls=.05;
   	class groupedtype;
   	var Na Mg Al Si K Ca Ba Fe;
   	ods select summary; 
run;
ods text="In this part we will use discriminant analysis to classify the groupedtype based
on chemical oxides, and at first we obatin best set of predictors using stepwise discrimant
function. Above table shows the final variable selection summary, and all the five variables
'Mg','Si','K','Ca','Ba' have p-values less than 0.05 significance level so these five variables
will be retained in the model for next steps"; 
title 'Excercise-3.b';
proc discrim data=glassid out=outresub outd=outdens manova pool=test;
   class groupedtype ;
   var Mg Si K Ca Ba;
run;
ods text="From the table above,Test for homoginity of with in covariance matrices .We observe 
that p-value is <0.001 which is less than 0.05 significance level,and we have evidence in 
support of alternate hypothesis (Ha: Homoginity of variance is not valid) hence we choose 
QDA over LDA because thecovariance matrices doesn't have same variance."; 
ods text="By looking at the Multivariate Statistics and F Approximations table above, we have
all the available tests have p-values less than 0.05 which is in support of alternate hypothesis, 
so the results say that it is possible to discriminate the galss type based the oxides we have chosen
from Stepwise selection.";

title 'Excercise-3.c';
proc discrim data=glassid pool=test crossvalidate;
   class groupedtype ;
   var Mg Si K Ca Ba;
   priors proportional;
   ods select ClassifiedCrossVal ErrorCrossVal;
run;
ods text="From the cross_validation results above with proportional priors, QDA is performed because of the difference
in variance of covariance matrices.And by looking at the error count estimates table we observe that
over all error  rate is 38.32 percent,but the 'vehiclewindow' glass type has less error rate 
of 17.65 percent followed by 'headlamps' with error rate 20.69 percent ,'glassware' with 
45.45 percent error rate.Where-as 'buildingwindow' has highest number of observations
misclassified with 43.15 percent error rate.
So from the error rates for each glass type and frequency table counts 'buildingwindow' type
is often is confused with other glass types and many observations are misclassified.
And 'glassware' type is also confused and it has highest error rate but it this type has 
fewer observations than 'buildingwindow so fewer observations are confused with other
glass types.";
*Excercise-4;
title 'Excercise-4.a';
ods text="In the previous part ,we observed that 'buildingwindow' is often confusesd with other types.
Originally there are 146 observations with 'buildingwindow' type and 83 observations are classified
correctly and  many observations are(54 observations) are mis classified as 'vehiclewindow' type.For 'vehiclewindow' type 
originally 17 observations that belong to 'vehiclewindow' are slightly confused with 'buildingwindow'.
Since beacuse of the crossover between the two glass types,the expert claim seems plausible that
'there is little difference in oxides in building and vehicle windows.";  
title 'Excercise-4.b';
data glassid;
    set glassid;
	newgroupedtype=groupedtype;
	if newgroupedtype="vehiclewindow" or newgroupedtype="buildingwindow" 
	then newgroupedtype="window";
run;
proc freq data=glassid;
     tables newgroupedtype;
run;     
proc stepdisc data=glassid sle=.05 sls=.05;
   	class newgroupedtype;
   	var Na Mg Al Si K Ca Ba Fe;
   	ods select Summary; 
run;
proc discrim data=glassid manova method=normal pool=test;
   class newgroupedtype ;
   var Mg Si K Ca Ba;
   *priors proportional;
run;
proc discrim data=glassid pool=test crossvalidate method=normal;
   class newgroupedtype ;
   var Mg Si K Ca Ba;
   priors proportional;
   ods select ClassifiedCrossVal ErrorCrossVal;
run;
ods text="In this step collapsed the buildingwindow,vehiclewindow types into one type called
window and the other two types are the same as before.At first we perform stepwise selection
to obtain best predcitors and the results were n't changed from the previous exercise ,we
still have five predcitors 'Mg','Si','K','Ca','Ba' retained in the model.";
ods text="From the Multivariate Statistics and F Approximations table for MANOVA test,we have
p-values (<0.001) less than 0.05 for all tests.So we can discriminate the galss type based the 
oxides we have chosen.And in the Test for homoginity of with in covariance matrices .We observe 
that p-value is <0.001 which is less than 0.05 significance level,hence we choose 
QDA over LDA like the previous excercise.";
ods text="From the QDA cross_validation results above with equal priors, from error count 
estimates table we observe that over all error  rate is 12.62 percent,but the 'window' 
type has less error rate of 6.75 percent followed by 'headlamps' with error rate 20.69 percent ,
'glassware' with 45.45 percent error rate.So from the error rates  'glassware' type is often is
confused with other glass types.";

title 'Excercise-4.c';   
ods text="Now we compare both the excercises-3,4 and the overall error rate after combining the
two glasstypes into one type has improvement of 12.62 percent versus 38.32 in the previous 
excercise.And the newly created'window' glass type has the lowest error rate of 8.59 percent and the 
remaining two glass type error rates didn't change from the previous excercise.Hence in accordance with the
expert opinion if we merge 'buildingwindow','vehiclewindow' into one level 'window' has improved
the discriminant model error rate by good margin.";

ods rtf close;