
/* ----------------------------------------------------------------------------*
								
								PROYECTO BECAS ESADE
								
						Descriptive Statistics & Internal Validity
										 ---
									 Jose & Lucía
									 
------------------------------------------------------------------------------*/

clear all
set seed 123456789

// 0 - Set working directories (see [0] Master) | Multi-user setup: 

{
*Lucía Cobreros 
if c(username) == "lucia.cobreros"{
	global dofiles "/Users/lucia.cobreros/Documents/GitHub/Proyecto-Becas-ESADE/Prog"
 }

*Jose (laptop)
if c(username) == "pepemontalbancastilla"{
	global dofiles ""
 }

*Jose (SOFI)
if c(username) == "jomo0019"{
	global dofiles ""
 }

}
run "${dofiles}/[0] Master.do"

* First, we have run [1] Clean - Becas to prepare the dataset. 

**************************************************************************************
// 1 - Generate thresholds & Running variable 
**************************************************************************************

use "$dataoutput/Becas.dta",clear 

//1.1. Missing values - Income

{
mdesc inc_*

*"Renta con deducciones" (net) has 53,151 (31% missing), while "Renta sin deducciones"  (gross)  has  7,163 (4% missing) --> There is no data for net income until 2016
gen miss_inc_net=(inc_net==.)
lab var miss_inc_net "Renta con deducciones missing"
gen miss_inc_gross=(inc_gross==.)
lab var miss_inc_gross "Renta sin deducciones missing"

tab miss_inc_gross year
tab miss_inc_net year
}

// 1.2. Income thresholds - below which students recieve a grant 

{
* --> Umbral 3: Fee waiver (matrícula)
gen thd3=.
replace thd3=14112 if hhsize==1 
replace thd3=24089 if hhsize==2  
replace thd3=32697 if hhsize==3  
replace thd3=38831 if hhsize==4  
replace thd3=43402 if hhsize==5 
replace thd3=46853 if hhsize==6 
replace thd3=50267 if hhsize==7  
replace thd3=53665 if hhsize==8
replace thd3=53665+3391 if hhsize==9
replace thd3=53665+3391*2 if hhsize==10
replace thd3=53665+3391*3 if hhsize==11
replace thd3=53665+3391*4 if hhsize==12
replace thd3=53665+3391*5 if hhsize==13
replace thd3=53665+3391*6 if hhsize==14
replace thd3=53665+3391*7 if hhsize==15

/* 
local increment = 3391
forvalues i = 9/`=_N' {
    replace thd3 = 53665 + (`i' - 8) * `increment' if hhsize == `i'
}
*/

lab var thd3 "Umbral 3 - FW"

	*Generate distance to threshold for both incomes
	*a) "Net" income (absolute and relative distance)
	gen dist_thd3=inc_net-thd3
	lab var dist_thd3 "Distancia U3: Ingreso con deducc."

	gen rel_dist_thd3=.
	replace rel_dist_thd3=dist_thd3/thd3
	lab var rel_dist_thd3 "Distancia Relativa U3: Ingreso con deduc."

	*b) "Gross" income (absolute and relative distance)
	gen dist_thd32=inc_gross-thd3
	lab var dist_thd32 "Distancia U3: Ingreso sin deduc."

	gen rel_dist_thd32=.
	replace rel_dist_thd32=dist_thd32/thd3
	lab var rel_dist_thd32 "Distancia Relativa U3: Ingreso sin deduc."

* --> Umbral 2: Fee waiver + A 
gen thd2=.
replace thd2=13236 if hhsize==1 
replace thd2=22594 if hhsize==2 
replace thd2=30668 if hhsize==3 
replace thd2=36421 if hhsize==4  
replace thd2=40708 if hhsize==5  
replace thd2=43945 if hhsize==6 
replace thd2=47149 if hhsize==7 
replace thd2=50333 if hhsize==8 
replace thd2=50333+3181 if hhsize==9 
replace thd2=50333+3181*2 if hhsize==10 
replace thd2=50333+3181*3 if hhsize==11
replace thd2=50333+3181*4 if hhsize==12
replace thd2=50333+3181*5 if hhsize==13 
replace thd2=50333+3181*6 if hhsize==14 
replace thd2=50333+3181*7 if hhsize==15

/*
local increment = 3181
forvalues i = 9/`=_N' {
    replace thd2 = 50333 + (`i' - 8) * `increment' if hhsize == `i'
}
*/

lab var thd2 "Umbral 2 - FW + A"

	*Generate distance to threshold for both incomes
	*a) "Net" income (absolute and relative distance)
	gen dist_thd2=inc_net-thd2
	lab var dist_thd2 "Distancia U2: Ingreso con deducc."

	gen rel_dist_thd2=.
	replace rel_dist_thd2=dist_thd2/thd2
	lab var rel_dist_thd2 "Distancia Relativa U2: Ingreso con deduc."

	*b) "Gross" income (absolute and relative distance)
	gen dist_thd22=inc_gross-thd2
	lab var dist_thd22 "Distancia U2: Ingreso sin deduc."

	gen rel_dist_thd22=.
	replace rel_dist_thd22=dist_thd22/thd2
	lab var rel_dist_thd22 "Distancia Relativa U2: Ingreso sin deduc."

* --> Umbral 1: Fee waiver + AA
gen thd1=.
replace thd1=3771 if hhsize==1 
replace thd1=7278 if hhsize==2 
replace thd1=10606 if hhsize==3 
replace thd1=13909 if hhsize==4 
replace thd1=17206 if hhsize==5 
replace thd1=20430 if hhsize==6 
replace thd1=23580 if hhsize==7 
replace thd1=26660 if hhsize==8 
replace thd1=26660+3079 if hhsize==9
replace thd1=26660+3079*2 if hhsize==10
replace thd1=26660+3079*3 if hhsize==11
replace thd1=26660+3079*4 if hhsize==12
replace thd1=26660+3079*5 if hhsize==13
replace thd1=26660+3079*6 if hhsize==14
replace thd1=26660+3079*7 if hhsize==15

/*
local increment = 3079
forvalues i = 9/`=_N' {
    replace thd1 = 26660 + (`i' - 8) * `increment' if hhsize == `i'
}
*/

