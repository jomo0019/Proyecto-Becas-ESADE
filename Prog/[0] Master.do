
/* ----------------- Setting up paths -------------------

				Directories for every user 
					 (Jose y Lucía)

 -------------------------------------------------------*/

 
// 1- Lucía Cobreros
if c(username) == "lucia.cobreros"{
		
	global main "/Users/lucia.cobreros/Documents/GitHub/Proyecto-Becas-ESADE"

	global data "/Users/lucia.cobreros/Dropbox/Proyecto Becas Universitarias/Data"
				
		*Code 
		global dofiles "$main/Prog"
		
		*Data
		global datainput "$data/Muestra aleatoria"
		global dataoutput "$data/Clean"

		*Output
		global figures "$main/Fig"
		global tables "$main/Tab"
		global logs "$main/Logs"

}
 
// 2a- Jose (laptop)

else if c(username) == "pepemontalbancastilla" {
		
	global main ""

	global data ""
				
		*Code 
		global dofiles "$main/Prog"
		
		*Data
		global datainput "$data/Muestra aleatoria"
		global dataoutput "$data/Clean"

		*Output
		global figures "$main/Fig"
		global tables "$main/Tab"

}
 
// 2b- Jose (SOFI)

else if c(username) == "jomo0019" {
		
	global main ""

	global data ""
				
		*Code 
		global dofiles "$main/Prog"
		
		*Data
		global datainput "$data/Muestra aleatoria"
		global dataoutput "$data/Clean"

		*Output
		global figures "$main/Fig"
		global tables "$main/Tab"

} 
 

// 3 - MEFP 

else if c(username) == "" {
		
	global main ""

	global data ""
				
		*Code 
		global dofiles "$main/Prog"
		
		*Data
		global datainput "$data/Muestra aleatoria"
		global dataoutput "$data/Clean"

		*Output
		global figures "$main/Fig"
		global tables "$main/Tab"

} 
 