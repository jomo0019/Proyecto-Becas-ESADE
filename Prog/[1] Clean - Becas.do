clear all
set more off

/*-----------------------------------------------------------------------------

						CLEAN SAMPLE - BECAS
							     MEFP
							  Lucía & Jose 

------------------------------------------------------------------------------*/


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

//1. Open Becas file, rename and label variables
import delimited "$datainput/Becas_sample_random.csv", delimiter(",")

{
drop v1 tipo_titulacion

rename personal_id id
rename curso year
rename organo_gestor institution
rename estado status
rename causa_denegacion cause_denial
rename miembros_familia hhsize
rename renta_sin_deducciones inc_gross
rename renta_con_deducciones inc_net
rename umbral threshold
rename cuantia_recibida amount
rename campo_conocimiento field
rename universidad_random university_id

label var year "Curso de referencia"
label var institution "Órgano gestor"
label var status "Estado de la beca"
label var cause_denial "Causa de denegación"
label var hhsize "Miembros de la familia"
label var inc_gross "Ingresos sin deducciones"
label var inc_net "Ingresos con deducciones"
label var threshold "Umbral"
label var amount "Cuantía recibida"
label var field "Campo de conocimiento"
label var university_id "Universidad"

tostring id, replace
}

//2. Add value labels

{
	//2.1. University ID (Confidencial)
label define university_id	46	"Alicante"	///
	43	"Extremadura"	///
	32	"Illes Baleares"	///
	9	"Barcelona "	///
	44	"Cádiz"	///
	72	"Córdoba"	///
	29	"Santiago de Compostela"	///
	56	"Granada"	///
	45	"Leon"	///
	4	"Complutense de Madrid"	///
	1	"Málaga"	///
	42	"Murcia"	///
	71	"Oviedo"	///
	37	"Salamanca"	///
	25	"La Laguna"	///
	79	"Cantabria"	///
	31	"Sevilla"	///
	22	"Valencia"	///
	10	"Valladolid"	///
	3	"Pais Vasco"	///
	54	"Zaragoza"	///
	27	"Autónoma de Barcelona"	///
	8	"Autónoma de Madrid"	///
	55	"Politécnica de Cataluña"	///
	40	"Politécnica de Madrid"	///
	48	"Las Palmas de Gran Canaria"	///
	38	"Politécnica de Valencia"	///
	77	"UNED"	///
	57	"Alcalá"	///
	19	"Deusto"	///
	11	"Navarra"	///
	67	"Pontificia de Salamanca"	///
	68	"Pontificia Comillas"	///
	7	"Castilla La Mancha"	///
	26	"Pública de Navarra"	///
	47	"Carlos III de Madrid"	///
	14	"A Coruña"	///
	73	"Vigo"	///
	53	"Pompeu Fabra"	///
	5	"Jaume I de Castellon"	///
	52	"Ramon Llul"	///
	49	"Rovira i Virgili"	///
	12	"Girona"	///
	17	"Lleida"	///
	78	"La Rioja"	///
	59	"San Pablo-CEU"	///
	65	"Alfonso X el Sabio"	///
	60	"Almería"	///
	36	"Huelva"	///
	15	"Jaen"	///
	21	"Burgos"	///
	20	"Antonio de Nebrija"	///
	50	"Europea de Madrid"	///
	2	"Oberta de Cataluña"	///
	13	"Miguel Hernández de Elche"	///
	39	"Rey Juan Carlos"	///
	81	"IE Universidad"	///
	35	"Pablo de Olavide"	///
	6	"Católica Santa Teresa de Avila"	///
	28	"Vic Central de Cataluña"	///
	18	"Mondragón Unibertsitatea"	///
	69	"Internacional de Cataluña"	///
	70	"Politécnica de Cartagena"	///
	63	"Camilo José Cela"	///
	66	"Católica San Antonio"	///
	80	"Cardenal Herrera-CEU"	///
	34	"Francisco de Vitoria"	///
	64	"Europea Miguel de Cervantes"	///
	24	"Abat Oliba CEU"	///
	76	"Católica de Valencia San Vicente Martir"	///
	23	"San Jorge"	///
	33	"A Distancia de Madrid"	///
	74	"Internacional Valenciana"	///
	82	"Internacional de La Rioja"	///
	30	"Europea de Canarias"	///
	51	"Internacional Isabel I de Castilla"	///
	16	"Loyola Andallucía"	///
	41	"Europea de Valencia"	///
	61	"Europea del Atlántico"	///
	62	"Universidad Fernando Pessoa-Canarias"	///
	58	"Univ. Del Atlántico medio"	///
	75	"Universidad Internacional Villanueva"		
label values university_id university_id

	//2.2. Denial cause
		//2.2.1. Generate a numeric variable 
gen cause_denial_num=	100100	if cause_denial==	"100100"
replace cause_denial_num=	100109	if cause_denial==	"100109"
replace cause_denial_num=	100411	if cause_denial==	"100411"
replace cause_denial_num=	100413	if cause_denial==	"100413"
replace cause_denial_num=	100414	if cause_denial==	"100414"
replace cause_denial_num=	100415	if cause_denial==	"100415"
replace cause_denial_num=	100416	if cause_denial==	"100416"
replace cause_denial_num=	100200	if cause_denial==	"100200"
replace cause_denial_num=	100201	if cause_denial==	"100201"
replace cause_denial_num=	100202	if cause_denial==	"100202"
replace cause_denial_num=	100203	if cause_denial==	"100203"
replace cause_denial_num=	100204	if cause_denial==	"100204"
replace cause_denial_num=	100110	if cause_denial==	"100110"
replace cause_denial_num=	100205	if cause_denial==	"100205"
replace cause_denial_num=	100206	if cause_denial==	"100206"
replace cause_denial_num=	100207	if cause_denial==	"100207"
replace cause_denial_num=	100208	if cause_denial==	"100208"
replace cause_denial_num=	100209	if cause_denial==	"100209"
replace cause_denial_num=	100210	if cause_denial==	"100210"
replace cause_denial_num=	100211	if cause_denial==	"100211"
replace cause_denial_num=	100212	if cause_denial==	"100212"
replace cause_denial_num=	100213	if cause_denial==	"100213"
replace cause_denial_num=	100214	if cause_denial==	"100214"
replace cause_denial_num=	100111	if cause_denial==	"100111"
replace cause_denial_num=	100215	if cause_denial==	"100215"
replace cause_denial_num=	100216	if cause_denial==	"100216"
replace cause_denial_num=	140105	if cause_denial==	"140105"
replace cause_denial_num=	140106	if cause_denial==	"140106"
replace cause_denial_num=	140124	if cause_denial==	"140124"
replace cause_denial_num=	140402	if cause_denial==	"140402"
replace cause_denial_num=	140403	if cause_denial==	"140403"
replace cause_denial_num=	140404	if cause_denial==	"140404"
replace cause_denial_num=	140412	if cause_denial==	"140412"
replace cause_denial_num=	140413	if cause_denial==	"140413"
replace cause_denial_num=	100112	if cause_denial==	"100112"
replace cause_denial_num=	180101	if cause_denial==	"180101"
replace cause_denial_num=	180102	if cause_denial==	"180102"
replace cause_denial_num=	180103	if cause_denial==	"180103"
replace cause_denial_num=	180104	if cause_denial==	"180104"
replace cause_denial_num=	180105	if cause_denial==	"180105"
replace cause_denial_num=	180106	if cause_denial==	"180106"
replace cause_denial_num=	180107	if cause_denial==	"180107"
replace cause_denial_num=	180108	if cause_denial==	"180108"
replace cause_denial_num=	180109	if cause_denial==	"180109"
replace cause_denial_num=	180110	if cause_denial==	"180110"
replace cause_denial_num=	100113	if cause_denial==	"100113"
replace cause_denial_num=	180111	if cause_denial==	"180111"
replace cause_denial_num=	180112	if cause_denial==	"180112"
replace cause_denial_num=	180113	if cause_denial==	"180113"
replace cause_denial_num=	180114	if cause_denial==	"180114"
replace cause_denial_num=	180115	if cause_denial==	"180115"
replace cause_denial_num=	180116	if cause_denial==	"180116"
replace cause_denial_num=	180117	if cause_denial==	"180117"
replace cause_denial_num=	180118	if cause_denial==	"180118"
replace cause_denial_num=	180119	if cause_denial==	"180119"
replace cause_denial_num=	180120	if cause_denial==	"180120"
replace cause_denial_num=	100114	if cause_denial==	"100114"
replace cause_denial_num=	180121	if cause_denial==	"180121"
replace cause_denial_num=	180122	if cause_denial==	"180122"
replace cause_denial_num=	180123	if cause_denial==	"180123"
replace cause_denial_num=	180124	if cause_denial==	"180124"
replace cause_denial_num=	180125	if cause_denial==	"180125"
replace cause_denial_num=	180126	if cause_denial==	"180126"
replace cause_denial_num=	180127	if cause_denial==	"180127"
replace cause_denial_num=	180128	if cause_denial==	"180128"
replace cause_denial_num=	180129	if cause_denial==	"180129"
replace cause_denial_num=	180130	if cause_denial==	"180130"
replace cause_denial_num=	100115	if cause_denial==	"100115"
replace cause_denial_num=	180131	if cause_denial==	"180131"
replace cause_denial_num=	180132	if cause_denial==	"180132"
replace cause_denial_num=	180133	if cause_denial==	"180133"
replace cause_denial_num=	180134	if cause_denial==	"180134"
replace cause_denial_num=	180135	if cause_denial==	"180135"
replace cause_denial_num=	180136	if cause_denial==	"180136"
replace cause_denial_num=	180137	if cause_denial==	"180137"
replace cause_denial_num=	180138	if cause_denial==	"180138"
replace cause_denial_num=	180139	if cause_denial==	"180139"
replace cause_denial_num=	180140	if cause_denial==	"180140"
replace cause_denial_num=	100116	if cause_denial==	"100116"
replace cause_denial_num=	180141	if cause_denial==	"180141"
replace cause_denial_num=	180142	if cause_denial==	"180142"
replace cause_denial_num=	180143	if cause_denial==	"180143"
replace cause_denial_num=	180144	if cause_denial==	"180144"
replace cause_denial_num=	180145	if cause_denial==	"180145"
replace cause_denial_num=	180146	if cause_denial==	"180146"
replace cause_denial_num=	180147	if cause_denial==	"180147"
replace cause_denial_num=	180148	if cause_denial==	"180148"
replace cause_denial_num=	180149	if cause_denial==	"180149"
replace cause_denial_num=	180150	if cause_denial==	"180150"
replace cause_denial_num=	100117	if cause_denial==	"100117"
replace cause_denial_num=	180151	if cause_denial==	"180151"
replace cause_denial_num=	180152	if cause_denial==	"180152"
replace cause_denial_num=	180153	if cause_denial==	"180153"
replace cause_denial_num=	180154	if cause_denial==	"180154"
replace cause_denial_num=	180155	if cause_denial==	"180155"
replace cause_denial_num=	180156	if cause_denial==	"180156"
replace cause_denial_num=	180157	if cause_denial==	"180157"
replace cause_denial_num=	180158	if cause_denial==	"180158"
replace cause_denial_num=	180159	if cause_denial==	"180159"
replace cause_denial_num=	180160	if cause_denial==	"180160"
replace cause_denial_num=	100118	if cause_denial==	"100118"
replace cause_denial_num=	180161	if cause_denial==	"180161"
replace cause_denial_num=	180162	if cause_denial==	"180162"
replace cause_denial_num=	180163	if cause_denial==	"180163"
replace cause_denial_num=	180164	if cause_denial==	"180164"
replace cause_denial_num=	180165	if cause_denial==	"180165"
replace cause_denial_num=	180166	if cause_denial==	"180166"
replace cause_denial_num=	180167	if cause_denial==	"180167"
replace cause_denial_num=	180168	if cause_denial==	"180168"
replace cause_denial_num=	180169	if cause_denial==	"180169"
replace cause_denial_num=	180170	if cause_denial==	"180170"
replace cause_denial_num=	100101	if cause_denial==	"100101"
replace cause_denial_num=	100119	if cause_denial==	"100119"
replace cause_denial_num=	180171	if cause_denial==	"180171"
replace cause_denial_num=	180172	if cause_denial==	"180172"
replace cause_denial_num=	180173	if cause_denial==	"180173"
replace cause_denial_num=	180174	if cause_denial==	"180174"
replace cause_denial_num=	180175	if cause_denial==	"180175"
replace cause_denial_num=	180176	if cause_denial==	"180176"
replace cause_denial_num=	180177	if cause_denial==	"180177"
replace cause_denial_num=	180178	if cause_denial==	"180178"
replace cause_denial_num=	180179	if cause_denial==	"180179"
replace cause_denial_num=	180180	if cause_denial==	"180180"
replace cause_denial_num=	100120	if cause_denial==	"100120"
replace cause_denial_num=	180181	if cause_denial==	"180181"
replace cause_denial_num=	180182	if cause_denial==	"180182"
replace cause_denial_num=	180183	if cause_denial==	"180183"
replace cause_denial_num=	180184	if cause_denial==	"180184"
replace cause_denial_num=	180185	if cause_denial==	"180185"
replace cause_denial_num=	250101	if cause_denial==	"250101"
replace cause_denial_num=	250102	if cause_denial==	"250102"
replace cause_denial_num=	250103	if cause_denial==	"250103"
replace cause_denial_num=	250106	if cause_denial==	"250106"
replace cause_denial_num=	250107	if cause_denial==	"250107"
replace cause_denial_num=	100121	if cause_denial==	"100121"
replace cause_denial_num=	250110	if cause_denial==	"250110"
replace cause_denial_num=	250117	if cause_denial==	"250117"
replace cause_denial_num=	250118	if cause_denial==	"250118"
replace cause_denial_num=	250119	if cause_denial==	"250119"
replace cause_denial_num=	250120	if cause_denial==	"250120"
replace cause_denial_num=	250122	if cause_denial==	"250122"
replace cause_denial_num=	250130	if cause_denial==	"250130"
replace cause_denial_num=	250301	if cause_denial==	"250301"
replace cause_denial_num=	250308	if cause_denial==	"250308"
replace cause_denial_num=	250311	if cause_denial==	"250311"
replace cause_denial_num=	100122	if cause_denial==	"100122"
replace cause_denial_num=	310101	if cause_denial==	"310101"
replace cause_denial_num=	310102	if cause_denial==	"310102"
replace cause_denial_num=	999021	if cause_denial==	"999021"
replace cause_denial_num=	100123	if cause_denial==	"100123"
replace cause_denial_num=	100124	if cause_denial==	"100124"
replace cause_denial_num=	100125	if cause_denial==	"100125"
replace cause_denial_num=	100126	if cause_denial==	"100126"
replace cause_denial_num=	100127	if cause_denial==	"100127"
replace cause_denial_num=	100128	if cause_denial==	"100128"
replace cause_denial_num=	100102	if cause_denial==	"100102"
replace cause_denial_num=	100129	if cause_denial==	"100129"
replace cause_denial_num=	100130	if cause_denial==	"100130"
replace cause_denial_num=	100131	if cause_denial==	"100131"
replace cause_denial_num=	100132	if cause_denial==	"100132"
replace cause_denial_num=	100133	if cause_denial==	"100133"
replace cause_denial_num=	100134	if cause_denial==	"100134"
replace cause_denial_num=	100135	if cause_denial==	"100135"
replace cause_denial_num=	100137	if cause_denial==	"100137"
replace cause_denial_num=	100138	if cause_denial==	"100138"
replace cause_denial_num=	100139	if cause_denial==	"100139"
replace cause_denial_num=	100103	if cause_denial==	"100103"
replace cause_denial_num=	100140	if cause_denial==	"100140"
replace cause_denial_num=	100141	if cause_denial==	"100141"
replace cause_denial_num=	100142	if cause_denial==	"100142"
replace cause_denial_num=	100146	if cause_denial==	"100146"
replace cause_denial_num=	100148	if cause_denial==	"100148"
replace cause_denial_num=	100149	if cause_denial==	"100149"
replace cause_denial_num=	100150	if cause_denial==	"100150"
replace cause_denial_num=	100151	if cause_denial==	"100151"
replace cause_denial_num=	100152	if cause_denial==	"100152"
replace cause_denial_num=	100153	if cause_denial==	"100153"
replace cause_denial_num=	100104	if cause_denial==	"100104"
replace cause_denial_num=	100154	if cause_denial==	"100154"
replace cause_denial_num=	100155	if cause_denial==	"100155"
replace cause_denial_num=	100156	if cause_denial==	"100156"
replace cause_denial_num=	100157	if cause_denial==	"100157"
replace cause_denial_num=	100158	if cause_denial==	"100158"
replace cause_denial_num=	100159	if cause_denial==	"100159"
replace cause_denial_num=	100160	if cause_denial==	"100160"
replace cause_denial_num=	100161	if cause_denial==	"100161"
replace cause_denial_num=	100162	if cause_denial==	"100162"
replace cause_denial_num=	100163	if cause_denial==	"100163"
replace cause_denial_num=	100105	if cause_denial==	"100105"
replace cause_denial_num=	100164	if cause_denial==	"100164"
replace cause_denial_num=	100165	if cause_denial==	"100165"
replace cause_denial_num=	100170	if cause_denial==	"100170"
replace cause_denial_num=	100171	if cause_denial==	"100171"
replace cause_denial_num=	100172	if cause_denial==	"100172"
replace cause_denial_num=	100174	if cause_denial==	"100174"
replace cause_denial_num=	100175	if cause_denial==	"100175"
replace cause_denial_num=	100177	if cause_denial==	"100177"
replace cause_denial_num=	100178	if cause_denial==	"100178"
replace cause_denial_num=	100300	if cause_denial==	"100300"
replace cause_denial_num=	100106	if cause_denial==	"100106"
replace cause_denial_num=	100301	if cause_denial==	"100301"
replace cause_denial_num=	100302	if cause_denial==	"100302"
replace cause_denial_num=	100303	if cause_denial==	"100303"
replace cause_denial_num=	100304	if cause_denial==	"100304"
replace cause_denial_num=	100305	if cause_denial==	"100305"
replace cause_denial_num=	100306	if cause_denial==	"100306"
replace cause_denial_num=	100307	if cause_denial==	"100307"
replace cause_denial_num=	100308	if cause_denial==	"100308"
replace cause_denial_num=	100309	if cause_denial==	"100309"
replace cause_denial_num=	100310	if cause_denial==	"100310"
replace cause_denial_num=	100107	if cause_denial==	"100107"
replace cause_denial_num=	100311	if cause_denial==	"100311"
replace cause_denial_num=	100312	if cause_denial==	"100312"
replace cause_denial_num=	100313	if cause_denial==	"100313"
replace cause_denial_num=	100314	if cause_denial==	"100314"
replace cause_denial_num=	100315	if cause_denial==	"100315"
replace cause_denial_num=	100316	if cause_denial==	"100316"
replace cause_denial_num=	100317	if cause_denial==	"100317"
replace cause_denial_num=	100318	if cause_denial==	"100318"
replace cause_denial_num=	100319	if cause_denial==	"100319"
replace cause_denial_num=	100400	if cause_denial==	"100400"
replace cause_denial_num=	100108	if cause_denial==	"100108"
replace cause_denial_num=	100401	if cause_denial==	"100401"
replace cause_denial_num=	100402	if cause_denial==	"100402"
replace cause_denial_num=	100403	if cause_denial==	"100403"
replace cause_denial_num=	100404	if cause_denial==	"100404"
replace cause_denial_num=	100405	if cause_denial==	"100405"
replace cause_denial_num=	100406	if cause_denial==	"100406"
replace cause_denial_num=	100407	if cause_denial==	"100407"
replace cause_denial_num=	100408	if cause_denial==	"100408"
replace cause_denial_num=	100409	if cause_denial==	"100409"
replace cause_denial_num=	100410	if cause_denial==	"100410"
replace cause_denial_num=	100193	if cause_denial==	"100193"
replace cause_denial_num=	100222	if cause_denial==	"100222"
replace cause_denial_num=	100224	if cause_denial==	"100224"
replace cause_denial_num=	100420	if cause_denial==	"100420"
replace cause_denial_num=	180252	if cause_denial==	"180252"
replace cause_denial_num=	100225	if cause_denial==	"100225"
replace cause_denial_num=	201121	if cause_denial==	"201121"
replace cause_denial_num=	201124	if cause_denial==	"201124"
replace cause_denial_num=	201126	if cause_denial==	"201126"
replace cause_denial_num=	100187	if cause_denial==	"100187"
replace cause_denial_num=	100182	if cause_denial==	"100182"
replace cause_denial_num=	100183	if cause_denial==	"100183"
replace cause_denial_num=	100184	if cause_denial==	"100184"
replace cause_denial_num=	100176	if cause_denial==	"100176"
replace cause_denial_num=	100186	if cause_denial==	"100186"
replace cause_denial_num=	100320	if cause_denial==	"100320"
replace cause_denial_num=	100321	if cause_denial==	"100321"
replace cause_denial_num=	100217	if cause_denial==	"100217"
replace cause_denial_num=	100219	if cause_denial==	"100219"
replace cause_denial_num=	100191	if cause_denial==	"100191"
replace cause_denial_num=	100185	if cause_denial==	"100185"
replace cause_denial_num=	100173	if cause_denial==	"100173"
replace cause_denial_num=	100501	if cause_denial==	"100501"
replace cause_denial_num=	100502	if cause_denial==	"100502"
replace cause_denial_num=	100503	if cause_denial==	"100503"
replace cause_denial_num=	100504	if cause_denial==	"100504"
replace cause_denial_num=	100500	if cause_denial==	"100500"
replace cause_denial_num=	100505	if cause_denial==	"100505"
replace cause_denial_num=	140514	if cause_denial==	"140514"
replace cause_denial_num=	100417	if cause_denial==	"100417"
replace cause_denial_num=	100181	if cause_denial==	"100181"
replace cause_denial_num=	100188	if cause_denial==	"100188"
replace cause_denial_num=	100506	if cause_denial==	"100506"
replace cause_denial_num=	100507	if cause_denial==	"100507"
replace cause_denial_num=	100324	if cause_denial==	"100324"
replace cause_denial_num=	100331	if cause_denial==	"100331"
replace cause_denial_num=	100332	if cause_denial==	"100332"
replace cause_denial_num=	100322	if cause_denial==	"100322"
replace cause_denial_num=	100329	if cause_denial==	"100329"
replace cause_denial_num=	100330	if cause_denial==	"100330"
replace cause_denial_num=	100323	if cause_denial==	"100323"
replace cause_denial_num=	100328	if cause_denial==	"100328"
replace cause_denial_num=	100189	if cause_denial==	"100189"
replace cause_denial_num=	100192	if cause_denial==	"100192"
replace cause_denial_num=	100194	if cause_denial==	"100194"
replace cause_denial_num=	100198	if cause_denial==	"100198"
replace cause_denial_num=	100325	if cause_denial==	"100325"
replace cause_denial_num=	100326	if cause_denial==	"100326"
replace cause_denial_num=	100333	if cause_denial==	"100333"
replace cause_denial_num=	100509	if cause_denial==	"100509"
replace cause_denial_num=	100510	if cause_denial==	"100510"
replace cause_denial_num=	140406	if cause_denial==	"140406"
replace cause_denial_num=	100512	if cause_denial==	"100512"
replace cause_denial_num=	140408	if cause_denial==	"140408"
replace cause_denial_num=	140411	if cause_denial==	"140411"
replace cause_denial_num=	100511	if cause_denial==	"100511"
replace cause_denial_num=	201101	if cause_denial==	"E01101"
replace cause_denial_num=	201102	if cause_denial==	"E01102"
replace cause_denial_num=	201103	if cause_denial==	"E01103"
replace cause_denial_num=	201104	if cause_denial==	"E01104"
replace cause_denial_num=	201105	if cause_denial==	"E01105"
replace cause_denial_num=	201106	if cause_denial==	"E01106"
replace cause_denial_num=	201113	if cause_denial==	"E01113"
replace cause_denial_num=	100334	if cause_denial==	"100334"
replace cause_denial_num=	201114	if cause_denial==	"E01114"
replace cause_denial_num=	201115	if cause_denial==	"E01115"
replace cause_denial_num=	201119	if cause_denial==	"E01119"
replace cause_denial_num=	100421	if cause_denial==	"100421"
replace cause_denial_num=	100422	if cause_denial==	"100422"
replace cause_denial_num=	100423	if cause_denial==	"100423"
replace cause_denial_num=	100424	if cause_denial==	"100424"
replace cause_denial_num=	201122	if cause_denial==	"E01122"
replace cause_denial_num=	100179	if cause_denial==	"100179"
		
label define cause_denial_num 100100 "DENEGACIONES COMUNES"	///
	100109	"Haber sido beneficiario de beca el número máximo de años que permite la Resolución de la Convocatoria."	///
	100411	"Por existir varias declaraciones ante la Agencia Tributaria, en relacion con el NIF/NIE "	///
	100413	"Por superar los umbrales de valores catastrales, tras consultar los datos que sobre su unidad familiar obran en poder de la Administración tributaria."	///
	100414	"Por haber incluido como miembro computable de su unidad familiar a un perceptor de Renta Básica de Emancipación."	///
	100415	"Según consta en el INEM, no se encuentra en situación laboral de desempleo e inscrito como demandante de empleo a la fecha que exige la convocatoria."	///
	100416	"Según consta en el INEM, no está o no ha estado percibiendo prestación o subsidio por desempleo con cargo al presupuesto del Servicio Público de Empleo a la fecha que exige la convocatoria."	///
	100200	"DENEGACIONES POR DATOS ECONÓMICOS"	///
	100201	"Superar los umbrales de renta establecidos para la concesión de beca."	///
	100202	"Superar los umbrales de renta establecidos para la exención de precios por servicios académicos o beca básica"	///
	100203	"No tener derecho a la beca de matrícula  y superar el primer umbral económico de renta familiar a efectos de beca (Centros privados)."	///
	100204	"El valor catastral de las fincas urbanas (excluida la vivienda habitual) supera el límite establecido en las bases de la convocatoria."	///
	100110	"Otras causas."	///
	100205	"La facturación del negocio / actividad económica supera el umbral establecido en las bases de la convocatoria."	///
	100206	"El valor catastral de las fincas rústicas supera los umbrales patrimoniales establecidos en las bases de la convocatoria."	///
	100207	"La suma de los rendimientos netos del capital mobiliario más el saldo neto de ganancias y pérdidas patrimoniales supera los límites establecidos en las bases de la convocatoria."	///
	100208	"El conjunto de elementos patrimoniales supera el límite establecido en las bases de la convocatoria."	///
	100209	"Por tener la obligación de presentar declaración por el Impuesto Extraordinario sobre el Patrimonio de acuerdo con la normativa reguladora del mencionado Impuesto."	///
	100210	"Por superar valores catastrales."	///
	100211	"Falta información fiscal"	///
	100212	"Superar los umbrales de renta establecidos para la concesión de la ayuda compensatoria, beca-salario o movilidad especial."	///
	100213	"Superar el umbral de renta correspondiente, establecido en la convocatoria, para la concesión de otro/s componente/s de la beca (escolarización/residencia/movilidad)."	///
	100214	"Por haber incluido como miembro computable de su unidad familiar a un perceptor de Renta Básica de Emancipación."	///
	100111	"Estar matriculado en Centro de Segundo Ciclo de Educación Infantil sostenido con fondos públicos."	///
	100215	"Por no acreditar encontrarse en situación laboral de desempleo e inscrito como demandante de empleo a la fecha que exige la convocatoria."	///
	100216	"Por no acreditar que se está o se ha estado percibiendo prestación o subsidio por desempleo con cargo al presupuesto del Servicio Público de Empleo a la fecha que exige la convocatoria."	///
	140105	"La cuantía actual del aumento es menor que la de la solicitud o el aumento de cuantía anterior. Precisa proceso de Reintegro"	///
	140106	"La cuantía actual del aumento es igual que la de la solicitud o el aumento de cuantía anterior."	///
	140124	"No alcanzar la puntuación total obtenida por el último alumno seleccionado como suplente"	///
	140402	"Supera límite patrimonial"	///
	140403	"No identificación de sus NIF, por las Agencias Tributarias"	///
	140404	"No identificación económica por las Agencias Tributarias"	///
	140412	"Solicitud que debe ser tramitada por la convocatoria general al poseer algún miembro de la unidad familiar un inmueble en la localidad donde cursa estudios."	///
	140413	"Solicitud que debe ser tramitada sin la ayuda de residencia, al poseer algún miembro de la unidad familiar un inmueble en la localidad donde cursa estudios."	///
	100112	"Estar matriculado en un Centro privado de Educación Infantil no debidamente autorizado."	///
	180101	"Certificado de calificaciones del curso o, en su defecto, las del curso anterior al que está realizando"	///
	180102	"Certificado de la calificación final del idioma solicitado durante el curso  o, en su defecto la del curso anterior al que está realizando."	///
	180103	"Fotocopia del NIF/NIE del solicitante"	///
	180104	"Estudios y curso que está realizando"	///
	180105	"Nº de Teléfono"	///
	180106	"Certificado de la nota media en el curso "	///
	180107	"Certificado de haber superado el 40 % de la totalidad de la carga lectiva de sus estudios universitarios"	///
	180108	"Título de familia numerosa (actualizado)"	///
	180109	"Certificado de minusvalía de miembros de la unidad familiar"	///
	180110	"Certificado de convivencia de los miembros de la unidad familiar"	///
	100113	"No cumplir la edad permitida que se establece en la convocatoria."	///
	180111	"Acreditación de independencia familiar del solicitante"	///
	180112	"Justificación de la situación familiar"	///
	180113	"Acreditación de orfandad absoluta del solicitante"	///
	180114	"Acreditación de hermanos universitarios del solicitante que estudian fuera del domicilio familiar"	///
	180115	"Falta firma de familiares"	///
	180116	"Falta fotocopia del D.N.I. del padre del solicitante"	///
	180117	"Falta fotocopia del D.N.I. de la madre del solicitante"	///
	180118	"Falta fotocopia del D.N.I. de los hermanos del solicitante"	///
	180119	"Falta fotocopia del D.N.I. del conyuge del padre o de la madre"	///
	180120	"Falta fotocopia del D.N.I. del abuelo/a del solicitante"	///
	100114	"No acreditar suficientemente a juicio de la Comisión competente la independencia económica y/o familiar."	///
	180121	"Firma de la solicitud de beca por todos los miembros computables de la familia mayores de 18 años"	///
	180122	"Certificado académico especial de becas-colaboración"	///
	180123	"Proyecto de colaboración"	///
	180124	"Evaluación del proyecto por parte del Departamento correspondiente"	///
	180125	"Orden de preferencia (en los casos en que se ha solicitado más de un Departamento)"	///
	180126	"Faltan datos cuenta bancaria"	///
	180127	"Contrato de arrendamiento o alquiler"	///
	180128	"Copia del expediente académico de los estudios que le dan acceso al master"	///
	180129	"Declaración Jurada del número de becas recibidas por el Ministerio de Educación para realizar estudios universitarios."	///
	180130	"Pendiente de cuenta bancaria a nombre del solicitante"	///
	100115	"Existencia de solicitudes en las que concurren circunstancias para una asignación preferente de acuerdo a lo establecido en las bases de la convocatoria."	///
	180131	"Petición del NIE (número de identificación extranjero) del solicitante o de algún familiar"	///
	180132	"Petición de ingresos en el extranjero"	///
	180133	"Documentación que justifique alguna de las situaciones específicas mencionadas en su solicitud"	///
	180134	"Certificado de la Dirección del Centro en el que consten los datos académicos y del Centro donde el alumno está matriculado."	///
	180135	"Certificado de la Dirección del Centro donde cursa sus estudios, indicando que su solicitud ha sido presentada en el plazo indicado en la convocatoria"	///
	180136	"Documentación acreditativa de que el solicitante pertenece a familia monoparental"	///
	180137	"Fotocopia del NIF/NIE del solicitante o, en su defecto, padre/madre/tutor"	///
	180138	"Datos bancarios: cuenta o cartilla y entidad donde desea percibir el importe de la beca (20 dígitos). El alumno solicitante deberá figurar como titular o cotitular de la misma"	///
	180139	"Certificado de la nota media en base 4, según el artículo Cuarto.-1 de la convocatoria."	///
	180140	"Certificado de matrícula del alumno para el curso "	///
	100116	"No reunir los requisitos de nacionalidad "	///
	180141	"Documento acreditativo de la tutela familiar o institucional del solicitante"	///
	180142	"Documento donde se autorice al centro a cobrar la ayuda"	///
	180143	"Certificado acreditativo de que el alumno se encuentra matriculado en el centro en la modalidad de integración."	///
	180144	"Certificación acreditativa de la duración y coste mensual del servicio de reeducación pedagógica y/o lenguaje o programa especial para alumnado con altas capacidades, expedido por el Centro o reeducador que lo preste."	///
	180145	"Justificante de los pagos mensuales de la residencia realizados durante el curso."	///
	180146	"Certificado bancario de la cuenta donde desea recibir el importe de la beca, ya que la aportada en la solicitud es errónea"	///
	180147	"Horario de los medios de comunicación existentes entre el domicilio familiar y el centro de estudios"	///
	180148	"Declaración responsable del solicitante de que no posee ningún título universitario o de que no está en situación legal de poseerlo"	///
	180149	"Certificado de Empadronamiento conjunto de la unidad familiar referido al año pasado."	///
	180150	"Justificar los ingresos de la unidad  familiar en el año pasado."	///
	100117	"No estar matriculado por enseñanza oficial en el curso actual en la totalidad de las asignaturas o créditos que le restan para finalizar el segundo ciclo de enseñanza universitaria."	///
	180151	"Certificado de vida laboral del solicitante o del sustentador principal."	///
	180152	"Autorización paterna."	///
	180153	"Certificado de la nota media en base 4, según el artículo Tercero.-1 de la convocatoria (en el modelo que se adjunta con la solicitud)."	///
	180154	"Certificado de la nota media en base 10, según el artículo Quinto de la convocatoria (en el modelo que se adjunta con la solicitud)."	///
	180155	"Datos de NIF/NIE erróneos. Se deberá presentar fotocopia para NIF/NIE "	///
	180156	"Certificado de uso de comedor para el curso actual, con indicación del coste"	///
	180157	"Certificado de necesidad de transporte"	///
	180158	"Acreditación de la situación legal de desempleo"	///
	180159	"Acreditación de tener reconocido el derecho a percibir prestación o subsidio por desempleo"	///
	180160	"Aportar justificante de trabajo en España"	///
	100118	"No presentar un proyecto de colaboración debidamente avalado y puntuado por el consejo del departamento correspondiente."	///
	180161	"Informe del equipo de orientación educativa y psicopedagógica en el que se detalle la necesidad de reeducación que se considere necesaria para su corrección y la duración previsible."	///
	180162	"Certificado de empadronamiento conjunto de la unidad familiar y DNI/NIE de los miembros mayores de 14 años"	///
	180163	"Otros documentos:"	///
	180164	"Certificación académica personal completa."	///
	180165	"Certificación del Jefe de la Secretaría correspondiente de la nota media del expediente académico del solicitante y de la nota media de su promoción."	///
	180166	"Curriculum Vitae, con indicación en su caso de los premios y becas que le hubieren sido concedidos, estancias de movilidad realizadas y otros méritos que desee alegar, acompañado de la documentación correspondiente."	///
	180167	"Fotocopia del Pasaporte."	///
	180168	"Certificado de la nota media ponderada de su expediente académico en base 10."	///
	180169	"Documentación acreditativa donde figure el curso en el que finalizó los estudios correspondientes para la obtención de la diplomatura de magisterio."	///
	180170	"Informe del equipo de orientación educativa y psicopedagógica en el que se acredite que el alumno está afectado de discapacidad o transtorno grave de conducta, o bien certificado de minusvalía."	///
	100101	"Solicitar beca o ayuda para estudios no amparados por la convocatoria."	///
	100119	"No obtener un nº de orden que le sitúe dentro del total de ayudas a conceder en el departamento para el que solicita la colaboración."	///
	180171	"Certificación de la nota media ponderada del expediente académico de los estudios que esté realizando calculada en base 10 y solamente en el caso de estar actualmente matriculado en primer curso, certificación de la nota de acceso  a la universidad."	///
	180172	"Justificación documental de los méritos alegados por Vd. en el curriculum vitae, relativos a: Publicaciones."	///
	180173	"Justificación documental de los méritos alegados por Vd. en el curriculum vitae, relativos a: Otras titulaciones."	///
	180174	"Justificación documental de los méritos alegados por Vd. en el curriculum vitae, relativos a: Idiomas (especificar)."	///
	180175	"Justificación documental de los méritos alegados por Vd. en el curriculum vitae, relativos a: Informática."	///
	180176	"Documento expedido por la Escuela o Facultad que acredite el curso académico al que corresponde la fecha de presentación del Proyecto Fin de Carrera."	///
	180177	"Documentación acreditativa de los méritos alegados en el curriculum."	///
	180178	"Documentación acreditativa de los Premios obtenidos y alegados en el curriculum."	///
	180179	"Documentación acreditativa de las becas obtenidas y alegadas en el curriculum."	///
	180180	"Documentación acreditativa de otras titulaciones que alega como méritos en el curriculum."	///
	100120	"Solicitar beca para un departamento sin cupo asignado."	///
	180181	"Documentación acreditativa de los cursos oficiales de idiomas alegados en el curriculum."	///
	180182	"Documentación acreditativa de los cursos, seminarios y congresos alegados en el curriculum."	///
	180183	"Propuesta de resolución de la Comisión de Escolarización para alumnado con necesidades educativas especiales."	///
	180184	"Estudios de mayor nivel realizados con anterioridad a los actuales."	///
	180185	"Documentación acreditativa de no haberse podido matrícular antes de finalizar el plazo de presentación de solicitudes"	///
	250101	"Solicitar ayuda para estudios no amparados por la convocatoria"	///
	250102	"Poseer título que le habilite para el ejercicio profesional o estar en disposición legal de obtenerlo y/o no ser la beca o ayuda que solicita para cursar estudios de un ciclo o grado superior a los de las enseñanzas cursadas"	///
	250103	"No consignar en la solicitud los datos básicos o no haber aportado la documentación necesaria en el plazo establecido para la resolución de la misma, pese a haberle sido requerida"	///
	250106	"Disfrutar de ayuda o beca incompatible"	///
	250107	"No cumplir plazos establecidos para presentación de la solicitud y/o documentos"	///
	100121	"No tener la condición de becario según lo establecido en la convocatoria."	///
	250110	"Otras causas"	///
	250117	"No estar matriculado por enseñanza oficial en el curso actual, en la totalidad de las asignaturas o créditos que le restan para finalizar el segundo ciclo de enseñanza universitaria."	///
	250118	"No presentar un proyecto de colaboración debidamente avalado y puntuado por el consejo del departamento correspondiente"	///
	250119	"No obtener un nº de orden que le sitúe dentro del total de ayudas a conceder en el departamento para el que solicita la colaboración"	///
	250120	"Solicitar beca para un departamento sin cupo asignado"	///
	250122	"Haber sido beneficiario de esta ayuda anteriormente"	///
	250130	"Ayuda no compatible con la realización del Proyecto Fin de carrera o Másteres Universitarios Oficiales"	///
	250301	"No alcanzar la nota media mínima del curso exigida"	///
	250308	"Por haberse comprobado inexactitud en los datos académicos aportados"	///
	250311	"No haber superado el primer ciclo y/o las asignaturas o créditos del segundo ciclo"	///
	100122	"Haber sido beneficiario de esta ayuda anteriormente."	///
	310101	"No haber cumplimentado el test en el plazo establecido."	///
	310102	"No haber realizado el pago establecido a la U.I.M.P."	///
	999021	"No tener la vecindad administrativa en el País Vasco"	///
	100123	"No haber cursado el idioma solicitado como asignatura, en el curso anterior."	///
	100124	"No alcanzar la puntuación total obtenida por el último alumno seleccionado como suplente."	///
	100125	"Sobrepasar la edad de 20 años a la fecha de finalización del plazo"	///
	100126	"Estar matriculado en un curso de educación infantil para el que la C.A, tiene establecida gratuidad"	///
	100127	"No cursar una de las ramas establecidas en la convocatoria durante el curso "	///
	100128	"Haber sido beneficiario de la ayuda para cursos de idiomas en el extranjero en dos ocasiones."	///
	100102	"Poseer título que le habilite para el ejercicio profesional o estar en disposición legal de obtenerlo y/o no ser la beca o ayuda que solicita para cursar estudios de un ciclo o grado superior a los de las enseñanzas cursadas."	///
	100129	"Repetir curso"	///
	100130	"Ayuda no compatible con la realización del Proyecto Fin de carrera o Másteres Universitarios Oficiales"	///
	100131	"Haber causado baja en el centro de estudios antes de la finalización del curso."	///
	100132	"Tener los servicios cubiertos por el Gobierno de la Comunidad Autónoma"	///
	100133	"Estar matriculado en un centro no autorizado"	///
	100134	"No asistir con regularidad al centro docente"	///
	100135	"Estar matriculado en un centro no sostenido con fondos públicos"	///
	100137	"No haber finalizado la Diplomatura en los cursos establecidos en la convocatoria"	///
	100138	"No cumplir requisitos según disposición final primera de la convocatoria"	///
	100139	"No iniciar estudios universitarios por primera vez."	///
	100103	"No consignar en la solicitud los datos básicos o no haber aportado la documentación necesaria para la resolución de la misma, pese a haberle sido requerida."	///
	100140	"Solicitar ayuda no convocada para el nivel de Educación Infantil"	///
	100141	"Nivel de estudios no autorizado en el centro"	///
	100142	"No cumplir los requisitos establecidos en la convocatoria para este tipo de ayudas."	///
	100146	"No cumplir el requisito de encontrarse el propio solicitante o sus sustentadores trabajando en España "	///
	100148	"No cumplir el requisito de edad con condición de becario en el curso correspondiente (Artículo Segundo 1 y 2)"	///
	100149	"Haber sido beneficiario de esta ayuda anteriormente (artículo duodécimo de la convocatoria)"	///
	100150	"El centro docente no propone ninguna ayuda para esta solicitud."	///
	100151	"No encontrarse en situación legal de desempleo."	///
	100152	"Ayuda no compatible con la realización de la Formación en centros de trabajo"	///
	100153	"Por no estar en posesión de título universitario."	///
	100104	"Por pérdida de curso/s lectivo/s en el supuesto de cambio de estudios cursados total o parcialmente con condición de becario."	///
	100154	"Por no acreditar el solicitante la edad requerida en las bases de la correspondiente convocatoria."	///
	100155	"Por no acreditar el solicitante la situación legal de desempleo requerida en las bases de la correspondiente convocatoria."	///
	100156	"Por no acreditar el solicitante la situación de perceptor de prestaciones de desempleo requerida en las bases de la correspondiente convocatoria."	///
	100157	"Por no encontrarse matriculado en estudios amparados por la correspondiente convocatoria."	///
	100158	"No estar matriculado en el curso actual en un curso completo de Máster"	///
	100159	"No tener derecho a la ayuda compensatoria al no tener cumplidos los 16 años."	///
	100160	"Tener la ayuda máxima de desplazamiento permitida según la convocatoria."	///
	100161	"No quedar suficientemente acreditada la composición de la unidad familiar."	///
	100162	"No cumplir el requisito para la concesión del componente de transporte urbano."	///
	100163	"No cumplir los requisitos para la adjudicación del componente de residencia."	///
	100105	"Para el Proyecto Fin de Carrera, no haber superado todas las asignaturas o créditos y/o no haber sido becario de la convocatoria general o beca de movilidad del Ministerio de Educación en el curso anterior (est. no universitarios)."	///
	100164	"No estar matriculado en el curso de la totalidad de los créditos que le restan para finalizar los estudios de la diplomatura de Maestro."	///
	100165	"Estar matriculado en un curso para el que la Comunidad Autónoma tiene establecida gratuidad de libros de texto"	///
	100170	"No haber finalizado sus estudios en el curso establecido en la convocatoria."	///
	100171	"No reunir los requisitos establecidos en el Artículo 4. 1. d) del  R.D. 1721/2007, de 21 de diciembre, por el que se regula el régimen de las becas y ayudas al estudio personalizadas (BOE de 17 de enero)."	///
	100172	"Para el Proyecto Fin de Carrera, no haber superado todas las asignaturas o créditos en el curso anterior (est.universitarios)."	///
	100174	"No tener derecho a percibir importe alguno en concepto de becas, subvenciones o ayudas por sentencia judicial"	///
	100175	"No cumplir el requisito para la concesión del componente de desplazamiento."	///
	100177	"No procede el componente de Compensación para la modalidad de estudios en los que está matriculado."	///
	100178	"No reunir los requisitos establecidos en el artículo 4.1.c) del R.D. 1721/2007, de 21 de diciembre, por el que se regula el régimen de las becas y ayudas al estudio personalizadas (BOE de 17 de enero de 2008)"	///
	100300	"DENEGACIONES POR DATOS ACADÉMICOS"	///
	100106	"Disfrutar de ayuda o beca incompatible."	///
	100301	"No alcanzar la nota media mínima exigida entre las convocatorias de junio y septiembre."	///
	100302	"No haber aprobado el número mínimo de asignaturas o créditos establecidos en las bases de la convocatoria."	///
	100303	"No estar matriculado en el número mínimo exigido de asignaturas o créditos en el curso anterior o último realizado."	///
	100304	"No estar matriculado en el número mínimo exigido de asignaturas o créditos en el presente curso."	///
	100305	"En caso de alumnado universitario que realiza estudios no presenciales, no tener el mínimo de asignaturas o créditos aprobados o matriculados"	///
	100306	"No haberse matriculado en un curso completo."	///
	100307	"No estar matriculado en el curso siguiente según el plan de estudios vigente."	///
	100308	"Por haberse comprobado inexactitud en los datos académicos aportados."	///
	100309	"No tener totalmente aprobado el curso requerido."	///
	100310	"No haber obtenido una nota final de notable en la asignatura del idioma."	///
	100107	"No cumplir plazos establecidos para presentación de la solicitud y/o documentos."	///
	100311	"No haber superado el primer ciclo y/o las asignaturas o créditos del segundo ciclo."	///
	100312	"No tener superado el 40 % de la carga lectiva total de sus estudios universitarios."	///
	100313	"No alcanzar la nota media mínima exigida del idioma correspondiente."	///
	100314	"No superar el primer test a través de Internet."	///
	100315	"No superar el segundo test presencial."	///
	100316	"No estar matriculado en el curso actual en la totalidad de los créditos que le quedan para finalizar el Máster"	///
	100317	"No haber superado el 80% de los créditos en que se matriculó en el curso anterior."	///
	100318	"No alcanzar su expediente la nota media exigida."	///
	100319	"No estar matriculado en el curso actual en el 2º curso de los mismos estudios para los que obtuvo beca el curso anterior."	///
	100400	"DENEGACIONES POR DATOS DE LA AEAT"	///
	100108	"No pertenecer a alguno/s de los colectivos enumerados en el artículo 4 de la Orden 1802/2002, de 9 de julio, para la concesión de la ayuda compensatoria."	///
	100401	"Por superar los umbrales de renta, tras consultar los datos que sobre su unidad familiar obran en poder de la Administración tributaria."	///
	100402	"Por superar los umbrales de patrimonio, tras consultar los datos que sobre su unidad familiar obran en poder de la Administración tributaria."	///
	100403	"No identificación de sus NIF, por las Agencias Tributarias."	///
	100404	"No identificación economica por las Agencias Tributarias."	///
	100405	"Por declararse independiente el solicitante, y no obstante, figurar en una declaración de IRPF, como descendiente."	///
	100406	"Falta información fiscal correspondiente al NIF/NIE "	///
	100407	"Por superar el volumen de negocio."	///
	100408	"Falta el titular principal de una Declaración de la Renta, a la que pertenece el solicitante o algun familiar."	///
	100409	"Faltan familiares a efectos fiscales.(ejercicio anterior)."	///
	100410	"Discrepancia entre los bienes señalados por el solicitante y la información de la Agencia Tributaria."	///
	100193	"Las cuantías de becas y ayudas así como de sus diferentes componentes no serán en ningún caso superiores al coste real de la prestación o prestaciones que cubran." ///
	100222	"No poseer el título académico requerido" ///
	100224	"No reunir los requisitos de la convocatoria" ///
	100420	"Ningún familiar está identificado por la AEAT"	///
	180252	"Certificado de título académico requerido"	///
	100225	"Por justificar ingresos objetivamente inferiores al nivel de gastos de la unidad familiar"	///
201121	"No reunir los requisitos establecidos en la convocatoria para ser beneficiario del régimen aplicable a las víctimas de violencia de género."	///
201124	"Por no encontrarse en situación de prestar la colaboración durante el número de horas y período requeridos en el artículo 5 e) de la convocatoria."	///
201126	"No haber obtenido el título alegado en la universidad que indica en su solicitud"	///
	100187	"No encontrarse matriculado en el centro y/o estudios para los que solicita ayuda"	///
	100182	"Renuncia"	///
	100183	"En el caso de cambio de estudios, haber disfrutado de beca para el mismo nivel que las enseñanzas matriculadas"	///
	100184	"Discordancia entre la identificación del alumno registrado en la sede electrónica y la del solicitante de beca"	///
	100176	"Haber sido transferidas las becas para estudios superiores no universitarios a la Comunidad Autónoma del País Vasco, donde tiene vecindad administrativa el solicitante"	///
	100186	"Los ingresos anuales son inferiores a los gastos de residencia del curso académico"	///
	100320	"Solicitar beca para una universidad en la que el alumno no se encuentra matriculado"	///
	100321	"Solicitar beca para una unidad distinta a un departamento universitario"	///
	100217	"No haberse podido determinar los ingresos de la unidad familiar"	///
	100219	"No haber aportado certificado resumen de la declaración de la renta o certificado de imputaciones"	///
	100191	"Haber disfrutado de beca para el mismo nivel o superior al de las enseñanzas para las que solicita la ayuda"	///
	100185	"La beca o ayuda que solicita no es para realizar estudios de un nivel superior al de los últimos estudios cursados"	///
	100173	"Haber sido beneficiario de beca el número máximo de años en otras enseñanzas comprendidas en la enseñanza secundaria postobligatoria"	///
	100501	"Por pérdida de curso/s lectivo/s en el supuesto de cambio de estudios cursados total o parcialmente con condición de becario"	///
	100502	"Poseer título, o estar en disposición legal para su obtención, del mismo o superior nivel al de los estudios   para los que se solicita la beca"	///
	100503	"Haber sido beneficiario de beca el número máximo de años que permite la Resolución de convocatoria"	///
	100504	"No alcanzar la nota  mínima exigida en la convocatoria"	///
	100500	"DENEGACIONES ACADEMICAS SSCC"	///
	100505	"No haber aprobado el número o porcentaje mínimo de asignaturas o créditos establecidos en las bases de la convocatoria"	///
	140514	"Solicitud que debe ser tramitada por la convocatoria general al poseer algún miembro de la unidad familiar un inmueble en la Comunidad Autónoma donde cursa estudios"	///
	100417	"Por superar los umbrales en acumulación de Patrimonio, tras consultar los datos que sobre su unidad familiar obran en poder de la Administración tributaria"	///
	100181	"Solicitud duplicada"	///
	100188	"Por haberse comprobado inexactitud en los datos"	///
	100506	"No estar matriculado en el número mínimo exigido de asignaturas o créditos en el presente curso"	///
	100507	"No estar matriculado en el número mínimo exigido de asignaturas o créditos en el curso anterior"	///
	100324	"Poseer título, o estar en disposición legal para su obtención, del mismo o superior nivel al de los estudios   para los que se solicita la beca"	///
	100331	"No alcanzar la nota media mínima exigida en la convocatoria"	///
	100332	"No haber aprobado el número o porcentaje mínimo de asignaturas o créditos establecidos en las bases de la convocatoria"	///
	100322	"No haber superado los 180 créditos requeridos para los estudios de Grado"	///
	100329	"No estar matriculado en el número mínimo exigido de asignaturas o créditos en el presente curso"	///
	100330	"No estar matriculado en el número mínimo de asignaturas o créditos en el curso anterior o último realizado"	///
	100323	"Por pérdida de curso/s lectivo/s en el supuesto de cambio de estudios cursados total o parcialmente con condición de becario"	///
	100328	"Haber sido beneficiario de beca el número máximo de años que permite la Resolución de la Convocatoria"	///
	100189	"Falta certificado de vida laboral de los miembros de la unidad familiar en edad laboral"	///
	100192	"Tener concedido el máximo de cuantías que le corresponden en función de los estudios o modalidad de matrícula"	///
	100194	"No alcanzar los requisitos académicos mínimos para ser beneficiario de otras cuantías de beca"	///
	100198	"Incumplimiento de los requisitos de aprovechamiento académico o asistencia a clase establecidos en la convocatoria"	///
	100325	"Haber sido beneficiario de beca el número máximo de años que permite la Resolución de convocatoria"	///
	100326	"No matriculado del primer curso de máster por primera vez"	///
	100333	"No estar en posesión de la titulación que da acceso a los estudios de Máster Oficial"	///
	100509	"No haber sido becario de la convocatoria general o beca de movilidad del Ministerio de Educación en el curso anterior"	///
	100510	"Poseer título, o estar en disposición legal para su obtención, del mismo o superior nivel al de los estudios para los que se solicita la beca"	///
	140406	"Falta información fiscal correspondiente al NIF/NIE"	///
	100512	"Por haber disfrutado anteriormente de beca para realizar los últimos créditos que le quedaban para finalizar sus estudios"	///
	140408	"Falta el titular principal de una Declaración de la Renta, a la que pertenece el solicitante o algun familiar"	///
	140411	"Por existir varias declaraciones ante la Agencia Tributaria, en relacion con el NIF/NIE"	///
	100511	"No tener totalmente aprobado el curso anterior"	///
	201101	"No ha sido seleccionado por las Instituciones de Educación Superior para ser beneficiario de la Convocatoria Erasmus Plus."	///
	201102	"No estar matriculado en la Universidad para la que se presenta en los estudios que dice estudiar."	///
	201103	"No tener el nivel de idioma adecuado para participar en la Convocatoria"	///
	201104	"No presentar certificado adecuado para justificar estancia de práticas."	///
	201105	"No tener aprobado el mínimo de créditos requerido en la Convocatoria de 60 para el caso de Grado"	///
	201106	"No disponer del permiso de residencia legal"	///
	201113	"Cambio de país de destino"	///
	100334	"Por haber disfrutado anteriormente de beca para realizar los últimos créditos que le quedaban para finalizar sus estudios"	///
	201114	"No tener aprobado el mínimo de créditos requerido en la Convocatoria de 30 para el caso de Grado"	///
	201115	"No alcanzar el mínimo de 60 créditos requeridos por la convocatoria."	///
	201119	"Por no haberse matriculado de curso completo. A estos efectos, la F.C.T. se consideran prácticas del curso anterior"	///
	100421	"Ningún familiar tiene datos en la AEAT, estén o no identificados"	///
	100422	"Falta información fiscal correspondiente a la persona o NIF/NIE"	///
	100423	"No figura entre los miembros grabados una persona que está en una declaración conjunta de uno de los miembros computables."	///
	100424	"Por existir varias declaraciones ante la Agencia Tributaria, en relación con el NIF/NIE"	///
	201122	"Por no cursar estudios en el año académico 2018/19, tal y como establece el artículo 4 de la Resolución de convocatoria (BOE de 16 de agosto)." ///
	100179	"No cumplir requisitos según Artículo 18 de la convocatoria"	
label values cause_denial_num cause_denial_num

		//2.2.2. Generate variable of priority (for the denial cause)
gen priority=1 if cause_denial_num==100401
replace priority=1 if cause_denial_num==100410
replace priority=1 if cause_denial_num==100217
replace priority=2 if cause_denial_num==100402
replace priority=3 if cause_denial_num==100402
replace priority=3 if cause_denial_num==100413
replace priority=3 if cause_denial_num==100415
replace priority=3 if cause_denial_num==100416
replace priority=3 if cause_denial_num==100214
replace priority=3 if cause_denial_num==100215
replace priority=3 if cause_denial_num==100216
replace priority=3 if cause_denial_num==100417
replace priority=4 if cause_denial_num==100407
replace priority=5 if cause_denial_num==100405
replace priority=6 if cause_denial_num==100411
replace priority=7 if cause_denial_num==100408
replace priority=8 if cause_denial_num==100406
replace priority=9 if cause_denial_num==100409

label var priority "Orden de prioridad en los criterios de denegaciónd e la beca"

	//2.4. Knowledge field 
label define field	42102	"Abogacía"	///
101401	"Actividad física y del deporte"	///
41301	"Administración y empresa"	///
31401	"Antropología social y cultural"	///
22201	"Arqueología"	///
73101	"Arquitectura"	///
73201	"Arquitectura técnica"	///
21501	"Artes escénicas"	///
21101	"Audiovisual, imagen y multimedia"	///
21301	"Bellas artes"	///
22302	"Bioética"	///
51101	"Biología"	///
51901	"Biomedicina"	///
51201	"Bioquímica"	///
51202	"Biotecnología"	///
81101	"Ciencia y producción animal"	///
72101	"Ciencia y tecnología de los alimentos"	///
52101	"Ciencias ambientales"	///
53201	"Ciencias del mar"	///
41601	"Comercio"	///
32101	"Comunicación"	///
21401	"Conservación y restauración"	///
41101	"Contabilidad y gestión de impuestos"	///
31203	"Cooperación al desarrollo"	///
31402	"Criminología"	///
42101	"Derecho"	///
61301	"Desarrollo de software y de aplicaciones"	///
61302	"Desarrollo de videojuegos"	///
11102	"Didácticas específicas"	///
21201	"Diseño"	///
61201	"Diseño y administración de bases de datos y redes"	///
31101	"Economía"	///
11201	"Educación infantil"	///
11301	"Educación primaria"	///
11901	"Educación social"	///
91301	"Enfermería"	///
72102	"Enología"	///
11403	"Enseñanza de lenguas españolas a extranjeros"	///
103101	"Enseñanza militar"	///
52201	"Entornos naturales y vida silvestre"	///
54201	"Estadística"	///
31408	"Estudios regionales"	///
31403	"Estudios y gestión de la cultura"	///
91601	"Farmacia"	///
22301	"Filosofía"	///
41201	"Financiera y actuarial"	///
41202	"Finanzas y contabilidad"	///
53301	"Física"	///
91501	"Fisioterapia"	///
101301	"Gastronomía y artes culinarias"	///
31404	"Geografía"	///
53202	"Geografía y ordenación del territorio"	///
53203	"Geología"	///
41304	"Gestión de centros educativos"	///
101402	"Gestión deportiva"	///
101302	"Gestión hotelera"	///
41305	"Gestión sanitaria"	///
41303	"Gestión y administración pública"	///
22202	"Historia"	///
21302	"Historia del arte"	///
22901	"Humanidades"	///
31405	"Igualdad de género"	///
32201	"Información y documentación"	///
61901	"Informática"	///
71601	"Ingeniería aeronáutica"	///
81102	"Ingeniería agraria y agroalimentaria"	///
81103	"Ingeniería agrícola, agropecuaria y medio rural"	///
72103	"Ingeniería alimentaria"	///
91401	"Ingeniería biomédica y de la salud"	///
73202	"Ingeniería civil"	///
71401	"Ingeniería de computadores"	///
71301	"Ingeniería de la energía"	///
72201	"Ingeniería de materiales"	///
72401	"Ingeniería de minas y  energía"	///
71901	"Ingeniería de organización industrial"	///
71402	"Ingeniería de sonido e imagen"	///
71403	"Ingeniería de telecomunicación"	///
71602	"Ingeniería del automóvil"	///
71302	"Ingeniería eléctrica"	///
71404	"Ingeniería electrónica industrial y automática"	///
71501	"Ingeniería en diseño industrial y desarrollo del producto"	///
71405	"Ingeniería en electrónica"	///
71502	"Ingeniería en tecnologías industriales"	///
82101	"Ingeniería forestal y montes"	///
73102	"Ingeniería geomática, topografía y cartografía"	///
81201	"Ingeniería horticultura y jardinería"	///
71503	"Ingeniería mecánica"	///
71201	"Ingeniería medioambiental"	///
61303	"Ingeniería multimedia"	///
71603	"Ingeniería naval y oceánica"	///
71101	"Ingeniería química industrial"	///
72301	"Ingeniería textil"	///
61304	"Inteligencia artificial"	///
23101	"Lengua inglesa"	///
23102	"Lenguas clásicas"	///
23901	"Lenguas modernas y aplicadas"	///
23201	"Lenguas y dialectos españoles"	///
23203	"Lingüística"	///
23202	"Literatura"	///
91502	"Logopedia"	///
41401	"Marketing"	///
54101	"Matemáticas"	///
91201	"Medicina"	///
31407	"Migraciones y acción humanitaria"	///
21502	"Música"	///
71902	"Nanotecnología"	///
104101	"Náutica y transporte marítimo"	///
91901	"Neurociencia"	///
91503	"Nutrición humana y dietética"	///
91101	"Odontología"	///
91402	"Óptica y optometría"	///
81988	"Otras agricultura y ganadería"	///
73988	"Otras arquitectura y construcción"	///
21988	"Otras artes"	///
53988	"Otras ciencias"	///
91988	"Otras ciencias de la salud"	///
51988	"Otras ciencias de la vida"	///
31988	"Otras ciencias sociales y jurídicas"	///
11988	"Otras educación"	///
22988	"Otras humanidades"	///
72988	"Otras industria manufacturera y producción"	///
61988	"Otras informática"	///
71988	"Otras ingeniería"	///
23988	"Otras lenguas"	///
23103	"Otras lenguas extranjeras"	///
54988	"Otras matemáticas y estadística"	///
41988	"Otras negocios y administración"	///
11401	"Otros maestros"	///
22203	"Patrimonio Histórico-Artístico"	///
11101	"Pedagogía"	///
32102	"Periodismo"	///
83101	"Pesca"	///
73104	"Planificación rural"	///
91504	"Podología"	///
31201	"Política y gestión pública"	///
102201	"Prevención y seguridad laboral"	///
11402	"Profesorado de educación secundaria"	///
103201	"Protección de la propiedad y las personas"	///
41402	"Protocolo y eventos"	///
31301	"Psicología"	///
91903	"Psicología general sanitaria"	///
41403	"Publicidad y relaciones públicas"	///
53101	"Química"	///
31202	"Relaciones internacionales"	///
41302	"Relaciones laborales y recursos humanos"	///
22101	"Religión y teología"	///
91902	"Salud pública"	///
104102	"Servicio de transporte terrestre"	///
104103	"Servicios de transporte aéreo"	///
31406	"Sociología"	///
91505	"Terapia ocupacional"	///
92301	"Trabajo social"	///
23104	"Traducción e interpretación"	///
101501	"Turismo"	///
73103	"Urbanismo y paisajismo"	///
84101	"Veterinaria"	
label values field field
}

//3. Clean variables and add additional value labels

{
	*Institution 
label define institution 0 "Estado" 17 "Pais Vasco"
label values institution institution 

	*Estado de la beca
label define status 0 "Denegada" 1 "Concedida"
label values status status 

	*Destring family members
destring hhsize, force replace

	*Destring income variables
destring inc_gross, force replace
destring inc_net, force replace

rename cause_denial cause_denial_s
rename cause_denial_num cause_denial
label var cause_denial "Causa de denegación de la beca"
}
save "$dataoutput/Becas.dta", replace

//4. DUPLICATES IN THE DATASET
/*

use "$outputdata/Becas.dta", clear

sort id year
duplicates drop

duplicates tag id year, gen(dups)
duplicates tag id year knowledge_field, gen (dups1) //Señalizo estos IDs, que solicitan beca para la misma carerra en el mismo año en 2 universidades distintas (no puede ser)
drop dups
rename dups1 dups_beca 
label var dups_beca "Solicitan la beca más de 1 vez en el mismo año para la misma carrera en 2 universidades distintas" //Será suficiente con únicamente luego unir utilizando también la variable de universidad 
*/
