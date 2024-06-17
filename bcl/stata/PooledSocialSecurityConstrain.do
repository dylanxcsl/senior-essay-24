////////////////
//  PREAMBLE  //
////////////////
version 11
capture log close
set more off
clear all

/*	program:	PooledSocialSecurityConstrain.do
	task:		Takes the pooled SocialSecurity matrix and imputes positions
				based on members' voting behavior.
	project:	A House Divided? 
	author:		Bateman, Clinton, and Lapinski */


****************************SETUP **************************
cd "ReplicationFiles"
use "PooledMatrixSocialSecurityAgnostic.dta", clear

**************************************************************
** Replace votes where YEA = For Social Security expansion

** If voted YEA to enhance benefits for women (widows and former spouses) in 2002
** ... implies supported program's establishment in 1935
local x V666_107
*** V39_74 - Final Passage in the House
*** V38_74 - Effort by determined opponent (Treadway) to recommitt to kill
*** V37_74 - Vote on the rule
local k V39_74
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** ... implies extending And Liberalizes Social Security Benefits To Widows, Children And Dependent Parents,
local k V56_76
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted YEA to remove earnings limit, allowing 
** Senior Citizens to work and still collect benefits
** ... implies supported program's establishment in 1935
local x V635_106
*** V39_74 - Final Passage in the House
local k V39_74
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** ... implies supported increasing senior's annual earnings 
** limit from $11280 to $30000
local k V819_104
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** ... implies supported increasing senior's annual earnings 
local k V723_104
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)


** If voted YEA to increase COLA benefits in 1984
** ... implies supported program's establishment in 1935
local x V875_98
*** V39_74 - Final Passage in the House
local k V39_74
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** ... implies supported increase benefits in 1970 and make future increases automatic
*** V251_91 is motion to recommit with an automatic benefits increase proposal
*** V252_91 is the passage of the bill
local k V251_91
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local k V252_91
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies extending And Liberalizes Social Security Benefits To Widows, Children And Dependent Parents,
local k V56_76
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted YEA to increase benefits in 1973 
** ... implies supported program's establishment in 1935
local x V433_93
*** V39_74 - Final Passage in the House
local k V39_74
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** ... implies extending And Liberalizes Social Security Benefits To Widows, Children And Dependent Parents,
local k V56_76
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted YEA to increase benefits in 1972 
** ... implies supported program's establishment in 1935
local x V498_92
*** V39_74 - Final Passage in the House
local k V39_74
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** ... implies extending And Liberalizes Social Security Benefits To Widows, Children And Dependent Parents,
local k V56_76
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)


** If voted YEA to increase benefits in 1970 and make future increases automatic 
** ... implies supported program's establishment in 1935
local x V251_91
*** V39_74 - Final Passage in the House
local k V39_74
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** ... implies supported increase benefits in 1969
local k V155_91
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported increase benefits in 1961
local k V20_87
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported increase benefits in 1958
local k V167_85
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported increase benefits in 1955
local k V63_84
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported increased benefits and expanded coverage in 1954
local k V101_83
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported increase benefits in 1952
local k V157_82
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported increase benefits and expand coverage in 1950
local k V236_81
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local k V112_81
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies extending And Liberalizes Social Security Benefits To Widows, Children And Dependent Parents,
local k V56_76
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted YEA to increase benefits in 1969
** ... implies supported program's establishment in 1935
local x V155_91
*** V39_74 - Final Passage in the House
local k V39_74
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** ... implies supported increase benefits in 1961
local k V20_87
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported increase benefits in 1958
local k V167_85
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported increase benefits in 1955
local k V63_84
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported increased benefits and expanded coverage in 1954
local k V101_83
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported increase benefits in 1952
local k V157_82
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported increase benefits and expand coverage in 1950
local k V236_81
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local k V112_81
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies extending And Liberalizes Social Security Benefits To Widows, Children And Dependent Parents,
local k V56_76
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)


** If voted YEA to increase benefits in 1961
** ... implies supported program's establishment in 1935
local x V20_87
*** V39_74 - Final Passage in the House
local k V39_74
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** ... implies supported increase benefits in 1958
local k V167_85
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported increase benefits in 1955
local k V63_84
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported increased benefits and expanded coverage in 1954
local k V101_83
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported increase benefits in 1952
local k V157_82
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported increase benefits and expand coverage in 1950
local k V236_81
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local k V112_81
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies extending And Liberalizes Social Security Benefits To Widows, Children And Dependent Parents,
local k V56_76
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted YEA to increase benefits in 1958
** ... implies supported program's establishment in 1935
local x V167_85
*** V39_74 - Final Passage in the House
local k V39_74
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** ... implies supported increase benefits in 1955
local k V63_84
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported increased benefits and expanded coverage in 1954
local k V101_83
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported increase benefits in 1952
local k V157_82
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported increase benefits and expand coverage in 1950
local k V236_81
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local k V112_81
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies extending And Liberalizes Social Security Benefits To Widows, Children And Dependent Parents,
local k V56_76
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)


