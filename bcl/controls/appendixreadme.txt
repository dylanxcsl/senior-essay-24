********************************************************************
File outlines the steps to reproduce the analyses in the 
Online Appendix for:

"A House Divided? Roll Calls, Polarization, and Policy Differences
in the U.S. House, 1877–2011" 
- David Bateman, Joshua Clinton, John Lapinski
**************************************************************************

All data analyses in this article were carried out using either 
Stata IC/11 for Windows (64-Bit x86-64) or .R Version 3.1.2, using 
.R packages pscl (Version 1.4.6) and RJAGS (Version 3-14). 

********************************************************************
There are 30 files, command and data, needed to replicate the analyses 
in the online appendix. 

These are first listed, and then described in more detail.

*************************************************************************
FULL LIST OF DATA FILES

1. SenatePooledMatrixCivilRightsAgnostic.dat
2. SenatePooledMatrixCivilRightsConstrained.dat
3. PooledMatrixCivilRightsConstrainedRandomProb25ImputationIter3.dat
4. PooledMatrixCivilRightsConstrainedRandomProb25ImputationIter5.dat
5. PooledMatrixCivilRightsConstrainedRandomProb25ImputationIter8.dat
6. MembersBothChambers.txt

Stata Data Files
7. SenatePooledMatrixCivilRightsAgnostic.dta
8. SenateCongressLevelAgnosticMedians45to110.dta
9. SenateCongressLevelConstrainedMedians45to110.dta
10. AdjustedCivilRightsIdealEstimates45to109.dta
11. AgnosticOneCongressTimeCivilRights.dta
12. ConstrainedOneCongressTimeCivilRights.dta
13. APRECivilRightsFinal.dta
14. CombinedLegisIdealOneCongressTimeCivilRights.dta
15. SenateAgnosticAndConstrained.dta
16. AgnosticConstrainedAndDWNOMINATE.dta
17. CivilRightsVotesPerCongress.dta
18. CounterFactualVotes.dta
19. EstimatedMidpointsCivilRights.dta
20. MembersBothChambers.dta
21. VaryImputations.dta
22. MidpointsConstrainedHouseCongressLevelMedians45to110.dta 
23. PolarizationByPartyLabels.dta 

*************************************************************************
FULL LIST OF COMMAND FILES
Stata Command Files
24. SenatePooledCivilRightsConstrain.do
25. CalculateAPRE.do
26. CreateAppendixFiguresReplication.do

R Command Files
27. ConstrainMidpointsCalculateMedian.R
28. SenateEstimateAgnosticCalculateMedian.R
29. SenateEstimateConstrainedCalculateMedian.R

Command File for RJAGS
30. OneCongressAtTime.bug
*************************************************************************
REPRODUCING THE ESTIMATES AND ANALYSES FOR THE ONLINE APPENDIX

Step One: Setting up the roll call matrices for the Senate.

There are two separate roll call files, for the extension 
of the analysis to the Senate in the appendix.

The first is a simple matrix of civil rights roll call votes
, in the KH format supported by the r package pscl. 
 
The variables are listed as VXXX_YY, where XXX is the roll call 
number in a given Congress and YY is the Congress number.

1. SenatePooledMatrixCivilRightsAgnostic.dat

The second is the same matrix, but with imputed
votes for selected roll calls. 

2. SenatePooledMatrixCivilRightsConstrained.dat

The imputation is done in the Stata .do files:

1. SenatePooledCivilRightsConstrain.do

The roll call matrices are used in Step Two to estimate ideal points.

********************************************************************
Step Two: Estimating Senate Civil Rights ideal points.

Two files estimate ideal points using IDEAL and calculate
the medians, for the chamber, each party, and for southern 
and northern Democrats, as well as polarization, all with
confidence intervals.

These files are:
1. SenateEstimateConstrainedCalculateMedian.R
2. SenateEstimateAgnosticCalculateMedian.R

They each generate three Stata .dta files and one R data image:

1. .RDATA files: saved data image after IDEAL has estimated ideal points and vote parameters.
(a) SenatePooledIdealCivilRightsAgnostic.RData: not included, produced by .R file.
(b) SenatePooledIdealCivilRightsConstrained.RData: not included, produced by .R file.

2. .dta files: Ideal points for individual representative/senators
(a) SenatePooledIdealCivilRightsAgnostic.dta: not included, produced by .R file.
(b) SenatePooledIdealCivilRightsConstrained.dta: not included, produced by .R file.

3. .dta files: Estimated vote parameters for the roll calls
(a) SenatePooledVotesCivilRightsAgnostic.dta: not included, produced by .R file.
(b) SenatePooledVotesCivilRightsConstrained.dta: not included, produced by .R file.

4. .dta files: Congress-level medians, polarization, and confidence intervals.
(a) SenateCongressLevelAgnosticMedians45to110.dta: Included.
(b) SenateCongressLevelConstrainedMedians45to110.dta: Included.

