////////////////
//  PREAMBLE  //
////////////////
version 11
capture log close
set more off
clear all

/*	program:	CreateFiguresReplication.do
	task:		Calls the files needed to produce the 
				Figures in main text
	project:	A House Divided? 
	author:		Bateman, Clinton, and Lapinski */


******************** SETUP: CHANGE DIRECTORY ********************
cd "C:\Users\David\Documents\My Dropbox\BatemanClintonLapinski\ReplicationFiles"

*****************************************************************
***
*** FIGURE 1: Elite Polarization in Congress, 1877-2013
*** 			
*****************************************************************
*** Calculate polarization using DW-NOMINATE and Common Space
*** These are based on mean rather than median, following Poole and 
*** Rosenthal.
use "AgnosticConstrainedAndDWNOMINATE.dta", clear
collapse (mean) dwnom1 commond1, by(party2 congress)
gen year = 1787+(congress*2)
tempvar a b c d
gen `a' 				= dwnom1 if party2==100
gen `b' 				= dwnom1 if party2==200
gen `c' 				= commond1 if party2==100
gen `d' 				= commond1 if party2==200
bys congress: egen demDW= mean(`a')
bys congress: egen gopDW= mean(`b')
bys congress: egen demCo= mean(`c')
bys congress: egen gopCo= mean(`d')
gen polarDW				= abs(demDW-gopDW)
gen polarCo				= abs(demCo-gopCo)
keep if party2==200

tw 	(scatter polarDW year, connect(l) col(navy) msize(small) mlw(vvthin) mlc(black))	///
	(scatter polarCo year, connect(l) lpat(dash) col(navy) msy(X)  mlw(vthin) )	///
	, graphregion(col(white)) xlab(1877(7)2011, labsize(vsmall) angle(45))	///
	xtitle("") ylab(, nogrid) yscale(off)	///
	legend(ring(0) pos(7) label(1 "DW-NOMINATE") label(2 "Common Space")	///
		size(vsmall) keygap(tiny) rowgap(tiny) 	///
		colgap(tiny) symxsize(large) col(1) ///
		region(color(white) fcolor(white)))		///
	name(Figure1, replace)
		
*****************************************************************
***
*** FIGURE 2: Predicting Votes on Prohibiting the Army at the Polls
*** 			and on Anti-Lynching Legislation using DW-NOMINATE
*** 			
*****************************************************************
use "CounterFactualVotes.dta", clear

*** SELECT A SET OF WELL-KNOWN LEGISLATORS FOR ILLUSTRATION PURPOSES
gen figure = 1 if icpsrlegis==3268 ///
	| icpsrlegis==15448 | icpsrlegis==15094  ///
	| icpsrlegis==15030 | icpsrlegis==15431  ///
	| icpsrlegis==29137 | icpsrlegis==14627  ///
	| icpsrlegis==7568  | icpsrlegis==29939   ///
	| icpsrlegis==3242  | icpsrlegis==99907  ///
	| icpsrlegis==29935 | icpsrlegis==99904 ///
	| icpsrlegis==29767 | icpsrlegis==20912 ///
	| icpsrlegis==8885

replace name = "Ford (R MI)" if icpsrlegis==3268
replace name = "Pelosi (D CA)" if icpsrlegis==15448
replace name = "Delay (R TX)" if icpsrlegis==15094
replace name = "Kasich (R OH)" if icpsrlegis==15030
replace name = "Lewis (D GA)" if icpsrlegis==15431
replace name = "Boehner (R OH)" if icpsrlegis==29137
replace name = "Gingrich (R GA)" if icpsrlegis==14627
replace name = "Powell (D NY)" if icpsrlegis==7568
replace name = "Ryan (R WI)" if icpsrlegis==29939
replace name = "Flynt (D GA)" if icpsrlegis==3242
replace name = "Reagan (R USA)" if icpsrlegis==99907
replace name = "Toomey (R PA)" if icpsrlegis==29935
replace name = "Nixon (R USA)" if icpsrlegis==99904
replace name = "Goode (D VA)" if icpsrlegis==29767
replace name = "Minnick (D ID)" if icpsrlegis==20912
replace name = "Stephens (D-GA)" if icpsrlegis==8885


*** Ending Federal supervision of elections, 1877.
*** Get the cut-line angle from the DW-NOMINATE Files. 
*** Use this to draw a two dimensional cut-line
preserve
	use "nominatecuttingangleshouse.dta", clear
	keep if cong==45 & rcnum==315
	summ clangle
	local angle = r(mean)
	summ mid1
	local mid1 = r(mean)
	summ mid2
	local mid2 = r(mean)
	local radians = `angle'*c(pi)/180	
	local y1 = `mid2' - 1 * sin(`radians')
	local x1 = `mid1' - 1 * cos(`radians')
	local y2 = `mid2' + 1 * sin(`radians')
	local x2 = `mid1' + 1 * cos(`radians')
restore

tw (scatter dwnom2 dwnom1 if partyc==200 ///
		, msymbol(th) msize(small) mlw(vvthin) color(maroon)) ///
	(scatter dwnom2 dwnom1 if partyc==100 ///
		, msymbol(oh) msize(small) mlw(vvthin) color(navy)) ///
	(scatter dwnom2 dwnom1 if figure ==1, msymbol(none) ///
			color(black) mlabel(name) mlabsize(vsmall) mlabcolor(black))  ///
	(function y= (tan(`radians'))*x+`mid2', range(-0.3 0.3)	///
		lwidth(thick) lcolor(black))	/// 
	, graphregion(color(white)) xlab(-1.5(.5)1.5, labsize(vsmall)) ///
	ylab(-1.5(.5)1.5, labsize(vsmall) nogrid) ///
	ytitle("DW-NOMINATE, Second Dimension", size(vsmall)) ///
	xtitle("DW-NOMINATE, First Dimension", size(vsmall)) ///
	legend(off) aspect(1) name(Elections, replace) ///
	text(1 -1.5 "Predicted to Vote to""Prohibit Military""Presence", 	///
		size(vsmall) placement(e) box bcolor(white) just(left))	///
	text(-1.25 1.5 "Predicted to Vote""Against Prohibiting""Military Presence", ///
		size(vsmall) placement(w) box bcolor(white) just(left))	///
	title("Military Presence at Polls, 1877", col(black) size(small))
	
preserve
	use "nominatecuttingangleshouse.dta", clear
	keep if cong==67 & rcnum==169
	summ clangle
	local angle = r(mean)
	summ mid1
	local mid1 = r(mean)
	summ mid2
	local mid2 = r(mean)
	local radians = `angle'*c(pi)/180	
	local y1 = `mid2' - 0.7 * sin(`radians')
	local x1 = `mid1' - 0.7 * cos(`radians')
	local y2 = `mid2' + 1.3 * sin(`radians')
	local x2 = `mid1' + 1.3 * cos(`radians')
restore
		
local coordx1 = `x1'
local coordy1 = `y1'
local coordx2 = `x2'
local coordy2 = `y2'

qui capture drop x1 y1
qui gen x1 = .
qui gen y1 = .
replace x1 = `coordx1' in 1
replace y1 = `coordy1' in 1
replace x1 = `coordx2' in 2
replace y1 = `coordy2' in 2
	
tw (scatter dwnom2 dwnom1 if partyc==200 ///
		, msymbol(th) msize(small) mlw(vvthin) color(maroon)) ///
	(scatter dwnom2 dwnom1 if partyc==100 ///
		, msymbol(oh) msize(small) mlw(vvthin) color(navy)) ///
	(scatter dwnom2 dwnom1 if figure ==1, msymbol(none) ///
			color(black) mlabel(name) mlabsize(vsmall) mlabcolor(black))  ///
	(function y= (tan(`radians'))*x+`mid2', range(-0.4 0.6)	///
		lwidth(thick) lcolor(black))	/// 
	,graphregion(color(white)) xlab(-1.5(.5)1.5, labsize(vsmall)) ///
	ylab(-1.5(.5)1.5, labsize(vsmall) nogrid) ///
	ytitle("DW-NOMINATE, Second Dimension", size(vsmall)) ///
	xtitle("DW-NOMINATE, First Dimension", size(vsmall)) ///
	legend(off) aspect(1) name(Lynchings, replace)	///
	text(1 -1.5 "Predicted to Vote""Against Anti-""Lynching Bill", ///
		size(vsmall) placement(e) box bcolor(white) just(left))	///
	text(-1.25 1.5 "Predicted to Vote""For Anti-""Lynching Bill", ///
		size(vsmall) placement(w) box bcolor(white) just(left))	///
	title("Anti-Lynching, 1922", col(black) size(small))

graph combine 	Elections 	Lynchings	///
				, graphregion(color(white)) name(Figure2, replace)
				
graph display Figure2, ysize(5) xsize(9)
graph drop Elections Lynchings

*****************************************************************
***
*** FIGURE 3: Party Medians on House Civil Rights, 1877-2009
*** 			
*****************************************************************

*** Load the agnostic estimates
*** The agnostic estimates were oriented the wrong way 
*** the last time they were generated, so we flip them. 
use "HouseCongressLevelAgnosticMedians45to110.dta", clear
foreach x of varlist pivot-ndemPivotci975 {
	replace `x' = `x'*-1
}

gen year = 1787+(congress*2)

*** Produce the median graphs
tw  (line demPivotci25 demPivotci975 year, 	///
		lw(vvvthin vvvthin) lc(emidblue emidblue)) ///
	(line gopPivotci25 gopPivotci975 year, 	///
		lw(vvvthin vvvthin) lc(erose erose)) ///
	(line sdemPivotci25 sdemPivotci975 year, 	///
		lw(vvvthin vvvthin) lc(eltgreen eltgreen)) ///
	(scatter demPivot year, connect(l) col(navy) 	///
		msy(o) mlw(vvvthin) mlc(black) msi(small))	///
	(scatter gopPivot year, connect(l) col(maroon) 	///
		msy(th) mlw(vvvthin) msi(small) )	///
	(scatter sdemPivot year, connect(l) col(forest_green) 	///
		lp(dash) msy(oh) mlw(vvvthin) msi(small) )	///
	(line pivot year, lcol(black) 	///
		 lw(vvvthin) )	///
	, graphregion(color(white)) xlab(1877(4)2009, angle(45) labsize(vsmall) )	///
	ylab(, nogrid labsize(vsmall)) ytitle("") xtitle("")	///
	legend(ring(0) col(2) pos(6) label(7 "Democratic") ///
		label(8 "Republicans") label(9 "Southern Democratic") 	///
		label(10 "Chamber Median") ///
		size(vsmall) keygap(tiny) rowgap(tiny) 	///
		colgap(tiny) symxsize(large) order(7 8 9 10) col(1) ///
		region(color(white) fcolor(white)))		///
	name(Figure3, replace) title("Party Medians on Civil Rights, House", size(small) col(black) )


*****************************************************************
***
*** FIGURE 4: Expected Midpoint Locations for Voting Rights Act
*** 			Final Passage Votes, 1952-2006
*** 			
*****************************************************************
*** EstimatedMidpointsCivilRights.dta includes "inferred" midpoints,
*** status quo locations, and policy proposal locations, and are for 
*** illustration only.

use "EstimatedMidpointsCivilRights.dta", clear

gen label1 		= "Midpoint"
gen label2 		= "SQ in 1957" if year==1957
replace label2	= "SQ in 1960" if year==1960
replace label2	= "SQ in 1965" if year==1965
replace label2	= "SQ in 1970 (Non-Reauthorization)" if year==1970
replace label2	= "SQ in 1975 (Non-Re.)" if year==1975
replace label2	= "SQ in 1982 (Non-Re.)" if year==1982
replace label2	= "SQ in 2006 (Non-Re.)" if year==2006
gen label3 		= "Proposal"

gen pos1	= 9 if year==1957 | year==2006
replace pos1= 3 if pos1==.

tw 	(rspike p_location sq_location year, 	///
		lpat(dot) lcol(black) lw(medium))	///
	(scatter p_location sq_location year , ///
		msymbol(x x) color(black black) mlwidth(medium medium) ///
		mlabel(label3 label2) mlabcol(black black) mlabsize(vsmall vsmall) mlabv(pos1)) ///
	(scatter inferredMidpoint year , ///
		msymbol(O) col(white) mlcol(black) mlwidth(vthin) ///
		mlab(label1) mlabsize(vsmall) mlabcol(black) mlabv(pos1)) ///
	, graphregion(color(white)) ylab(-0.75 "Racial Liberalism" .25 "Racial Conservatism" , notick labsize(vsmall) nogrid ) ///
	xlab(1952(2)2006, labsize(vsmall) angle(45)) xtitle("") ///
	yscale(range(-1 0.5))	///
	legend(off)  ///
	name(Figure4, replace)
	
*****************************************************************
***
*** FIGURE 5: Estimated Versus Expected Trajectory of Policy
*** 			Change, 1952-2009
***
*****************************************************************
*** EstimatedMidpointsCivilRights.dta takes the estimated location 
*** of the midpoints for Civil Rights bills' passage. The estimated
*** midpoints are taken from PooledVotesCivilRightsAgnostic.dta, produced
*** when estimating the agnostic scores in IDEAL. 

use "EstimatedMidpointsCivilRights.dta", clear


tw 	(scatter agnMidpoint year , ///
		connect(l) lpa(-.) msymbol(Oh) color(black) mlwidth(vvthin)  yaxis(1) ) ///
	(line pivot year, ///
		lcolor(gs10) lpattern(solid) sort) ///
	, graphregion(color(white)) ylab(-0.5 "Racial Liberalism" 1.75 "Racial Conservatism" , notick labsize(vsmall) nogrid ) ///
	xlab(1957(2)2009, labsize(vsmall) angle(45)) xtitle("") ///
	yscale(range(-0.75 2))	///
	legend(ring(0) pos(11) cols(1) region(color(none) lcolor(white)) ///
		label(1 "Estimated Midpoint") label(2 "House Median") ///
		order(1 2) holes(3 4 5) size(vsmall)) scale(0.85) ///
	note("Note: The estimated midpoint is based on the statistical model of roll call votes" , size(vsmall))	///
	name(Figure5, replace)
*****************************************************************
***
*** FIGURE 6: Party Medians on House Civil Rights,
*** 			Agnostic and Constrained, 1877-2009
***
*****************************************************************
*** Load the constrained estimates
use "HouseCongressLevelConstrainedMedians45to110.dta", clear

*** Rename all of the variables so as to merge
*** the agnostic estimates

foreach x of varlist pivot-polarci975 {
	rename `x' `x'Cons
}
tempfile temp
save `temp', replace

*** Load the agnostic estimates
*** The agnostic estimates were oriented the wrong way 
*** the last time they were generated, so we flip them. 
use "HouseCongressLevelAgnosticMedians45to110.dta"
foreach x of varlist pivot-ndemPivotci975 {
	replace `x' = `x'*-1
}

*** Merge in the constrained estimated
merge 1:1 congress using `temp', nogen
*** Merge in a dataset that counts the number of imputed votes
*** per Congress 
merge 1:1 congress using "HouseImputingCivilRightsInfo.dta", nogen

*** Standardize all the estimates by the value of 
*** polarization in year 1, i.e. the 45th Congress
local modCons = polarCons[1]
local mod = polar[1]

foreach x of varlist pivotCons-polarci975Cons {
	replace `x' = `x'/`modCons'
}
foreach x of varlist pivot-polarci975 {
	replace `x' = `x'/`mod'
}

gen year = 1787+(congress*2)

*** Produce the median graphs
tw 	(line demPivotci25 demPivotci975 demPivotci25Cons demPivotci975Cons year,	///
		lp(solid solid shortdash shortdash) lw(vvvthin vvvthin vvvthin vvvthin) lc(gs10 gs10 gs10 gs10))	///
	(scatter demPivot demPivotCons year,	///
		connect(l l) msy(o none) msize(small small) lp(solid dash) col(navy black) mlc(black) mlw(vthin vthin))	///
	, graphregion(color(white)) xlab(1877(13)2009, labsize(vsmall)) xtitle("") ///
	ylab(-0.5(.25)1, nogrid labsize(vsmall)) legend(off) ///
	title("Democrats", color(black) size(small) ring(0)) name(dem, replace) 

tw 	(line sdemPivotci25 sdemPivotci975 sdemPivotci25Cons sdemPivotci975Cons year,	///
		lp(solid solid shortdash shortdash) lw(vvvthin vvvthin vvvthin vvvthin) lc(gs10 gs10 gs10 gs10))	///
	(scatter sdemPivot sdemPivotCons year,	///
		connect(l l) msy(oh none) msize(small small) lp(solid dash) col(forest_green black) mlw(vthin vthin))	///
	, graphregion(color(white)) xlab(1877(13)2009, labsize(vsmall)) xtitle("") ///
	ylab(-0.5(.25)1, nogrid labsize(vsmall))  ///
	legend(ring(0) col(1) order(5 6) size(small) pos(7) symxsize(large) ///
		label(5 "No Policy Content") label(6 "Policy Content") region(fcol(none) lcol(none))) ///
	title("Southern Democrats", color(black) size(small) ring(0)) name(sdem, replace) 

tw 	(line gopPivotci25 gopPivotci975 gopPivotci25Cons gopPivotci975Cons year,	///
		lp(solid solid shortdash shortdash) lw(vvvthin vvvthin vvvthin vvvthin) lc(gs10 gs10 gs10 gs10))	///
	(scatter gopPivot gopPivotCons year,	///
		connect(l l) msy(th none) msize(small small) lp(solid dash) col(maroon black) mlw(vthin vthin))	///
	, graphregion(color(white)) xlab(1877(13)2009, labsize(vsmall)) xtitle("") ///
	ylab(-0.5(.25)1, nogrid labsize(vsmall)) legend(off) ///
	title("Republicans", color(black) size(small) ring(0)) name(gop, replace) 

*** Identify the years in which more the imputations
*** included more than 10% of members and include in the
*** polarization graph
qui levelsof year if imputingincludes10perofmembers==1, local(year)
tw (line polarci25 polarci975 polarci25Cons polarci975Cons year,	///
		lp(solid solid shortdash shortdash) lw(vvvthin vvvthin vvvthin vvvthin) lc(gs10 gs10 gs10 gs10))	///
	(scatter polar polarCons year,	///
		connect(l l) msy(oh none) msize(small small) lp(solid dash) col(navy black) mlw(vthin vthin))	///
	, graphregion(color(white)) xlab(1877(13)2009, labsize(vsmall)) xtitle("") ///
	xline(`year', lcol(gs10))	legend(off) ///
	ylab(0(.25)1, nogrid labsize(vsmall))  ///
	title("Polarization", color(black) size(small) ring(0) box bcol(white)) name(polar, replace) 
		
graph combine dem gop sdem polar, 	///
	graphregion(color(white)) imargin(zero) 	///
	note("Grey lines in bottom right indicate where more than 10% of members had votes imputed.", size(vsmall))	///
	name(Figure6, replace)
	
graph display Figure6, ysize(11) xsize(8.5)
graph drop dem gop sdem polar
*****************************************************************
***
*** FIGURE 7: Percentage of Imputed Votes, 1877-2006
***
*****************************************************************
*** Load the matrix of civil rights votes
use "PooledMatrixCivilRightsAgnostic.dta", clear

*** Remove the missing or absent votes
qui foreach x of varlist V* {
	replace `x' = . if `x'>=7 | `x'==0
	rename `x' `x'_agn
}

*** Count how many votes were cast by a given member and then drop the rollcalls
egen rcvotescast = rownonmiss(V*)
keep congress-party2 rcvotescast

*** Merge the imputed roll calls
merge 1:1 icpsrlegis using "PooledMatrixCivilRightsConstrained.dta", nogen

*** Remove the missing or absent votes
qui foreach x of varlist V* {
	replace `x' = . if `x'>=7 | `x'==0
}
*** Count how many votes were cast by a given member, including imputed votes.
*** Calculate how many votes and the percentage of votes imputed, per member.
egen rcvotescastimpute = rownonmiss(V*)
gen rcvotesimputed = rcvotescastimpute-rcvotescast
keep congress-party2 rcvotescast rcvotescastimpute rcvotesimputed
drop congres

gen perimputed = rcvotesimputed/rcvotescastimpute
gen chamber = 1

merge 1:m icpsrlegis chamber using "MembersBothChambers.dta", keepusing(congress icpsrstate)
keep if _merge==3
keep if congress>=45 & congress<=110
gen year = 1787+cong*2
gen south = icpsrstate>=40 & icpsrstate<=56 | icpsrstate==11 | icpsrstate==34

preserve
	collapse perimputed, by(congress south party2)
	replace perimputed = perimputed*100
	keep if party2==100 & south==1
	drop party2 south
	rename perimputed south
	tempfile south 
	save `south'
restore
preserve
	collapse perimputed, by(congress party2)
	replace perimputed = perimputed*100
	
	gen dem1 = perimputed if party2==100
	gen gop1 = perimputed if party2==200
	bysort congress: egen dem = max(dem1)
	bysort congress: egen gop = max(gop1)
	
	keep if party2==100 
	drop dem1 gop1 perimputed party2

	merge 1:1 congress using `south'
	merge 1:1 congress using "HouseImputingCivilRightsInfo.dta", nogen
	gen year = 1787+cong*2
	
	qui levelsof year if imputingincludes10perofmembers==1, local(year)
	gen imputed = 1 if imputedrcs==1 | imputedrcs==2
	tw 	(scatter dem year,	///
			connect(l l) msy(o p) msize(small small) ///
			lp(solid dash) col(navy black) mlc(black) mlw(vthin vthin))	///
		(scatter gop year,	///
			connect(l l) msy(th p) msize(small small) ///
			lp(solid dash) col(maroon black) mlw(vthin vthin))	///
		(scatter south year,	///
			connect(l l) msy(oh p) msize(small small) ///
			lp(solid dash) col(forest_green black) mlw(vthin vthin))	///
		(bar imputed year, color(black) yaxis(2) barwidth(0.5))	///
		, graphregion(color(white)) xlab(1877(10)2009, labsize(vsmall)) xtitle("") ///
		ylab(0(10)50, nogrid labsize(vsmall)) ytitle("% of Members' Votes Imputed", size(vsmall)) ///
		yscale(range(0 20) off axis(2))	///
		yscale(range(-3 50) axis(1))	///
		legend(order(1 2 3) ring(0) col(1) size(vsmall) pos(11) symxsize(large) ///
		label(1 "Democrats") label(2 "Republicans") label(3 "Southern Democrats") ///
		region(fcol(none) lcol(none)))  name(Figure7, replace) 
restore
*****************************************************************
***
*** FIGURE 8: Party Medians and Polarization on House 
***				Social Security, 1877-2006
***
*****************************************************************
*** Load the constrained estimates
use "SocialSecurityCongressLevelConstrainedMedians74to110.dta", clear

*** Rename all of the variables so as to merge
*** the agnostic estimates
foreach x of varlist pivot-polarci975 {
	rename `x' `x'Cons
}
	
tempfile temp
save `temp', replace

*** Load the agnostic estimates
*** The agnostic estimates were oriented the wrong way 
*** the last time they were generated, so we flip them. 
use "SocialSecurityCongressLevelAgnosticMedians74to110.dta"

foreach x of varlist pivot-ndemPivotci975 {
	replace `x' = `x'*-1
}

*** Merge in the constrained estimated

merge 1:1 congress using `temp', nogen

*** Standardize all the estimates by the value of 
*** polarization in year 1, i.e. the 45th Congress
local modCons = polarCons[1]
local mod = polar[1]

foreach x of varlist pivotCons-polarci975Cons {
	replace `x' = `x'/`modCons'
}
foreach x of varlist pivot-polarci975 {
	replace `x' = `x'/`mod'
}

gen year = 1787+(congress*2)

tw 	(line demPivotci25 demPivotci975 demPivotci25Cons demPivotci975Cons year,	///
		lp(solid solid shortdash shortdash) lw(vvvthin vvvthin vvvthin vvvthin) lc(gs10 gs10 gs10 gs10))	///
	(scatter demPivot demPivotCons year,	///
		connect(l l) msy(o none) msize(small small) lp(solid dash) col(navy black) mlc(black) mlw(vthin vthin))	///
	, graphregion(color(white)) xlab(1935(10)2005, labsize(vsmall)) xtitle("") ///
	ylab(, nogrid labsize(vsmall)) legend(off) ///
	title("Democrats", color(black) size(small) ring(0)) name(dem, replace) 

tw 	(line gopPivotci25 gopPivotci975 gopPivotci25Cons gopPivotci975Cons year,	///
		lp(solid solid shortdash shortdash) lw(vvvthin vvvthin vvvthin vvvthin) lc(gs10 gs10 gs10 gs10))	///
	(scatter gopPivot gopPivotCons year,	///
		connect(l l) msy(th none) msize(small small) lp(solid dash) col(maroon black) mlw(vthin vthin))	///
	, graphregion(color(white)) xlab(1935(10)2005, labsize(vsmall)) xtitle("") ///
	ylab(, nogrid labsize(vsmall)) legend(off) ///
	title("Republicans", color(black) size(small) ring(0)) name(gop, replace) 

tw (line polarci25 polarci975 polarci25Cons polarci975Cons year,	///
		lp(solid solid shortdash shortdash) lw(vvvthin vvvthin vvvthin vvvthin) lc(gs10 gs10 gs10 gs10))	///
	(scatter polar polarCons year,	///
		connect(l l) msy(oh none) msize(small small) lp(solid dash) col(navy black) mlw(vthin vthin))	///
	, graphregion(color(white)) xlab(1935(10)2005, labsize(vsmall)) xtitle("") ///
	ylab(, nogrid labsize(vsmall))  ///
	legend(ring(0) col(1) order(5 6) size(small) pos(4) symxsize(large) ///
	label(5 "No Policy Content") label(6 "Policy Content") region(fcol(none) lcol(none))) ///
	title("Polarization", color(black) size(small) ring(0)) name(polar, replace) 
	
graph combine dem gop polar, 	///
	graphregion(color(white)) imargin(zero) 	///
	name(Figure8, replace)
	
graph drop dem gop polar

******************************************************************************
*** Save files
******************************************************************************
graph display Figure1
graph export "Figures\Figure1.png", height(1600) replace	
graph export "Figures\Figure1.pdf", fontface("Times New Roman") replace	

graph display Figure2
graph export "Figures\Figure2.png", height(1600) replace	
graph export "Figures\Figure2.pdf", fontface("Times New Roman") replace	

graph display Figure3
graph export "Figures\Figure3.png", height(1600) replace	
graph export "Figures\Figure3.pdf", fontface("Times New Roman") replace	

graph display Figure4
graph export "Figures\Figure4.png", height(1600) replace	
graph export "Figures\Figure4.pdf", fontface("Times New Roman") replace	

graph display Figure5
graph export "Figures\Figure5.png", height(1600) replace	
graph export "Figures\Figure5.pdf", fontface("Times New Roman") replace	

graph display Figure6
graph export "Figures\Figure6.png", height(1600) replace	
graph export "Figures\Figure6.pdf", fontface("Times New Roman") replace	

graph display Figure7
graph export "Figures\Figure7.png", height(1600) replace	
graph export "Figures\Figure7.pdf", fontface("Times New Roman") replace	

graph display Figure8
graph export "Figures\Figure8.png", height(1600) replace	
graph export "Figures\Figure8.pdf", fontface("Times New Roman") replace	

