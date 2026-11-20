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


* --- 4. Personas segun tramos de educación ---

forvalues t = 4(4)20 {

    quietly count if educ >= `t' & educ < `t' + 4 // cuenta las personas que están dentro de cada tramo de educación

    display "Educación de `t' a " `t' + 3 " años: " r(N) " personas" // muestra cuántas personas hay en cada tramo
}

* Resultados que se obtuvieron: 4 personas tienen entre 4 y 7 años de educación,19 entre 8 y 11 años, 25 entre 12 y 15 años, 10 entre 16 y 19 años y 2 entre 20 y 23 años. En total se consideran las 60 personas de la base.

* --- 5. Programa de descriptivos por grupo ---

capture program drop descriptivos_grupo // elimina el programa anterior si ya existe, para evitar errores al ejecutarlo nuevamente
program define descriptivos_grupo
    display _newline "=== Descriptivos por `1' ===" // muestra el grupo que estamos analizando
    tabulate `1' // muestra cuántas personas hay en cada categoría del grupo
    tabstat ingreso educ, by(`1') statistics(mean sd n) // muestra el promedio, la desviación estándar y la cantidad de datos por grupo
end
* Aplicar el programa a los grupos definidos al inicio

foreach g of local grupos {
    descriptivos_grupo `g' // ejecuta el programa para cada grupo de la lista
}

* Resultados obtenidos por sector:
* Agricultura: 13 personas, ingreso promedio de $447.846 y educación de 12,31 años
* Comercio: 6 personas, ingreso promedio de $523.833 y educación de 11,33 años
* Construcción: 5 personas, ingreso promedio de $520.800 y educación de 10 años
* Educación: 8 personas, ingreso promedio de $908.857 y educación de 16,25 años
* Industria: 11 personas, ingreso promedio de $697.889 y educación de 13,27 años
* Servicios: 17 personas, ingreso promedio de $788.600 y educación de 12,35 años
* Educación presenta el mayor ingreso promedio y Agricultura el menor.
* En algunos sectores hay datos de ingreso faltantes, por eso la cantidad usada para calcular el promedio puede ser menor

* Resultados obtenidos por región:
* Araucanía: 11 personas, ingreso promedio de $638.600 y educación de 12,27 años
* Biobío: 10 personas, ingreso promedio de $633.200 y educación de 12,3 años
* Maule: 12 personas, ingreso promedio de $659.273 y educación de 13,33 años
* Metropolitana: 12 personas, ingreso promedio de $637.636 y educación de 12,92 años.
* Ñuble: 15 personas, ingreso promedio de $696.692 y educación de 12,73 años
* Ñuble presenta el mayor ingreso promedio entre las regiones analizadas
* También aquí hay algunos ingresos faltantes, por lo que los promedios consideran menos observaciones que el total de personas de cada región

* Resultados obtenidos por género:
* Mujeres: 29 personas, ingreso promedio de $636.296 y educación de 12,97 años
* Hombres: 31 personas, ingreso promedio de $673.607 y educación de 12,52 años
* En esta muestra, los hombres presentan un ingreso promedio mayor que las mujeres
* Para calcular los promedios de ingreso se consideran 27 mujeres y 28 hombres, debido a los datos faltantes


* --- 6. Variable temporal para trabajar con ingresos ---

tempvar ing_miles // crea una variable temporal que stata elimina automáticamente cuando termina el do-file

generate `ing_miles' = ingreso / 1000 // convierte los ingresos a miles de pesos

summarize `ing_miles' // muestra un resumen de los ingresos expresados en miles de pesos

* Resultados que se obtuvieron: se consideran 55 observaciones porque hay 5 ingresos faltantes
* El ingreso promedio es de $655,29, la desviación estándar es de $209,91 y el ingreso mínimo es de $180.000 y el máximo de $1.093
* Se utiliza tempvar para que esta variable temporal no quede guardada en la base de datos


* --- 7. Personas con ingresos mayores al umbral ---

count if ingreso > $umbral & !missing(ingreso) // cuenta las personas que tienen ingresos mayores al valor definido al inicio, excluyendo los datos faltantes
* Resultados que se obtuvieron: 41 personas tienen ingresos superiores a $500.000
* Se excluyen los 5 ingresos faltantes, por lo que el conteo considera solo datos disponibles.
* Se utiliza !missing(ingreso) para excluir los ingresos faltantes, sin esta condición, stata podria contar los valores faltantes como si fueran mayores al umbral que utiliza el valor de $500.000 que se definio en los parametros del inicio, porque los considera superiores a cualquier número


* --- 8. Modelos de regresión ---

quietly regress `depvar' `controles' // estima el primer modelo usando ingreso como variable dependiente y educación y experiencia como controles donde los analiza 

estimates store m1 // guarda los resultados del primer modelo

quietly regress `depvar' `controles' i.mujer // estima el segundo modelo agregando el género como variable explicativa, la cual es la variable mujer para considerar las diferencias de ingreso según género

estimates store m2 // guarda los resultados del segundo modelo

estimates table m1 m2, b(%9.0f) se stats(N r2) stfmt(%5.3f) // compara los coeficientes, errores estándar, cantidad de observaciones y R cuadrado de ambos modelos mostrando los resultados de m1 y m2

display "Coeficiente de educación: " _b[educ] // muestra el coeficiente de educación del segundo modelo, ya que el display esta despues de la segunda regresión

* Resultados que se obtuvieron:
* En el modelo 1, educación presenta un coeficiente de $42.019, mientras que en el modelo 2, el coeficiente aumenta a $42.246 al agregar la variable mujer
* Esto quiere decir que un año adicional de educación se relaciona con un ingreso mayor, manteniendo constantes las demas variables
* En el segundo modelo, el coeficiente de mujer es -$55.686, lo que significa un ingreso estimado menor respecto de los hombres
* El R cuadrado aumenta de 0,458 a 0,475, por lo que el segundo modelo explica una proporción ligeramente mayor de las diferencias de ingreso
* Ambos modelos consideran 55 observaciones
* El coeficiente de mujer no es estadísticamente significativo al 5 %, por lo que no se puede afirmar que exista una diferencia significativa de ingresos por género en este modelo



* --- 9. Regresión por sector y exportación de resultados ---

levelsof sector, local(sectores) // obtiene los nombres de los sectores y los guarda en una macro local

local n : word count `sectores' // cuenta cuántos sectores hay

matrix resultados = J(`n', 3, .) // crea una matriz con una fila por sector y tres columnas para guardar los resultados

local i = 1 // indica la primera fila de la matriz

foreach s of local sectores {

    quietly regress ingreso educ if sector == "`s'" // estima la relación entre ingreso y educación para cada sector

    matrix resultados[`i', 1] = _b[educ] // guarda el coeficiente de educación
    matrix resultados[`i', 2] = _se[educ] // guarda el error estándar del coeficiente
    matrix resultados[`i', 3] = e(N) // guarda la cantidad de observaciones utilizadas

    local ++i // pasa a la siguiente fila de la matriz
}

putexcel set "output/tarea_t5_por_sector.xlsx", replace // crea el archivo Excel y reemplaza uno anterior si existe

putexcel A1=("Sector") B1=("Coeficiente educación") C1=("Error estándar") D1=("Observaciones") // escribe los encabezados de las columnas

local i = 2 // indica la segunda fila de Excel, después de los encabezados

foreach s of local sectores {
    putexcel A`i' = ("`s'") // escribe el nombre del sector
    local ++i // pasa a la siguiente fila de Excel
}

putexcel B2 = matrix(resultados) // exporta los resultados de la matriz a Excel

* Resultados que se obtuvieron:
* Se realizaron regresiones para los seis sectores de la base de datos
* Todos los sectores presentan una relación positiva entre educación e ingreso
* Industria presenta el mayor coeficiente de educación, con $42.712,64.
* Construcción presenta el menor coeficiente, con $23.782,61
* Se guardaron los coeficientes de educación, sus errores estándar y la cantidad de observaciones
* Los resultados se exportaron correctamente al archivo Excel tarea_t5_por_sector.xlsx