lab var thd1 "Umbral 1 - FW + AA"

	*Generate distance to threshold for both incomes
	*a) "Net" income (absolute and relative distance)
	gen dist_thd1=inc_net-thd1
	lab var dist_thd1 "Distancia U1: Ingreso con deducc."

	gen rel_dist_thd1=.
	replace rel_dist_thd1=dist_thd1/thd1
	lab var rel_dist_thd1 "Distancia Relativa U1: Ingreso con deduc."

	*b) "Gross" income (absolute and relative distance)
	gen dist_thd12=inc_gross-thd1
	lab var dist_thd12 "Distancia U1: Ingreso sin deduc."

	gen rel_dist_thd12=.
	replace rel_dist_thd12=dist_thd12/thd1
	lab var rel_dist_thd12 "Distancia Relativa U2: Ingreso sin deduc."

}

// 1.3. Other variables

{
* Private unis
gen private_uni = 0
local private_codes 2 6 16 18 19 20 23 24 28 30 34 41 50 51 52 58 59 61 62 63 64 65 66 67 68 69 74 75 76 80 81 82
foreach code in `private_codes' {
    replace private_uni = 1 if university_id == `code'
}

}

**************************************************************************************
// 2 - Income jumps for the 3 threshoolds 
**************************************************************************************

// 2.1. Grant jumps using income with deductions 

{
	//2.1.1. Create Bins 

*Bins de Ingreso U3
capture drop __00000*
set more off

egen Xjlb=cut(rel_dist_thd3), at(-0.6(.025)0.6)
gen Xj=Xjlb+(.025/2) 
tab Xj, gen(bin_dumm)
gen uno=1
egen n_bin=sum(uno), by(Xj)
egen n_tot=sum(uno) 
gen Yj=n_bin/(n_tot*.025) // --> Densidad
rename Xj inc_distance_bin_U3
lab var inc_distance_bin_U3 "Relative Income-Distance to Eligibility Cutoff U3"
drop Xjlb uno n_bin n_tot Yj bin_dumm*

bys inc_distance_bin_U3: egen cuantia_recibida_U3=mean(amount)
bys inc_distance_bin_U3: egen estado_U3=mean(status)

*Bins de Ingreso U2
capture drop __00000*

set more off
egen Xjlb=cut(rel_dist_thd2), at(-0.6(.025)0.6)
gen Xj=Xjlb+(.025/2) 
tab Xj, gen(bin_dumm)
gen uno=1
egen n_bin=sum(uno), by(Xj)
egen n_tot=sum(uno) 
gen Yj=n_bin/(n_tot*.025) 
rename Xj inc_distance_bin_U2
lab var inc_distance_bin_U2 "Relative Income-Distance to Eligibility Cutoff U2"
drop Xjlb uno n_bin n_tot Yj bin_dumm*

bys inc_distance_bin_U2: egen cuantia_recibida_U2=mean(amount)
bys inc_distance_bin_U2: egen estado_U2=mean(status)

*Bins de Ingreso U1
capture drop __00000*

set more off
egen Xjlb=cut(rel_dist_thd1), at(-0.6(.025)0.6)
gen Xj=Xjlb+(.025/2) 
tab Xj, gen(bin_dumm)
gen uno=1
egen n_bin=sum(uno), by(Xj)
egen n_tot=sum(uno) 
gen Yj=n_bin/(n_tot*.025) 
rename Xj inc_distance_bin_U1
lab var inc_distance_bin_U1 "Relative Income-Distance to Eligibility Cutoff U1"
drop Xjlb uno n_bin n_tot Yj bin_dumm*

bys inc_distance_bin_U1: egen cuantia_recibida_U1=mean(amount)
bys inc_distance_bin_U1: egen estado_U1=mean(status)

	//2.1.2. Graphical analysis 
	//a) Gráficos de saltos del estado de la Beca 

	*U1 (alumnado con menor renta)
gr twoway (scatter estado_U1 inc_distance_bin_U1, msymbol(circle) msize(small) mcolor(navy) ylabel(0(0.2)1, gmax) xlabel(-0.6(.1)0.6, format(%9.0gc))  ), ///
xline(0, lcolor(red) lpattern(dash))  graphregion(color(white)) legend(off) ///
xtitle("Relative Income-Distance to Eligibility Cutoff U1", size(small) height(5))  ytitle("Estado de la Beca (0-1)", size(small) height(5)) ///   
title( "T1 Discontinuity",color(g10) height(5) size(large))
graph export "$figures/estado_U1_condeduccion.pdf", replace

	*U2 --> Hay gente que se está por encima del umbral y aun así recibe la beca (identificar)
gr twoway (scatter estado_U2 inc_distance_bin_U2, msymbol(circle) msize(small) mcolor(navy) ylabel(0(0.2)1, gmax) xlabel(-0.6(.1)0.6, format(%9.0gc))  ), ///
xline(0, lcolor(red) lpattern(dash))  graphregion(color(white)) legend(off) ///
xtitle("Relative Income-Distance to Eligibility Cutoff U2", size(small) height(5))  ytitle("Estado de la Beca (0-1)", size(small) height(5)) ///   
title( "T2 Discontinuity",color(g10) height(5) size(large) )
graph export "$figures/estado_U2_condeduccion.pdf", replace	

	*U3 --> Prob no es 1, es 0 (como con U2) por lo que tenemos no compliance y quizá sea necesario fuz
gr twoway (scatter estado_U3 inc_distance_bin_U3, msymbol(circle) msize(small) mcolor(navy) ylabel(0(0.2)1, gmax) xlabel(-0.6(.1)0.6, format(%9.0gc))  ), ///
xline(0, lcolor(red) lpattern(dash))  graphregion(color(white)) legend(off) ///
xtitle("Relative Income-Distance to Eligibility Cutoff U3", size(small) height(5))  ytitle("Estado de la Beca (0-1)", size(small) height(5)) ///   
title( "T3 Discontinuity",color(g10) height(5) size(large) )
graph export "$figures/estado_U3_condeduccion.pdf", replace	

	//b) Saltos en la cantidad recibida de beca (€)

	*U1
gr twoway (scatter cuantia_recibida_U1 inc_distance_bin_U1, msymbol(circle) msize(small) mcolor(navy) ylabel(1000(500)3000, gmax) xlabel(-0.6(.1)0.6, format(%9.0gc))  ), ///
xline(0, lcolor(red) lpattern(dash))  graphregion(color(white)) legend(off) ///
xtitle("Relative Income-Distance to Eligibility Cutoff U1", size(small) height(5))  ytitle("Amount of Cash Allowance Awarded (Euros)", size(small) height(5)) ///   
title( "T1 Discontinuity",color(g10) height(5) size(large) )
graph export "$figures/Cantidadbeca_U1_condeduccion.pdf", replace

	*U2 --> Si es mayor que el umbral, no deberían recibir una cantidad? (A)
gr twoway (scatter cuantia_recibida_U2 inc_distance_bin_U2, msymbol(circle) msize(small) mcolor(navy) ylabel(0(250)2000, gmax) xlabel(-0.6(.1)0.6, format(%9.0gc))  ), ///
xline(0, lcolor(red) lpattern(dash))  graphregion(color(white)) legend(off) ///
xtitle("Relative Income-Distance to Eligibility Cutoff U2", size(small) height(5))  ytitle("Amount of Cash Allowance Awarded (Euros)", size(small) height(5)) ///   
title( "T2 Discontinuity",color(g10) height(5) size(large) )
graph export "$figures/Cantidadbeca_U2_condeduccion.pdf", replace	

	*U3 --> Prácticamente mismo gráfico que U2 en cuantía (no tiene sentido)
gr twoway (scatter cuantia_recibida_U3 inc_distance_bin_U3, msymbol(circle) msize(small) mcolor(navy) ylabel(0(250)2000, gmax) xlabel(-0.6(.1)0.6, format(%9.0gc))  ), ///
xline(0, lcolor(red) lpattern(dash))  graphregion(color(white)) legend(off) ///
xtitle("Relative Income-Distance to Eligibility Cutoff U3", size(small) height(5))  ytitle("Amount of Cash Allowance Awarded (Euros)", size(small) height(5)) ///   
title( "T3 Discontinuity",color(g10) height(5) size(large) )
graph export "$figures/Cantidadbeca_U3_condeduccion.pdf", replace	
}

