////////////////
//  PREAMBLE  //
////////////////
version 11
capture log close
set more off
clear all

/*	program:	PooledCivilRightsConstrain.do
	task:		Takes the pooled civil rights matrix and imputes positions
				based on members' voting behavior. 
	project:	A House Divided? 
	author:		Bateman, Clinton, and Lapinski */


****************************SETUP **************************
cd "ReplicationFiles"


use "PooledMatrixCivilRightsAgnostic.dta", clear


**************************************************************
** Replace votes where YEA = For Civil Rights expansion

** If voted YEA on Equal Employment Opportunity Act of 1966
** ... implies supported anti-discrimination on carriers
local x V243_89
local k V210_48
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported anti-discrimination in employment in 1950
local k V148_81
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)


** If voted YEA on Civil Rights Act of 1968
** ... implies supported anti-discrimination on carriers
local x V113_90
local k V210_48
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted YEA on Equal Employment Opportunity Act of 1971
** ... implies supported anti-discrimination on carriers
local x V176_92
local k V210_48
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted YEA to restore broad civil rights guarantees
** ... implies supported anti-discrimination on carriers
local x V506_100
local k V210_48
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local x V527_100
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1964 Civil Rights Act
local x V506_100
local k V182_88
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local x V527_100
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted YEA to create new anti-discrimination protections for employees
** ... implies supported anti-discrimination on carriers
local x V871_100
local k V210_48
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local x V127_102
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local x V372_102
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** ... implies supported 1964 Civil Rights Act
local x V871_100
local k V182_88
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local x V127_102
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
local x V372_102
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)


** If voted YEA for Civil Rights Act 1990
** ... implies supported 1964 Act
local x V821_101
local k V182_88
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** If voted YEA on Civil Rights Act of 1991
** ... implies supported Civil Rights Act of 1964
local x V372_102
local k V182_88
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted YEA on 2007 Re-Authorization of VRA,
** ... implies supported 1981 re-authorization
local x V1042_109
local k V228_97
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1975 extension
local k V192_94
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1971 re-authorization
local k V274_91
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1965 VRA
local k V107_89
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1960 Civil Rights Act
local k V102_86
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1957 Civil Rights Act
local k V42_85
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** ... implies supported enforcing 14th Amendment 
local k V105_56
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported amendment retaining right of 
** franchise section in 1890s election law
local k V53_53
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported Lodge Act of 1890 
local k V235_51
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)


** If voted YEA on 1981 Re-Authorization of VRA,
** ... implies supported 1975 extension
local x V228_97
local k V192_94
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1971 re-authorization
local k V274_91
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1965 VRA
local k V107_89
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1960 Civil Rights Act
local k V102_86
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1957 Civil Rights Act
local k V42_85
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported enforcing 14th Amendment 
local k V105_56
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported amendment retaining right of 
** franchise section in 1890s election law
local k V53_53
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported Lodge Act of 1890 
local k V235_51
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)


** If voted YEA on 1975 extension of VRA,
** ... implies supported 1971 re-authorization
local x V192_94
local k V274_91
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1965 VRA
local k V107_89
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1960 Civil Rights Act
local k V102_86
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1957 Civil Rights Act
local k V42_85
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported Removing Poll Taxes in 1949

** ... implies supported enforcing 14th Amendment 
local k V105_56
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported amendment retaining right of 
** franchise section in 1890s election law
local k V53_53
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported Lodge Act of 1890 
local k V235_51
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted YEA on 1971 re-authorization of VRA,
** ... implies supported 1965 VRA
local x V274_91
local k V107_89
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1960 Civil Rights Act
local k V102_86
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1957 Civil Rights Act
local k V42_85
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** ... implies supported enforcing 14th Amendment 
local k V105_56
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported amendment retaining right of 
** franchise section in 1890s election law
local k V53_53
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported Lodge Act of 1890 
local k V235_51
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted YEA on 1965 VRA,
** ... implies supported 1960 Civil Rights Act
local x V107_89
local k V102_86
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1957 Civil Rights Act
local k V42_85
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)


