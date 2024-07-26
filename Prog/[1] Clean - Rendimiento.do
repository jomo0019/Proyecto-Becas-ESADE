clear all
set more off

//0. Set directories 

/*-----------------------------------------------------------------------------

						CLEAN SAMPLE - Rendimiento
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

//1. Rename and label variables

import delimited "$datainput/Rendimiento_sample_random.csv", clear

rename personal_id id
rename curso year
rename nacimiento birth
rename tipo_titulacion degree_type //Solamente tenemos alumnos de grado
rename campo_conocimiento field
rename rama_conocimiento branch
rename nota_media_exp average_grade
rename forma_acceso access_type
rename nota_admision admission_grade
rename ocupacion_padres parental_occupation
rename estudios_padres parental_studies
rename primera_matriculacion first_registration
rename curso_1 first_year
rename edad first_year_age
rename sexo sex
rename titularidad_universidad university_ownership
rename ccaa_universidad ccaa_university
rename modalidad_universidad university_modality
rename prov_residencia_ramdom family_residence_province
rename prov_unidad_ramdom faculty_province
rename prov_universidad_random university_province
rename nacionalidad_random nacionality
rename pais_residencia_random random_family_country
rename universidad_random university_id
rename nacionality nationality 

tostring id, replace
drop v1 degree_type

label var year "Curso de referencia"
label var birth "Año de nacimiento"
label var branch "Rama de conocimiento (agregada)"
label var field "Tipo de estudio que cursa (rama desagregada)"
label var curso_acceso_titulacion "Curso de acceso al grado, desde 2013"
label var creditos_matriculados_desde_inic "Créditos presentados desde el inicio"
label var creditos_matriculados_curso "Créditos matriculados en el curso de referencia"
label var creditos_matriculados_1_curso "Créditos matriculados en 1ª matrícula del curso de referencia"
label var creditos_matriculados_2_curso "Créditos matriculados en 2ª matrícula del curso de referencia"
label var creditos_matriculados_3_curso "Créditos matriculados en 3ª matrícula del curso de referencia"
label var creditos_presentados_curso "Créditos presentados en el curso de referencia"
label var creditos_superados_curso "Créditos superados en el curso de referencia"
label var titula_curso_referencia "Si titula o no en el curso de referencia"
label var average_grade "Nota media del grado (para egresados)"
label var access_type "Forma de acceso"
label var admission_grade "Nota de admisión [0-14]"
label var parental_occupation "Ocupación de los padres"
label var parental_studies "Estudios de los padres"
label var first_registration "Si el año en curso es la primera matrícula"
label var first_year "Primer año en el que aparece con información para ese grado"
label var first_year_age "Edad (proxy) el primer año que se matricula"
label var sex "Sexo"
label var university_ownership "Titularidad de la universidad"
label var ccaa_university "CCAA de la universidad"
label var university_modality "Modalida de la universidad"
label var family_residence_province "Provincia de residencia familiar"
label var faculty_province "Provincia de la facultad"
label var university_province "Provincia de la universidad"
label var nationality "Nacionalidad"
label var random_family_country "País de residencia familiar - Random"
label var university_id "Universidad - Random"


//2. Define labels randomizated by SIIU (CONFIDENCIAL)

	//2.1. Family residence 
label define family_residence	4	"Álava"	///
	32	"Albacete"	///
	26	"Alicante"	///
	39	"Almería"	///
	8	"Ávila"	///
	52	"Badajoz"	///
	28	"Illes Balears"	///
	5	"Barcelona"	///
	34	"Burgos"	///
	11	"Cáceres"	///
	9	"Cádiz"	///
	36	"Castellón"	///
	45	"Ciudad Real"	///
	43	"córdoba"	///
	10	"A Coruña"	///
	46	"Cuenca"	///
	42	"Girona"	///
	41	"Granada"	///
	17	"Guadalajara"	///
	38	"Gipuzkoa Huelva"	///
	47	"Huelva"	///
	23	"Huesca"	///
	50	"Jaén"	///
	25	"León"	///
	37	"Lleida"	///
	3	"La Rioja"	///
	16	"Lugo "	///
	53	"Madrid"	///
	2	"Málaga"	///
	22	"Murcia"	///
	51	"Navarra"	///
	6	"Ourense"	///
	54	"Asturias"	///
	1	"Palencia"	///
	49	"Las Palmas"	///
	55	"Pontevedra"	///
	31	"Salamanca"	///
	27	"Santa Cruz de Tenerife"	///
	18	"Cantabria"	///
	35	"Segovia"	///
	44	"Sevilla"	///
	13	"Soria"	///
	12	"Tarragona"	///
	30	"Teruel"	///
	40	"Toledo"	///
	19	"Valencia"	///
	48	"Valladolid"	///
	24	"Bizkaia"	///
	21	"Zamora"	///
	20	"Zaragoza"	///
	33	"Ceuta"	///
	29	"Melilla"	///
	14	"Extranjero"	///
	15	"No consta"	///
	7	"No consta"	
label values family_residence family_residence 


	//2.2. Faculty province (CONFIDENCIAL)
label define faculty_province	45	"Álava"	///
	25	"Albacete"	///
	31	"Alicante"	///
	20	"Almería"	///
	9	"Ávila"	///
	38	"Badajoz"	///
	50	"Illes Balears"	///
	15	"Barcelona"	///
	36	"Burgos"	///
	43	"Cáceres"	///
	29	"Cádiz"	///
	53	"Castellón"	///
	4	"Ciudad Real"	///
	46	"Córdoba"	///
	3	"A Coruña"	///
	2	"Cuenca"	///
	5	"Girona"	///
	47	"Granada"	///
	13	"Guadalajara"	///
	12	"Gipuzkoa Huelva"	///
	51	"Huelva"	///
	42	"Huesca"	///
	33	"Jaén"	///
	52	"León"	///
	24	"Lleida"	///
	37	"La Rioja"	///
	17	"Lugo "	///
	7	"Madrid"	///
	19	"Málaga"	///
	6	"Murcia"	///
	14	"Navarra"	///
	26	"Ourense"	///
	30	"Asturias"	///
	21	"Palencia"	///
	10	"Las Palmas"	///
	18	"Pontevedra"	///
	39	"Salamanca"	///
	32	"Santa Cruz de Tenerife"	///
	11	"Cantabria"	///
	44	"Segovia"	///
	23	"Sevilla"	///
	34	"Soria"	///
	49	"Tarragona"	///
	1	"Teruel"	///
	22	"Toledo"	///
	41	"Valencia"	///
	40	"Valladolid"	///
	16	"Bizkaia"	///
	8	"Zamora"	///
	27	"Zaragoza"	///
	28	"Ceuta"	///
	48	"Melilla"	///
	35	"No consta"	
label values faculty_province faculty_province


	//2.3. University province  (CONFIDENCIAL)
label define university_province	2	"Alicante"	///
	17	"Almería"	///
	16	"Ávila"	///
	14	"Badajoz"	///
	32	"Illes Balears"	///
	21	"Barcelona"	///
	3	"Burgos"	///
	4	"Cádiz"	///
	24	"Castellón"	///
	37	"Ciudad Real"	///
	22	"Córdoba"	///
	30	"A Coruña"	///
	10	"Girona"	///
	20	"Granada"	///
	35	"Gipuzkoa"	///
	19	"Huelva"	///
	25	"Jaén"	///
	31	"León"	///
	33	"Lleida"	///
	6	"La Rioja"	///
	11	"Madrid "	///
	7	"Málaga"	///
	36	"Murci"	///
	5	"Navarra"	///
	23	"Asturias"	///
	18	"Las Palmas "	///
	1	"Pontevedra"	///
	15	"Salamanca"	///
	29	"Santa Cruz de Tenerife"	///
	26	"Cantabria"	///
	12	"Segovia"	///
	27	"Sevilla"	///
	9	"Tarragona"	///
	8	"Valencia"	///
	13	"Valladolid"	///
	34	"Bizkaia"	///
	28	"Zaragoza"	
label values university_province university_province

	 //2.4. Define labels of university (CONFIDENCIAL)
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

label define ccaa_university 0 "Estado" 1 "Andalucía" 2 "Aragón" 3 "Asturias" 4 "Illes Balears" ///
5 "Islas Canarias" 6 "Cantabria" 7 "Castilla y León" 8 "Castilla - La Mancha" 9 "Cataluña" ///
10 "Extremadura" 11"Galicia" 12 "La Rioja" 13 "Madrid" 14 "Región de Murcia" 15 "Comunidad Foral de Navarra" ///
16 "Comunidad Valenciana" 17 "País Vasco"
label values ccaa_university ccaa_university

//3. Clean variables 
tostring id, replace

	*Rama de conocimiento desagregada
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
	
	*Rama de conocimiento 
label define branch 1 "Artes y humanidades" 2 "Ciencias" 3 "Ciencias sociales y juridicas" 4 "Ingenieria y Arquitectura" 5 "Ciencias de salud" 8 "No aplica" 9 "No consta"
label values branch branch

	*Créditos matriculados/aprobados
destring creditos*, force replace

	*Titula o no en el curso de referencia
replace titula=. if titula==2 //No sabemos qué es el valor 2
label define titula 0 "No titula" 1 "Titula"
label values titula titula 
		
	*Nota media 
replace average_grade = . if average_grade > 10
bys id field (average_grade): gen average_grade_fill=average_grade[1] 

	*Vía de acceso 
destring access_type, replace force
replace access_type=. if access_type==99|access_type==88

label define access_type 1 "PAU" 2 "Estudiantes internacionales de la UE" 3 "FP superior" 4 "Mayores de 25" 5 "Mayores de 40"6 "Mayores de 45" 7 "Estudiantes extranjeros" 8 "Poseer titulo universitario" 9 "Convalidacion parcial estudios extranjeros" 10 "Traslado de expediente" 11 "Enseñanzas anteriores" 12 "Acceso sin pau a bachilleratos previos a LOMCE"
label value access_type access_type

	*Nota de admisión al grado
destring admission_grade, force replace
replace admission_grade = . if admission_grade > 14 | admission_grade<0

	*Parental occupation
replace parental_occupation=. if parental_occupation==9

label define parental_occupation 4 "Ambos con ocupaciones altas" 3 "Uno de ellos con ocupación alta" 2 "Ambos con ocupaciones medias" 1 "Uno de ellos con ocupación media" 0 "Ambos con ocupaciones bajas o sin ocupación" 
label values parental_occupation parental_occupation

	*Parental studies
replace parental_studies=. if parental_studies==9

label define parental_studies 4 "Ambos con estudios superiores" 3 "Uno de ellos con estudios superiores" 2 "Ambos con estudios medios" 1 "Uno de ellos con estudios medios" 0 "Ambos con estudios primarios o sin estudios" 
label values parental_studies parental_studies
	
	*Sex
label define sex 0 "Mujeres" 1 "Hombres"
label value sex sex

	gen female=1 if sex==0
	replace female=0 if sex==1 
	label define female 0 "Hombre" 1 "Mujer"
	label values female female
	label var female "Mujer"

	*University ownership
des university_ownership 

	gen public=1 if university_ownership=="Pública"
	replace public=0 if university_ownership=="Privada"
	label define public 0 "Privada" 1 "Pública"
	label values public public
	label var public "Titularidad pública"

	*Nationality 
des nationality 

	gen spanish_nationality=1 if nationality==114
	replace spanish_nationality=0 if nationality!=114
	label define spanish_nationality 0 "Extranjera" 1 "Española"
	label values spanish_nationality spanish_nationality
	label var spanish_nationality "Nacionalidad española"
	
	*Family residence
des random_family_country

	gen spanish_family_residence=1 if random_family_country==24
	replace spanish_family_residence=0 if random_family_country!=24
	label define spanish_family_residence 0 "En el extranjero" 1 "En España"
	label values spanish_family_residence spanish_family_residence 
	label var  spanish_family_residence "Residencia familiar en España"
	
save "$dataoutput/Rendimiento.dta", replace