// 2.2. Grant jumps using income without deductions (gross)

{
drop inc_distance_bin_*
drop cuantia_recibida_* estado_*

	//2.1.1. Create Bins 

*Bins de Ingreso U3
capture drop __00000*

set more off
egen Xjlb=cut(rel_dist_thd32), at(-0.6(.025)0.6)
gen Xj=Xjlb+(.025/2) 
tab Xj, gen(bin_dumm)
gen uno=1
egen n_bin=sum(uno), by(Xj)
egen n_tot=sum(uno) 
gen Yj=n_bin/(n_tot*.025) 
rename Xj inc_distance_bin_U3
lab var inc_distance_bin_U3 "Relative Income-Distance to Eligibility Cutoff U3 (without deductions)"
drop Xjlb uno n_bin n_tot Yj bin_dumm*

bys inc_distance_bin_U3: egen cuantia_recibida_U3=mean(amount)
bys inc_distance_bin_U3: egen estado_U3=mean(status)

*Bins de Ingreso U2
capture drop __00000*

set more off
egen Xjlb=cut(rel_dist_thd22), at(-0.6(.025)0.6)
gen Xj=Xjlb+(.025/2) 
tab Xj, gen(bin_dumm)
gen uno=1
egen n_bin=sum(uno), by(Xj)
egen n_tot=sum(uno) 
gen Yj=n_bin/(n_tot*.025) 
rename Xj inc_distance_bin_U2
lab var inc_distance_bin_U2 "Relative Income-Distance to Eligibility Cutoff U2 (without deductions)"
drop Xjlb uno n_bin n_tot Yj bin_dumm*

bys inc_distance_bin_U2: egen cuantia_recibida_U2=mean(amount)
bys inc_distance_bin_U2: egen estado_U2=mean(status)

*Crear bins de Ingreso U1
capture drop __00000*
 
set more off
egen Xjlb=cut(rel_dist_thd12), at(-0.6(.025)0.6)
gen Xj=Xjlb+(.025/2) 
tab Xj, gen(bin_dumm)
gen uno=1
egen n_bin=sum(uno), by(Xj)
egen n_tot=sum(uno) 
gen Yj=n_bin/(n_tot*.025) 
rename Xj inc_distance_bin_U1
lab var inc_distance_bin_U1 "Relative Income-Distance to Eligibility Cutoff U1 (without deductions)"
drop Xjlb uno n_bin n_tot Yj bin_dumm*

bys inc_distance_bin_U1: egen cuantia_recibida_U1=mean(amount)
bys inc_distance_bin_U1: egen estado_U1=mean(status)

	//2.1.2. Graphical analysis 
	
	//a) Gráficos de saltos del estado de la Beca 

	*U1
gr twoway (scatter estado_U1 inc_distance_bin_U1, msymbol(circle) msize(small) mcolor(navy) ylabel(0(0.2)1, gmax) xlabel(-0.6(.1)0.6, format(%9.0gc))  ), ///
xline(0, lcolor(red) lpattern(dash))  graphregion(color(white)) legend(off) ///
xtitle("Relative Income-Distance to Eligibility Cutoff U1 (without deductions)", size(small) height(5))  ytitle("Estado de la Beca (0-1)", size(small) height(5)) ///   
title( "T1 Discontinuity",color(g10) height(5) size(large) )
graph export "$figures/estado_U1_sindeduccion.pdf", replace

	*U2
gr twoway (scatter estado_U2 inc_distance_bin_U2, msymbol(circle) msize(small) mcolor(navy) ylabel(0(0.2)1, gmax) xlabel(-0.6(.1)0.6, format(%9.0gc))  ), ///
xline(0, lcolor(red) lpattern(dash))  graphregion(color(white)) legend(off) ///
xtitle("Relative Income-Distance to Eligibility Cutoff U2 (without deductions)", size(small) height(5))  ytitle("Estado de la Beca (0-1)", size(small) height(5)) ///   
title( "T2 Discontinuity",color(g10) height(5) size(large) )
graph export "$figures/estado_U2_sindeduccion.pdf", replace	

	*U3
gr twoway (scatter estado_U3 inc_distance_bin_U3, msymbol(circle) msize(small) mcolor(navy) ylabel(0(0.2)1, gmax) xlabel(-0.6(.1)0.6, format(%9.0gc))  ), ///
xline(0, lcolor(red) lpattern(dash))  graphregion(color(white)) legend(off) ///
xtitle("Relative Income-Distance to Eligibility Cutoff U3 (without deductions)", size(small) height(5))  ytitle("Estado de la Beca (0-1)", size(small) height(5)) ///   
title( "T3 Discontinuity",color(g10) height(5) size(large) )
graph export "$figures/estado_U3_sindeduccion.pdf", replace	

	//a) Gráficos de saltos de las cantidades (€) recibidas

	*U1
gr twoway (scatter cuantia_recibida_U1 inc_distance_bin_U1, msymbol(circle) msize(small) mcolor(navy) ylabel(1000(500)3000, gmax) xlabel(-0.6(.1)0.6, format(%9.0gc))  ), ///
xline(0, lcolor(red) lpattern(dash))  graphregion(color(white)) legend(off) ///
xtitle("Relative Income-Distance to Eligibility Cutoff U1 (without deductions)", size(small) height(5))  ytitle("Amount of Cash Allowance Awarded (Euros)", size(small) height(5)) ///   
title( "T1 Discontinuity",color(g10) height(5) size(large) )
graph export "$figures/Cantidadbeca_U1_sindeduccion.pdf", replace

	*U2
gr twoway (scatter cuantia_recibida_U2 inc_distance_bin_U2, msymbol(circle) msize(small) mcolor(navy) ylabel(0(250)2000, gmax) xlabel(-0.6(.1)0.6, format(%9.0gc))  ), ///
xline(0, lcolor(red) lpattern(dash))  graphregion(color(white)) legend(off) ///
xtitle("Relative Income-Distance to Eligibility Cutoff U2 (without deductions)", size(small) height(5))  ytitle("Amount of Cash Allowance Awarded (Euros)", size(small) height(5)) ///   
title( "T2 Discontinuity",color(g10) height(5) size(large) )
graph export "$figures/Cantidadbeca_U2_sindeduccion.pdf", replace	

	*U3
gr twoway (scatter cuantia_recibida_U3 inc_distance_bin_U3, msymbol(circle) msize(small) mcolor(navy) ylabel(0(250)2000, gmax) xlabel(-0.6(.1)0.6, format(%9.0gc))  ), ///
xline(0, lcolor(red) lpattern(dash))  graphregion(color(white)) legend(off) ///
xtitle("Relative Income-Distance to Eligibility Cutoff U3 (without deductions)", size(small) height(5))  ytitle("Amount of Cash Allowance Awarded (Euros)", size(small) height(5)) ///   
title( "T3 Discontinuity",color(g10) height(5) size(large) )
graph export "$figures/Cantidadbeca_U3_sindeduccion.pdf", replace	

drop inc_distance_bin_*
drop cuantia_recibida_* estado_*

}
save "$dataoutput/Becas_2013_20.dta",replace	