** ... implies supported enforcing 14th Amendment 
local k V105_56
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported amendment retaining right of 
** franchise section in 1890s election law
local k V53_53
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported Lodge Act of 1890 
local k V235_51
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted YEA on 1960 Civil Rights Act
** ... implies supported 1957 Civil Rights Act
local x V102_86
local k V42_85
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported amendment retaining right of 
** franchise section in 1890s election law
local k V53_53
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported Lodge Act of 1890 
local k V235_51
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted YEA on 1957 Civil Rights Act
** ... implies supported amendment retaining right of 
** franchise section in 1890s election law
local x V42_85
local k V53_53
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported Lodge Act of 1890 
local k V235_51
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted YEA on re-authorizing the Civil Rights Commission in 1991
** ... implies supported 1989 re-authorizing
local x V364_102
local k V357_101
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1979 re-authorizing
local k V181_96
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1971 appropriations
local k V53_92
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1970 appropriations
local k V373_91
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1967 re-authorization
local k V89_90
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)
** ... implies supported 1963 re-authorization
local k V72_88
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted YEA on Civil Rights (Housing) Act of 1968
** ... implies supported weaker 1966 Bill
local k V293_89
replace `k' = V113_90 if V113_90==1 & (`k'==. | `k'==9 | `k'==0)


** If voted YEA on Civil Rights Act of 1964
** ... implies supported anti-discrimination on carriers
local x V182_88
local k V210_48
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

** If voted Lodge Bill
** ... implies supported amendment retaining right of 
** franchise section in 1890s election law
local x V235_51
local k V53_53
replace `k' = `x' if `x'==1 & (`k'==. | `k'==9 | `k'==0)

**************************************************************************

** Replace votes where NAY = Against Civil Rights expansion. Here we can
** infer that those who opposed one set of policies (antilynching) would also
** have opposed another set of more radical policies (the VRA, or the Civil Rights Acts)

** Nay on 1957 Civil Rights Act...
** ... implies YEA on repealing Federal supervisison
local x V42_85
local k V315_45
replace `k' = 1 if `x'==6 & (`k'==. | `k'==9 | `k'==0)

** ... implies YEA on repealing Military supervisison
local k V314_45
replace `k' = 1 if `x'==6 & (`k'==. | `k'==9 | `k'==0)

** ... implies NAY on retaining Section Six of Fed. Election Laws in 1893
local k V53_53
replace `k' = `x' if `x'==6 & (`k'==. | `k'==9 | `k'==0)

** ... implies NAY on enforcing 14th Amendment 
local k V105_56
replace `k' = `x' if `x'==6 & (`k'==. | `k'==9 | `k'==0)

** ...implies NAY on 1964 Act
local k V128_88
replace `k' = `x' if `x'==6 & (`k'==. | `k'==9 | `k'==0)
local k V182_88
replace `k' = `x' if `x'==6 & (`k'==. | `k'==9 | `k'==0)

** ...implies NAY on 1965 Act
local k V87_89
replace `k' = `x' if `x'==6 & (`k'==. | `k'==9 | `k'==0)
local k V107_89
replace `k' = `x' if `x'==6 & (`k'==. | `k'==9 | `k'==0)

** ...implies NAY on 1969 Amendments
local k V274_91
replace `k' = `x' if `x'==6 & (`k'==. | `k'==9 | `k'==0)

** ...implies NAY on 1975 Reauthorization
local k V192_94
replace `k' = `x' if `x'==6 & (`k'==. | `k'==9 | `k'==0)
local k V328_94
replace `k' = `x' if `x'==6 & (`k'==. | `k'==9 | `k'==0)

** ...implies NAY on 1981 Reauthorization
local k V228_97
replace `k' = `x' if `x'==6 & (`k'==. | `k'==9 | `k'==0)

** ...implies NAY on 1993 Reauthorization
local k V735_102
replace `k' = `x' if `x'==6 & (`k'==. | `k'==9 | `k'==0)

** ...implies NAY on 2007 Reauthorization
local k V1042_109
replace `k' = `x' if `x'==6 & (`k'==. | `k'==9 | `k'==0)

** Nay on 1965 VRA...
** ... implies YEA on ending Military supervisison
local x V87_89
local k V314_45
replace `k' = 1 if `x'==6 & (`k'==. | `k'==9 | `k'==0)

** ... implies NAY on retaining Section Six of Fed. Election Laws in 1893
local k V53_53
replace `k' = `x' if `x'==6 & (`k'==. | `k'==9 | `k'==0)

** Voting Rights
** If voted for military supervision (NAY on HR 6145), 
** ... implies supported the weak supervision of 1957 and 1960 Acts.
local x V314_45  // Military Supervision
local k V42_85  // Civil Rights Act 1957
replace `k' = 1 if `x'==6 & (`k'==. | `k'==9 | `k'==0)
local k V102_86  // Civil Rights Act 1960
replace `k' = 1 if `x'==6 & (`k'==. | `k'==9 | `k'==0)
local k V106_86  // Civil Rights Act 1960
replace `k' = 1 if `x'==6 & (`k'==. | `k'==9 | `k'==0)

save "PooledMatrixCivilRightsConstrained.dta", replace

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



outfile using "PooledMatrixCivilRightsConstrained.dat", runtogether replace


	
