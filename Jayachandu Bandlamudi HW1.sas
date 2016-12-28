* Stat -448 : Home work -1 ;
* NetID: bandlmd2 , Name: Jayachandu Bandlamudi;

ods rtf file='C:\Stat 448\Jayachandu Bandlamudi HW1.rtf' ;
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

* Exercise-1;
title Exercise-1.a;
proc univariate data=seeds;
var asymmetry compactness;
ods select Moments BasicMeasures;
run;
title Exercise-1.b;
proc sort data=seeds;
by variety;
run;
proc univariate data=seeds;
var asymmetry compactness;
by variety;
ods select Moments BasicMeasures;
run;


* Exercise-2;
title Exercise-2.a ;
proc univariate data=seeds normal;
  var compactness;
  histogram /normal ;
  probplot / normal(mu=est sigma=est) ;
  ods select TestsForNormality Histogram ProbPlot;
run;
title Exercise-2.b;
proc univariate data=seeds normal;
  var compactness;
  by variety;
  histogram /normal ;
  probplot / normal(mu=est sigma=est);
  ods select TestsForNormality Histogram ProbPlot ;
run;


* Exercise-3;
title Exercise-3.a;
proc univariate data=seeds mu0=0.875;
var compactness;
ods select BasicMeasures TestsForLocation;
run;

title Exercise-3.b;
proc ttest data=seeds side=l;
var compactness;
class variety;
where variety = "Kama" or variety="Rosa";
ods select ConfLimits TTests Equality;
run;


* Exercise-4;
title Exercise-4.a;
proc corr data=seeds pearson spearman;
var  area length  width asymmetry;
ods select PearsonCorr SpearmanCorr;
run; 

title Exercise-4.b;
proc corr data=seeds pearson spearman;
var  area length  width asymmetry;
by variety;
ods select PearsonCorr SpearmanCorr;
run; 

ods rtf close;