**************************************************************************************
*  3 - Internal validity (continuidad del score): Ingreso con deducciones 
**************************************************************************************

//3.1) Histograma de Distancia Relativa del Ingreso a los Umbrales

use "$dataoutput/Becas_2013_20.dta",clear

{
*a) Toda la distribución de ingresos con deducciones --> Vemos un pico 
twoway (histogram inc_net if inrange(inc_net,10000, 11000)==1 , bin(50) color(gray%30) ), ///
		ytitle("Density", height(5) size(medsmall) margin(medsmall) ) ///
		yscale(lstyle(none)) ///
		ylabel( , nogrid format(%9.2f) ) ///
		xtitle("Renta Familiar (euros)", height(5) size(medsmall) margin(medsmall) ) ///
		xscale(lstyle(none)) ///
		graphregion(color(white)) plotregion(style(none)) legend(off)  
        graph export "$figures/histograma_condeduccion.pdf", replace
		
*U1
twoway (histogram rel_dist_thd1 if inrange(rel_dist_thd1,-0.6, 0.6)==1 , bin(50) color(gray%30) ), ///
		ytitle("Density", height(5) size(medsmall) margin(medsmall) ) ///
		yscale(lstyle(none)) ///
		ylabel( , nogrid format(%9.2f) ) ///
		xtitle("Relative Income-Distance to Eligibility Cutoff U1", height(5) size(medsmall) margin(medsmall) ) ///
		xscale(lstyle(none)) ///
		xlabel(-0.6(.1)0.6 , nogrid ) ///
		xline(0, lcolor(red) lpattern(dash) lw(med)) ///
		graphregion(color(white)) plotregion(style(none)) legend(off)  
        graph export "$figures/histograma_U1_condeduccion.pdf", replace
		
*U2
twoway (histogram rel_dist_thd2 if inrange(rel_dist_thd2,-0.6, 0.6)==1 , bin(50) color(gray%30) ), ///
		ytitle("Density", height(5) size(medsmall) margin(medsmall) ) ///
		yscale(lstyle(none)) ///
		ylabel( , nogrid format(%9.2f) ) ///
		xtitle("Relative Income-Distance to Eligibility Cutoff U2", height(5) size(medsmall) margin(medsmall) ) ///
		xscale(lstyle(none)) ///
		xlabel(-0.6(.1)0.6 , nogrid ) ///
		xline(0, lcolor(red) lpattern(dash) lw(med)) ///
		graphregion(color(white)) plotregion(style(none)) legend(off)  
        graph export "$figures/histograma_U2_condeduccion.pdf", replace		
		
*U3
twoway (histogram rel_dist_thd3 if inrange(rel_dist_thd3,-0.6, 0.6)==1 , bin(50) color(gray%30) ), ///
		ytitle("Density", height(5) size(medsmall) margin(medsmall) ) ///
		yscale(lstyle(none)) ///
		ylabel( , nogrid format(%9.2f) ) ///
		xtitle("Relative Income-Distance to Eligibility Cutoff U3", height(5) size(medsmall) margin(medsmall) ) ///
		xscale(lstyle(none)) ///
		xlabel(-0.6(.1)0.6 , nogrid ) ///
		xline(0, lcolor(red) lpattern(dash) lw(med)) ///
		graphregion(color(white)) plotregion(style(none)) legend(off)  
        graph export "$figures/histograma_U3_condeduccion.pdf", replace			

}


//3.2. Test de Densidad Umbrales

*3.2) McCrary Test (2008)