They rely on the roll call matrices, discussed above, as well 
as another file [MembersBothChambers.txt] that lists congressional 
membership for each House and Senate. This allows us to identify from 
the combined matrix just those members who sat in a particular Congress.


********************************************************************
Step Three: Alternative Ways to Estimate Scores

We have included a variety of alternative ways of estimating 
the Civil Rights scores. 

1. Groseclose, Levitt, and Snyder (GLS) adjustement of Congress-level scores
2. Constrain the vote parameters, at the Congress-level or in a pooled matrix
3. Impute votes on a probabilistic basis

1. The GLS-adjustment is generated by subsetting civil rights votes for each Congress
and estimating a Congress-level score in IDEAL. A program implementing the 
GLS-adjustment is then applied to these scores, theoretically placing
the individual level ideal points on a common scale. The major limitation of this
approach is that Civil Rights was frequently not voted on or received only a small
number of votes. As a result, the scores are often quite erratic. Another limitation
of the GLS-technique is that voting needs to be on the same dimension across all 
Congresses, leading to highly inflated adjusted scores if not.

The adjusted-civil rights scores are included in:
- AdjustedCivilRightsIdealEstimates45to109.dta 

These were generated for each congress using the roll calls included
in PooledMatrixCivilRightsAgnostic.dat, used for the main analysis. The file includes
a few variables of importance: D1, the raw IDEAL-produced score; D1_norm, the 
raw score placed on a consistent orientation; and a series of congress- and individual-
paramaters xD1, aD1, and bD1. The last two are used to produce the adjusted score,
adjustD1.

2. An alternative way to proceed is to draw on the technique outlined by 
Nokken and Poole: estimate a pooled matrix, hold the vote parameters fixed on the
basis of these estimates, and then re-estimate Congress or pooled scores 
around these constrained parameters.

We have proceeded in two ways. We estimate a constant score with an agnostic pooled
matrix, and use the estimated vote parameters to provide a fixed midpoint in 
an RJAGS code [OneCongressAtTime.Bug]. We also estimate a constant score in a pooled
matrix in which we use the vote parameters from the agnostic estimation as a hard
prior for the Discrimination parameter in IDEAL.

The files to replicate these estimates are:
- OneCongressAtTime.Bug
- ConstrainMidpointsCalculateMedian.R

The files generated by these are:
- AgnosticOneCongressTimeCivilRights.dta 
- ConstrainedOneCongressTimeCivilRights.dta 
- MidpointsConstrainedHouseCongressLevelMedians45to110.dta 

3. A final alternative was to impute votes but to do so on a probabilistic basis.
Each potential vote imputation in PooledCivilRightsConstrain.do was imputed
based on a pre-defined probability. The analyses here were from a .25 probability. 
Because the estimation procedure can be time-consuming, we generated only a dozen
of roll call matrices at this probabilityl level and then selected the one with the 
fewest imputations, the most imputations, and an average number of imputations.

The roll call matrices selected were:
- PooledMatrixCivilRightsConstrainedRandomProb25ImputationIter3.dat
- PooledMatrixCivilRightsConstrainedRandomProb25ImputationIter5.dat
- PooledMatrixCivilRightsConstrainedRandomProb25ImputationIter8.dat

The same IDEAL code used to produce the other estimates was used to 
estimate scores using the matrices with probabilistic imputations.

The estimated produced from these roll call files were combined in:
- VaryImputations.dta 

********************************************************************
Step Four: Producing The Appendix Figures and Appendix Table

All Figures in the main text and appendix are produced by the Stata .do files:

1. CreateFiguresReplication.do
2. CreateAppendixFiguresReplication.do
 
Details on each of the figures are provided in the .do files. The .do files 
rely primarily on the files produced in Step Two, and especially on the 
4th type of file: the Congress-level estimates for the party and regional medians, 
polarization, and the confidence intervals. They also use DW-NOMINATE scores, 
Common Space Scores, the cut-line angles estimated in NOMINATE, available 
from www.voteview.com, as well as other files in which estimates were produced
by other means.

Additional files needed to produce these figures, not discussed above, are:

1. SenateAgnosticAndConstrained.dta -- Agnostic and constrained Senate scores
2. AgnosticConstrainedAndDWNOMINATE.dta -- Merged file with DW-NOMINATE and our scores
3. CivilRightsVotesPerCongress.dta -- Count of votes on Civil rights per Congress
4. CounterFactualVotes.dta -- Matrix of votes, with DW-, Common, and our Scores
5. EstimatedMidpointsCivilRights.dta -- The "inferred" midpoints and estimated midpoints
6. MembersBothChambers.dta -- List of members
7. PolarizationByPartyLabels.dta -- Example of label/region based imputation.

To create the table of predicted votes and APRE, we use the file:
- CalculateAPRE.do

This cycles through all the roll call votes, estimates a probit regression
of vote choice, and calculates APRE and the percent correctly predicted. It 
then produces summary statistics for the different types of scores.