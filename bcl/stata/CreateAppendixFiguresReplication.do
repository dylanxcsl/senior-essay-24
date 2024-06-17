////////////////
//  PREAMBLE  //
////////////////
version 11
capture log close
set more off
clear all

/*	program:	CreateAppendixFiguresReplication.do
	task:		Calls the files needed to produced the 
				Figures in the appendix
	project:	A House Divided? 
	author:		David Bateman */


****************************SETUP **************************
cd "ReplicationFiles"

********************************************************************************
*** APPENDIX FIGURE A1: Measuring Polarization: Two Ways, Two Chambers
***						Two Estimators, 1877-2009
********************************************************************************
use "AgnosticConstrainedAndDWNOMINATE.dta", clear
collapse (p25) CRAgn25=civilRightsAgn CRCons25=civilRightsCons (p75) 	///
	CRAgn75=civilRightsAgn CRCons75=civilRightsCons (p10) CRAgn10=civilRightsAgn ///
	CRCons10=civilRightsCons (p90) CRAgn90=civilRightsAgn CRCons90=civilRightsCons, by(congress)
gen year = 1787+(congress*2)
gen polarAgn1	= abs(CRAgn25-CRAgn75)
gen polarCons1	= abs(CRCons25-CRCons75)
gen polarAgn2	= abs(CRAgn10-CRAgn90)
gen polarCons2	= abs(CRCons10-CRCons90)

local modAgn = polarAgn1[1]
local modCons = polarCons1[1]
replace polarAgn1 = polarAgn1/`modAgn'
replace polarAgn2 = polarAgn2/`modAgn'
replace polarCons1 = polarCons1/`modCons'
replace polarCons2 = polarCons2/`modCons'

tw 	(scatter polarAgn1 year, connect(l) col(navy) msize(small) mlw(vvthin) mlc(black))	///
	(line polarCons1 year, connect(l) lpat(dash) col(black) )	///
	, graphregion(col(white)) xlab(1877(13)2011, labsize(vsmall) )	///
	xtitle("") ylab(, nogrid labsize(vsmall)) legend(off) name(House2575, replace)	///
	title("House: 75th and 25th Percentiles", size(small) col(black))

tw 	(scatter polarAgn2 year, connect(l) col(navy) msize(small) mlw(vvthin) mlc(black))	///
	(line polarCons2 year, connect(l) lpat(dash) col(black) )	///
	, graphregion(col(white)) xlab(1877(13)2011, labsize(vsmall) )	///
	xtitle("") ylab(, nogrid labsize(vsmall)) legend(off) name(House1090, replace)	///
	title("House: 90th and 10th Percentiles", size(small) col(black))
	
	
use "SenateAgnosticAndConstrained.dta", clear
collapse (p25) CRAgn25=civilRightsAgn CRCons25=civilRightsCons (p75) 	///
	CRAgn75=civilRightsAgn CRCons75=civilRightsCons (p10) CRAgn10=civilRightsAgn ///
	CRCons10=civilRightsCons (p90) CRAgn90=civilRightsAgn CRCons90=civilRightsCons, by(congress)
gen year = 1787+(congress*2)
gen polarAgn1	= abs(CRAgn25-CRAgn75)
gen polarCons1	= abs(CRCons25-CRCons75)
gen polarAgn2	= abs(CRAgn10-CRAgn90)
gen polarCons2	= abs(CRCons10-CRCons90)

local modAgn = polarAgn1[1]
local modCons = polarCons1[1]
replace polarAgn1 = polarAgn1/`modAgn'
replace polarAgn2 = polarAgn2/`modAgn'
replace polarCons1 = polarCons1/`modCons'
replace polarCons2 = polarCons2/`modCons'

tw 	(scatter polarAgn1 year, connect(l) col(navy) msize(small) mlw(vvthin) mlc(black))	///
	(line polarCons1 year, connect(l) lpat(dash) col(black) )	///
	, graphregion(col(white)) xlab(1877(13)2011, labsize(vsmall) )	///
	xtitle("") ylab(, nogrid labsize(vsmall)) legend(off) name(Senate2575, replace)	///
	title("Senate: 75th and 25th Percentiles", size(small) col(black))

tw 	(scatter polarAgn2 year, connect(l) col(navy) msize(small) mlw(vvthin) mlc(black))	///
	(line polarCons2 year, connect(l) lpat(dash) col(black) )	///
	, graphregion(col(white)) xlab(1877(13)2011, labsize(vsmall))	///
	xtitle("") ylab(, nogrid labsize(vsmall)) name(Senate1090, replace)	///
	legend(ring(0) col(1) size(small) pos(7) symxsize(large) ///
		label(1 "No Policy Content") label(2 "Policy Content") region(fcol(none) lcol(none))) ///
	title("Senate: 90th and 10th Percentiles", size(small) col(black))