{

*U1
use "$dataoutput/Becas_2013_20.dta",clear
DCdensity_m rel_dist_thd1 if rel_dist_thd1>-0.6 & rel_dist_thd1<0.6, breakpoint(0) b(0) generate(Xj Yj r0 fhat se_fhat) 

g bw = r(bandwidth)
replace Xj=. if (Xj<=-0.60 | Xj>0.60)
replace fhat=. if (r0<=-0.60+bw | r0>0.60-bw)
g up = fhat + 1.96*se_fhat
g low = fhat - 1.96*se_fhat
gr twoway (scatter Yj Xj, msymbol(circle_hollow) mcolor(gray))   ///       
      (line fhat r0 if r0 < 0, lcolor(black) lwidth(medthick))  ///
       (line fhat r0 if r0 > 0, lcolor(black) lwidth(medthick))   ///
          (line up r0 if r0 < 0, lcolor(black) lwidth(vthin))              ///
            (line low r0 if r0 < 0, lcolor(black) lwidth(vthin))              ///
              (line up r0 if r0 > 0, lcolor(black) lwidth(vthin))              ///
                (line low r0 if r0 > 0, lcolor(black) lwidth(vthin)),         ///    
			xline(0, lcolor(red) lpattern(dash) lw(med)) legend(off) graphregion(color(white)) xlabel(-0.6(0.1)0.66, format(%9.0gc)) ///
			xtitle("Relative Income-Distance to Eligibility Cutoff", height(5))  ytitle("Density Estimate", height(5)) title("T1 Discontinuity", height(5) size(large) color(g10)) 
			graph export "$figures/Mccrary_U1_condeduccion.pdf", replace

*U2
use "$dataoutput/Becas_2013_20.dta",clear
DCdensity_m rel_dist_thd2 if rel_dist_thd2>-0.6 & rel_dist_thd2<0.6, breakpoint(0) b(0) generate(Xj Yj r0 fhat se_fhat) 

g bw = r(bandwidth)
replace Xj=. if (Xj<=-0.60 | Xj>0.60)
replace fhat=. if (r0<=-0.60+bw | r0>0.60-bw)
g up = fhat + 1.96*se_fhat
g low = fhat - 1.96*se_fhat
gr twoway (scatter Yj Xj, msymbol(circle_hollow) mcolor(gray))   ///       
      (line fhat r0 if r0 < 0, lcolor(black) lwidth(medthick))  ///
       (line fhat r0 if r0 > 0, lcolor(black) lwidth(medthick))   ///
          (line up r0 if r0 < 0, lcolor(black) lwidth(vthin))              ///
            (line low r0 if r0 < 0, lcolor(black) lwidth(vthin))              ///
              (line up r0 if r0 > 0, lcolor(black) lwidth(vthin))              ///
                (line low r0 if r0 > 0, lcolor(black) lwidth(vthin)),         ///    
			xline(0, lcolor(red) lpattern(dash) lw(med)) legend(off) graphregion(color(white)) xlabel(-0.6(0.1)0.66, format(%9.0gc)) ///
			xtitle("Relative Income-Distance to Eligibility Cutoff", height(5))  ytitle("Density Estimate", height(5)) title("T2 Discontinuity", height(5) size(large) color(g10)) 
			graph export "$figures/Mccrary_U2_condeduccion.pdf", replace
			
*U3
use "$dataoutput/Becas_2013_20.dta",clear
DCdensity_m rel_dist_thd3 if rel_dist_thd3>-0.6 & rel_dist_thd3<0.6, breakpoint(0) b(0) generate(Xj Yj r0 fhat se_fhat) 

g bw = r(bandwidth)
replace Xj=. if (Xj<=-0.60 | Xj>0.60)
replace fhat=. if (r0<=-0.60+bw | r0>0.60-bw)
g up = fhat + 1.96*se_fhat
g low = fhat - 1.96*se_fhat
gr twoway (scatter Yj Xj, msymbol(circle_hollow) mcolor(gray))   ///       
      (line fhat r0 if r0 < 0, lcolor(black) lwidth(medthick))  ///
       (line fhat r0 if r0 > 0, lcolor(black) lwidth(medthick))   ///
          (line up r0 if r0 < 0, lcolor(black) lwidth(vthin))              ///
            (line low r0 if r0 < 0, lcolor(black) lwidth(vthin))              ///
              (line up r0 if r0 > 0, lcolor(black) lwidth(vthin))              ///
                (line low r0 if r0 > 0, lcolor(black) lwidth(vthin)),         ///    
			xline(0, lcolor(red) lpattern(dash) lw(med)) legend(off) graphregion(color(white)) xlabel(-0.6(0.1)0.66, format(%9.0gc)) ///
			xtitle("Relative Income-Distance to Eligibility Cutoff", height(5))  ytitle("Density Estimate", height(5)) title("T3 Discontinuity", height(5) size(large) color(g10)) 
			graph export "$figures/Mccrary_U3_condeduccion.pdf", replace			

}

*3.3) RDDENSITY (Cattaneo et al, 2018)

use "$dataoutput/Becas_2013_20.dta",clear

