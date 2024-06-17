**************************************************************
*This Program calculates a linear model with 1 latent variable
*for data with missing values (not all individuals are involved 
*in all trials).  The model is:
*            y_nt = a_t + b_t * X_n + e_nt
*  where:    y_nt is the observed variable for nth individual 
*                 tth trial (i.e. ADA score of member n in year t)
*            a_t =  the intercept (shift) for trial t
*            b_t =  the slope (stretch) for trial t
*            X_n =  the true unobserved (assumed constant) characteristic 
*                   of the nth individual in the sample.
*            e_nt = residual error assumes: e_nt~N(0,sigma) where sigma is
*                   is constant accross all individuals and trials.
* 
* In order to idenitify and estimate the model the following information
* is required:
*         o  An observed variable (e.g. ADA score in a given year)
*         o  A variable that uniquely identifies each individual  (e.g. MC)
*         o  A variable that uniquely identifies each trial (e.g. year chamber)
*         o  A scaling restriction setting a a_t=0 & b_t=1 for some trial t
*         
*  SYNTAX:
*     inflat <observed variable>, n(<n identifier>) t(<t identifier>)
*              i(<number of iterations>) cons(<t for a_t=0 b_t=1>) start 
*              disp
*
*     Options:  disp = display more info on what's happening in each interation
*               start = calculate start values for x 
*               i(<iterations>) = number of iterations, 100 is default
*
*
*
*  Jeff Lewis 
*  (jblewis@ucla.edu)
*  2000
* 
*************************************************************************

set more off
capture program drop inflat
program define inflat
version 5.0

set more 1

*************** Parse Arguements ***********************
local varlist "req"
local options "n(string) t(string) cons(string) disp start i(integer 100)" 
parse "`*'"
capture confirm `n'
capture confirm `t'
local year "`t'"
local member "`n'"

************** Setup temp vars & locals ****************
quietly {
capture drop a b
capture drop a_old b_old x_old
gen a_old = .
gen b_old = .
gen x_old = .
tempvar Y yr e2 sig mem isbase
local score "`varlist'"
if "`disp'" == "" { local disp "*" }
gen `sig' = .
gen `e2' = .
gen `Y' = .
}

************** Generate start values **********************
quietly {
if "`start'" != "" { egen x = mean(`score'), by(`member') }
gen a = 0
gen b = 1
}

*************  Give members a number from 1 to N **********
quietly {
sort `member' 
gen `mem' = 0
replace `mem' = 1 if `member' != `member'[_n-1]
replace `mem' = sum(`mem')
summ `mem'
local max = _result(6)
}


************  Give each year a number from 1 to T ******
sort `year'
quietly gen `yr'=0
quietly replace `yr' = 1 if `year'!=`year'[_n-1]
quietly replace `yr' = sum(`yr')
quietly gen `isbase' = `yr' if `year' == `cons'
quietly summ `isbase'
local isbasel = _result(6)
drop `isbase'
quietly summ `yr' 
local minyr = _result(5)
local maxyr = _result(6)

*********** Start the program running *******************
disp "Scaling: `score'"
disp "--------"
disp "Last t = `maxyr'"
disp "Last n = `max'"
disp "Base t = `isbasel'"
disp
pause

