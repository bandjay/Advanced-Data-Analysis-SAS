* Stat -448 : Home work -5 ;
* NetID: bandlmd2 , Name: Jayachandu Bandlamudi;

ods rtf file='C:\Stat 448\Jayachandu Bandlamudi HW5.rtf' ;


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

*Excercise-1;
title 'Excercise-1.a';
proc princomp data=seeds;
   id variety;
   ods exclude SimpleStatistics Corr Eigenvectors;
run;

ods text="Above we have plot for variance explained and from the plot we can say that
first two principal components can explain atleast 85% of the total variation from original variables and
these two components cumulatively exaplain 89% of variation.Also, we know that average eigen value of 
the correlation matrix is '1' so considering this method we would select components with eigen values
greater than'1' so we choose first two components based on the eigen value table .From the scree plot above 
we observe that after the 4th component the plot is flat which signfies the elbow, and we can choose the first 2 or 3 components
by this method but two components would be ideal considering the steepness of the line";

title 'Excercise-1.b';
proc princomp data=seeds;
   id variety;
   ods select Eigenvectors;
run;

ods text="In part-a ,considering 85% crterion we decided to consider first two principal components.
Now we will look at these two components and figure out what are the original fetaures that are
being picked.In the table above we have Eigen vectors for the components,for
the first component we can write prin1=(0.44*area)+(0.44*perimeter)+(0.28*compactness)+(0.42*length)+
(0.43*width)-(0.12*aysmmetry)+(0.39*groovelength) all the original features such as 'area','perimeter','compactness','length','width',
'groove length' has postive values and  which means if any of these features increases then there will be increase
in first component.Where-as 'asymmetry' has negative value so the first component is isolating/picking up
 the 'asymmetry' feature from the other seed features.";
ods text="The second component can be written as prin2=(0.03*area)+(0.09*perimeter)-(0.53*compactness)+(0.21*length)-
(0.12*width)+(0.72*aysmmetry)+(0.38*groovelength) and it has smaller positive values for 'area','perimeter' and higher
positive values for  'length','groove length','asymmetry' and negative values for 'compactness','width' so 
the second component is a mix of several seed features.It is difficult to infer original seed features
from the component.";

title 'Excercise-1.c';
* get visualizations of components;
proc princomp data=seeds plots= score(ellipse ncomp=2);
   id variety;
   ods select ScorePlot;
run;

ods text="From the score plot above,we observe that 'Rosa' variety is allinged towards the right side of the 
ellipse ,'Kama' variety is mostly in the middle and 'canadian' variety is allinged towards the left side
of ellipse.And w.r.to the component-1 axis 'Rosa' has larger values and 'canadian' variety has smaller values,
we also know that component-1 is picking up 'asymmetry' feature of seed and it has negative value
hence we infer that 'Rosa' variety has less 'asymmetry' when compared to 'canadian' variety.If we consider
component-2 as reference we obsereve that all three varieties are spreaded out ,so it is difficult to infer
original seed features from component-2 across varieties ."; 

   
*Excercise-2;
title 'Excercise-2.a';
proc princomp data=seeds cov;
   id variety;
   ods exclude SimpleStatistics Corr Eigenvectors;
run;
ods text= "In the previous Exercise, we did correlation based PCA with scaling but now we do not scale the variables
and we try Covariance based PCA.Using covariance based PCA ,as we observe from the above tables the first two 
principal components would be sufficient to cover atleast 85% of the variation from the original variables.In fact in this 
case the first components cumulatively explained 99.3% variation in the original varaibles.From the average eigen value
method we have two components whose eigen values are greater than 1, so we choose first two components.Moving on to
scree plot based component selection, we observe in the plot that after the 3rd component the plot is flat hence choosing
first two components would be the ideal choice.";

title 'Excercise-2.b';
proc princomp data=seeds cov;
   id variety;
   ods select Eigenvectors;
run;

ods text="From previous part,we decided to consider first two principal components.
Now we will look at these two components and figure out what are the original fetaures that are
being picked.In the table above we have Eigen vectors for the components, and we observe that 
the first component can written prin1=(0.88*area)+(0.40*perimeter)+(0.004*compactness)+(0.13*length)+
(0.11*width)-(0.13*aysmmetry)+(0.13*groovelength) .And from this equation compactness feature is almost NULL in component-1
area has largest positive value,some variables has sligthly positive values and asymmetry has negative value
.So, it is difficult to infer component interms of original seed features and also what features are being picked up.";
ods text="The second component can be written as prin2=(0.10*area)+(0.06*perimeter)-(0.002*compactness)+(0.03*length)+
(0.002*width)+(0.99*aysmmetry)+(0.08*groovelength) and it has almost NULL values for 'width','compactness' and higher
positive values for  'asymmetry',all other variables  has smaller positive values so the second component is picking 
asymmetry feature of the seeds.";


title 'Excercise-2.c';
* get visualizations of components;
proc princomp data=seeds plots= score(ellipse ncomp=2) cov;
   id variety;
   ods select ScorePlot;
run;