{
*We have to flip the relative distance to use RDrobust in an intuitive way
gen rel_dist_flipp_thd1=(-1)*rel_dist_thd1
gen rel_dist_flipp_thd2=(-1)*rel_dist_thd2
gen rel_dist_flipp_thd3=(-1)*rel_dist_thd3

estimates clear
capture matrix drop res

foreach c in 1 2 3{	

	*** Model 1: assuming equal c.d.f. on each side, linear poly, symmetric bandwdith
	rddensity rel_dist_flipp_thd`c', c(0) p(1) bwselect(diff) fitselect(restricted) all kernel(triangular) vce(jackknife) // No en todas las universidades 
	cap mat drop tmp
	mat tmp = nullmat(tmp) , e(h_l)	// col 1 is h_
	mat tmp = tmp , e(h_r)			// col 2 is h+
	mat tmp = tmp , e(N_h_l)		// col 3 is Nw_
	mat tmp = tmp , e(N_h_r)		// col 4 is Nw+
	mat tmp = tmp , e(pv_q) 		// col 5 is density test p-values
	mat rownames tmp = c`c'_res_symbw_p1
	if `c' == 1{
		mat res = nullmat(res) \ tmp
	}
	else {
		mat res = res \ tmp	
	}
	
	*** Model 3: NOT assuming equal c.d.f. on each side, linear poly, symmetric bandwdith
	rddensity rel_dist_flipp_thd`c', c( 0 ) p(1) bwselect(diff) fitselect(unrestricted) all kernel(triangular) vce(jackknife) 
	cap mat drop tmp
	mat tmp = nullmat(tmp) , e(h_l)		// col 1 is h_
	mat tmp = tmp , e(h_r)				// col 2 is h+
	mat tmp = tmp , e(N_h_l)			// col 3 is Nw_
	mat tmp = tmp , e(N_h_r)			// col 4 is Nw+
	mat tmp = tmp , e(pv_q) 			// col 5 is density test p-values
	mat rownames tmp = c`c'_unres_symbw_p1
	mat res = res \ tmp	
	
	** Model 5: NOT assuming equal c.d.f. on each side, linear poly, asymmetric bandwdith
	rddensity rel_dist_flipp_thd`c', c( 0 ) p(1) bwselect(each) fitselect(unrestricted) all kernel(triangular) vce(jackknife) 
	cap mat drop tmp
	mat tmp = nullmat(tmp) , e(h_l)		// col 1 is h_
	mat tmp = tmp , e(h_r)				// col 2 is h+
	mat tmp = tmp , e(N_h_l)			// col 3 is Nw_
	mat tmp = tmp , e(N_h_r)			// col 4 is Nw+
	mat tmp = tmp , e(pv_q) 			// col 5 is density test p-values
	mat rownames tmp = c`c'_unres_asymbw_p1
	mat res = res \ tmp	
	
} 
	
* Check complete matrix: 
mat colnames res =  hLeft hRight NObsLeft NObsRight pvalue

estout matrix(res, fmt(%9.3f %9.3f %9.0g %9.0g %9.3f)), varwidth(30)	 

* Tables
* Excel 
estout matrix(res, fmt(%9.3f %9.3f %9.0g %9.0g %9.3f)) using "$tables/RDdensity_condeduccion.csv", ///
		replace delimiter(,) varwidth(20) title("RD Density Results") 

* Tex 
estout matrix(res, fmt(%9.3f %9.3f %9.0g %9.0g %9.3f)) using "$tables/RDdensity_condeduccion.tex", ///
		replace delimiter(&) end(\\) ///
		prehead(`"\begin{tabular}{l*{6}{c}}"' `"\toprule"') ///
		postfoot(`"\bottomrule"'`"\end{tabular}"' )

* ¿En qué universidades hay discontinuidad en el cut-off?
}

/*
{
log using $logs/university , replace

numlabel university_id,add
tab university_id 

forvalues y=1(1)22{
	
	dis `y'
	rddensity rel_dist_flipp_thd1 if university_id==`y', c(0) p(1) bwselect(diff) fitselect(restricted) all kernel(triangular) vce(jackknife) 

}

forvalues y=82(1)82{
	
	dis `y'
	rddensity rel_dist_flipp_thd1 if university_id==`y', c(0) p(1) bwselect(diff) fitselect(restricted) all kernel(triangular) vce(jackknife) 

}

* Ocurre en: País Vasco, Santa Teresa de Ávila, Navarra, Mondragón Unibersitatea, Burgos, Pública Navarra, Francisco de Vitoria, Poli de Madrid, Leín, Carlos III, Las Palmas, Poli de CAT, Camilo José Cela, Europea Miguel de Cervantes, Pontificia de Salamanca, Internacional de CAT, Córdoba, UNED, La Rioja, Cantabria

drop if inlist(university_id, 3, 6, 11, 18, 21, 26, 34, 40, 45, 47, 48, 55)	| inlist(university_id, 63, 64, 67, 69, 72, 77, 78, 79)
rddensity rel_dist_flipp_thd1, c(0) p(1) bwselect(diff) fitselect(restricted) all kernel(triangular) vce(jackknife) //--> Sigue incumpliéndose continuidad

}		
*/		
			
		
*2.3) RDDENSITY GRAPHS (Cattaneo et al, 2018)
{
use "$dataoutput/Becas_2013_20.dta",clear

*U1
rddensity rel_dist_thd1 if rel_dist_thd2>-0.6 & rel_dist_thd2<0.6, c( 0 ) p(1) bwselect(diff) fitselect(restricted) all kernel(triangular) vce(jackknife) plot 
graph export "$figures/rddensity_U1_condeduccion.pdf", replace	

*U2
rddensity rel_dist_thd2 if rel_dist_thd2>-0.6 & rel_dist_thd2<0.6, c( 0 ) p(1) bwselect(diff) fitselect(restricted) all kernel(triangular) vce(jackknife) plot 
graph export "$figures/rddensity_U2_condeduccion.pdf", replace

*U3
rddensity rel_dist_thd3 if rel_dist_thd3>-0.6 & rel_dist_thd3<0.6, c( 0 ) p(1) bwselect(diff) fitselect(restricted) all kernel(triangular) vce(jackknife) plot 
graph export "$figures/rddensity_U3_condeduccion.pdf", replace


}


**************************************************************************************
*  4 - Internal validity (continuidad del score): Ingreso sin deducciones  
**************************************************************************************