local itter = 1
while `itter' <= `i' {
  sort `year'
  disp
  disp "iteration = `itter'"
 ******* Get As & Bs ************
  local yrl = 1
  `disp' "    Finding As and Bs"
  `disp' "      Year: " _continue    
  while `yrl' <= `maxyr' {
    `disp' "`yrl'.." _continue
       if `yrl' != `isbasel' {
	 quietly {
	   reg `score' x if `yr'==`yrl'  
	   matrix b = get(_b)
	   replace a = b[1,2] if `yr' == `yrl' 
	   replace b = b[1,1] if `yr' == `yrl'
	 }
       }
  local yrl = `yrl' + 1
  }
  `disp'

  *******  Get Xs ******************************
  local meml = 1
  sort `mem' `yr'
  quietly replace `Y' = `score' - a
  `disp' "   Finding Xs"
  `disp' "     member: " _continue
  while `meml' < `max' {
     `disp' "`meml'.." _continue
     quietly {
	 capture reg `Y' b if `mem' == `meml', noc
	 if _rc == 0 {
         	matrix b = get(_b)
		replace x=b[1,1] if `mem' == `meml'
		}
	 else {
		`disp' in red " (1 obs) " _continue
		replace x = `Y'/b if `mem' == `meml'
		}
	 }
     local meml = `meml' + 1
   }
`disp'

*** generate llik *****
quietly replace `e2' = (`score' - a - b*x)^2
quietly replace `sig' = sum(`e2')
local sig2 = `sig'[_N] / _N
local llike = -_N * (ln(sqrt(2*_pi*sqrt(`sig2'))) + .5)

********* Setup for Next iteration *******
** Check for convergence **

local conv = .99999999
if `itter' > 1 {
	qui corr x x_old
	local corr = _result(4)
        disp in red "corr x = " _result(4)
	if `corr' > `conv' {
		qui corr b b_old
		local corr = _result(4)
		disp in red "corr b = " _result(4)
		if `corr' > `conv' {
			qui corr a a_old
			local corr = _result(4)
   		        disp in red "corr a = " _result(4)
                    	if `corr' > `conv' {
          			disp in green "Parameters converged"
   			        disp
			        local itter = `i' + 1
			        }
		        }
		}
	}			


** display end of iteration stuff **

disp
disp "Time = $S_TIME"
disp "Sigma = " %8.4f sqrt(`sig2')
disp "Log-likelihood = " %9.4f `llike'
disp in green "10th Obs:"   
disp in green "---------"
disp in green "Parameter" _column(10)"Value" _column(20)"Change"
disp in green "---------" _column(10)"-----" _column(20)"------"
disp in green "a" in yellow _column(10) a[10] _column(20) a[10] - a_old[10]
disp in green "b" in yellow _column(10) b[10] _column(20) b[10] - b_old[10]
disp in green "x" in yellow _column(10) x[10] _column(20) x[10] - x_old[10]
local itter = `itter' + 1
*quietly save c:\temp, replace
replace x_old = x
replace b_old = b
replace a_old = a
}

set more 0
drop x_old b_old a_old
end

*************************************************************************
* The script below sets up the data and then runs the inflat program.
* It can be adjusted for chamber and for the range of congresses 
* by setting global macros. 
* It assumes the data is in a .csv file, with each row holding a member's 
* ideal point, the upper and lower bound for the estimated ideal point, 
* the given congressional session and chamber in which this was 
* estimated, as well as the ICPSR unique identifier for each member. 
*
* For a minimal application, only the ideal point (d1), a unique legislator
* ID variable (eg., icpsrlegis), and the legislative session are required.
* 
* The variable name for the ideal point is d1. If there are more dimensions
* estimated then these would be listed as d1, d2 ... dn. Issue specific
* scores are considered dimensions in this context.
*
* It goes through the following steps: 
*
* 	(1) Normalizing polarity/rotation: 
* 		The code normalizes the polarity. Rather than set the scale at the 
*		of estimation (usually with Democrats on the "left"), we normalized 
* 		the estimates by setting a mean of zero and an SD of 1. The direction 
*		of the scale is  accordingly arbitrary for each session. This can leave 
* 		Democrats on the left or right. We did this because for some issue areas 
*		party might not be a good predictor of the underlying cleavage.
*		But to standardize them across time, we need them to have the correct
*		polarity. We do this by regressing a given Congress's scores on
*		those of the previous Congresses. Where the coefficient is positive
*		we leave the estimates unchanged. Where the coefficient is negative
*		we multiply all of that Congress's coefficients by -1. This can be
*		skipped if the sessions have the same polarity already (as might be
*		the case if estimated using W-NOMINATE). 
*	(2) It then runs the inflat program. See the details above. 
*************************************************************************
 
clear
set mem 2000m
cd "~/Projects/GitHub/senior-essay-24/03. Stata"