graph combine 	House2575 House1090 Senate2575 Senate1090	///
	, graphregion(color(white)) imargin(tiny) ycommon name(FigureA1, replace)

graph display FigureA1, ysize(8.5) ysize(11)
graph drop House2575 House1090 Senate2575 Senate1090
*****************************************************************
*** APPENDIX FIGURE A2: Polarization Using Issue-Specific
*** 						Civil Rights Votes, 1877-2009
*****************************************************************
use "HouseCongressLevelAgnosticMedians45to110.dta", clear
foreach x of varlist pivot-ndemPivotci975 {
	replace `x' = `x'*-1
}
gen year = 1787+(congress*2)

tw 	(scatter polar year, connect(l) col(navy) msize(small) mlw(vvthin) mlc(black))	///
	, graphregion(col(white)) xlab(1877(7)2011, labsize(vsmall) )	///
	ytitle("Polarization", size(vsmall)) xtitle("") ylab(, nogrid labsize(vsmall)) legend(off) name(FigureA2, replace)	///
	title("Polarization, House Votes on Civil Rights", size(small) col(black))

********************************************************************************
*** APPENDIX FIGURE A3: House Party Medians on Civil rights, 1877–2005:
*** 					Groseclose, Levitt, and Snyder Adjustment 
********************************************************************************
use "AdjustedCivilRightsIdealEstimates45to109.dta", clear
replace adjust = adjust*-1
gen south = icpsrstate>=40 & icpsrstate<=49 | icpsrs==54
gen year = 1787+(congress*2)
*** A problem with GLS-adjustment is that ideal points
*** need to be on a single dimension. If there is substantial
*** off-dimensional voting, the estimates explode. This happens
*** in 1963.
drop if year==1963