// 4.1) Histograma de Distancia Relativa del Ingreso a los Umbrales
{
use "$dataoutput/Becas_2013_20.dta",clear

*Toda la distribución de ingresos
twoway (histogram inc_gross if inrange(inc_gross,0, 70000)==1 , bin(50) color(gray%30) ), ///
		ytitle("Density", height(5) size(medsmall) margin(medsmall) ) ///
		yscale(lstyle(none)) ///
		ylabel( , nogrid format(%9.2f) ) ///
		xtitle("Renta Familiar (euros)", height(5) size(medsmall) margin(medsmall) ) ///
		xscale(lstyle(none)) ///
		xlabel(0(10000)70000, nogrid ) ///
		xline(0, lcolor(red) lpattern(dash) lw(med)) ///
		graphregion(color(white)) plotregion(style(none)) legend(off)  
        graph export "$figures/histograma_sindeduccion.pdf", replace
		
*U1
twoway (histogram rel_dist_thd12 if inrange(rel_dist_thd12,-0.6, 0.6)==1 , bin(50) color(gray%30) ), ///
		ytitle("Density", height(5) size(medsmall) margin(medsmall) ) ///
		yscale(lstyle(none)) ///
		ylabel( , nogrid format(%9.2f) ) ///
		xtitle("Relative Income-Distance to Eligibility Cutoff U1 (without deductions)", height(5) size(medsmall) margin(medsmall) ) ///
		xscale(lstyle(none)) ///
		xlabel(-0.6(.1)0.6 , nogrid ) ///
		xline(0, lcolor(red) lpattern(dash) lw(med)) ///
		graphregion(color(white)) plotregion(style(none)) legend(off)  
        graph export "$figures/histograma_U1_sindeduccion.pdf", replace
		
*U2
gen inrange_data = inrange(rel_dist_thd22, -0.6, 0.6) //por outliers que no se restringen en -1

twoway (histogram rel_dist_thd22 if inrange_data==1 , bin(50) color(gray%30) ), ///
		ytitle("Density", height(5) size(medsmall) margin(medsmall) ) ///
		yscale(lstyle(none)) ///
		ylabel( , nogrid format(%9.2f) ) ///
		xtitle("Relative Income-Distance to Eligibility Cutoff U2 (without deductions)", height(5) size(medsmall) margin(medsmall) ) ///
		xscale(lstyle(none)) ///
		xlabel(-0.6(.1)0.6 , nogrid ) ///
		xline(0, lcolor(red) lpattern(dash) lw(med)) ///
		graphregion(color(white)) plotregion(style(none)) legend(off)  
        graph export "$figures/histograma_U2_sindeduccion.pdf", replace		
drop inrange_data 
	
*U3
gen inrange_data = inrange(rel_dist_thd32, -0.6, 0.6) //por outliers que no se restringen en -1
twoway (histogram rel_dist_thd32 if inrange(rel_dist_thd3,-0.6, 0.6)==1 , bin(50) color(gray%30) ), ///
		ytitle("Density", height(5) size(medsmall) margin(medsmall) ) ///
		yscale(lstyle(none)) ///
		ylabel( , nogrid format(%9.2f) ) ///
		xtitle("Relative Income-Distance to Eligibility Cutoff U3 (without deductions)", height(5) size(medsmall) margin(medsmall) ) ///
		xscale(lstyle(none)) ///
		xlabel(-0.6(.1)0.6 , nogrid ) ///
		xline(0, lcolor(red) lpattern(dash) lw(med)) ///
		graphregion(color(white)) plotregion(style(none)) legend(off)  
        graph export "$figures/histograma_U3_sindeduccion.pdf", replace			
drop inrange_data 
}


// 4.2) McCray test de continuidad (2008)

{

*U1
use "$dataoutput/Becas_2013_20.dta",clear
DCdensity_m rel_dist_thd12 if rel_dist_thd12>-0.6 & rel_dist_thd12<0.6, breakpoint(0) b(0) generate(Xj Yj r0 fhat se_fhat) 

g bw = r(bandwidth)
replace Xj=. if (Xj<=-0.60 | Xj>0.60)
replace fhat=. if (r0<=-0.60+bw | r0>0.60-bw)
g up = fhat + 1.96*se_fhat
g low = fhat - 1.96*se_fhat
gr twoway (scatter Yj Xj, msymbol(circle_hollow) mcolor(gray))   ///       
      (line fhat r0 if r0 < 0, lcolor(black) lwidth(medthick))  ///
       (line fhat r0 if r0 > 0, lcolor(black) lwidth(medthick))   ///
          (line up r0 if r0 < 0, lcolor(black) lwidth(vthin))              ///
            (line low r0 if r0 < 0, lcolor(black) lwidth(vthin))              ///
              (line up r0 if r0 > 0, lcolor(black) lwidth(vthin))              ///
                (line low r0 if r0 > 0, lcolor(black) lwidth(vthin)),         ///    
			xline(0, lcolor(red) lpattern(dash) lw(med)) legend(off) graphregion(color(white)) xlabel(-0.6(0.1)0.66, format(%9.0gc)) ///
			xtitle("Relative Income-Distance to Eligibility Cutoff (without deductions)", height(5))  ytitle("Density Estimate", height(5)) title("T1 Discontinuity", height(5) size(large) color(g10)) 
			graph export "$figures/Mccrary_U1_sindeduccion.pdf", replace

*U2
use "$dataoutput/Becas_2013_20.dta",clear
DCdensity_m rel_dist_thd22 if rel_dist_thd22>-0.6 & rel_dist_thd22<0.6, breakpoint(0) b(0) generate(Xj Yj r0 fhat se_fhat) 

g bw = r(bandwidth)
replace Xj=. if (Xj<=-0.60 | Xj>0.60)
replace fhat=. if (r0<=-0.60+bw | r0>0.60-bw)
g up = fhat + 1.96*se_fhat
g low = fhat - 1.96*se_fhat
gr twoway (scatter Yj Xj, msymbol(circle_hollow) mcolor(gray))   ///       
      (line fhat r0 if r0 < 0, lcolor(black) lwidth(medthick))  ///
       (line fhat r0 if r0 > 0, lcolor(black) lwidth(medthick))   ///
          (line up r0 if r0 < 0, lcolor(black) lwidth(vthin))              ///
            (line low r0 if r0 < 0, lcolor(black) lwidth(vthin))              ///
              (line up r0 if r0 > 0, lcolor(black) lwidth(vthin))              ///
                (line low r0 if r0 > 0, lcolor(black) lwidth(vthin)),         ///    
			xline(0, lcolor(red) lpattern(dash) lw(med)) legend(off) graphregion(color(white)) xlabel(-0.6(0.1)0.66, format(%9.0gc)) ///
			xtitle("Relative Income-Distance to Eligibility Cutoff (without deductions)", height(5))  ytitle("Density Estimate", height(5)) title("T2 Discontinuity", height(5) size(large) color(g10)) 
			graph export "$figures/Mccrary_U2_sindeduccion.pdf", replace
			
*U3
use "$dataoutput/Becas_2013_20.dta",clear
DCdensity_m rel_dist_thd32 if rel_dist_thd32>-0.6 & rel_dist_thd32<0.6, breakpoint(0) b(0) generate(Xj Yj r0 fhat se_fhat) 

g bw = r(bandwidth)
replace Xj=. if (Xj<=-0.60 | Xj>0.60)
replace fhat=. if (r0<=-0.60+bw | r0>0.60-bw)
g up = fhat + 1.96*se_fhat
g low = fhat - 1.96*se_fhat
gr twoway (scatter Yj Xj, msymbol(circle_hollow) mcolor(gray))   ///       
      (line fhat r0 if r0 < 0, lcolor(black) lwidth(medthick))  ///
       (line fhat r0 if r0 > 0, lcolor(black) lwidth(medthick))   ///
          (line up r0 if r0 < 0, lcolor(black) lwidth(vthin))              ///
            (line low r0 if r0 < 0, lcolor(black) lwidth(vthin))              ///
              (line up r0 if r0 > 0, lcolor(black) lwidth(vthin))              ///
                (line low r0 if r0 > 0, lcolor(black) lwidth(vthin)),         ///    
			xline(0, lcolor(red) lpattern(dash) lw(med)) legend(off) graphregion(color(white)) xlabel(-0.6(0.1)0.66, format(%9.0gc)) ///
			xtitle("Relative Income-Distance to Eligibility Cutoff (without deductions)", height(5))  ytitle("Density Estimate", height(5)) title("T3 Discontinuity", height(5) size(large) color(g10)) 
			graph export "$figures/Mccrary_U3_sindeduccion.pdf", replace			

}