** Set global macros and load data. Should be changed to user's specifications.
global firstcong	= 91
global lastcong 	= 117
global issue		= 7
global chamber 		House // Options are House and Senate
insheet using "${chamber}-${firstcong}-to-${lastcong}-Issue-Area-${issue}-wnom_nomissing.csv", clear

** Sort by member and Congress. This makes it easier to inspect the relevant data 
sort icpsr congress

** Adjust polarity for each estimated dimension/issue area. 
foreach k in d1 {
	
	** Create variables to index the previous congress's estimated ideal point
	** for each member in both congresses and a rolling average for all of these. 
	** Create variable to index any new normalized (correct polarity) 
	** adjustments. Starts with just the original estimate.
	gen nextcongress=.
	gen `k'_previous=.
	gen `k'_rolling=.
	gen `k'_norm = `k' 

	** Index all congresses with observations. Some issue areas might be 
	** absent in a given Congress. If there are multipe issue areas (dn) being
	** estimated in the same file, then the missing Congresses might differ. 
	** Store this in a matrix showing list successive observations
	** (eg., 80th, 81st, 83rd, 85th Congresses if no obs for 82nd and 84th). 
	** For most applications, no congressional sessions will be dropped. 
	preserve
		drop if `k'==.
		levelsof congress, local(congress)
		matrix input congress= (`congress')
		local iteration = 1
	restore

	** Use matrix to fill in nextcongress variable.
	foreach l in `congress' {
		sort congress
		local nc = el("congress",1, `iteration'+1) 
		replace nextcongress= `nc' if congress==`l' & `k'!=.
		local iteration = `iteration'+1
	}

	** Gets list of all Congresses in file, regardless of whether some 
	** dimensions/issues have no observations in a given Congress.
	levelsof congress, local(congress)
	
	** Create a matrix to store the coefficients. Can be useful to inspect
	** though mostly just bookkeeping. 
	loc unique = ${lastcong} - ${firstcong} + 1
	matrix a= J(`unique',3, .)
	
	local iteration = 1
	
	** Run through each Congress and make the polarity adjustment.
	foreach l in `congress' {
		
		** Sort by legislator ID and for each ID fill in `k'_previous for each
		** dimension/issue area the normalized estimate from the previous congress.
		** Create a rolling average of that legislator's previous ideal points.
		** It is important here that the bysort command act by legislator but be 
		** sorted by legislator congress. 
		sort icpsr congress
		bys icpsr (congress) : replace `k'_previous = `k'_norm[_n-1]
		bys icpsr (congress) : replace `k'_rolling = sum(`k'_previous)/_n

		** Use the current Congress's ideal point to predict the rolling average
		** of previous Congress's for each member. 
		capture regress `k'_rolling `k'_norm if congress==`l'
		capture matrix b = get(_b)
		local b = el("b",1, 1)
		local r2 = e(r2)

		** We keep the slope information: indexes which congresses we flipped 
		** and relationship of the previous to the subsequent Congress. 
		matrix a[`iteration',1] = `l'
		matrix a[`iteration',2] = `b'
		matrix a[`iteration',3] = `r2'
		local iteration = `iteration'+1

		** Replace the current normalized (correct polarity) ideal point if
		** the coefficient is negative. Keep it as if positive. 
		if `b' <0 {
			replace `k'_norm = `k'*-1 if congress==`l'
		}
		else {
			replace `k'_norm = `k' if congress==`l'
		}
	}
	** No longer need nextcongress variable so drop it. Keep _rolling and 
	** _previous for bookkeeping, though they can also be dropped. 
	drop nextcongress
	** Complete the loop for the first dimension/issue area that is being 
	** adjusted and then returns to the beginning to do the next (if any). 
}


** Since we have reversed the polarity of some Congress's ideal points, we
** also need to do the same with the lower and upper bounds (if these have 
** been estimated). Since this involves renaming (lower becomes upper if 
** flipped) we do it separately from the above code.
*foreach k in d1 {
*	gen lower`k'_norm = lower`k'
*	gen upper`k'_norm = upper`k'
*	replace lower`k'_norm = upper`k'*-1 if `k'_norm==(`k'*-1)
*	replace upper`k'_norm = lower`k'*-1 if `k'_norm==(`k'*-1)
*} 


************************************************************************** 
* Now that all ideal points are on the correct polarity - defined by the 
* previous sessions - we can run the inflat program. 
*
* The code again allows multiple dimensions/issue area codes to be adjusted
* sequentially. To do so, add d2, d3, ... , dn to the first line of the loop.
*
**************************************************************************

** Run inflat program for each estimated dimension/issue area. 
foreach k in d1 {
	** The inflat program has us drop legislators who are missing observations.
	** Since some of these might be non-missing in other dimensions/issue
	** areas, so I preserve the initial file in memory and restore it for each
	** additional dimension/issue area. 
	preserve
		keep if congress>=${firstcong} & congress<=${lastcong}
		
		** If the code were rewritten to include both chambers, 
		** this would be egen group = group(congress chamber). It sets the 
		** time variable t. 
		egen group = group(congress) 
		
		** inflat requires a scaling restriction where a = 0 and b = 1
		** for some time = t. This is an arbitrary imposition, and we use
		** the midpoint of the time series. 
		qui summ group, detail
		global midpoint		= int((r(max)-r(min))/2)
		
		** This is an obsolete part of the code, relevant only where importing
		** a .csv file where there is text (eg NA) in the ideal point variable.
		** This would have been flagged in step (1) Normalizing polarity/rotation
		loc j `k'_norm
		destring `j', replace force
		
		** Drop missing observations.
		drop if `j' == .		
		
		** Run inflat program, seeing the unique legislator identifier 'n' as
		** icpsrlegis, the unique time/session identifier as group, and using
		** the midpoint of the observed groups as the constraint. Run 1000 
		** iterations. 
		inflat `j', n(icpsr) t(group) cons(${midpoint}) i(10) start
		
		** inflat produces the individual and session-specific parameters
		** required for the Groseclose, Levitt, and Snyder (1999) adjustment.
		** The adjustment itself is achieved by subtracting from each member's 
		** ideal point (normalized to be correct polarity) the intercept for 
		** trial 't' ('a') and then dividing by the slope for trial 't'.
		** for trial t
		gen adjust_`k' = (`j' - a) / b
		rename a a_`k'
		rename b b_`k'
		rename x x_`k'
		
		** Make the same adjustments to the upper and lower bounds
		*gen adjust_lower`k' = (lower`k'_norm - a_`k') / b_`k'
		*gen adjust_upper`k' = (upper`k'_norm - a_`k') / b_`k'
		
		** Save as a temporary file. This facilitates merging different
		** dimensions or issue areas if adjusting for multiple. 
		tempfile temp_`k'
		save `temp_`k'', replace
	restore
}

use `temp_d1', clear
** If you estimated multiple dimensions/issue areas, merge them into a common 
** file here. Alternatively, you could save them all in the loop immediately 
** above under unique file names. 
*merge icpsrlegis congress chamber using `temp_d2'

** Order the data so that the adjusted ideal points are upfront. The raw scores 
** (dn, lowerdn, upperdn, dn_norm, lowerdn_norm, upperdn_norm) should not be used. 
** The adjustment parameters (x_dn, ** a_dn, b_dn) and the corrections for 
** polarity (_previous, _rolling) are worth keeping for bookkeeping.

order congress chamber icpsr adjust_d1 // adjust_d2 adjust_lowerd2 adjust_upperd2 ... adjust_dn adjust_lowerdn adjust_upperdn

sort congress chamber

** Save files as .dta or .csv
save "Adjusted-${chamber}-${firstcong}-to-${lastcong}-Issue-Area-${issue}-wnom_nomissing.dta", replace
outsheet using "Adjusted-${chamber}-${firstcong}-to-${lastcong}-Issue-Area-${issue}-wnom_nomissing.csv", replace comma