preserve
	collapse adjust, by(year partycode)
	tempvar a b 
	gen `a' = adjust if partycode==100
	gen `b' = adjust if partycode==200 
	bys year: egen dem = mean(`a')
	bys year: egen gop = mean(`b')
	keep if partycode==100 
	keep year dem gop
	tempfile temp
	save `temp'
restore
preserve
	collapse adjust, by(year partycode south)
	keep if partycode==100 & south==1
	rename adjust sdem
	keep year sdem

	merge 1:1 year using `temp' ,nogen
	
tw 	(line sdem year,	///
		lp(dash) col(forest_green) )	///
	(line dem year,	///
		lp(solid) col(navy) mlc(black) )	///
	(line gop year,	///
		 lp(-.) col(maroon)  )	///
	, graphregion(color(white)) xlab(1877(13)2009, labsize(vsmall)) xtitle("") ///
	ylab(, nogrid labsize(vsmall))  ///
	legend(ring(0) col(1) size(vsmall) pos(1) symxsize(large) ///
		label(2 "Democratic") label(3 "Republican") 	///
		label(1 "Southern Democratic")	///
		region(fcol(none) lcol(none))) ///
	name(FigureA3, replace) 
restore	
********************************************************************************
*** APPENDIX FIGURE A4: House Party Medians on Civil rights, 1877–2005:
*** 					Nokken-Poole Technique 
********************************************************************************
use "AgnosticOneCongressTimeCivilRights.dta", clear
replace dem		= dem*-1
replace sdem	= sdem*-1
replace gop		= gop*-1

gen year = 1787+(congress*2)

tw 	(scatter sdem year,	///
		connect(l) msym(oh) msize(small) lp(dash) col(forest_green) mlw(vvvthin))	///
	(scatter dem year,	///
		connect(l) msym(o) msize(small) lp(solid) col(navy) mlc(black) mlw(vvvthin))	///
	(scatter gop year,	///
		connect(l) msym(th) msize(small) lp(-.) col(maroon)  mlw(vvvthin))	///
	, graphregion(color(white)) xlab(1877(13)2009, labsize(vsmall)) xtitle("") ///
	ylab(, nogrid labsize(vsmall)) legend(off) ///
	title("No Policy Content", color(black) size(small) ) name(NoPolicyContent, replace) 

use "ConstrainedOneCongressTimeCivilRights.dta", clear
replace dem		= dem*-1
replace sdem	= sdem*-1
replace gop		= gop*-1

gen year = 1787+(congress*2)

tw 	(scatter sdem year,	///
		connect(l) msym(oh) msize(small) lp(dash) col(forest_green) mlw(vvvthin))	///
	(scatter dem year,	///
		connect(l) msym(o) msize(small) lp(solid) col(navy) mlc(black) mlw(vvvthin))	///
	(scatter gop year,	///
		connect(l) msym(th) msize(small) lp(-.) col(maroon)  mlw(vvvthin))	///
	, graphregion(color(white)) xlab(1877(13)2009, labsize(vsmall)) xtitle("") ///
	ylab(, nogrid labsize(vsmall)) ///
	legend(ring(0) col(1) size(vsmall) pos(1) symxsize(large) ///
		label(2 "Democratic") label(3 "Republican") 	///
		label(1 "Southern Democratic")	///
		region(fcol(none) lcol(none))) ///
	title("Policy Content", color(black) size(small) ) name(PolicyContent, replace) 

graph combine NoPolicyContent PolicyContent	///
	, graphregion(col(white)) imargin(tiny) ycommon name(FigureA4, replace)
	
********************************************************************************
*** APPENDIX FIGURE B1: Constrained Midpoints and Imputed Votes 
********************************************************************************
use "MidpointsConstrainedHouseCongressLevelMedians45to110.dta", clear

foreach x of varlist pivot-polarci975 {
	rename `x' `x'MPCons
}

*** Merge in the imputation constraint estimates
merge 1:1 congress using "HouseCongressLevelConstrainedMedians45to110.dta"

gen year = 1787+cong*2
	
local modMP = polarMPCons[1]
local modImpute = polar[1]
	
replace demPivotMPCons = demPivotMPCons/`modMP' 
replace gopPivotMPCons = gopPivotMPCons/`modMP'
replace sdemPivotMPCons = sdemPivotMPCons/`modMP'
replace polarMPCons = polarMPCons/`modMP'
	
replace demPivot = demPivot/`modImpute' 
replace gopPivot = gopPivot/`modImpute'
replace sdemPivot = sdemPivot/`modImpute'
replace polar = polar/`modImpute'
	
tw 	(scatter demPivotMPCons demPivot year, 	///
		connect(l l) col(navy navy) msize(small) ///
		lp(solid dash) msy(o none) mlw(vvthin vvthin) mlc(black))	///
	, graphregion(color(white)) xlab(1877(13)2007, labsize(vsmall)) ///
	ylab(, nogrid labsize(vsmall)) name(dem, replace) legend(off) xtitle("") ytitle("")	///
	title("Democratic", size(small) col(black) ring(0))
	
tw	(scatter gopPivotMPCons gopPivot year, ///
		connect(l l) col(maroon maroon) msize(small) lp(solid dash) ///
		msy(th none) mlw(vvthin vvthin) mlc(maroon maroon))	///
	, graphregion(color(white)) xlab(1877(13)2007, labsize(vsmall)) ///
	ylab(, nogrid labsize(vsmall)) name(gop, replace) legend(off) xtitle("") ytitle("") ///
	title("Republican", size(small) col(black) ring(0))
	
tw	(scatter sdemPivotMPCons sdemPivot year, ///
		connect(l l) col(forest_green forest_green) msize(small) ///
		lp(solid dash) msy(oh none) mlw(vvthin vvthin) )	///
	, graphregion(color(white)) xlab(1877(13)2007, labsize(vsmall)) ///
	ylab(, nogrid labsize(vsmall)) name(south, replace) 	///
	legend(ring(0) pos(7) label(1 "Constrained Midpoints") ///
		label(2 "Imputed Votes") size(small) keygap(tiny) rowgap(tiny) 	///
		colgap(tiny) symxsize(large) col(1) ///
		region(color(white) fcolor(white)))	 xtitle("") ytitle("") ///
	title("Southern Democratic", size(small) col(black) ring(0))
	
tw 	(scatter polarMPCons polar year, ///
		connect(l l) col(navy black) msize(small) lp(solid dash) ///
		msy(o none) mlw(vvthin vvthin) mlc(black))	///
	, graphregion(color(white)) xlab(1877(13)2007, labsize(vsmall)) ///
	ylab(, nogrid labsize(vsmall)) name(polar, replace)  xtitle("")	ytitle("") legend(off) ///
	title("Polarization", size(small) col(black) ring(0))
	
	
	graph combine dem gop south polar, 	///
		graphregion(color(white)) imargin(tiny) name(FigureB1, replace)
	graph display FigureB1, ysize(11) xsize(8.5)
	graph drop dem gop south polar
********************************************************************************
*** APPENDIX FIGURE B2: Probabilistic Imputation Compared with Fully
*** 			Constrained and Unconstrained Models 
********************************************************************************
use "VaryImputations.dta", clear		
	
preserve
	collapse (median) agnostic constrained fewest most, by(congress partycode)

	keep if partycode==200
	
	rename agnostic GOPUncon
	rename constrained GOPFullCon
	rename fewest GOPLeastCon
	rename most GOPMostCon
	
	tempfile temp1
	save `temp1', replace
restore
preserve
	collapse (median) agnostic constrained fewest most, by(congress partycode)

	keep if partycode==100
	
	rename agnostic DemUncon
	rename constrained DemFullCon
	rename fewest DemLeastCon
	rename most DemMostCon
	
	drop partycode
	
	tempfile temp2
	save `temp2', replace
restore
preserve

	collapse (median) agnostic constrained fewest most, by(congress partycode south)

	keep if partycode==100 & south==1
	
	rename agnostic SDemUncon
	rename constrained SDemFullCon
	rename fewest SDemLeastCon
	rename most SDemMostCon
	
	drop partycode south
	
	merge 1:1 congress using `temp1', nogen
	merge 1:1 congress using `temp2', nogen
	
	gen year = 1787+cong*2
	
	gen polarUncon 	= abs(DemUncon - GOPUncon)
	gen polarFullCon= abs(DemFullCon - GOPFullCon)
	gen polarLeastCon= abs(DemLeastCon - GOPLeastCon)
	gen polarMostCon= abs(DemMostCon - GOPMostCon)
	
	local uncon = polarUncon[1]
	local Full = polarFullCon[1]
	local Least = polarLeastCon[1]
	local Most = polarMostCon[1]
	
	foreach x in Dem SDem GOP polar {
		replace `x'Uncon = `x'Uncon/`uncon'
		replace `x'Full = `x'Full/`Full'
		replace `x'Least = `x'Least/`Least'
		replace `x'Most = `x'Most/`Most'
	}
	
	tw (scatter  DemLeastCon DemMostCon DemUncon DemFullCon year, 	///
			connect(l l l l) col(gs10 gs10 navy black ) msize(small small small small) ///
			lp(solid dash solid dash) msy(none none o none) mlw(medthin medthin ///
			vvthin vvthin) mlc(black))	///
		, graphregion(color(white)) xlab(1877(13)2007, 	labsize(vsmall)) ///
		ylab(, nogrid) name(dem, replace) legend(off) ///
		xtitle("") title("Democrats", ring(0) size(small) col(black))
		
	tw (scatter  SDemLeastCon SDemMostCon SDemUncon SDemFullCon year, 	///
			connect(l l l l) col(gs10 gs10 forest_green black ) msize(small small small small) ///
			lp(solid dash solid dash) msy(none none o none) mlw(medthin medthin ///
			vvthin vvthin) mlc(black))	///
		, graphregion(color(white)) xlab(1877(13)2007, 	labsize(vsmall)) ///
		ylab(, nogrid) name(sdem, replace)  ///
		legend(ring(0) pos(7) order(3 4 1 2) label(3 "Unconstrained") ///
			label(4 "Full Model") label(1 "Probabilistic""Imputation, Fewest") 	///
			label(2 "Probabilistic""Imputation, Most")	///
			size(vsmall) keygap(tiny) rowgap(tiny) 	///
			colgap(tiny) symxsize(large) col(1) ///
			region(color(white) fcolor(white)))	///
		xtitle("") title("Southern Democrats", ring(0) size(small) col(black))
		
	tw (scatter  GOPLeastCon GOPMostCon GOPUncon GOPFullCon year, 	///
			connect(l l l l) col(gs10 gs10 maroon black ) msize(small small small small) ///
			lp(solid dash solid dash) msy(none none th none) mlw(medthin medthin ///
			vvthin vvthin) )	///
		, graphregion(color(white)) xlab(1877(13)2007, 	labsize(vsmall)) ///
		ylab(, nogrid) name(gop, replace) legend(off) ///
		xtitle("") title("Republicans", ring(0) size(small) col(black))	

	tw (scatter  polarLeastCon polarMostCon polarUncon polarFullCon year, 	///
			connect(l l l l) col(gs10 gs10 navy black ) msize(small small small small) ///
			lp(solid dash solid dash) msy(none none o none) mlw(medthin medthin ///
			vvthin vvthin) mlc(black))	///
		, graphregion(color(white)) xlab(1877(13)2007, 	labsize(vsmall)) ///
		ylab(, nogrid) name(polar, replace) legend(off) ///
		xtitle("") title("Polarization", ring(0) size(small) col(black))	
restore
	
	graph combine dem gop sdem polar, 	///
		graphregion(color(white)) imargin(tiny) name(FigureB2, replace)
	graph drop dem gop sdem polar
	
	
		
********************************************************************************
*** APPENDIX FIGURE C1: Proportion of the Roll Call Agenda Involving Civil Rights 
********************************************************************************
use "CivilRightsVotesPerCongress.dta", clear	

tw 	(scatter civilrights year if chamber==1, ///
		connect(l) col(navy) mlw(vvthin) mlco(black) msize(small)) ///
	(scatter civilrights year if chamber==2, ///
		connect(l) msy(t) lc(black) col(white) lw(thin) mlw(vvthin) mlco(black)) ///
	, graphregion(color(white)) ///
	xlab(1877(13)2009, labsize(vsmall)) xtitle("")	///
	legend(ring(0) col(1) size(vsmall) pos(11) symxsize(large)	///
		label(1 "House") label(2 "Senate")	///
		region(fcol(none) lcol(none)))	///
	ylab(, nogrid labsize(vsmall)) ytitle(, size(vsmall)) name(FigureC1, replace)
********************************************************************************
*** APPENDIX FIGURE C2: Percentage of Second-Dimension Civil Rights Votes
*** 		in DW-NOMINATE, by Congress 1877-2009 
********************************************************************************
	
use "CivilRightsVotesPerCongress.dta", clear

tw 	(scatter secondDim year, connect(l) lwi(vthin) msy(o) mlw(vvthin) mlc(black)) ///
	, graphregion(color(white)) ///
	xlab(1877(13)2009, labsize(vsmall)) xtitle("")	///
	ylab(, nogrid labsize(vsmall)) ytitle(, size(vsmall)) name(FigureC2, replace)
*********************************************************************
*** APPENDIX FIGURE D1: An example of polarization using an extreme
***	imputation of voting decisions based on identity.  
*********************************************************************
use "PolarizationByPartyLabels.dta", clear

foreach x of varlist polar-polarci975 {
	rename `x' `x'Cons
}
tempfile temp
save `temp', replace


*** Merge in the Agnostic estimated
merge 1:1 congress using "HouseCongressLevelAgnosticMedians45to110.dta", nogen keepusing(polar polarci25 polarci975)

*** Standardize all the estimates by the value of 
*** polarization in year 1, i.e. the 45th Congress
local modCons = polarCons[1]
local mod = polar[1]

foreach x of varlist polarCons-polarci975Cons {
	replace `x' = `x'/`modCons'
}
foreach x of varlist polar-polarci975 {
	replace `x' = `x'/`mod'
}

gen year = 1787+(congress*2)

*** Produce the median graphs

	
tw (line polarci25 polarci975 polarci25Cons polarci975Cons year,	///
		lp(solid solid shortdash shortdash) lw(vvvthin vvvthin vvvthin vvvthin) lc(gs10 gs10 gs10 gs10))	///
	(scatter polar polarCons year,	///
		connect(l l) msy(oh none) msize(small small) lp(solid dash) col(navy black) mlw(vthin vthin))	///
	, graphregion(color(white)) xlab(1877(13)2009, labsize(vsmall)) xtitle("") ///
	legend(ring(0) col(1) order(5 6) size(small) pos(7) symxsize(large) ///
		label(5 "No Policy Content") label(6 "Policy Content") region(fcol(none) lcol(none))) ///
	ylab(, nogrid labsize(vsmall))  ///
	title("Polarization", color(black) size(small) ring(0) box bcol(white)) name(FigureD1, replace) 	
		
*********************************************************************
*** APPENDIX FIGURE E1: Predicting Final Passage Votes on Prohibiting
***		Army from Maintaining Peace at the Polls and on Lynching
*********************************************************************
use "CounterFactualVotes.dta", clear

gen figure = 1 if icpsrlegis==3268 ///
	| icpsrlegis==15448 | icpsrlegis==15094  ///
	| icpsrlegis==15030 | icpsrlegis==15431  ///
	| icpsrlegis==29137 | icpsrlegis==14627  ///
	| icpsrlegis==7568  | icpsrlegis==29939   ///
	| icpsrlegis==3242  | icpsrlegis==99907  ///
	| icpsrlegis==29935 | icpsrlegis==99904 ///
	| icpsrlegis==29767 | icpsrlegis==20912 

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

	
*** make sure that all of the variables are coded as 0 or 1	
qui foreach x of varlist V* {
	replace `x' = 1 if `x' ==2 | `x'==3
	replace `x' = 0 if `x' ==4 | `x'==5 | `x'==6
	replace `x' = . if `x' >=7 
}


