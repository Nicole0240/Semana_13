* ============================================
* Proyecto: Análisis casen - T5 
* Autor: Nicole Jara
* Fecha: 2026-11-19
* Propósito: Do-file automatizado
* ============================================

cd "C:/Users/Ragnar Lothbrok/Documents/Fundamentos/Semana_13"

version 14 // corre con las reglas de Stata 14, aunque se tenga una version más actualizada
clear all // limpia los datos y resultados que pudieran estar cargados 
set more off // evita que Stata se detenga para mostrar resultados por partes
capture mkdir "output" // crea la carpeta output 
capture log close // cerrar un log que haya quedado abierto
log using "output/tarea_t5.log", replace text // log using comienza a guardar los resultados que aparecen en Stata, luego "output/tarea_t5.log" indica donde se guardará el archivo, replace reemplaza el log anterior si existe y por ultimo text lo guarda como archivo de texto. inicia el registro de resultados y lo guarda en la carpeta output

* --- 1. Parámetros de configuración ---

local datos "data/raw/casen_reducido.csv" // ubicación de la base de datos
local depvar "ingreso" // variable que quiero analizar
local numericas "ingreso educ edad experiencia" // variables numericas que usare para los descriptivos
local controles "educ experiencia" // variables que usare como controles en las regresiones 
local grupos "sector region genero" // grupos que analizare por separado

global umbral = 500000 // valor de ingreso que usare como referencia para hacer un filtro 

* Usare macros locales para guardar datos que ocupare dentro de este do-file
* Usare una macro global para el umbral porque también puede utilizarse en otros do-files
* De esta forma, si necesito cambiar algún dato puedo hacerlo directamente desde esta sección

* --- 2. Cargar y preparar los datos ---

import delimited "`datos'", clear varnames(1) encoding("utf-8") // carga la base de datos usando la ruta que deje guardada al inicio (local datos)

generate experiencia = max(edad - educ - 6, 0) // calcula los años de experiencia, evitando que el resultado sea negativo

label variable experiencia "Experiencia potencial (años)" // agrega una descripción a la variable

generate mujer = (genero == "F") if !missing(genero) // crea una variable que identifica con 1 a las mujeres y con 0 a los hombres

label variable mujer "Mujer (1 = sí)" // agrega una descripción a la variable

label define mujer_etiqueta 0 "Hombre" 1 "Mujer" // define los nombres que tendrá cada valor

label values mujer mujer_etiqueta // asigna los nombres anteriores a la variable mujer

describe, short // muestra cuántas observaciones y variables tiene la base

* La base comenzó con 60 observaciones y 6 variables
* Después de crear experiencia y mujer, quedó con 60 observaciones y 8 variables


* --- 3. Descriptivos de variables numéricas ---

foreach v of local numericas {

    display _newline "===== Descriptivos de `v' =====" // muestra el nombre de la variable que se estan revisando

    summarize `v', detail // muestra información más completa de la variable, como su promedio, mínimo y máximo
}

* Los resultados que se han obtenido son:
* Ingreso: 55 observaciones, promedio de $655.290,9 y mediana de $672.000
* Educación: 60 observaciones, promedio de 12,73 años y mediana de 12,5 años
* Edad: 60 observaciones, promedio de 44,52 años y mediana de 45,5 años
* Experiencia: 60 observaciones, promedio de 25,78 años y mediana de 27 años
* En ingreso hay 5 datos faltantes, por eso se consideran solo 55 observaciones
