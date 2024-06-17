////////////////
//  PREAMBLE  //
////////////////
version 11
capture log close
set more off
clear all

/*	program:	SenatePooledCivilRightsConstrain.do
	task:		Takes the pooled civil rights matrix and imputes positions
				based on members' voting behavior. 
	project:	A House Divided? 
	author:		Bateman, Clinton, and Lapinski */


****************************SETUP **************************
cd "ReplicationFiles"

use "SenatePooledMatrixCivilRightsAgnostic.dta", clear

**************************************************************
** Replace votes where YEA = For Civil Rights expansion


** If voted YEA on Equal Employment Opportunity in 1975
** ... implies supported anti-discrimination in earlier years
local x V382_94
local k V503_92
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local x V503_92
local x V428_91
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local x V428_91
local k V369_81
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local k V334_81
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local x V369_81
local k V168_78
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local k V170_78
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)


** If voted YEA to restore broad civil rights guarantees
** ... implies supported earlier civil rights guarantees
local x V238_102
local k V473_101
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local k V616_101
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

local x V473_101
local k V432_100
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local k V487_100
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

local x V432_100
local k V1288_94
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local k V1249_94
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

local x V1288_94
local k V409_88
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local k V302_88
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted YEA to restore broad civil rights guarantees
** ... implies supported earlier civil rights guarantees
local x V227_102
local k V473_101
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local k V616_101
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

local x V616_101
local k V487_100
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local k V432_100
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

local x V487_100
local k V1288_94
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local k V1249_94
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

local x V1249_94
local k V409_88
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local k V302_88
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted YEA on Civil Rights Act of 1964
** ... implies supported nonsegregated carriers
local x V409_88
local k V308_48
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted YEA on Civil Rights Act of 1964
** ... implies supported jury rights
local x V409_88
local k V94_46
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted YEA on Civil Rights Act of 1964
** ... implies supported anti-lynching
local x V409_88
local k V106_75
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local k V101_75
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted YEA on Civil Rights Act of 1964
** ... implies supported anti-discrimination in schools
local x V409_88
local k V81_81
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported anti-discrimination in public housing
local k V63_81
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)


** If voted YEA on 2006 Re-Authorization of VRA,
** ... implies supported 1992 re-authorization
local x V578_109
local k V460_102
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1981 re-authorization
local x V578_109
local k V687_97
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1975 re-authorization
local x V578_109
local k V329_94
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies opposed removing trigger in 1975
local k V315_94
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies opposed removing section 5 in 1975
local k V318_94
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1971 re-authorization
local x V578_109
local k V342_91
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1965 Act
local x V578_109
local k V178_89
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local x V578_109
local k V78_89
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1960 Civil Rights Act
local x V578_109
local k V284_86
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1957 Civil Rights Act
local x V578_109
local k V105_85
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted YEA on 1981 Re-Authorization of VRA,
** ... implies supported 1975 extension
local x V687_97
local k V329_94
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1971 re-authorization
local x V329_94
local k V342_91
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1965 Act
local x V342_91
local k V178_89
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local x V342_91
local k V78_89
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1960 Civil Rights Act
local x V78_89
local k V284_86
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1957 Civil Rights Act
local x V284_86
local k V105_85
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

****** **********************
** ... implies opposed repeal of 15th amendment (NAY VOTE)
local x V105_85
local k V225_63
replace `k' = 6 if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies support commitment to 15th amendment
local x V225_63
local k V409_45
replace `k' = 1 if `x'==6 & (`k'==. | `k'==9 | `k'==0)


** If voted YEA on Civil Rights Act of 1968 (Housing)
** ... implies supported Civil Rights Act of 1966 (Housing)
local x V346_90
local k V448_89
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted for Civil Rights commission in 1983
** ... implies supported Civil rights commission in earlier years
local x V350_98
local k V663_96
replace `k' = 1 if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local k V124_96
replace `k' = 1 if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local x V663_96
local k V144_88
replace `k' = 1 if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local x V124_96
local k V144_88
replace `k' = 1 if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted YEA on 2006 Re-Authorization of VRA,
** ... implies supported defense of black voting
local x V578_109
local k V95_53
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted YEA on VRA,
**... implies supported defense of black voting
local x V178_89
local k V95_53
replace `k' = 1 if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** ... implies investigating suppression of votes in Mississippi
local k V6_50
replace `k' = 1 if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted NAY on 1957 Civil Rights Act,
** ... implies opposed defense of black voting
local x V105_85
local k V95_53
replace `k' = 1 if `x'==1 & (`k'==. | `k'==9 | `k'==0)

********************************************************************************	
/* Create an outfile with a consistent spacing */
qui replace congress = 9999
qui order congress icpsrlegis icpsrstate dist lstate party2 eh1 eh2 name
qui tostring congress, replace
qui recast str3 congress, force
qui tostring icpsrlegis, replace
qui recast str5 icpsrlegis, force
qui tostring icpsrstate, replace
qui recast str2 icpsrstate, force
qui tostring dist, replace
qui recast str2 dist, force
qui recast str7 lstate, force
qui tostring party2, replace
qui recast str4 party2
qui tostring eh1, replace
qui recast str1 eh1, force
qui tostring eh2, replace
qui recast str1 eh2, force
qui replace eh1="" if eh1=="."
qui replace eh2="" if eh2=="."
qui recast str11 name, force


foreach x of varlist V* {
	replace `x' = 0 if `x'==.
	tostring `x', replace
}

qui ds, has(type string)
qui foreach v of varlist icpsrlegis icpsrstate lstate eh1 eh2 name {
	local spaces : display _dup(245) " "
	local length = substr("`: type `v''",4,.)
	replace `v'=`v'+substr("`spaces'",1,`length' - length(`v'))
	replace `v' = `v'
	local type : type `v' 
	local type : subinstr local type "str" "" 
	format `v' %-`type's
}

qui foreach v of varlist congress dist party2 {
	local spaces : display _dup(245) " "
	local length = substr("`: type `v''",4,.)
	replace `v'=substr("`spaces'",1,`length' - length(`v'))+`v'
	replace `v' = `v'
	local type : type `v' 
	local type : subinstr local type "str" "" 
	format `v' %-`type's
}

outfile using "SenatePooledMatrixCivilRightsConstrained.dat", runtogether replace