probit V315_45 civilRightsAgn
predict yhat1


tw 	(line yhat1 civilRightsAgn , col(black) sort ) ///
	(scatter yhat1 civilRightsAgn  if figure ==1 , mlw(vvvthin) msize(small) msymbol(none) ///
		mlabel(name) mlabsize(tiny) mlabcolor(black) mlabpos(12) ), ///
	yline(0.5, lpattern(dot) lwidth(medthick) lcolor(black)) legend(off)  ///
	title("Prohibiting Military Presence at the Polls, 1877", col(black) size(small)) ///
	graphregion(color(white)) xlab(, labsize(vsmall)) ///
	ylab(0(.2)1, labsize(vsmall) nogrid) ///
	ytitle("Predicted Probability of Voting Yea", size(vsmall)) ///
	xtitle("Civil Rights Estimates", size(vsmall)) name(elections, replace)

probit V169_67 civilRightsAgn
predict yhat2

tw 	(line yhat2 civilRightsAgn , col(black) sort ) ///
	(scatter yhat2 civilRightsAgn  if figure ==1 , mlw(vvvthin) msize(small) msymbol(none) ///
		mlabel(name) mlabsize(tiny) mlabcolor(black) mlabpos(12) ), ///
	yline(0.5, lpattern(dot) lwidth(medthick) lcolor(black)) legend(off)  ///
	title("Anti-Lynching Legislation, 1922", col(black) size(small)) ///
	graphregion(color(white)) xlab(, labsize(vsmall)) ///
	ylab(0(.2)1, labsize(vsmall) nogrid) ///
	ytitle("Predicted Probability of Voting Yea", size(vsmall)) ///
	xtitle("Civil Rights Estimates", size(vsmall)) name(lynching, replace)