// 4.3) RDDENSITY (Cattaneo et al, 2018)

{
use "$dataoutput/Becas_2013_20.dta",clear

*We have to flip the relative distance to use RDrobust in an intuitive way
gen rel_dist_flipp_thd12=(-1)*rel_dist_thd12
gen rel_dist_flipp_thd22=(-1)*rel_dist_thd22
gen rel_dist_flipp_thd32=(-1)*rel_dist_thd32


estimates clear
capture matrix drop res

foreach c in 1 2 3{	

	*** Model 1: assuming equal c.d.f. on each side, linear poly, symmetric bandwdith
	rddensity rel_dist_flipp_thd`c'2, c( 0 ) p(1) bwselect(diff) fitselect(restricted) all kernel(triangular) vce(jackknife) 
	cap mat drop tmp
	mat tmp = nullmat(tmp) , e(h_l)	// col 1 is h_
	mat tmp = tmp , e(h_r)			// col 2 is h+
	mat tmp = tmp , e(N_h_l)		// col 3 is Nw_
	mat tmp = tmp , e(N_h_r)		// col 4 is Nw+
	mat tmp = tmp , e(pv_q) 		// col 5 is density test p-values
	mat rownames tmp = c`c'_res_symbw_p1
	if `c' == 1{
		mat res = nullmat(res) \ tmp
	}
	else {
		mat res = res \ tmp	
	}
	*** Model 3: NOT assuming equal c.d.f. on each side, linear poly, symmetric bandwdith
	rddensity rel_dist_flipp_thd`c'2, c( 0 ) p(1) bwselect(diff) fitselect(unrestricted) all kernel(triangular) vce(jackknife) 
	cap mat drop tmp
	mat tmp = nullmat(tmp) , e(h_l)		// col 1 is h_
	mat tmp = tmp , e(h_r)				// col 2 is h+
	mat tmp = tmp , e(N_h_l)			// col 3 is Nw_
	mat tmp = tmp , e(N_h_r)			// col 4 is Nw+
	mat tmp = tmp , e(pv_q) 			// col 5 is density test p-values
	mat rownames tmp = c`c'_unres_symbw_p1
	mat res = res \ tmp	
	** Model 5: NOT assuming equal c.d.f. on each side, linear poly, asymmetric bandwdith
	rddensity rel_dist_flipp_thd`c'2, c( 0 ) p(1) bwselect(each) fitselect(unrestricted) all kernel(triangular) vce(jackknife) 
	cap mat drop tmp
	mat tmp = nullmat(tmp) , e(h_l)		// col 1 is h_
	mat tmp = tmp , e(h_r)				// col 2 is h+
	mat tmp = tmp , e(N_h_l)			// col 3 is Nw_
	mat tmp = tmp , e(N_h_r)			// col 4 is Nw+
	mat tmp = tmp , e(pv_q) 			// col 5 is density test p-values
	mat rownames tmp = c`c'_unres_asymbw_p1
	mat res = res \ tmp	
	
} 
	
// Check complete matrix: 
mat colnames res =  hLeft hRight NObsLeft NObsRight pvalue

estout matrix(res, fmt(%9.3f %9.3f %9.0g %9.0g %9.3f)), varwidth(30)	 

* Tables
* Excel 
estout matrix(res, fmt(%9.3f %9.3f %9.0g %9.0g %9.3f)) using "$tables/RDdensity_sindeduccion.csv", ///
		replace delimiter(,) varwidth(20) title("RD Density Results (without deduction)") 

* Tex 
estout matrix(res, fmt(%9.3f %9.3f %9.0g %9.0g %9.3f)) using "$tables/RDdensity_sindeduccion.tex", ///
		replace delimiter(&) end(\\) ///
		prehead(`"\begin{tabular}{l*{6}{c}}"' `"\toprule"') ///
		postfoot(`"\bottomrule"'`"\end{tabular}"' )

}

// 4.4) RDDENSITY GRAPHS (Cattaneo et al, 2018)
{
use "$dataoutput/Becas_2013_20.dta",clear

*U1
rddensity rel_dist_thd12 if rel_dist_thd12>-0.6 & rel_dist_thd12<0.6, c( 0 ) p(1) bwselect(diff) fitselect(restricted) all kernel(triangular) vce(jackknife) plot 
graph export "$figures/rddensity_U1_sindeduccion.pdf", replace	

*U2
rddensity rel_dist_thd22 if rel_dist_thd22>-0.6 & rel_dist_thd22<0.6, c( 0 ) p(1) bwselect(diff) fitselect(restricted) all kernel(triangular) vce(jackknife) plot 
graph export "$figures/rddensity_U2_sindeduccion.pdf", replace

*U3
rddensity rel_dist_thd32 if rel_dist_thd32>-0.6 & rel_dist_thd32<0.6, c( 0 ) p(1) bwselect(diff) fitselect(restricted) all kernel(triangular) vce(jackknife) plot 
graph export "$figures/rddensity_U3_sindeduccion.pdf", replace


}