** If voted YEA to increase benefits in 1955
** ... implies supported program's establishment in 1935
local x V63_84
*** V39_74 - Final Passage in the House
local k V39_74
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported increased benefits and expanded coverage in 1954
local k V101_83
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported increase benefits in 1952
local k V157_82
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported increase benefits and expand coverage in 1950
local k V236_81
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local k V112_81
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies extending And Liberalizes Social Security Benefits To Widows, Children And Dependent Parents,
local k V56_76
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)


** If voted YEA to increase benefits and expand coverege in 1954
** ... implies supported program's establishment in 1935
local x V101_83
*** V39_74 - Final Passage in the House
local k V39_74
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** ... implies supported increase benefits in 1952
local k V157_82
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported increase benefits and expand coverage in 1950
local k V236_81
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local k V112_81
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies extending And Liberalizes Social Security Benefits To Widows, Children And Dependent Parents,
local k V56_76
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted YEA to increase benefits in 1952
** ... implies supported program's establishment in 1935
local x V157_82
*** V39_74 - Final Passage in the House
local k V39_74
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** ... implies supported increase benefits and expand coverage in 1950
local k V236_81
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local k V112_81
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies extending And Liberalizes Social Security Benefits To Widows, Children And Dependent Parents,
local k V56_76
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted YEA to increase benefits and expand coverage in 1950
** ... implies supported program's establishment in 1935
local x V236_81
*** V39_74 - Final Passage in the House
local k V39_74
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

local x V112_81
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies extending And Liberalizes Social Security Benefits To Widows, Children And Dependent Parents,
local k V56_76
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted YEA to increase benefits and expand coverage in 1939
** ... implies supported program's establishment in 1935
local x V56_76
*** V39_74 - Final Passage in the House
local k V39_74
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)



******************************************************************
** Replace votes where NAY = AGAINST Social Security expansion
** If voted AGAINST program's establishment in 1935 
** ... implies opposed increased benefits and expand coverage in 1939
*** V39_74 - Final Passage in the House
local x V39_74
local k V56_76
replace `k' = `x' if `x'==6 & (`k'==. | `k'==9 | `k'==0)
 
** ... implies opposed increased benefits and expand coverage in 1950
local k V112_81
replace `k' = `x' if `x'==6 & (`k'==. | `k'==9 | `k'==0)
local k V236_81
replace `k' = `x' if `x'==6 & (`k'==. | `k'==9 | `k'==0)

** ... implies opposed increased benefits in 1952
local k V157_82
replace `k' = `x' if `x'==6 & (`k'==. | `k'==9 | `k'==0)

** ... implies opposed increased benefits and expand coverege in 1954
local k V101_83
replace `k' = `x' if `x'==6 & (`k'==. | `k'==9 | `k'==0)

** ... implies opposed increased benefits in 1955
local k V63_84
replace `k' = `x' if `x'==6 & (`k'==. | `k'==9 | `k'==0)

** ... implies opposed increased benefits in 1958
local k V167_85
replace `k' = `x' if `x'==6 & (`k'==. | `k'==9 | `k'==0)

** ... implies opposed increased benefits in 1961
local k V20_87
replace `k' = `x' if `x'==6 & (`k'==. | `k'==9 | `k'==0)


** ... implies opposed increased benefits in 1969
local k V155_91
replace `k' = `x' if `x'==6 & (`k'==. | `k'==9 | `k'==0)

** ... implies opposed increased benefits in 1970 and make future increases automatic
local k V252_91
replace `k' = `x' if `x'==6 & (`k'==. | `k'==9 | `k'==0)

** ... implies opposed increased benefits in 1973
local k V433_93
replace `k' = `x' if `x'==6 & (`k'==. | `k'==9 | `k'==0)

** ... implies opposed increased COLA benefits in 1984
local k V875_98
replace `k' = `x' if `x'==6 & (`k'==. | `k'==9 | `k'==0)

******************************************************************

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


qui foreach x of varlist V* {
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
outfile using "PooledMatrixSocialSecurityConstrainedFINAL.dat", runtogether replace


	