graph combine elections lynching	///
	, graphregion(col(white)) imargin(tiny) ycommon name(FigureE1, replace)

graph drop elections lynching

*********************************************************************
*** APPENDIX FIGURE E2: Predicting Final Passage Votes on the Voting
***		Rights Act, 1965 and 2006
*********************************************************************
use "CounterFactualVotes.dta", clear

gen figure = 1 if icpsrlegis==3268 ///
	| icpsrlegis==15448 | icpsrlegis==15094  ///
	| icpsrlegis==15030 | icpsrlegis==15431  ///
	| icpsrlegis==29137 | icpsrlegis==14627  ///
	| icpsrlegis==7568  | icpsrlegis==29939   ///
	| icpsrlegis==3242  | icpsrlegis==99907  ///
	| icpsrlegis==29935 | icpsrlegis==99904 ///
	| icpsrlegis==29767 | icpsrlegis==20912 

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

	
*** make sure that all of the variables are coded as 0 or 1	
qui foreach x of varlist V* {
	replace `x' = 1 if `x' ==2 | `x'==3
	replace `x' = 0 if `x' ==4 | `x'==5 | `x'==6
	replace `x' = . if `x' >=7 
}


probit V107_89 civilRightsCons
predict yhat1


tw 	(line yhat1 civilRightsCons , col(black) sort ) ///
	(scatter yhat1 civilRightsCons  if figure ==1 , mlw(vvvthin) msize(small) msymbol(none) ///
		mlabel(name) mlabsize(tiny) mlabcolor(black) mlabpos(12) ), ///
	yline(0.5, lpattern(dot) lwidth(medthick) lcolor(black)) legend(off)  ///
	title("Passage of Voting Rights Act, 1965", col(black) size(small)) ///
	graphregion(color(white)) xlab(, labsize(vsmall)) ///
	ylab(0(.2)1, labsize(vsmall) nogrid) ///
	ytitle("Predicted Probability of Voting Yea", size(vsmall)) ///
	xtitle("Civil Rights Estimates, with Policy Content", size(vsmall)) name(vra1, replace)

