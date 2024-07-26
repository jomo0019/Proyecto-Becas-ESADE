**************************************************************************************
** Códigos para Lucia **28 Junio 2024
**************************************************************************************
/*
ÍNDICE
1) Fijar los paths
2) Ejemplo Balancing Checks variables individuales usando Rdrobust
3) Ejemplo Balancing Checks con el índice de variables socioeconómicas
4) Ejemplo Balancing Checks variables individuales usando OLS y Joint significance
5) Representación gráfica del índice de variables socioeconómicas
*/

**************************************************************************************
** Ejemplo Al principio fijamos los paths para poder linkearlo con Overleaf (incluir al principio del do-file)
**************************************************************************************
{
clear all
set seed 123456789

* Multi-user setup: 

{
	// Setting up paths: 
	if c(username) == "pepemontalbancastilla" {
		// Jose's directories laptop
		global datainput 		"/Users/pepemontalbancastilla/Dropbox/Research/Class Size/data/!raw"
		global datatemp 		"/Users/pepemontalbancastilla/Dropbox/Research/Class Size/data/!temp"
		global dataoutput 		"/Users/pepemontalbancastilla/Dropbox/Research/Class Size/data/!clean"
		global results			"/Users/pepemontalbancastilla/Dropbox/Research/Class Size/results"
		global code				"/Users/pepemontalbancastilla/Dropbox/Research/Class Size/code"
		global overleaf         "/Users/pepemontalbancastilla/Dropbox/Overleaf/Class Size Draft"
		// this is where we store ado files for this project
	}
	
	else if c(username) == "jomo0019"  {
		// Jose directory SOFI
		global datainput 		"/Users/jomo0019/Dropbox/Research/Class Size/data/!raw"
		global datatemp 		"/Users/jomo0019/Dropbox/Research/Class Size/data/!temp"
		global dataoutput 		"/Users/jomo0019/Dropbox/Research/Class Size/data/!clean"
		global results			"/Users/jomo0019/Dropbox/Research/Class Size/results"
		global code				"/Users/jomo0019/Dropbox/Research/Class Size/code"
		global overleaf         "/Users/jomo0019/Dropbox/Overleaf/Class Size Draft"
	}
	*
	else if c(username) == "lucia"  {
		// Pierre's laptop
		global datainput 		"...\data\!raw"
		global datatemp 		"...\data\!temp"
		global dataoutput 		"...\data\!clean"
		global results			"...\results"
		global code				"...\code"
	}
}


cd "$datatemp"

exit 

}
**************************************************************************************
** Ejemplo Balancing Checks variables individuales usando Rdrobust
**************************************************************************************
{
* Load the data 
use "$dataoutput/estimation sample low income point.dta", clear 


* globals:
gl pretreatvars		age31round female sizehh income_totalhh spanish mother_spanish father_spanish ///
					distance1_w distance5_w   nbschools1000m std_sch_VA_500 std_sch_VA_1000
						

* EXCL sibs EXCL nonspanish 

global mysamp	mysamplenosib == 1 & ( mother_spanish != 0 | father_spanish != 0 ) & puntos_hermano_adm==0

 
						
*** BALANCING TABLE VERTICAL: 

estimates clear
capture matrix drop balancing

foreach c in 1 2 {	
	// Estimates at cutoff c : 
	local t = 1
	foreach v of global pretreatvars {
		rdrobust `v' rel`c' if $mysamp , c(0) p(1) all masspoints(adjust) bwselect(mserd) kernel(triangular)  scaleregul(1) covs(_year* district*)
		* fill in balancing table matrix
		capture matrix drop r
		matrix r = nullmat(r) , e(tau_bc) 									// coef est. (Robust)
		matrix r = r , e(se_tau_rb) 										// robust se
		matrix r = r , e(pv_rb) 											// robust pvalue
		* matrix r = r , e(h_l) 											// estimated 1/2 bandwidth
		matrix r = r , e(N_h_l)+e(N_h_r)									// total effective N obs
		qui sum `v' if e(sample) == 1 & relative_distance`c'_flipped < 0	// mean before cutoff 
		matrix r = r , r(mean) 												// ymean below cutoff
		matrix rownames r = `v'
		matrix balancing = nullmat(balancing) \ r
		matrix colnames balancing = b se p N ymean
		
	local ++t 
	} // end of loop on variables
	
} // end loop over cutoffs

		
// Report balancing matrix
estout matrix(balancing, fmt(%9.3f %9.3f %9.3f %9.0g %9.3f ))

* Tables
 	
estout matrix(balancing, fmt(%9.3f %9.3f %9.3f %9.0g %9.3f )) using "$results/Tables/balancing vertical EXCL sibs EXCL nonspanish.tex",  style(tex) label replace varwidth(20) title("Balancing tests on predetermined variables") 	



}

**************************************************************************************
** Ejemplo Balancing Checks con el índice de variables socioeconómicas
**************************************************************************************
*****Ejemplo de tabla con el índice de variables socioeconómicas
{
use "$dataoutput/Cleaned_2018_2019",clear
append using "$datatemp/Survey_Family_Grade3&6&10_2017_2018"
append using "$dataoutput/Cleaned_2016_2017"
append using "$dataoutput/Cleaned_2015_2016"

sort year ID_school grade
	
joinby year ID_school grade using "$dataoutput/Class_register_2016_2019"
	
	
*Observations including unmatched: 	618,403
*Obervations deleating unmatched: 614,969
*Observations not matched: 3434 (0.5% of observations not matched)

*Drop certian obervations
drop if Nenrolled==0 // 399 observations deleted
drop if classes_total==0 //6,681 observations deleted

drop if private==1

****Class Size
gen class_size=Nenrolled/classes_total
lab var class_size "Average Class Size (records)"

***Creating enrollment variables
*Enrollment controls for Grades 3 and 6
g func1_cohort_g36= Nenrolled/(int(Nenrolled/30)+1)
gen cohort2 =(Nenrolled^2)/100
gen trend_cohort_g36= Nenrolled if Nenrolled>=0 & Nenrolled<=30
replace  trend_cohort_g36= 15+(Nenrolled/2) if Nenrolled>=31 & Nenrolled<=60
replace  trend_cohort_g36= 25+(Nenrolled/3) if Nenrolled>=61 & Nenrolled<=90
replace  trend_cohort_g36= 32.5+(Nenrolled/4) if Nenrolled>=91 & Nenrolled<=120
replace  trend_cohort_g36= 38.5+(Nenrolled/5) if Nenrolled>=121 & Nenrolled<=150
replace  trend_cohort_g36= 43.5+(Nenrolled/6) if Nenrolled>=151 & Nenrolled<=180

*Enrollment controls for Grade 10
g func1_cohort_g10= Nenrolled/(int(Nenrolled/33)+1)
gen trend_cohort_g10= Nenrolled if Nenrolled>=0 & Nenrolled<=33
replace  trend_cohort_g10= 16.5+(Nenrolled/2) if Nenrolled>=34 & Nenrolled<=66
replace  trend_cohort_g10= 27.5+(Nenrolled/3) if Nenrolled>=67 & Nenrolled<=99
replace  trend_cohort_g10= 35.75+(Nenrolled/4) if Nenrolled>=100 & Nenrolled<=132
replace  trend_cohort_g10= 42.35+(Nenrolled/5) if Nenrolled>=133 & Nenrolled<=165
replace  trend_cohort_g10= 47.84+(Nenrolled/6) if Nenrolled>=166 & Nenrolled<=198

*Generate var for cluster se
egen school_year= group(ID_school year)
egen school= group(ID_school)
* Generate year FE
tabulate year, generate(yr)		
global year_dummy "yr2 yr3 yr4"	

*Generate DAT FE
gen DAT2=1 if DAT=="Capital"
replace DAT2=2 if DAT=="Este"
replace DAT2=3 if DAT=="Norte"
replace DAT2=4 if DAT=="Oeste"
replace DAT2=5 if DAT=="Sur"

bys ID_school grade: egen DAT22=max(DAT2) 
drop DAT DAT2

gen DAT="Capital" if DAT22==1
replace DAT="Este"  if DAT22==2
replace DAT="Norte"  if DAT22==3
replace DAT="Oeste"  if DAT22==4
replace DAT="Sur"  if DAT22==5

tabulate DAT, generate(dat)
global controls "dat2 dat3 dat4 dat5 public"


*Pre-determined characteristics
*Age
drop age
gen age=year-year_birth 
lab var age "Student Age"


*Age when start going to school, nursery school or daycare
gen age_start_bef2y=(age_start==1) if age_start<.
lab var age_start_bef2y "Start school, nursery or daycare before turning 2 years-old"

*Books at home
gen books_less50=(books_home<=2) if books_home<.
lab var books_less50 "Less than 50 books at home"
gen books_more50=(books_home>2) if books_home<.
lab var books_more50 "More than 50 books at home"


*Parental education
*Mother
gen mother_education_ls=(mother_education<=3) if mother_education<.
lab var mother_education_ls "Mother education: Lower secondary completed or lower"
gen mother_education_hs=(mother_education==4 | mother_education==5) if mother_education<.
lab var mother_education_hs "Mother education: Higher secondary or Vocational"
gen mother_education_un=(mother_education>=6 ) if mother_education<.
lab var mother_education_un "Mother education: Tertiary University or more"
*Father
gen father_education_ls=(father_education<=3) if father_education<.
lab var father_education_ls "Father education: Lower secondary completed or lower"
gen father_education_hs=(father_education==4 | father_education==5) if father_education<.
lab var father_education_hs "Father education: Higher secondary or Vocational"
gen father_education_un=(father_education>=6 ) if father_education<.
lab var father_education_un "Father education: Tertiary University or more"
*Years of education
gen mother_yearsedu=0 if mother_education==1 & mother_education<.
replace mother_yearsedu=6 if mother_education==2 & mother_education<.
replace mother_yearsedu=10 if mother_education==3 & mother_education<.
replace mother_yearsedu=12 if mother_education==4 & mother_education<.
replace mother_yearsedu=15 if mother_education==5 & mother_education<.
replace mother_yearsedu=15 if mother_education==6 & mother_education<.
replace mother_yearsedu=17 if mother_education==7 & mother_education<.
replace mother_yearsedu=19 if mother_education==8 & mother_education<.
replace mother_yearsedu=22 if mother_education==9 & mother_education<.
lab var mother_yearsedu "Mother years of education"
gen father_yearsedu=0 if father_education==1 & father_education<.
replace father_yearsedu=6 if father_education==2 & father_education<.
replace father_yearsedu=10 if father_education==3 & father_education<.
replace father_yearsedu=12 if father_education==4 & father_education<.
replace father_yearsedu=15 if father_education==5 & father_education<.
replace father_yearsedu=15 if father_education==6 & father_education<.
replace father_yearsedu=17 if father_education==7 & father_education<.
replace father_yearsedu=19 if father_education==8 & father_education<.
replace father_yearsedu=22 if father_education==9 & father_education<.
lab var father_yearsedu "Father years of education"

*Employment Status
gen mother_fulltime=(mother_empstatus==1) if mother_empstatus<.
lab var mother_fulltime "Mother full time worker"
gen mother_unemp=(mother_empstatus==3) if mother_empstatus<.
lab var mother_unemp "Mother unemployed"
gen father_fulltime=(father_empstatus==1) if father_empstatus<.
lab var father_fulltime "Father full time worker"
gen father_unemp=(father_empstatus==3) if father_empstatus<.
lab var father_unemp "Father unemployed"

*Parental occupation
*Mother
gen mother_occupation_el=(mother_occupation==1 | mother_occupation==2) if mother_occupation<.
lab var mother_occupation_el "Mother occupation: Elementary occupation or lower"
gen mother_occupation_adm=(mother_occupation==5) if mother_occupation<.
lab var mother_occupation_adm "Mother occupation: Administrative staff"
gen mother_occupation_techass=(mother_occupation==6) if mother_occupation<.
lab var mother_occupation_techass "Mother occupation: Technicians and scientific assistants"
gen mother_occupation_dir=(mother_occupation==7) if mother_occupation<.
lab var mother_occupation_dir "Mother occupation: Directors and managers" 
gen mother_occupation_tech=(mother_occupation==8) if mother_occupation<.
lab var mother_occupation_tech "Mother occupation: Technicians and scientific professionals" 
*Father
gen father_occupation_el=(father_occupation==1 | father_occupation==2) if father_occupation<.
lab var father_occupation_el "Father occupation: Elementary occupation or lower"
gen father_occupation_adm=(father_occupation==5) if father_occupation<.
lab var father_occupation_adm "Father occupation: Administrative staff"
gen father_occupation_techass=(father_occupation==6) if father_occupation<.
lab var father_occupation_techass "Father occupation: Technicians and scientific assistants"
gen father_occupation_dir=(father_occupation==7) if father_occupation<.
lab var father_occupation_dir "Father occupation: Directors and managers" 
gen father_occupation_tech=(father_occupation==8) if father_occupation<.
lab var father_occupation_tech "Father occupation: Technicians and scientific professionals"


*Student Standardized Test Scores
egen stdyr_all=rowmean(stdyr_math stdyr_language)

*************

global vars_balance female spanish father_spanish mother_spanish  age_start_bef2y N_dig_devices books_less50 books_more50 mother_yearsedu  father_yearsedu mother_fulltime mother_unemp father_fulltime father_unemp mother_occupation_el father_occupation_el mother_occupation_adm  father_occupation_adm  mother_occupation_techass father_occupation_techass  

*Summary Index
reg stdyr_all $vars_balance /*where $vars_balance are pre-determined characteristics*/
predict resid_outcome, resid   /*residuals*/
gen pr_outcome = stdyr_all - resid_outcome /*fitted values */

*Generate variables
*Grades
gen pr_outcome3=pr_outcome if grade==3 & pr_outcome<.
lab var pr_outcome3 "Summary Index: Grade 3"
gen pr_outcome6=pr_outcome if grade==6 & pr_outcome<.
lab var pr_outcome6 "Summary Index: Grade 6"
gen pr_outcome10=pr_outcome if grade==10 & pr_outcome<.
lab var pr_outcome10 "Summary Index: Grade 10"
*Grades & Public
gen pr_outcome3np=pr_outcome if grade==3 & public==0 & pr_outcome<.
lab var pr_outcome3np "Summary Index: Grade 3 and Public 0"
gen pr_outcome3p=pr_outcome if grade==3 & public==1 & pr_outcome<.
lab var pr_outcome3p "Summary Index: Grade 3 and Public 1"
gen pr_outcome6np=pr_outcome if grade==6 & public==0 & pr_outcome<.
lab var pr_outcome6np "Summary Index: Grade 6 and Public 0"
gen pr_outcome6p=pr_outcome if grade==6 & public==1 & pr_outcome<.
lab var pr_outcome6p "Summary Index: Grade 6 and Public 1"
gen pr_outcome10np=pr_outcome if grade==10 & public==0 & pr_outcome<.
lab var pr_outcome10np "Summary Index: Grade 10 and Public 0"
gen pr_outcome10p=pr_outcome if grade==10 & public==1 & pr_outcome<.
lab var pr_outcome10p "Summary Index: Grade 10 and Public 1"


********First Stage Grade 3 and 6

global vars_balance func1_cohort_g36 Nenrolled cohort2 trend_cohort_g36 func1_cohort_g36 Nenrolled cohort2 trend_cohort_g36 func1_cohort_g36 Nenrolled cohort2 trend_cohort_g36


di "${vars_balance}"

 
local r: word count $vars_balance 
	di "`r'"
	local rr=(`r'*2+3)	

	matrix coefi = J(`rr', 18, .)
	matrix colnames coefi =  "Grade 3" "Grade 3" "Grade 3"  "Grade 3" "Grade 3" "Grade 3" "Grade 6" "Grade 6" "Grade 6"  "Grade 6" "Grade 6" "Grade 6"  "Grade 10" "Grade 10" "Grade 10"  "Grade 10" "Grade 10" "Grade 10"
	matrix rownames coefi = $vars_balance
	mat list coefi


	local i= 1
	local j=2
	
************************REGRESSIONS***
*******************Grade 3
*Column 1
reg pr_outcome3 func1_cohort_g36  Nenrolled $year_dummy $controls if grade==3, clu(school) 
*func1_cohort_g36 
mat coefi[`i',1]= round(_b[func1_cohort_g36], 0.00001)
mat coefi[`j',1]= round(_se[func1_cohort_g36], 0.000001)
mat coefi[`i',10]= round((2 * ttail(e(df_r), abs(_b[func1_cohort_g36]/_se[func1_cohort_g36]))), 0.000001)
*Nenrolled 
mat coefi[`i'+2,1]= round(_b[Nenrolled], 0.00001)
mat coefi[`j'+2,1]= round(_se[Nenrolled], 0.000001)
mat coefi[`i'+2,10]= round((2 * ttail(e(df_r), abs(_b[Nenrolled]/_se[Nenrolled]))), 0.000001)
*R2 & F-test
test func1_cohort
mat coefi[9+1,1]= e(r2)
mat coefi[9+2,1]= round(r(F),.001)
count if grade==3
mat coefi[9+3,1]= r(N)

*Column 2
reg pr_outcome3 func1_cohort_g36  Nenrolled cohort2 $year_dummy $controls if grade==3, clu(school) 
*func1_cohort_g36 
mat coefi[`i',2]= round(_b[func1_cohort_g36], 0.00001)
mat coefi[`j',2]= round(_se[func1_cohort_g36], 0.000001)
mat coefi[`i',11]= round((2 * ttail(e(df_r), abs(_b[func1_cohort_g36]/_se[func1_cohort_g36]))), 0.000001)
*Nenrolled 
mat coefi[`i'+2,2]= round(_b[Nenrolled], 0.00001)
mat coefi[`j'+2,2]= round(_se[Nenrolled], 0.000001)
mat coefi[`i'+2,11]= round((2 * ttail(e(df_r), abs(_b[Nenrolled]/_se[Nenrolled]))), 0.000001)
*Cohort 2
mat coefi[`i'+4,2]= round(_b[cohort2], 0.00001)
mat coefi[`j'+4,2]= round(_se[cohort2], 0.000001)
mat coefi[`i'+4,11]= round((2 * ttail(e(df_r), abs(_b[cohort2]/_se[cohort2]))), 0.000001)
*R2 & F-test
test func1_cohort
mat coefi[9+1,2]= e(r2)
mat coefi[9+2,2]= round(r(F),.001)
count if grade==3
mat coefi[9+3,2]= r(N)

*Column 3
reg pr_outcome3 func1_cohort_g36  trend_cohort_g36 $year_dummy $controls if grade==3, clu(school) 
*func1_cohort_g36 
mat coefi[`i',3]= round(_b[func1_cohort_g36], 0.00001)
mat coefi[`j',3]= round(_se[func1_cohort_g36], 0.000001)
mat coefi[`i',12]= round((2 * ttail(e(df_r), abs(_b[func1_cohort_g36]/_se[func1_cohort_g36]))), 0.000001)
*trend_cohort_g36
mat coefi[`i'+6,3]= round(_b[trend_cohort_g36], 0.00001)
mat coefi[`j'+6,3]= round(_se[trend_cohort_g36], 0.000001)
mat coefi[`i'+6,12]= round((2 * ttail(e(df_r), abs(_b[trend_cohort_g36]/_se[trend_cohort_g36]))), 0.000001)
*R2 & F-test
test func1_cohort
mat coefi[9+1,3]= e(r2)
mat coefi[9+2,3]= round(r(F),.001)
count if grade==3
mat coefi[9+3,3]= r(N)

*******************Grade 6
*Column 1
reg pr_outcome6 func1_cohort_g36  Nenrolled $year_dummy $controls if grade==6, clu(school) 
*func1_cohort_g36 
mat coefi[`i',4]= round(_b[func1_cohort_g36], 0.00001)
mat coefi[`j',4]= round(_se[func1_cohort_g36], 0.000001)
mat coefi[`i',13]= round((2 * ttail(e(df_r), abs(_b[func1_cohort_g36]/_se[func1_cohort_g36]))), 0.000001)
*Nenrolled 
mat coefi[`i'+2,4]= round(_b[Nenrolled], 0.00001)
mat coefi[`j'+2,4]= round(_se[Nenrolled], 0.000001)
mat coefi[`i'+2,13]= round((2 * ttail(e(df_r), abs(_b[Nenrolled]/_se[Nenrolled]))), 0.000001)
*R2 & F-test
test func1_cohort
mat coefi[9+1,4]= e(r2)
mat coefi[9+2,4]= round(r(F),.001)
count if grade==6
mat coefi[9+3,4]= r(N)

*Column 2
reg pr_outcome6 func1_cohort_g36  Nenrolled cohort2 $year_dummy $controls if grade==6, clu(school) 
*func1_cohort_g36 
mat coefi[`i',5]= round(_b[func1_cohort_g36], 0.00001)
mat coefi[`j',5]= round(_se[func1_cohort_g36], 0.000001)
mat coefi[`i',14]= round((2 * ttail(e(df_r), abs(_b[func1_cohort_g36]/_se[func1_cohort_g36]))), 0.000001)
*Nenrolled 
mat coefi[`i'+2,5]= round(_b[Nenrolled], 0.00001)
mat coefi[`j'+2,5]= round(_se[Nenrolled], 0.000001)
mat coefi[`i'+2,14]= round((2 * ttail(e(df_r), abs(_b[Nenrolled]/_se[Nenrolled]))), 0.000001)
*Cohort 2
mat coefi[`i'+4,5]= round(_b[cohort2], 0.00001)
mat coefi[`j'+4,5]= round(_se[cohort2], 0.000001)
mat coefi[`i'+4,14]= round((2 * ttail(e(df_r), abs(_b[cohort2]/_se[cohort2]))), 0.000001)
*R2 & F-test
test func1_cohort
mat coefi[9+1,5]= e(r2)
mat coefi[9+2,5]= round(r(F),.001)
count if grade==6
mat coefi[9+3,5]= r(N)

*Column 3
reg pr_outcome6 func1_cohort_g36  trend_cohort_g36 $year_dummy $controls if grade==6, clu(school) 
*func1_cohort_g36 
mat coefi[`i',6]= round(_b[func1_cohort_g36], 0.00001)
mat coefi[`j',6]= round(_se[func1_cohort_g36], 0.000001)
mat coefi[`i',15]= round((2 * ttail(e(df_r), abs(_b[func1_cohort_g36]/_se[func1_cohort_g36]))), 0.000001)
*trend_cohort_g36
mat coefi[`i'+6,6]= round(_b[trend_cohort_g36], 0.00001)
mat coefi[`j'+6,6]= round(_se[trend_cohort_g36], 0.000001)
mat coefi[`i'+6,15]= round((2 * ttail(e(df_r), abs(_b[trend_cohort_g36]/_se[trend_cohort_g36]))), 0.000001)
*R2 & F-test
test func1_cohort
mat coefi[9+1,6]= e(r2)
mat coefi[9+2,6]= round(r(F),.001)
count if grade==6
mat coefi[9+3,6]= r(N)

*******************Grade 10
*Column 1
reg pr_outcome10 func1_cohort_g10  Nenrolled $year_dummy $controls if grade==10, clu(school) 
*func1_cohort_g36 
mat coefi[`i',7]= round(_b[func1_cohort_g10], 0.00001)
mat coefi[`j',7]= round(_se[func1_cohort_g10], 0.000001)
mat coefi[`i',16]= round((2 * ttail(e(df_r), abs(_b[func1_cohort_g10]/_se[func1_cohort_g10]))), 0.000001)
*Nenrolled 
mat coefi[`i'+2,7]= round(_b[Nenrolled], 0.00001)
mat coefi[`j'+2,7]= round(_se[Nenrolled], 0.000001)
mat coefi[`i'+2,16]= round((2 * ttail(e(df_r), abs(_b[Nenrolled]/_se[Nenrolled]))), 0.000001)
*R2 & F-test
test func1_cohort
mat coefi[9+1,7]= e(r2)
mat coefi[9+2,7]= round(r(F),.001)
count if grade==10
mat coefi[9+3,7]= r(N)

*Column 2
reg pr_outcome10 func1_cohort_g10  Nenrolled cohort2 $year_dummy $controls if grade==10, clu(school) 
*func1_cohort_g36 
mat coefi[`i',8]= round(_b[func1_cohort_g10], 0.00001)
mat coefi[`j',8]= round(_se[func1_cohort_g10], 0.000001)
mat coefi[`i',17]= round((2 * ttail(e(df_r), abs(_b[func1_cohort_g10]/_se[func1_cohort_g10]))), 0.000001)
*Nenrolled 
mat coefi[`i'+2,8]= round(_b[Nenrolled], 0.00001)
mat coefi[`j'+2,8]= round(_se[Nenrolled], 0.000001)
mat coefi[`i'+2,17]= round((2 * ttail(e(df_r), abs(_b[Nenrolled]/_se[Nenrolled]))), 0.000001)
*Cohort 2
mat coefi[`i'+4,8]= round(_b[cohort2], 0.00001)
mat coefi[`j'+4,8]= round(_se[cohort2], 0.000001)
mat coefi[`i'+4,17]= round((2 * ttail(e(df_r), abs(_b[cohort2]/_se[cohort2]))), 0.000001)
*R2 & F-test
test func1_cohort
mat coefi[9+1,8]= e(r2)
mat coefi[9+2,8]= round(r(F),.001)
count if grade==10
mat coefi[9+3,8]= r(N)

*Column 3
reg pr_outcome10 func1_cohort_g10  trend_cohort_g10 $year_dummy $controls if grade==10, clu(school) 
*func1_cohort_g36 
mat coefi[`i',9]= round(_b[func1_cohort_g10], 0.00001)
mat coefi[`j',9]= round(_se[func1_cohort_g10], 0.000001)
mat coefi[`i',18]= round((2 * ttail(e(df_r), abs(_b[func1_cohort_g10]/_se[func1_cohort_g10]))), 0.000001)
*trend_cohort_g36
mat coefi[`i'+6,9]= round(_b[trend_cohort_g10], 0.00001)
mat coefi[`j'+6,9]= round(_se[trend_cohort_g10], 0.000001)
mat coefi[`i'+6,18]= round((2 * ttail(e(df_r), abs(_b[trend_cohort_g10]/_se[trend_cohort_g10]))), 0.000001)
*R2 & F-test
test func1_cohort
mat coefi[9+1,9]= e(r2)
mat coefi[9+2,9]= round(r(F),.001)
count if grade==10
mat coefi[9+3,9]= r(N)


matlist coefi
	drop _all
	  svmat coefi

	  rename (coefi1 coefi2 coefi3 coefi4 coefi5 coefi6 coefi7 coefi8 coefi9 coefi10 coefi11 coefi12 coefi13 coefi14 coefi15 coefi16 coefi17 coefi18) (beta1 beta2 beta3 beta4 beta5 beta6 beta7 beta8 beta9 pvalue1 pvalue2 pvalue3 pvalue4 pvalue5 pvalue6 pvalue7 pvalue8 pvalue9 )
	  
	  
	   gen variable=""
	   replace variable="fjt" if _n==1
	   replace variable="Number of students enrolled" if _n==3
	   replace variable="Enrollment squared/100" if _n==5
	   replace variable="Piecewise linear trend" if _n==7
	 


	
	forvalue x=1(1)9 {
	
	gen stars_beta`x' = "*" if pvalue`x'<=0.1 & pvalue`x'>0.05 & pvalue`x'!=.
	replace stars_beta`x' = "**" if pvalue`x'<=0.05 & pvalue`x'>0.01 & pvalue`x'!=.
	replace stars_beta`x' = "***" if pvalue`x'<=0.01 & pvalue`x'!=.
	}
	
	
	*All variables except observations
	foreach var of varlist beta1 beta2 beta3 beta4 beta5 beta6 beta7 beta8 beta9{
		
		gen `var'_s=string(`var',"%9.2f") if _n!=`r'*2+3
		replace `var'_s=string(`var',"%9.0f") if _n==`r'*2+3
		replace `var'_s="" if `var'_s=="."
		replace `var'_s="0"+`var'_s if substr(`var'_s,1,1)=="." 
		drop `var'
		rename `var'_s `var'
		
		}
	
	
	****Label the F-Test and Observations
	replace variable="R-squared" if _n==9+1
	replace variable="F-Test" if _n==9+2
	replace variable="Number of pupils" if _n==9+3
	
	
	forvalue x=1(1)9 {
	gen coeff`x' = beta`x' + stars_beta`x'
	replace coeff`x'="("+coeff`x'+")" if variable==""
	}
	
	forvalue x=1(1)9 {
	replace coeff`x'="" if coeff`x'=="()"
	}

	keep variable coeff1  coeff2  coeff3   coeff4 coeff5 coeff6 coeff7 coeff8 coeff9
	order variable coeff1  coeff2  coeff3  coeff4 coeff5 coeff6 coeff7 coeff8 coeff9

	label var variable "Variable"
	label var  coeff1 "Grade 3"
	label var  coeff2 "Grade 3"
	label var  coeff3 "Grade 3"
	label var  coeff4 "Grade 6"
	label var  coeff5 "Grade 6"
	label var  coeff6 "Grade 6"
    label var  coeff7 "Grade 10"
	label var  coeff8 "Grade 10"
	label var  coeff9 "Grade 10"
 	  
	  drop if _n>=13

	 
	global noteapp1 "The table shows the parametric estimates where the outcome variable is a summary index of all pre-determined student and parent characteristics. The dependent variable is the predicted value from a regression of standardized student test scores on all student and parent pre-determined characteristics. Each coefficient comes from a separate regression on the variables listed in the rows. Maximum class size rule fjt is computed using school enrollment. These regressions also include the following control variables: year fixed-effects and school administrative districts fixed-effects. Robust standard errors, clustered on school, are shown in parentheses. Significance levels are indicated by: * significant at 10\%, ** significant at 5\%, *** significant at 1\%."
	
	texsave using "$overleaf/04_appendix/summary_param.tex", width(1.05\textwidth) ///
	replace size(tiny) align(lccccccccc) location(htbp) varlabels frag ///
	title(Maximum Class Size Rule Parametric Estimates of Summary Index of Students' Baseline Characteristics for Grades 3, 6 and 10 in 2016-2019.) marker(tab:summary_param) ///
	footnote("$noteapp1", size(tiny)) nofix autonumber hlines(-3) 
		  


}


**************************************************************************************
** Ejemplo Balancing Checks variables individuales usando OLS y Joint significance
**************************************************************************************
******Ejemplo con varios intervalos y muestras
{
foreach c in 12 10 8 5  { 
foreach g in 3 6 {

use "$dataoutput/Cleaned_2018_2019",clear
append using "$datatemp/Survey_Family_Grade3&6&10_2017_2018"
append using "$dataoutput/Cleaned_2016_2017"
append using "$dataoutput/Cleaned_2015_2016"

sort year ID_school grade
	
joinby year ID_school grade using "$dataoutput/Class_register_2016_2019"
	
	
/*
 Result                           # of obs.
    -----------------------------------------
    not matched                         3,434
        from master                     2,221  (_merge==1)
        from using                      1,213  (_merge==2)

    matched                           614,945  (_merge==3)

*/

*Drop certian obervations
drop if Nenrolled==0 // 399 observations deleted
drop if classes_total==0 //6,658 observations deleted (1% of sample)
drop if private==1

****Class Size
gen class_size=Nenrolled/classes_total
lab var class_size "Average Class Size (records)"

*Basic First Stage
*1) Maximum Class Size Rule of 30 for Grades 3 & 6
*Generate Threshold dummies
gen z1=(Nenrolled>30) if Nenrolled<.
gen z2=(Nenrolled>60) if Nenrolled<.
gen z3=(Nenrolled>90) if Nenrolled<.
gen z4=(Nenrolled>120) if Nenrolled<.
gen z5=(Nenrolled>150) if Nenrolled<.

*Generate relative distance to cutoffs (running variable)
gen renrolz1=Nenrolled-31 if Nenrolled<.
gen renrolz2=Nenrolled-61 if Nenrolled<.
gen renrolz3=Nenrolled-91 if Nenrolled<.
gen renrolz4=Nenrolled-121 if Nenrolled<.
gen renrolz5=Nenrolled-151 if Nenrolled<.

*Generate interaction terms between cutoff and running variables
gen Nenrolled_z1=renrolz1*z1 if Nenrolled<. 
gen Nenrolled_z2=renrolz2*z2 if Nenrolled<.
gen Nenrolled_z3=renrolz3*z3 if Nenrolled<.
gen Nenrolled_z4=renrolz4*z4 if Nenrolled<.
gen Nenrolled_z5=renrolz5*z5 if Nenrolled<.

*Pre-determined characteristics
*Age
drop age
gen age=year-year_birth 
lab var age "Student Age"

*Age when start going to school, nursery school or daycare
gen age_start_bef2y=(age_start==1) if age_start<.
lab var age_start_bef2y "Start school, nursery or daycare before turning 2 years-old"

*Books at home
gen books_less50=(books_home<=2) if books_home<.
lab var books_less50 "Less than 50 books at home"
gen books_more50=(books_home>2) if books_home<.
lab var books_more50 "More than 50 books at home"


*Parental education
*Mother
gen mother_education_ls=(mother_education<=3) if mother_education<.
lab var mother_education_ls "Mother education: Lower secondary completed or lower"
gen mother_education_hs=(mother_education==4 | mother_education==5) if mother_education<.
lab var mother_education_hs "Mother education: Higher secondary or Vocational"
gen mother_education_un=(mother_education>=6 ) if mother_education<.
lab var mother_education_un "Mother education: Tertiary University or more"
*Father
gen father_education_ls=(father_education<=3) if father_education<.
lab var father_education_ls "Father education: Lower secondary completed or lower"
gen father_education_hs=(father_education==4 | father_education==5) if father_education<.
lab var father_education_hs "Father education: Higher secondary or Vocational"
gen father_education_un=(father_education>=6 ) if father_education<.
lab var father_education_un "Father education: Tertiary University or more"
*Years of education
gen mother_yearsedu=0 if mother_education==1 & mother_education<.
replace mother_yearsedu=6 if mother_education==2 & mother_education<.
replace mother_yearsedu=10 if mother_education==3 & mother_education<.
replace mother_yearsedu=12 if mother_education==4 & mother_education<.
replace mother_yearsedu=15 if mother_education==5 & mother_education<.
replace mother_yearsedu=15 if mother_education==6 & mother_education<.
replace mother_yearsedu=17 if mother_education==7 & mother_education<.
replace mother_yearsedu=19 if mother_education==8 & mother_education<.
replace mother_yearsedu=22 if mother_education==9 & mother_education<.
lab var mother_yearsedu "Mother years of education"
gen father_yearsedu=0 if father_education==1 & father_education<.
replace father_yearsedu=6 if father_education==2 & father_education<.
replace father_yearsedu=10 if father_education==3 & father_education<.
replace father_yearsedu=12 if father_education==4 & father_education<.
replace father_yearsedu=15 if father_education==5 & father_education<.
replace father_yearsedu=15 if father_education==6 & father_education<.
replace father_yearsedu=17 if father_education==7 & father_education<.
replace father_yearsedu=19 if father_education==8 & father_education<.
replace father_yearsedu=22 if father_education==9 & father_education<.
lab var father_yearsedu "Father years of education"

*Employment Status
gen mother_fulltime=(mother_empstatus==1) if mother_empstatus<.
lab var mother_fulltime "Mother full time worker"
gen mother_unemp=(mother_empstatus==3) if mother_empstatus<.
lab var mother_unemp "Mother unemployed"
gen father_fulltime=(father_empstatus==1) if father_empstatus<.
lab var father_fulltime "Father full time worker"
gen father_unemp=(father_empstatus==3) if father_empstatus<.
lab var father_unemp "Father unemployed"

*Parental occupation
*Mother
gen mother_occupation_el=(mother_occupation==1 | mother_occupation==2) if mother_occupation<.
lab var mother_occupation_el "Mother occupation: Elementary occupation or lower"
gen mother_occupation_adm=(mother_occupation==5) if mother_occupation<.
lab var mother_occupation_adm "Mother occupation: Administrative staff"
gen mother_occupation_techass=(mother_occupation==6) if mother_occupation<.
lab var mother_occupation_techass "Mother occupation: Technicians and scientific assistants"
gen mother_occupation_dir=(mother_occupation==7) if mother_occupation<.
lab var mother_occupation_dir "Mother occupation: Directors and managers" 
gen mother_occupation_tech=(mother_occupation==8) if mother_occupation<.
lab var mother_occupation_tech "Mother occupation: Technicians and scientific professionals" 
*Father
gen father_occupation_el=(father_occupation==1 | father_occupation==2) if father_occupation<.
lab var father_occupation_el "Father occupation: Elementary occupation or lower"
gen father_occupation_adm=(father_occupation==5) if father_occupation<.
lab var father_occupation_adm "Father occupation: Administrative staff"
gen father_occupation_techass=(father_occupation==6) if father_occupation<.
lab var father_occupation_techass "Father occupation: Technicians and scientific assistants"
gen father_occupation_dir=(father_occupation==7) if father_occupation<.
lab var father_occupation_dir "Father occupation: Directors and managers" 
gen father_occupation_tech=(father_occupation==8) if father_occupation<.
lab var father_occupation_tech "Father occupation: Technicians and scientific professionals"

*Student Standardized Test Scores
egen stdyr_all=rowmean(stdyr_math stdyr_language)

*Generate var for cluster se
egen school_year= group(ID_school year)
egen school= group(ID_school)
* Generate year FE
tabulate year, generate(yr)		
global year_dummy "yr2 yr3 yr4"	
*Enrollment controls
global enrollment_controlz1  renrolz1 Nenrolled_z1
global enrollment_controlz2  renrolz2 Nenrolled_z2
global enrollment_controlz3  renrolz3 Nenrolled_z3
global enrollment_controlz4  renrolz4 Nenrolled_z4
global enrollment_controlz5  renrolz5 Nenrolled_z5
gen cohort2 =(Nenrolled^2)

*Generate DAT FE

gen DAT2=1 if DAT=="Capital"
replace DAT2=2 if DAT=="Este"
replace DAT2=3 if DAT=="Norte"
replace DAT2=4 if DAT=="Oeste"
replace DAT2=5 if DAT=="Sur"

bys ID_school grade: egen DAT22=max(DAT2) 
drop DAT DAT2

gen DAT="Capital" if DAT22==1
replace DAT="Este"  if DAT22==2
replace DAT="Norte"  if DAT22==3
replace DAT="Oeste"  if DAT22==4
replace DAT="Sur"  if DAT22==5

tabulate DAT, generate(dat)
global controls "dat2 dat3 dat4 dat5 public"


global vars_balance female spanish father_spanish mother_spanish  age_start_bef2y N_dig_devices books_less50 books_more50 mother_yearsedu  father_yearsedu mother_fulltime mother_unemp father_fulltime father_unemp mother_occupation_el father_occupation_el mother_occupation_adm  father_occupation_adm  mother_occupation_techass father_occupation_techass  



di "${vars_balance}"

 
local r: word count $vars_balance
	di "`r'"
	local rr=(`r'*2+1)	

	matrix coefi = J(`rr', 12, .)
	matrix colnames coefi =  "Cutoff 1" "Cutoff 2" "Cutoff 3" "Cutoff 4" "Cutoff 5" 
	matrix rownames coefi = $vars_balance
	mat list coefi


	local i= 1
	local j=2

foreach x in $vars_balance {

****Student Test Scores
reg `x' stdyr_all  Nenrolled $year_dummy $controls if grade==`g' ,  clu(school_year)
        mat coefi[`i',1]= round(_b[stdyr_all], 0.00001)
		mat coefi[`j',1]= round(_se[stdyr_all], 0.000001)
		mat coefi[`i',7]= round((2 * ttail(e(df_r), abs(_b[stdyr_all]/_se[stdyr_all]))), 0.000001)
		*mat coefi[`i',4]= e(N)
		*sum  `x' if e(sample)==1  & treat2_2021==0
		*mat coefi[`i',1]= round(r(mean), 0.00001)

****Z1			
reg `x' z1 $enrollment_controlz1 $year_dummy $controls if Nenrolled>=(31-`c') & Nenrolled<(31+`c')  & grade==`g'  ,  clu(school) 
		
		mat coefi[`i',2]= round(_b[z1], 0.00001)
		mat coefi[`j',2]= round(_se[z1], 0.000001)
		mat coefi[`i',8]= round((2 * ttail(e(df_r), abs(_b[z1]/_se[z1]))), 0.000001)
		*mat coefi[`i',4]= e(N)
		*sum  `x' if e(sample)==1  & treat2_2021==0
		*mat coefi[`i',1]= round(r(mean), 0.00001)

		******Z2
reg `x' z2 $enrollment_controlz2 $year_dummy $controls if Nenrolled>=(61-`c') & Nenrolled<(61+`c')  & grade==`g'  ,  clu(school) 

        mat coefi[`i',3]= round(_b[z2], 0.00001)
		mat coefi[`j',3]= round(_se[z2], 0.000001)
		mat coefi[`i',9]= round((2 * ttail(e(df_r), abs(_b[z2]/_se[z2]))), 0.000001)
		*mat coefi[`i',4]= e(N)
		*sum  `x' if e(sample)==1  & treat2_2021==0
		*mat coefi[`i',1]= round(r(mean), 0.00001)



******Z3	
reg `x' z3 $enrollment_controlz3 $year_dummy $controls if Nenrolled>=(91-`c') & Nenrolled<(91+`c')  & grade==`g'  ,  clu(school) 

        mat coefi[`i',4]= round(_b[z3], 0.00001)
		mat coefi[`j',4]= round(_se[z3], 0.000001)
		mat coefi[`i',10]= round((2 * ttail(e(df_r), abs(_b[z3]/_se[z3]))), 0.000001)
		*mat coefi[`i',4]= e(N)
		*sum  `x' if e(sample)==1  & treat2_2021==0
		*mat coefi[`i',1]= round(r(mean), 0.00001)



******Z4
reg `x' z4 $enrollment_controlz4 $year_dummy $controls if Nenrolled>=(121-`c') & Nenrolled<(121+`c')  & grade==`g'  ,  clu(school) 

        mat coefi[`i',5]= round(_b[z4], 0.00001)
		mat coefi[`j',5]= round(_se[z4], 0.000001)
		mat coefi[`i',11]= round((2 * ttail(e(df_r), abs(_b[z4]/_se[z4]))), 0.000001)
		*mat coefi[`i',4]= e(N)
		*sum  `x' if e(sample)==1  & treat2_2021==0
		*mat coefi[`i',1]= round(r(mean), 0.00001)


******Z5
reg `x' z5 $enrollment_controlz5 $year_dummy $controls if Nenrolled>=(151-`c') & Nenrolled<(151+`c')  & grade==`g'  ,  clu(school) 

        mat coefi[`i',6]= round(_b[z5], 0.00001)
		mat coefi[`j',6]= round(_se[z5], 0.000001)
		mat coefi[`i',12]= round((2 * ttail(e(df_r), abs(_b[z5]/_se[z5]))), 0.000001)
		*mat coefi[`i',4]= e(N)
		*sum  `x' if e(sample)==1  & treat2_2021==0
		*mat coefi[`i',1]= round(r(mean), 0.00001)

		local i=`i'+ 2
		local j=`j'+ 2
		
		local l_`x': variable label `x'
		
		
	}
	
****F-Test of Joint Significance
*Academic Achievement	
reg stdyr_all $vars_balance $enrollment_control $year_dummy $controls if grade==`g'  ,  clu(school) 
*test $vars_balance
*mat coefi[`r'*2+1,1]= round(r(F),.001)
*mat coefi[`r'*2+2,1]= round(r(p), .001)
count if grade==`g'
mat coefi[`r'*2+1,1]= r(N)
*Z1	
reg z1 $vars_balance $enrollment_controlz1 $year_dummy $controls if Nenrolled>=(31-`c') & Nenrolled<(31+`c')  & grade==`g' ,  clu(school) 
*test $vars_balance
*mat coefi[`r'*2+1,2]= round(r(F),.001)
*mat coefi[`r'*2+2,2]= round(r(p), .001)
count if Nenrolled>=(31-`c') & Nenrolled<(31+`c') & grade==`g' 
mat coefi[`r'*2+1,2]= r(N)
*Z2
reg z2 $vars_balance $enrollment_controlz2 $year_dummy $controls if Nenrolled>=(61-`c') & Nenrolled<(61+`c')  & grade==`g'   ,  clu(school) 
*test $vars_balance
*mat coefi[`r'*2+1,3]= round(r(F),.001)
*mat coefi[`r'*2+2,3]= round(r(p), .001)
count if Nenrolled>=(61-`c') & Nenrolled<(61+`c') & grade==`g' 
mat coefi[`r'*2+1,3]= r(N)              
*Z3
reg z3 $vars_balance $enrollment_controlz3 $year_dummy $controls if Nenrolled>=(91-`c') & Nenrolled<(91+`c')  & grade==`g'  ,  clu(school) 
*test $vars_balance
*mat coefi[`r'*2+1,4]= round(r(F),.001)
*mat coefi[`r'*2+2,4]= round(r(p), .001)
count if Nenrolled>=(91-`c') & Nenrolled<(91+`c') & grade==`g' 
mat coefi[`r'*2+1,4]= r(N)   	
*Z4
reg z4 $vars_balance $enrollment_controlz4 $year_dummy $controls if Nenrolled>=(121-`c') & Nenrolled<(121+`c') & grade==`g'  ,  clu(school) 
*test $vars_balance
*mat coefi[`r'*2+1,5]= round(r(F),.001)
*mat coefi[`r'*2+2,5]= round(r(p), .001)
count if Nenrolled>=(121-`c') & Nenrolled<(121+`c') & grade==`g' 
mat coefi[`r'*2+1,5]= r(N)  	
*Z5
reg z5 $vars_balance $enrollment_controlz5 $year_dummy $controls if Nenrolled>=(151-`c') & Nenrolled<(151+`c') & grade==`g'   ,  clu(school) 
*test $vars_balance
*mat coefi[`r'*2+1,6]= round(r(F),.001)
*mat coefi[`r'*2+2,6]= round(r(p), .001)
count if Nenrolled>=(151-`c') & Nenrolled<(151+`c') & grade==`g'
mat coefi[`r'*2+1,6]= r(N)  		

	
	matlist coefi
	drop _all
	  svmat coefi

	  rename (coefi1 coefi2 coefi3 coefi4 coefi5 coefi6 coefi7 coefi8 coefi9 coefi10 coefi11 coefi12) (beta1 beta2 beta3 beta4 beta5 beta6 pvalue1 pvalue2 pvalue3 pvalue4 pvalue5 pvalue6)
	  
	   gen variable=""
	 
	 local i=1
	 local j=2 
	 
	 forvalue x=1/`r' {
		
		local this: word `x' of $vars_balance
		replace variable="`l_`this''" if _n==`i'
		local i=`i'+2
		
	 }
	
	forvalue x=1(1)6 {
	
	gen stars_beta`x' = "*" if pvalue`x'<=0.1 & pvalue`x'>0.05 & pvalue`x'!=.
	replace stars_beta`x' = "**" if pvalue`x'<=0.05 & pvalue`x'>0.01 & pvalue`x'!=.
	replace stars_beta`x' = "***" if pvalue`x'<=0.01 & pvalue`x'!=.
	}
	
	
	*All variables except observations
	foreach var of varlist beta1 beta2 beta3 beta4 beta5 beta6{
		
		gen `var'_s=string(`var',"%9.2f") if _n!=`r'*2+1
		replace `var'_s=string(`var',"%9.0f") if _n==`r'*2+1
		replace `var'_s="" if `var'_s=="."
		replace `var'_s="0"+`var'_s if substr(`var'_s,1,1)=="." 
		drop `var'
		rename `var'_s `var'
		
		}
	
	
	****Label the F-Test and Observations
	*replace variable="F-Test" if _n==`r'*2+1
	*replace variable="P-value of F-Test" if _n==`r'*2+2
	replace variable="Number of pupils" if _n==`r'*2+1
	
	
	forvalue x=1(1)6 {
	gen coeff`x' = beta`x' + stars_beta`x'
	replace coeff`x'="("+coeff`x'+")" if variable==""
	}

	keep variable coeff1  coeff2  coeff3  coeff4  coeff5 coeff6
	order variable coeff1  coeff2  coeff3  coeff4  coeff5 coeff6

	label var variable "Variable"
	label var  coeff1 "Test Scores"
	label var  coeff2 "Cutoff 1"
	label var  coeff3 "Cutoff 2"
	label var  coeff4 "Cutoff 3"
	label var  coeff5 "Cutoff 4"
	label var  coeff6 "Cutoff 5"
 

	 
	global noteapp1 "The table shows the RDD nonparametric estimates for the different student' observable variables. Each coefficient comes from a separate regression on the variables listed in the rows, where the running variable is the school enrollment distance to the maximum class size rule. Test scores are standardized. These regressions also include the following control variables: student enrollment relative distance to the maximum class size rule cutoff, interaction between indicator of being above the cutoff and the student enrollment relative distance to the maximum class size rule cutoff, year fixed-effects, and school administrative districts fixed-effects. Above 1st/2nd/3rd/4th/5th threshold are indicators equaling unity if school enrollment in Grade `g' exceeds the first/second/third/fourth/fifth threshold of the class size rule. Independent variables are predetermined parent and student characteristics. The window size for the school enrollment distance to the cutoff is $\pm$ `c' students. Robust standard errors, clustered on school, are shown in parentheses. Significance levels are indicated by: * significant at 10\%, ** significant at 5\%, *** significant at 1\%."
	
	texsave using "$overleaf/04_appendix/balance_stud_`c'_Grade`g'.tex", width(\textwidth) ///
	replace size(tiny) align(lcccccc) location(htbp) varlabels frag ///
	title(Balance of Applicants' Baseline Characteristics for Grade `g' in 2016-2019 (window size=`c' students).) marker(tab:balance_stud_`c'_Grade`g') ///
	footnote("$noteapp1", size(tiny)) nofix autonumber hlines(-1) 
	

	
}
}

}

**************************************************************************************
** Ejemplo Representación gráfica índica de variables socioeconómicas
**************************************************************************************

{

use "$dataoutput/Cleaned_2018_2019",clear
append using "$datatemp/Survey_Family_Grade3&6&10_2017_2018"
append using "$dataoutput/Cleaned_2016_2017"
append using "$dataoutput/Cleaned_2015_2016"

sort year ID_school grade
	
joinby year ID_school grade using "$dataoutput/Class_register_2016_2019"
	
	
*Observations including unmatched: 	618,403
*Obervations deleating unmatched: 614,969
*Observations not matched: 3434 (0.5% of observations not matched)

*Drop certian obervations
drop if Nenrolled==0 // 399 observations deleted
drop if classes_total==0 //6,681 observations deleted

*Generate one variable for public, semi-public and private school
rename public public2
gen public=1 if public2==1
replace public=2 if semi_public==1
replace public=3 if private==1
drop if private==1
****Class Size
gen class_size=Nenrolled/classes_total
lab var class_size "Average Class Size (records)"
*Basic First Stage
*1) Maximum Class Size Rule of 30 for Grades 3 & 6
*Generate Threshold dummies
gen z1=(Nenrolled>30) if Nenrolled<.
gen z2=(Nenrolled>60) if Nenrolled<.
gen z3=(Nenrolled>90) if Nenrolled<.
gen z4=(Nenrolled>120) if Nenrolled<.
gen z5=(Nenrolled>150) if Nenrolled<.

*Generate relative distance to cutoffs (running variable)
gen renrolz1=Nenrolled-31 if Nenrolled<.
gen renrolz2=Nenrolled-61 if Nenrolled<.
gen renrolz3=Nenrolled-91 if Nenrolled<.
gen renrolz4=Nenrolled-121 if Nenrolled<.
gen renrolz5=Nenrolled-151 if Nenrolled<.

*Generate interaction terms between cutoff and running variables
gen Nenrolled_z1=renrolz1*z1 if Nenrolled<. 
gen Nenrolled_z2=renrolz2*z2 if Nenrolled<.
gen Nenrolled_z3=renrolz3*z3 if Nenrolled<.
gen Nenrolled_z4=renrolz4*z4 if Nenrolled<.
gen Nenrolled_z5=renrolz5*z5 if Nenrolled<.


*Pre-determined characteristics
*Age
drop age
gen age=year-year_birth 
lab var age "Student Age"


*Age when start going to school, nursery school or daycare
gen age_start_bef2y=(age_start==1) if age_start<.
lab var age_start_bef2y "Start school, nursery or daycare before turning 2 years-old"

*Books at home
gen books_less50=(books_home<=2) if books_home<.
lab var books_less50 "Less than 50 books at home"
gen books_more50=(books_home>2) if books_home<.
lab var books_more50 "More than 50 books at home"


*Parental education
*Mother
gen mother_education_ls=(mother_education<=3) if mother_education<.
lab var mother_education_ls "Mother education: Lower secondary completed or lower"
gen mother_education_hs=(mother_education==4 | mother_education==5) if mother_education<.
lab var mother_education_hs "Mother education: Higher secondary or Vocational"
gen mother_education_un=(mother_education>=6 ) if mother_education<.
lab var mother_education_un "Mother education: Tertiary University or more"
*Father
gen father_education_ls=(father_education<=3) if father_education<.
lab var father_education_ls "Father education: Lower secondary completed or lower"
gen father_education_hs=(father_education==4 | father_education==5) if father_education<.
lab var father_education_hs "Father education: Higher secondary or Vocational"
gen father_education_un=(father_education>=6 ) if father_education<.
lab var father_education_un "Father education: Tertiary University or more"
*Years of education
gen mother_yearsedu=0 if mother_education==1 & mother_education<.
replace mother_yearsedu=6 if mother_education==2 & mother_education<.
replace mother_yearsedu=10 if mother_education==3 & mother_education<.
replace mother_yearsedu=12 if mother_education==4 & mother_education<.
replace mother_yearsedu=15 if mother_education==5 & mother_education<.
replace mother_yearsedu=15 if mother_education==6 & mother_education<.
replace mother_yearsedu=17 if mother_education==7 & mother_education<.
replace mother_yearsedu=19 if mother_education==8 & mother_education<.
replace mother_yearsedu=22 if mother_education==9 & mother_education<.
lab var mother_yearsedu "Mother years of education"
gen father_yearsedu=0 if father_education==1 & father_education<.
replace father_yearsedu=6 if father_education==2 & father_education<.
replace father_yearsedu=10 if father_education==3 & father_education<.
replace father_yearsedu=12 if father_education==4 & father_education<.
replace father_yearsedu=15 if father_education==5 & father_education<.
replace father_yearsedu=15 if father_education==6 & father_education<.
replace father_yearsedu=17 if father_education==7 & father_education<.
replace father_yearsedu=19 if father_education==8 & father_education<.
replace father_yearsedu=22 if father_education==9 & father_education<.
lab var father_yearsedu "Father years of education"

*Employment Status
gen mother_fulltime=(mother_empstatus==1) if mother_empstatus<.
lab var mother_fulltime "Mother full time worker"
gen mother_unemp=(mother_empstatus==3) if mother_empstatus<.
lab var mother_unemp "Mother unemployed"
gen father_fulltime=(father_empstatus==1) if father_empstatus<.
lab var father_fulltime "Father full time worker"
gen father_unemp=(father_empstatus==3) if father_empstatus<.
lab var father_unemp "Father unemployed"

*Parental occupation
*Mother
gen mother_occupation_el=(mother_occupation==1 | mother_occupation==2) if mother_occupation<.
lab var mother_occupation_el "Mother occupation: Elementary occupation or lower"
gen mother_occupation_adm=(mother_occupation==5) if mother_occupation<.
lab var mother_occupation_adm "Mother occupation: Administrative staff"
gen mother_occupation_techass=(mother_occupation==6) if mother_occupation<.
lab var mother_occupation_techass "Mother occupation: Technicians and scientific assistants"
gen mother_occupation_dir=(mother_occupation==7) if mother_occupation<.
lab var mother_occupation_dir "Mother occupation: Directors and managers" 
gen mother_occupation_tech=(mother_occupation==8) if mother_occupation<.
lab var mother_occupation_tech "Mother occupation: Technicians and scientific professionals" 
*Father
gen father_occupation_el=(father_occupation==1 | father_occupation==2) if father_occupation<.
lab var father_occupation_el "Father occupation: Elementary occupation or lower"
gen father_occupation_adm=(father_occupation==5) if father_occupation<.
lab var father_occupation_adm "Father occupation: Administrative staff"
gen father_occupation_techass=(father_occupation==6) if father_occupation<.
lab var father_occupation_techass "Father occupation: Technicians and scientific assistants"
gen father_occupation_dir=(father_occupation==7) if father_occupation<.
lab var father_occupation_dir "Father occupation: Directors and managers" 
gen father_occupation_tech=(father_occupation==8) if father_occupation<.
lab var father_occupation_tech "Father occupation: Technicians and scientific professionals"


*Student Standardized Test Scores
egen stdyr_all=rowmean(stdyr_math stdyr_language)

*Generate var for cluster se
egen school_year= group(ID_school year)
egen school= group(ID_school)
* Generate year FE
tabulate year, generate(yr)		
global year_dummy "yr2 yr3 yr4"	
*Enrollment controls
gen cohort2 =(Nenrolled^2)
global enrollment_controlz1  renrolz1 Nenrolled_z1
global enrollment_controlz2  renrolz2 Nenrolled_z2
global enrollment_controlz3  renrolz3 Nenrolled_z3
global enrollment_controlz4  renrolz4 Nenrolled_z4
global enrollment_controlz5  renrolz5 Nenrolled_z5

*Generate DAT FE

gen DAT2=1 if DAT=="Capital"
replace DAT2=2 if DAT=="Este"
replace DAT2=3 if DAT=="Norte"
replace DAT2=4 if DAT=="Oeste"
replace DAT2=5 if DAT=="Sur"

bys ID_school grade: egen DAT22=max(DAT2) 
drop DAT DAT2

gen DAT="Capital" if DAT22==1
replace DAT="Este"  if DAT22==2
replace DAT="Norte"  if DAT22==3
replace DAT="Oeste"  if DAT22==4
replace DAT="Sur"  if DAT22==5

tabulate DAT, generate(dat)
global controls "dat2 dat3 dat4 dat5 public"


*************

global vars_balance female spanish father_spanish mother_spanish  age_start_bef2y N_dig_devices books_less50 books_more50 mother_yearsedu  father_yearsedu mother_fulltime mother_unemp father_fulltime father_unemp mother_occupation_el father_occupation_el mother_occupation_adm  father_occupation_adm  mother_occupation_techass father_occupation_techass  

*Summary Index
*Grade 3
reg stdyr_all $vars_balance if grade==3 /*where $vars_balance are pre-determined characteristics*/
predict resid_outcome3 if grade==3 , resid   /*residuals*/
gen pr_outcome3 = stdyr_all - resid_outcome3 if grade==3  /*fitted values */

*Grade 6
reg stdyr_all $vars_balance if grade==6 /*where $vars_balance are pre-determined characteristics*/
predict resid_outcome6 if grade==6 , resid   /*residuals*/
gen pr_outcome6 = stdyr_all - resid_outcome6 if grade==6 /*fitted values */

*Grade 10
reg stdyr_all $vars_balance if grade==10 /*where $vars_balance are pre-determined characteristics*/
predict resid_outcome10 if grade==10 , resid   /*residuals*/
gen pr_outcome10 = stdyr_all - resid_outcome10 if grade==10 /*fitted values */

** Standardize grades with respect to mean and s.d. of each year
foreach y of varlist pr_outcome3 pr_outcome6 pr_outcome10{
	egen std_`y'=std(`y')  , mean(0) std(1)
}

capture drop __00000*
*Bins 
set more off
egen Xjlb=cut(Nenrolled), at(1(3)237)
gen Xj=Xjlb
tab Xj, gen(bin_dumm)
gen uno=1
egen n_bin=sum(uno), by(Xj)
egen n_tot=sum(uno) 
gen Yj=n_bin/(n_tot*3) 
rename Xj Nenrolled_bin
lab var  Nenrolled_bin "Number of students enrolled"


***Graphs 
*Grade 3
bys Nenrolled_bin: egen std_pr_outcome_g3=mean(std_pr_outcome3) 

twoway (scatter std_pr_outcome_g3 Nenrolled_bin if Nenrolled<180, mcolor(navy) msize(small)) , ///
ytitle("Predicted Summary Index in Grade 3 (Std.)", size(medsmall) margin(medsmall) ) ///
xtitle("School Enrollment in Grade 3 ", size(medsmall) margin(medsmall) ) xlabel(0(15)180) ///
xline(30, lcolor(red) lpattern(dash)) xline(60, lcolor(red) lpattern(dash))  xline(90, lcolor(red) lpattern(dash)) xline(120, lcolor(red) lpattern(dash)) xline(150, lcolor(red) lpattern(dash)) graphregion(color(white)) plotregion(style(none)) leg(off) 
graph export "$overleaf/04_appendix/summaryidx_g3.png", replace


*Grade 6
bys Nenrolled_bin: egen std_pr_outcome_g6=mean(std_pr_outcome6) 

twoway (scatter std_pr_outcome_g6 Nenrolled_bin if Nenrolled<180, mcolor(navy) msize(small)) , ///
ytitle("Predicted Summary Index in Grade 6 (Std.)", size(medsmall) margin(medsmall) ) ///
xtitle("School Enrollment in Grade 6 ", size(medsmall) margin(medsmall) ) xlabel(0(15)180) ///
xline(30, lcolor(red) lpattern(dash)) xline(60, lcolor(red) lpattern(dash))  xline(90, lcolor(red) lpattern(dash)) xline(120, lcolor(red) lpattern(dash)) xline(150, lcolor(red) lpattern(dash)) graphregion(color(white)) plotregion(style(none)) leg(off) 
graph export "$overleaf/04_appendix/summaryidx_g6.png", replace



*Grade 10
bys Nenrolled_bin: egen std_pr_outcome_g10=mean(std_pr_outcome10) 

twoway (scatter std_pr_outcome_g10 Nenrolled_bin if Nenrolled<190, mcolor(navy) msize(small)) , ///
ytitle("Predicted Summary Index in Grade 10 (Std.)", size(medsmall) margin(medsmall) ) ///
xtitle("School Enrollment in Grade 10 ", size(medsmall) margin(medsmall) ) xlabel(0(33)180) ///
xline(33, lcolor(red) lpattern(dash)) xline(66, lcolor(red) lpattern(dash))  xline(99, lcolor(red) lpattern(dash)) xline(132, lcolor(red) lpattern(dash)) xline(165, lcolor(red) lpattern(dash)) graphregion(color(white)) plotregion(style(none)) leg(off) 
graph export "$overleaf/04_appendix/summaryidx_g10.png", replace


}