ods text="From the score plot , considering component-1 as reference we obsereve that 'Rosa' variety is alligned
towards the right part of ellipse and 'Kama','Canadian' variety observations are all mixed up.So component -1 is not able to
segregate observations to infer the original seed features.Simlilarly w.r.to component-2 reference we could not
distingusih between varieties because all the observations are mixed up.";

ods text ="Now we compare both correlation and covariance based PCA,and from the results of both methods we observe that
eigen values of principal components,cumulative percent of variance explained of covaraiance based PCA are larger than Correlation based PCA.
This is because  in covaraince based PCA we didn't scale variables so the variables with larger variance will have more impact on components.
By looking at the score plots in both cases, correlation based PCA results are satisfactory and more interpreatble
than covariance based PCA.Hence, correlation based PCA best caputures differences in features across varieties.";
 

*Excercise-3;
title 'Excercise-3.a';
proc cluster data=seeds method=average plots(maxpoints=300) ccc pseudo;
   var area perimeter compactness length width 
		asymmetry groovelength;
   copy variety;
   ods exclude EigenvalueTable ClusterHistory;
run;

ods text="From the dendrogram plot above we can choose 3 clusters beacuse they would segreagte all observations into different
groups such that one group is different from others and observations within a group are similar.And we also have plots
for CCC,Pseudo-F,Pseudo- t squared statistics.For CCC statistic we look for peak values in the plot and at 3 we have
maximum CCC so we choose 3 clusters.In a similar way for the Pseudo-F we look for maximum value and in the plot at 3 we have
the maximum statistic so 3 clusters would the choice.But for Pseudo-t squared we look for minimum value and in the plot
minimum is obsevred at 3,so 3 clsuters would be the choice in this case as well.";

title 'Excercise-3.b';
* try 3 clusters from dendrogram;
proc tree noprint ncl=3 out=out3;
   copy area perimeter compactness length width 
		asymmetry groovelength variety;
run;

proc freq data=out3;
  tables cluster*variety/ nopercent norow nocol;
run;

ods text="From previous step we have chosen 3 clusters, and we performed clustering to group observations into 3 cluster
groups now we compare these cluster groups with the actual varieties of seeds.And from the table above we can see
that cluster-1 has 87 observations with all of the 70 observations from canadian variety,17 observations from kama
variety so cluster-1 signfies canadian variety seeds with crossover of Kama variety.Cluster-2 has 76 observations
in total with 53 observations from Kama variety,23 observations from Rosa variety, so cluster-2 majorly
signifes Kama variety with cross over of Rosa variety.Where as cluster-3 has only 47 observations and all of them are
from Rosa variety ,so cluster-3 signifies Rosa variety with no crossover of other varieties.";

*Excercise-4;
title 'Excercise-4.a';
proc cluster data=seeds method=average plots(maxpoints=300) standard ccc pseudo;
   var area perimeter compactness length width 
		asymmetry groovelength;
   copy variety;
   ods exclude EigenvalueTable ClusterHistory;
run;

ods text="From the dendrogram plot above we can choose 4 clusters eventhough one of the cluster has very few observations(~5)
and these four cluster groups have well segregated the observations.And we also have plots
for CCC,Pseudo-F,Pseudo- t squared statistics.From CCC statistic plot we have peak value at 4 
for CCC so we choose 4 clusters.In a similar way for the Pseudo-F we have maximum value at 4 
for Pseudo-F statistic so 4 clusters would the choice.But for Pseudo-t squared we look for minimum value and it is at 4,
so 4 clsuters would be the choice in this case as well.";

title 'Excercise-4.b';
* try 3 clusters from dendrogram;
proc tree noprint ncl=4 out=outs4;
   copy area perimeter compactness length width 
		asymmetry groovelength variety;
run;
proc freq data=outs4;
  tables cluster*variety/ nopercent norow nocol;
run;

ods text="From previous step we have chosen 4 clusters, and we grouped observations into 4 cluster groups
 now we compare these cluster groups with the actual varieties of seeds.And from the table above we can see
that cluster-1 has 69 observations with 63 observations from canadian variety,6 observations from kama
variety so this cluster signfies canadian variety seeds with little crossover of Kama variety.
Cluster-2 has 68 observations in total with 59 observations from Kama variety,4 observations from Rosa variety,
5 from Canadian variety so cluster-2 majorly signifes Kama variety with cross over of Rosa,canadian variety.
Where as cluster-3 has only 68 observations and 66 are from Rosa variety,2 from kama variety,so cluster-3 signifies 
Rosa variety with little crossover of kama variety.Where as the fourth cluster has just 5 observations with
cross over between canadian,rosa varieties";

proc means data=seeds;
run;

ods text="Now we compare the two clusterings using scaling and not scaling the variables.And the
scaling apporach clustering performed better than non-sclaing approach by observing the clusters crossover
across varieties and scaling approach has less crossover.The reason being the
fetaures in the seeds data have different magnitudes and by observing above table feature 'area'
has mean of ~15 where as compactness has mean value of 0.87,so the features have diffrent scales/
magntidues and using unscaled fetaures is not a good idea.As a result clustering with scaling features
performed better with little crossover between varieties.";

ods rtf close;