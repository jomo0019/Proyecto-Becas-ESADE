* PROYECTO DE ANALYSIS DE BECAS UNIVERSITARIAS ESADE ECONPOL
* Septiembre 2023
*

* Install third-party packages.
ssc install outreg2,replace
ssc install cmogram,replace
ssc install qqvalue,replace
ssc install estout,replace
net install rdrobust, from(https://raw.githubusercontent.com/rdpackages/rdrobust/master/stata) replace
net install rddensity, from(https://raw.githubusercontent.com/rdpackages/rddensity/master/stata) replace

*Directories

*set path					
global dir = "" // replace "" with the directory where the replication folder is saved
global do = "$dir/Prog"
global data =  "$dir/Data"
global tables = "$dir/Tab"
global figure = "$dir/Fig"

log using replication_Becas_ESADE_2023, text replace
*
*
*** Step 1. Descriptive Statistics & Internal validity  ****
*
do "$do/Internal_validity_Becas".do
*
*** Step 2. Main Results ****
*
*do "$do/Results_Becas".do
*
*** Step 3. Figures Online Appendix ****
*
*do "$do/Figures_Becas_apx".do
*
*** Step 4. Tables Online Appendix ****
*
*do "$do/Tables_Becas_apx".do
*
log close