probit V1042_109 civilRightsCons
predict yhat2

tw 	(line yhat2 civilRightsCons , col(black) sort ) ///
	(scatter yhat2 civilRightsCons  if figure ==1 , mlw(vvvthin) msize(small) msymbol(none) ///
		mlabel(name) mlabsize(tiny) mlabcolor(black) mlabpos(12) ), ///
	yline(0.5, lpattern(dot) lwidth(medthick) lcolor(black)) legend(off)  ///
	title("Re-Authorization of Voting Rights Act, 2006", col(black) size(small)) ///
	graphregion(color(white)) xlab(, labsize(vsmall)) ///
	ylab(0(.2)1, labsize(vsmall) nogrid) ///
	ytitle("Predicted Probability of Voting Yea", size(vsmall)) ///
	xtitle("Civil Rights Estimates, with Policy Content", size(vsmall)) name(vra2, replace)

graph combine vra1 vra2	///
	, graphregion(col(white)) imargin(tiny) ycommon name(FigureE2, replace)

graph drop vra1 vra2

*****************************************************************
*** APPENDIX FIGURE E3: Location of the Estimated Midpoints for
***				Estimator with Imputed Votes
*****************************************************************

use "EstimatedMidpointsCivilRights.dta", clear


tw 	(scatter agnMidpoint year , ///
		connect(l) lpa(-.) msymbol(Oh) color(black) mlwidth(vvthin)  yaxis(1) ) ///
	(scatter inferredMidpoint year, ///
		connect(l) col(black) lpat(solid) msym(X) sort) ///
	, graphregion(color(white)) ylab(-0.5 "Racial Liberalism" 1.75 "Racial Conservatism" , notick labsize(vsmall) nogrid ) ///
	xlab(1957(4)2009, labsize(vsmall) angle(45)) xtitle("") ///
	yscale(range(-0.75 2)) legend(off)	///
	name(NoPolicy, replace) title("No Policy Content", size(small) col(black))

tw 	(scatter consMidpoint year , ///
		connect(l) lpa(-.) msymbol(Oh) color(black) mlwidth(vvthin)  yaxis(1) ) ///
	(scatter inferredMidpoint year, ///
		connect(l) col(black) lpat(solid) msym(X) sort) ///
	, graphregion(color(white)) ylab(none, nogrid ) ///
	xlab(1957(4)2009, labsize(vsmall) angle(45)) xtitle("") ///
	yscale(range(-0.75 2))	///
	legend(ring(0) pos(1) cols(1) region(color(none) lcolor(white)) ///
		label(1 "Estimated Midpoint") label(2 "House Median") ///
		order(1 2) holes(3 4 5) size(vsmall)) scale(0.85) ///
	name(Policy, replace) title("With Policy Content", size(small) col(black))

