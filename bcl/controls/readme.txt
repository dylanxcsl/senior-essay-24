********************************************************************
File outlines the steps to reproduce the analyses in:

"A House Divided? Roll Calls, Polarization, and Policy Differences
in the U.S. House, 1877–2011" 
- David Bateman, Joshua Clinton, John Lapinski

An additional file outlines the steps needed to reproduce the remaining
analyses in the appendix: appendixreadme.txt
********************************************************************
There are 25 files, command and data, needed to replicate the analyses 
in the main text. These are first listed, and then described in more detail.

**************************************************************************
All data analyses in this article were carried out using either 
Stata IC/11 for Windows (64-Bit x86-64) or .R Version 3.1.2, using 
.R packages pscl (Version 1.4.6) and RJAGS (Version 3-14). 
**************************************************************************
FULL LIST OF DATA FILES

1. PooledMatrixCivilRightsAgnostic.dat
2. PooledMatrixSocialSecurityAgnostic.dat
3. PooledMatrixCivilRightsConstrained.dat
4. PooledMatrixSocialSecurityConstrained.dat
5. MembersBothChambers.txt

Stata Data Files
6. PooledMatrixCivilRightsAgnostic.dta
7. PooledMatrixSocialSecurityAgnostic.dta
8. PooledMatrixCivilRightsConstrained.dta
9. HouseCongressLevelAgnosticMedians45to110.dta
10. HouseCongressLevelConstrainedMedians45to110.dta
11. SocialSecurityCongressLevelAgnosticMedians74to110.dta
12. SocialSecurityCongressLevelConstrainedMedians74to110.dta
13. nominatecuttingangleshouse.dta
14. AgnosticConstrainedAndDWNOMINATE.dta
15. CounterFactualVotes.dta
16. EstimatedMidpointsCivilRights.dta
17. HouseImputingCivilRightsInfo.dta
18. MembersBothChambers.dta

*************************************************************************
FULL LIST OF COMMAND FILES
Stata Command Files
19. PooledCivilRightsConstrain.do
20. PooledSocialSecurityConstrain.do
21. CreateFiguresReplication.do

R Command Files
22. EstimateConstrainedCalculateMedian.R
23. EstimateAgnosticCalculateMedian.R
24. SocialSecurityEstimateAgnosticCalculateMedian.R
25. SocialSecurityEstimateConstrainedCalculateMedian.R
*************************************************************************
REPRODUCING THE ESTIMATES AND ANALYSES

Step One: Setting up the roll call matrices.

There are four separate roll call files, for the main analyses
and for the extension to Social Security.
 
The first two (1-2) are simple matrices of roll call votes, in the 
KH format supported by the r package pscl. 

Civil rights and Social Security votes were identified using 
the Lapinski/Katznelson coding scheme (2006). 

The variables are listed as VXXX_YY, where XXX is the roll call 
number in a given Congress and YY is the Congress number.

1. PooledMatrixCivilRightsAgnostic.dat
2. PooledMatrixSocialSecurityAgnostic.dat

The next two (3-4) are the same matrices, but with imputed
votes for selected roll calls. 

3. PooledMatrixCivilRightsConstrained.dat
4. PooledMatrixSocialSecurityConstrained.dat

The imputation is done in the Stata .do files:

1. PooledCivilRightsConstrain.do
2. PooledSocialSecurityConstrain.do

The roll call matrices are used in Step Two to estimate ideal points.

********************************************************************
Step Two: Estimating ideal points.

Four files estimate ideal points using IDEAL and calculate
the medians, for the chamber, each party, and for southern 
and northern Democrats, including confidence intervals; 
polarization, i.e. the absolute difference between the 
two party medians, with confidence intervals.

IDEAL is available in the R package pscl (Version 1.4.6)

These files are:
1. EstimateConstrainedCalculateMedian.R
2. EstimateAgnosticCalculateMedian
3. SocialSecurityEstimateAgnosticCalculateMedian.R
4. SocialSecurityEstimateConstrainedCalculateMedian.R

They each generate three Stata .dta files and one R data image:

1. .RDATA files: saved data image after IDEAL has estimated ideal points and vote parameters.
(a) PooledIdealCivilRightsAgnostic.RData: not included, produced by .R file.
(b) PooledIdealCivilRightsConstrained.RData: not included, produced by .R file.
(c) PooledIdealSocialSecurityAgnostic.RData: not included, produced by .R file3. 4. (d) (d) PooledIdealSocialSecurityConstrained.RData: not included, produced by .R file..

2. .dta files: Ideal points for individual representative/senators
(a) PooledIdealCivilRightsAgnostic.dta: not included, produced by .R file.
(b) PooledIdealCivilRightsConstrained.dta: not included, produced by .R file.
(c) PooledIdealSocialSecurityAgnostic.dta: not included, produced by .R file.
(d) PooledIdealSocialSecurityConstrained.dta: not included, produced by .R file.

3. .dta files: Estimated vote parameters for the roll calls
(a) PooledVotesCivilRightsAgnostic.dta: not included, produced by .R file.
(b) PooledVotesCivilRightsConstrained.dta: not included, produced by .R file.
(c) PooledVotesSocialSecurityAgnostic.dta: not included, produced by .R file.
(d) PooledVotesSocialSecurityConstrained.dta: not included, produced by .R file.

4. .dta files: Congress-level medians, polarization, and confidence intervals.
(a) HouseCongressLevelAgnosticMedians45to110.dta: Included.
(b) HouseCongressLevelConstrainedMedians45to110.dta: Included.
(c) SocialSecurityCongressLevelAgnosticMedians45to110.dta: Included.
(d) SocialSecurityCongressLevelConstrainedMedians45to110.dta: Included.

They rely on the roll call matrices, discussed above, as well 
as another file [MembersBothChambers.txt] that lists congressional 
membership for each House and Senate. This allows us to identify from 
the combined matrix just those members who sat in a particular Congress.

********************************************************************
Step Three: Producing Median/Polarization Graphs

All Figures in the main text and appendix are produced by the Stata .do files:

1. CreateFiguresReplication.do
2. CreateAppendixFiguresReplication.do
 
More details of the Appendix files are discussed in appendixreadme.txt

Details on each of the figures are provided in the .do files. The .do files 
rely primarily on the files produced in Step Two, and especially on the 
4th type of file: the Congress-level estimates for the party and regional medians, 
polarization, and the confidence intervals. They also use DW-NOMINATE scores, 
Common Space Scores, and the cut-line angles estimated in NOMINATE, available 
from www.voteview.com.

The additional files needed to produce these figures are:

1. nominatecuttingangleshouse.dta -- Cut-line angles from NOMINATE
2. AgnosticConstrainedAndDWNOMINATE.dta -- Merged file with DW-NOMINATE and our scores
3. CounterFactualVotes.dta -- Matrix of votes, with DW-, Common, and our Scores
4. EstimatedMidpointsCivilRights.dta -- The "inferred" midpoints and estimated midpoints
5. HouseImputingCivilRightsInfo.dta -- Count of how many votes were imputed
6. MembersBothChambers.dta -- List of members
