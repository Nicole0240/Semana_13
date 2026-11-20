# Semana_13
Tarea T5 Stata - Do-file automatizado - Análisis de datos CASEN en Stata

Autor: Nicole Jara  
Fecha: 19-11-2026
Descripción: Desarrollo de un do-file automatizado en Stata para analizar una base 
de datos CASEN reducida. Se utilizan macros de configuración, ciclos, programas y 
matrices para organizar y automatizar los análisis. Además, se realizan estadísticas 
descriptivas, regresiones y exportación de resultados por sector a un archivo excel.

Base de datos utilizada:casen_reducido.csv, archivo en formato CSV con 60 
observaciones y 6 variables iniciales. Se utilizó el software Stata 18.0.

La tarea incluye:

- Configuración de parámetros mediante macros locales y globales para facilitar 
la modificación de rutas, variables y valores de referencia.
- Importación y preparación de la base de datos mediante import delimited.
- Creación de las variables experiencia y mujer, incluyendo sus etiquetas.
- Estadísticas descriptivas de ingreso, educación, edad y experiencia mediante 
foreach y summarize.
- Distribución de personas según tramos de educación utilizando forvalues y count.
- Creación de un programa para obtener estadísticas descriptivas por sector, región y género.
- Uso de tempvar para crear una variable temporal con los ingresos expresados en miles de pesos.
- Conteo de personas con ingresos superiores a $500.000, excluyendo los valores faltantes.
- Estimación y comparación de dos modelos de regresión, considerando educación, experiencia y género.
- Estimación de regresiones por sector mediante un ciclo, almacenamiento de resultados 
en una matriz con J() y exportación a excel mediante putexcel.
- Interpretación general de los resultados y reconocimiento de las limitaciones del análisis.

Cómo revisar la entrega

- scripts/: contiene el do-file tarea_t5.do, donde se desarrolla la configuración, 
preparación de datos, análisis descriptivo, regresiones y exportación de resultados. (`scripts/tarea_t5.do`)
- data/raw/: contiene la base de datos original casen_reducido.csv. (`data/raw/casen_reducido.csv`)
- output/: contiene el registro de resultados tarea_t5.log, generado al ejecutar el do-file, y el archivo 
excel tarea_t5_por_sector.xlsx, que junta los resultados de las regresiones por sector. 
(output/tarea_t5.log y output/tarea_t5_por_sector.xlsx)

Declaración de autoría humana y uso de tecnologías digitales emergentes

- Herramienta de IA utilizada: ChatGPT
- Para qué se usó: Para aclarar dudas sobre el uso de macros locales y globales, 
ciclos foreach y forvalues, para que era el uso de tempvar, matrices y exportación de 
resultados mediante putexcel. También consulte sobre como manejar los valores faltantes 
en stata y revisión de errores que iba teniendo.
- Qué hice yo: Organicé la estructura y desarrollé el do-file en stata, configuré 
los parámetros, importé y preparé la base de datos, ejecuté los comandos y revisé 
los resultados obtenidos. También elaboré las estadísticas descriptivas, los modelos 
de regresión, las interpretaciones de cada punto y la exportación de resultados por sector. 
Realicé correcciones al código y a sus explicaciones durante el desarrollo de la actividad.
- Verificación: Ejecuté el do-file completo en stata y revisé los resultados 
generados, incluyendo el registro .log y el archivo excel. Confirmo que comprendo 
los comandos utilizados y puedo explicar el procedimiento de automatización, 
análisis e interpretación de los resultados.