graph combine NoPolicy Policy,	///
		graphregion(col(white)) ycommon name(FigureE3, replace)
graph drop NoPolicy Policy

*****************************************************************
*** APPENDIX FIGURE F1: Party Medians on Senate Civil Rights,
*** 			Agnostic and Constrained, 1877-2009
*****************************************************************
use "SenateCongressLevelConstrainedMedians45to110.dta", clear

foreach x of varlist pivot-polarci975 {
	rename `x' `x'Cons
}
	
tempfile temp
save `temp', replace

use "SenateCongressLevelAgnosticMedians45to110.dta"
foreach x of varlist pivot-ndemPivotci975 {
	replace `x' = `x'*-1
}

merge 1:1 congress using `temp', nogen


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
	, graphregion(color(white)) xlab(1877(13)2009, labsize(vsmall)) xtitle("") ///
	ylab(-0.5(.25)1, nogrid labsize(vsmall)) legend(off) ///
	title("Democrats", color(black) size(small) ring(0)) name(dem, replace) 

tw 	(line sdemPivotci25 sdemPivotci975 sdemPivotci25Cons sdemPivotci975Cons year,	///
		lp(solid solid shortdash shortdash) lw(vvvthin vvvthin vvvthin vvvthin) lc(gs10 gs10 gs10 gs10))	///
	(scatter sdemPivot sdemPivotCons year,	///
		connect(l l) msy(oh none) msize(small small) lp(solid dash) col(forest_green black) mlw(vthin vthin))	///
	, graphregion(color(white)) xlab(1877(13)2009, labsize(vsmall)) xtitle("") ///
	ylab(-0.5(.25)1, nogrid labsize(vsmall)) legend(off) ///
	title("Southern Democrats", color(black) size(small) ring(0)) name(sdem, replace) 

tw 	(line gopPivotci25 gopPivotci975 gopPivotci25Cons gopPivotci975Cons year,	///
		lp(solid solid shortdash shortdash) lw(vvvthin vvvthin vvvthin vvvthin) lc(gs10 gs10 gs10 gs10))	///
	(scatter gopPivot gopPivotCons year,	///
		connect(l l) msy(th none) msize(small small) lp(solid dash) col(maroon black) mlw(vthin vthin))	///
	, graphregion(color(white)) xlab(1877(13)2009, labsize(vsmall)) xtitle("") ///
	ylab(-0.5(.25)1, nogrid labsize(vsmall)) legend(off) ///
	title("Republicans", color(black) size(small) ring(0)) name(gop, replace) 

tw (line polarci25 polarci975 polarci25Cons polarci975Cons year,	///
		lp(solid solid shortdash shortdash) lw(vvvthin vvvthin vvvthin vvvthin) lc(gs10 gs10 gs10 gs10))	///
	(scatter polar polarCons year,	///
		connect(l l) msy(oh none) msize(small small) lp(solid dash) col(navy black) mlw(vthin vthin))	///
	, graphregion(color(white)) xlab(1877(13)2009, labsize(vsmall)) xtitle("") ///
	ylab(0(.25)1, nogrid labsize(vsmall))  ///
	legend(ring(0) col(1) order(5 6) size(small) pos(7) symxsize(large) ///
	label(5 "No Policy Content") label(6 "Policy Content") region(fcol(none) lcol(none))) ///
	title("Polarization", color(black) size(small) ring(0)) name(polar, replace) 
	
graph combine dem gop sdem polar, 	///
	graphregion(color(white)) imargin(zero) 	///
	name(FigureF1, replace)
	
graph display FigureF1, ysize(11) xsize(8.5)
graph drop dem gop sdem polar


*****************************************************************
*** APPENDIX FIGURE F2: Comparison of House and Senate 	
***						Constrained Estimates
*****************************************************************
use "HouseCongressLevelConstrainedMedians45to110.dta", clear

gen year = 1787+(congress*2)

tw 	(line sdemPivotci25 sdemPivotci975 year,	///
		lp(solid solid) lw(vvvthin vvvthin) lc(eltgreen eltgreen))	///
	(line ndemPivotci25 ndemPivotci975 year,	///
		lp(solid solid) lw(vvvthin vvvthin ) lc(emidblue emidblue))	///
	(line gopPivotci25 gopPivotci975  year,		///
		lp(solid solid ) lw(vvvthin vvvthin ) lc(erose erose))	///
	(line pivot year,	///
		lp(solid) col(gs10) lw(medthin))	///
	(scatter sdemPivot year,	///
		connect(l) msy(oh) msize(small) lp(dash) col(forest_green) mlw(vvvthin))	///
	(scatter ndemPivot year,	///
		connect(l) msy(o) msize(small) lp(solid) col(navy) mlc(black) mlw(vvvthin))	///
	(scatter gopPivot year,	///
		connect(l) msy(th) msize(small) lp(solid) col(maroon)  mlw(vvvthin))	///
	, graphregion(color(white)) xlab(1877(13)2009, labsize(vsmall)) xtitle("") ///
	ylab(none, nogrid labsize(vsmall)) legend(off) ///
	title("House", color(black) size(small) ring(0)) name(House, replace) 

use "SenateCongressLevelConstrainedMedians45to110.dta", clear

gen year = 1787+(congress*2)

tw 	(line sdemPivotci25 sdemPivotci975 year,	///
		lp(solid solid) lw(vvvthin vvvthin) lc(eltgreen eltgreen))	///
	(line ndemPivotci25 ndemPivotci975 year,	///
		lp(solid solid) lw(vvvthin vvvthin ) lc(emidblue emidblue))	///
	(line gopPivotci25 gopPivotci975  year,		///
		lp(solid solid ) lw(vvvthin vvvthin ) lc(erose erose))	///
	(line pivot year,	///
		lp(solid) col(gs10) lw(medthin))	///
	(scatter sdemPivot year,	///
		connect(l) msy(oh) msize(small) lp(dash) col(forest_green) mlw(vvvthin))	///
	(scatter ndemPivot year,	///
		connect(l) msy(o) msize(small) lp(solid) col(navy) mlc(black) mlw(vvvthin))	///
	(scatter gopPivot year,	///
		connect(l) msy(th) msize(small) lp(solid) col(maroon)  mlw(vvvthin))	///
	, graphregion(color(white)) xlab(1877(13)2009, labsize(vsmall)) xtitle("") ///
	ylab(none, nogrid labsize(vsmall)) ///
	legend(ring(0) order(9 10 8 7) col(1) size(vsmall) pos(1) symxsize(large) ///
		label(9 "Northern Democratic") label(10 "Republican") 	///
		label(8 "Southern Democratic") label(7 "Chamber Median") 	///
		region(fcol(none) lcol(none))) ///
	title("Senate", color(black) size(small) ring(0)) name(Senate, replace) 

graph combine House Senate, 	///
	graphregion(col(white)) ycommon name(FigureF2, replace)
graph drop House Senate


******************************************************************************
*** Save files
******************************************************************************
graph display FigureA1
graph export "AppendixFigures\FigureA1.png", height(1600) replace	
graph export "AppendixFigures\FigureA1.pdf", fontface("Times New Roman") replace

graph display FigureA2
graph export "AppendixFigures\FigureA2.png", height(1600) replace	
graph export "AppendixFigures\FigureA2.pdf", fontface("Times New Roman") replace	

graph display FigureA3
graph export "AppendixFigures\FigureA3.png", height(1600) replace	
graph export "AppendixFigures\FigureA3.pdf", fontface("Times New Roman") replace	

graph display FigureA4
graph export "AppendixFigures\FigureA4.png", height(1600) replace	
graph export "AppendixFigures\FigureA4.pdf", fontface("Times New Roman") replace	

graph display FigureB1
graph export "AppendixFigures\FigureB1.png", height(1600) replace	
graph export "AppendixFigures\FigureB1.pdf", fontface("Times New Roman") replace	

graph display FigureB2
graph export "AppendixFigures\FigureB2.png", height(1600) replace	
graph export "AppendixFigures\FigureB2.pdf", fontface("Times New Roman") replace	

graph display FigureC1
graph export "AppendixFigures\FigureC1.png", height(1600) replace	
graph export "AppendixFigures\FigureC1.pdf", fontface("Times New Roman") replace	

graph display FigureC2
graph export "AppendixFigures\FigureC2.png", height(1600) replace	
graph export "AppendixFigures\FigureC2.pdf", fontface("Times New Roman") replace	

graph display FigureD1
graph export "AppendixFigures\FigureD1.png", height(1600) replace	
graph export "AppendixFigures\FigureD1.pdf", fontface("Times New Roman") replace	

graph display FigureE1
graph export "AppendixFigures\FigureE1.png", height(1600) replace	
graph export "AppendixFigures\FigureE1.pdf", fontface("Times New Roman") replace	

graph display FigureE2
graph export "AppendixFigures\FigureE2.png", height(1600) replace	
graph export "AppendixFigures\FigureE2.pdf", fontface("Times New Roman") replace	

graph display FigureE3
graph export "AppendixFigures\FigureE3.png", height(1600) replace	
graph export "AppendixFigures\FigureE3.pdf", fontface("Times New Roman") replace	

graph display FigureF1
graph export "AppendixFigures\FigureF1.png", height(1600) replace	
graph export "AppendixFigures\FigureF1.pdf", fontface("Times New Roman") replace	

graph display FigureF2
graph export "AppendixFigures\FigureF2.png", height(1600) replace	
graph export "AppendixFigures\FigureF2.pdf", fontface("Times New Roman") replace	
