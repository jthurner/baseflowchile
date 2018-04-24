CAMELS-CL: Catchment Attributes and Meteorology for Large Sample Studies - Chile Dataset.

CAMELS-CL es una base de datos integrada a escala de cuenca que contiene series diarias hidrológicas, meteorológicas y atributos de 516 cuencas a lo largo de Chile. Los atributos de las cuencas se calculan en base a información de topografía, geología, glaciares, cobertura de suelo y derechos de agua. El detalle de las series de tiempo y de los atributos calculados para cada cuenca se encuentran en Alvarez-Garreton et al., (2018) 

http://www.cr2.cl/recursos-y-publicaciones/bases-de-datos/datos-informacion-integrada-por-cuencas/

Última actualización: Enero 2018
Contacto: Camila Alvarez Garretón - calvarezgarreton@gmail.com
Centro de Ciencia del Clima y la Resiliencia (FONDAP 15110009)
We are doing our best to identify and correct errors. If you find unrealistic/suspicious values, please let us know ASAP. Thank you.


---------------------------------------------------------------------------------------------
REFERENCIA: 

Si Ud. usa estos datos, por favor citar:

Alvarez-Garreton, C., Mendoza, P. A., Boisier, J. P., Addor, N., Galleguillos, M., Zambrano-Bigiarini, M., Lara, A., Puelma, C., Cortes, G., Garreaud, R., McPhee, J., and Ayala, A.: The CAMELS-CL dataset: catchment attributes and meteorology for large sample studies – Chile dataset, Hydrol. Earth Syst. Sci. Discuss., https://doi.org/10.5194/hess-2018-23, in review, 2018.


---------------------------------------------------------------------------------------------
BASE DE DATOS DESCARGABLE: 

1_CAMELScl_attributes.csv:
Archivo que contiene los atributos calculados para cada cuenca (detalles en Alvarez-Garreton et al., 2018). La estructura del archivo consiste en una columna por cada cuenca, y filas que corresponden a los siguientes datos:

- gauge_id: código identificador de la cuenca, corresponde al código BNA de la estación fluviométrica utilizada como outlet en el proceso de delimitación.
- gauge_name: nombre de la estación fluviométrica.
- gauge_lat (° decimales S): latitud de la estación fluviométrica reportada por la DGA.
- gauge_lon (° decimales W): longitud de la estación fluviométrica reportada por la DGA.
- area (km2): calculada en base al polígono del área aportante de la cuenca.  
- elev_gauge (m s.n.m.): altura de la estación fluviométrica (punto de salida de la cuenca), calculada en base a las coordenadas de la estación y el modelo digital de elevación de ASTER GDEM.
- elev_mean (m s.n.m.): altura media de la cuenca, calculada en base al modelo digital de elevación de ASTER GDEM y al polígono del área aportante de la cuenca.
- elev_med (m s.n.m.): altura mediana de la cuenca, calculada en base al modelo digital de elevación de ASTER GDEM 30-m y al polígono del área aportante de la cuenca. Esta altura corresponde al 50% de la distribución de la altura de los pixeles de elevación dentro de la cuenca.
- elev_max (m s.n.m.): altura máxima de la cuenca.
- elev_min (m s.n.m.): altura mínima de la cuenca.
- slope_mean (m km-1): pendiente media de la cuenca.
- nested_inner (-): número de cuencas contenidas dentro de la cuenca gauge_id.
- nested_outer (-): número de cuencas que contienen a la cuenca gauge_id. 
- location_type: clasificación de la cuenca en "coastal", "foothill" y "altiplano", basado en elevaciones del punto de salida (gauge_elev) menores a 50 m a.s.l., entre 1000 and 1200 m a.s.l., y mayor a 3,500 m a.s.l., respectivamente. 
- geol_class_1st: clase geológica más común dentro de la cuenca.
- geol_class_1st_frac (-): fracción de la cuenca asociada a su clase geológica más común.
- geol_class_2nd: segunda clase geológica más común dentro de la cuenca.
- geol_class_2nd_frac (-): fracción de la cuenca asociada a su segunda clase geológica más común.
- carb_rocks_frac: fracción de la cuenca correspondiente a la clase geológica "carbonate sedimentary rocks".
- crop_frac (%): porcentaje de la cuenca cubierto por cultivos (clase 100 del mapa de Zhao et al., 2016).
- nf_frac (%): porcentaje de la cuenca cubierto por bosque nativo (clases 210 y 220).
- fp_frac (%): porcentaje de la cuenca cubierto por plantación forestal (clase 240 y 250).
- grass_frac (%): porcentaje de la cuenca cubierto por pastizales (clase 300).
- shrub_frac (%): porcentaje de la cuenca cubierto por matorrales (clase 400).
- wet_frac (%): porcentaje de la cuenca cubierto por humedales y cuerpos de agua (clases 500 y 600).
- imp_frac (%): porcentaje de la cuenca cubierto por superficies impermeables  y tierras desnudas (clases 800 y 900).
- snow_frac (%): porcentaje de la cuenca cubierto por hielo y nieve (clase 1000).
- forest_frac (%): porcentaje de la cuenca cubierto por superficie arbórea, incluyendo bosque nativo y plantación forestal (nf_frac + fp_frac) 
- fp_nf_index (-): índice de plantación forestal, calculado como fp_frac / (nf_frac + fp_frac)
- dom_land_cover (-): nombre clase dominante dentro de la cuenca.
- dom_land_cover_frac (%): porcentaje de la cuenca cubierto por la clase dominante.
- land_cover_missing (%): porcentaje de la cuenca no cubierto por el mapa de cobertura de suelo de Zhao et al., (2016).
- glaciers_frac (%): porcentaje de la cuenca cubierto por glaciares, según el inventario nacional de glaciares de la DGA.
- p_mean_i (mm/day): precipitación media diaria del producto i (i = 1, 2, 3, 4 for precip1, precip2, precip3 and precip4, respectivamente).
- pet_mean(mm/day): evapotranspiración potencial media diaria sobre la cuenca.
- aridity_i (-): índice de aridez, calculado como la razón entre la evapotranspiración media diaria (pet_mean) y la precipitación media diaria (p_mean_i).
- p_seasonality_i (-): estacionalidad y ocurrencia de la precipitación (producto i). 
- frac_snow_i (-): fracción de la precipitación (producto i) que cae como nieve (i.e., en días con temperaturas medias menores a 0 ◦C).
- high_prec_freq_i (days/year): frecuencia de días de alta precipitación (≥5 veces la precipitación media diaria) para el producto i.
- high_prec_dur_i (days/year): duración promedio de eventos de alta precipitación (número consecutivo de días con precipitación ≥5 veces la precipitación media diaria), para el producto i.
- high_prec_timing_i (days/year): estación cuando ocurren más días de precipitaciones altas (≥ 5 veces la precipitación media diaria), para el producto i.
- low_prec_freq_i (days/year): frecuencia de días de alta precipitación (< 1 mmday−1) para el producto i. 
- low_prec_dur_i (days/year): duración promedio de eventos de alta precipitación (número consecutivo de días con precipitación < 1 mmday−1), para el producto i.
- low_prec_timing_i (days/year): estación cuando ocurren más días de precipitaciones altas (< 1 mmday−1).
- q_mean (mm/day): escorrentía media diaria
- runoff_ratio_i (-): coeficiente de escorrentía, calculado como el cuociente entre escorrentía media diaria y precipitación media diaria (q_mean/p_mean), para el producto i.
- stream_elas_i (-): elasticidad del caudal frente a cambios en precipitación, para producto i de precipitación. 
- slope_fdc (-): pendiente de la curva de duración (entre el percentil 33 y 66 del logaritmo del caudal) 
- baseflow_index (-): índice de flujo base, calculado como el cuociente entre flujo base medio y la escorrentía media. 
- hdf_mean (día del año): fecha del flujo medio, correspondiente a la fecha cuándo la escorrentía acumulada desde el 1ro de abril alcanza la mitad de la escorrentía anual)
- Q5 (mm/day): 5% de probabilidad de no exedencia (flujos bajos).
- Q95 (mm/day): 95% de probabilidad de no exedencia (flujos altos).
- high_q_freq (days/year): frecuencia de días de alta escorrentía (≥ 9 veces la escorrentía media diaria).
- high_q_dur (days): duración promedio de eventos de alta escorrentía (número consecutivo de días con escorrentía ≥9 veces la escorrentía media diaria)
- low_q_freq (days/year):frecuencia de días de baja escorrentía (< 0.2 veces la escorrentía media diaria)
- low_q_dur (days): duración promedio de eventos de alta precipitación (número consecutivo de días con escorrentía < 0.2 veces la escorrentía media diaria)
- zero_q_freq (%): porcentaje de días con escorrentía nula
- snow_ratio (-): cuociente entre el peak de equivalente en agua de nieve y la escorrentía anual.
- sur_rights_n (-): número total de derechos superficiales concedidos dentro de la cuenca (incluye todos los tipos de derechos).
- sur_rights_flow (m3/s): caudal anual de todos los derechos superficiales consuntivos permanente y continuos otorgados dentro de la cuenca.
- interv_degree (-): grado de intervención, calculado como el caudal anual de aguas superficiales otorgado (sur_rights_flow) normalizado por el caudal medio anual de la cuenca.
- gw_rights_n (-): número total de derechos de aguas subterráneas concedidos dentro de la cuenca (incluye todos los tipos de derechos).
- gw_rights_flow (m3/s): caudal anual de todos los derechos de aguas subterráneas consuntivos permanente y continuos otorgados dentro de la cuenca.



---------------------------------------------------------------------------------------------
2) CAMELScl_streamflow_m3s.csv:
Archivo que contiene el caudal medio diario (m3/s) observado para cada estación fluviométrica (el caudal se obtiene de la recopilación efectuada por el Centro de Ciencia del Clima y la Resiliencia, CR2, que contiene registros de la Dirección General de Aguas y la Dirección Meteorológica (http://www.cr2.cl/recursos-y-publicaciones/bases-de-datos/datos-de-caudales/). La estructura del archivo consiste en una columna por cada cuenca, y filas que corresponden a los siguientes datos:

- gauge_id: código identificador de la cuenca, corresponde al código BNA de la estación fluviométrica utilizada como outlet en el proceso de delimitación.
- gauge_name: nombre de la estación fluviométrica.
- gauge_lat (° decimales S): latitud de la estación fluviométrica reportada por la DGA.
- gauge_lon (° decimales W): longitud de la estación fluviométrica reportada por la DGA.
- area (km2): calculada en base al polígono del área aportante de la cuenca.  
- elev_gauge (m s.n.m.): altura de la estación fluviométrica (punto de salida de la cuenca), calculada en base a las coordenadas de la estación y el modelo digital de elevación de ASTER GDEM.
- elev_mean (m s.n.m.): altura media de la cuenca, calculada en base al modelo digital de elevación de ASTER GDEM y al polígono del área aportante de la cuenca.
- start_obs: fecha de comienzo de observaciones 
- Las siguientes filas contienen las mediciones observadas (m3/s) por día.



---------------------------------------------------------------------------------------------
3) CAMELScl_streamflow_mm.csv:
Archivo que contiene la escorrentía medio diario (mm/día) calculada para cada cuenca a partir del caudal observado normalizado por el área calculada para cada cuenca (detalles en Alvarez-Garreton et al., 2018). La estructura del archivo consiste en una columna por cada cuenca, y filas que corresponden a los siguientes datos:

- gauge_id: código identificador de la cuenca, corresponde al código BNA de la estación fluviométrica utilizada como outlet en el proceso de delimitación.
- gauge_name: nombre de la estación fluviométrica.
- gauge_lat (° decimales S): latitud de la estación fluviométrica reportada por la DGA.
- gauge_lon (° decimales W): longitud de la estación fluviométrica reportada por la DGA.
- area (km2): calculada en base al polígono del área aportante de la cuenca.  
- elev_gauge (m s.n.m.): altura de la estación fluviométrica (punto de salida de la cuenca), calculada en base a las coordenadas de la estación y el modelo digital de elevación de ASTER GDEM.
- elev_mean (m s.n.m.): altura media de la cuenca, calculada en base al modelo digital de elevación de ASTER GDEM y al polígono del área aportante de la cuenca.
- start_obs: fecha de comienzo de observaciones 
- Las siguientes filas contienen la escorrentía calculada por cuenca (mm/día).



---------------------------------------------------------------------------------------------
4) CAMELScl_precip_cr2met.csv:
Archivo que contiene la precipitación media diaria sobre la cuenca (mm/día), la cual se obtiene de los datos grillados CR2MET (detalles en Alvarez-Garreton et al., 2018). La estructura del archivo consiste en una columna por cada cuenca, y filas que corresponden a los siguientes datos:

- gauge_id: código identificador de la cuenca, corresponde al código BNA de la estación fluviométrica utilizada como outlet en el proceso de delimitación.
- gauge_name: nombre de la estación fluviométrica.
- gauge_lat (° decimales S): latitud de la estación fluviométrica reportada por la DGA.
- gauge_lon (° decimales W): longitud de la estación fluviométrica reportada por la DGA.
- area (km2): calculada en base al polígono del área aportante de la cuenca.  
- elev_gauge (m s.n.m.): altura de la estación fluviométrica (punto de salida de la cuenca), calculada en base a las coordenadas de la estación y el modelo digital de elevación de ASTER GDEM.
- elev_mean (m s.n.m.): altura media de la cuenca, calculada en base al modelo digital de elevación de ASTER GDEM y al polígono del área aportante de la cuenca.
- start_obs: fecha de comienzo de observaciones 
- Las siguientes filas contienen la precipitación media diaria por cuenca (mm/día).



---------------------------------------------------------------------------------------------
5) CAMELScl_precip_chirps.csv:
Archivo que contiene la precipitación media diaria sobre la cuenca (mm/día), la cual se obtiene de los datos satelitales Climate Hazards Group InfraRed Precipitation with Station data (CHIRPS) version 2 dataset (detalles en Alvarez-Garreton et al., 2018). La estructura del archivo consiste en una columna por cada cuenca, y filas que corresponden a los siguientes datos:

- gauge_id: código identificador de la cuenca, corresponde al código BNA de la estación fluviométrica utilizada como outlet en el proceso de delimitación.
- gauge_name: nombre de la estación fluviométrica.
- gauge_lat (° decimales S): latitud de la estación fluviométrica reportada por la DGA.
- gauge_lon (° decimales W): longitud de la estación fluviométrica reportada por la DGA.
- area (km2): calculada en base al polígono del área aportante de la cuenca.  
- elev_gauge (m s.n.m.): altura de la estación fluviométrica (punto de salida de la cuenca), calculada en base a las coordenadas de la estación y el modelo digital de elevación de ASTER GDEM.
- elev_mean (m s.n.m.): altura media de la cuenca, calculada en base al modelo digital de elevación de ASTER GDEM y al polígono del área aportante de la cuenca.
- start_obs: fecha de comienzo de observaciones 
- Las siguientes filas contienen la precipitación media diaria por cuenca (mm/día).



---------------------------------------------------------------------------------------------
6) CAMELScl_precip_mswep.csv:
Archivo que contiene la precipitación media diaria sobre la cuenca (mm/día), la cual se obtiene de los datos satelitales Multi-Source Weighted-Ensemble Precipitation (MSWEP) v1.1 dataset (detalles en Alvarez-Garreton et al., 2018). La estructura del archivo consiste en una columna por cada cuenca, y filas que corresponden a los siguientes datos:

- gauge_id: código identificador de la cuenca, corresponde al código BNA de la estación fluviométrica utilizada como outlet en el proceso de delimitación.
- gauge_name: nombre de la estación fluviométrica.
- gauge_lat (° decimales S): latitud de la estación fluviométrica reportada por la DGA.
- gauge_lon (° decimales W): longitud de la estación fluviométrica reportada por la DGA.
- area (km2): calculada en base al polígono del área aportante de la cuenca.  
- elev_gauge (m s.n.m.): altura de la estación fluviométrica (punto de salida de la cuenca), calculada en base a las coordenadas de la estación y el modelo digital de elevación de ASTER GDEM.
- elev_mean (m s.n.m.): altura media de la cuenca, calculada en base al modelo digital de elevación de ASTER GDEM y al polígono del área aportante de la cuenca.
- start_obs: fecha de comienzo de observaciones 
- Las siguientes filas contienen la precipitación media diaria por cuenca (mm/día).



---------------------------------------------------------------------------------------------
7) CAMELScl_precip_mswep.csv:
Archivo que contiene la precipitación media diaria sobre la cuenca (mm/día), la cual se obtiene de los datos satelitales Multi-Source Weighted-Ensemble Precipitation (MSWEP) v1.1 dataset (detalles en Alvarez-Garreton et al., 2018). La estructura del archivo consiste en una columna por cada cuenca, y filas que corresponden a los siguientes datos:

- gauge_id: código identificador de la cuenca, corresponde al código BNA de la estación fluviométrica utilizada como outlet en el proceso de delimitación.
- gauge_name: nombre de la estación fluviométrica.
- gauge_lat (° decimales S): latitud de la estación fluviométrica reportada por la DGA.
- gauge_lon (° decimales W): longitud de la estación fluviométrica reportada por la DGA.
- area (km2): calculada en base al polígono del área aportante de la cuenca.  
- elev_gauge (m s.n.m.): altura de la estación fluviométrica (punto de salida de la cuenca), calculada en base a las coordenadas de la estación y el modelo digital de elevación de ASTER GDEM.
- elev_mean (m s.n.m.): altura media de la cuenca, calculada en base al modelo digital de elevación de ASTER GDEM y al polígono del área aportante de la cuenca.
- start_obs: fecha de comienzo de observaciones 
- Las siguientes filas contienen la precipitación media diaria por cuenca (mm/día).



---------------------------------------------------------------------------------------------
8) CAMELScl_tmin_cr2met.csv:
Archivo que contiene la temperatura mínima diaria sobre la cuenca (ºC), la cual se obtiene de los datos grillados CR2MET (detalles en Alvarez-Garreton et al., 2018). La estructura del archivo consiste en una columna por cada cuenca, y filas que corresponden a los siguientes datos:

- gauge_id: código identificador de la cuenca, corresponde al código BNA de la estación fluviométrica utilizada como outlet en el proceso de delimitación.
- gauge_name: nombre de la estación fluviométrica.
- gauge_lat (° decimales S): latitud de la estación fluviométrica reportada por la DGA.
- gauge_lon (° decimales W): longitud de la estación fluviométrica reportada por la DGA.
- area (km2): calculada en base al polígono del área aportante de la cuenca.  
- elev_gauge (m s.n.m.): altura de la estación fluviométrica (punto de salida de la cuenca), calculada en base a las coordenadas de la estación y el modelo digital de elevación de ASTER GDEM.
- elev_mean (m s.n.m.): altura media de la cuenca, calculada en base al modelo digital de elevación de ASTER GDEM y al polígono del área aportante de la cuenca.
- start_obs: fecha de comienzo de observaciones 
- Las siguientes filas contienen la temperatura mínima diaria por cuenca (ºC).



---------------------------------------------------------------------------------------------
9) CAMELScl_tmax_cr2met.csv:
Archivo que contiene la temperatura máxima diaria sobre la cuenca (ºC), la cual se obtiene de los datos grillados CR2MET (detalles en Alvarez-Garreton et al., 2018). La estructura del archivo consiste en una columna por cada cuenca, y filas que corresponden a los siguientes datos:

- gauge_id: código identificador de la cuenca, corresponde al código BNA de la estación fluviométrica utilizada como outlet en el proceso de delimitación.
- gauge_name: nombre de la estación fluviométrica.
- gauge_lat (° decimales S): latitud de la estación fluviométrica reportada por la DGA.
- gauge_lon (° decimales W): longitud de la estación fluviométrica reportada por la DGA.
- area (km2): calculada en base al polígono del área aportante de la cuenca.  
- elev_gauge (m s.n.m.): altura de la estación fluviométrica (punto de salida de la cuenca), calculada en base a las coordenadas de la estación y el modelo digital de elevación de ASTER GDEM.
- elev_mean (m s.n.m.): altura media de la cuenca, calculada en base al modelo digital de elevación de ASTER GDEM y al polígono del área aportante de la cuenca.
- start_obs: fecha de comienzo de observaciones 
- Las siguientes filas contienen la temperatura máxima diaria por cuenca (ºC).



---------------------------------------------------------------------------------------------
10) CAMELScl_pet_8d_modis.csv:
Archivo que contiene la evapotranspiración potencial acumulada a 8 días (mm/8 días), la cual se se obtiene del producto MODIS (detalles en Alvarez-Garreton et al., 2018). La estructura del archivo consiste en una columna por cada cuenca, y filas que corresponden a los siguientes datos:

- gauge_id: código identificador de la cuenca, corresponde al código BNA de la estación fluviométrica utilizada como outlet en el proceso de delimitación.
- gauge_name: nombre de la estación fluviométrica.
- gauge_lat (° decimales S): latitud de la estación fluviométrica reportada por la DGA.
- gauge_lon (° decimales W): longitud de la estación fluviométrica reportada por la DGA.
- area (km2): calculada en base al polígono del área aportante de la cuenca.  
- elev_gauge (m s.n.m.): altura de la estación fluviométrica (punto de salida de la cuenca), calculada en base a las coordenadas de la estación y el modelo digital de elevación de ASTER GDEM.
- elev_mean (m s.n.m.): altura media de la cuenca, calculada en base al modelo digital de elevación de ASTER GDEM y al polígono del área aportante de la cuenca.
- start_obs: fecha de comienzo de observaciones 
- Las siguientes filas contienen la evapotranspiración potencial (mm/8d) sobre la cuenca (hay datos cada 8 días, y corresponden a la evapotranspiración acumulada de los últimos 8 días).



---------------------------------------------------------------------------------------------
11) CAMELScl_pet_hargreaves.csv:
Archivo que contiene la evapotranspiración potencial diaria (mm/día) sobre la cuenca, la cual se obtiene utilizando las fórmulas de Hargreaves and Samani (1985) (detalles en Alvarez-Garreton et al., 2018). La estructura del archivo consiste en una columna por cada cuenca, y filas que corresponden a los siguientes datos:

- gauge_id: código identificador de la cuenca, corresponde al código BNA de la estación fluviométrica utilizada como outlet en el proceso de delimitación.
- gauge_name: nombre de la estación fluviométrica.
- gauge_lat (° decimales S): latitud de la estación fluviométrica reportada por la DGA.
- gauge_lon (° decimales W): longitud de la estación fluviométrica reportada por la DGA.
- area (km2): calculada en base al polígono del área aportante de la cuenca.  
- elev_gauge (m s.n.m.): altura de la estación fluviométrica (punto de salida de la cuenca), calculada en base a las coordenadas de la estación y el modelo digital de elevación de ASTER GDEM.
- elev_mean (m s.n.m.): altura media de la cuenca, calculada en base al modelo digital de elevación de ASTER GDEM y al polígono del área aportante de la cuenca.
- start_obs: fecha de comienzo de observaciones 
- Las siguientes filas contienen la evapotranspiración potencial (mm/d) sobre la cuenca.



---------------------------------------------------------------------------------------------
12) CAMELScl_swe.csv:
Archivo que contiene el equivalente en agua de nieve diario (m/día), que se obtiene del producto UCLA SWE Reanalysis (Cortes y Margulis, 2016) (detalles en Alvarez-Garreton et al., 2018). La estructura del archivo consiste en una columna por cada cuenca, y filas que corresponden a los siguientes datos:

- gauge_id: código identificador de la cuenca, corresponde al código BNA de la estación fluviométrica utilizada como outlet en el proceso de delimitación.
- gauge_name: nombre de la estación fluviométrica.
- gauge_lat (° decimales S): latitud de la estación fluviométrica reportada por la DGA.
- gauge_lon (° decimales W): longitud de la estación fluviométrica reportada por la DGA.
- area (km2): calculada en base al polígono del área aportante de la cuenca.  
- elev_gauge (m s.n.m.): altura de la estación fluviométrica (punto de salida de la cuenca), calculada en base a las coordenadas de la estación y el modelo digital de elevación de ASTER GDEM.
- elev_mean (m s.n.m.): altura media de la cuenca, calculada en base al modelo digital de elevación de ASTER GDEM y al polígono del área aportante de la cuenca.
- start_obs: fecha de comienzo de observaciones 
- Las siguientes filas contienen el equivalente en agua de nieve (m/d) sobre la cuenca.



---------------------------------------------------------------------------------------------
13) CAMELScl_catch_hierarchy.csv:
Archivo que contiene una matriz (516 x 516) lógica (con valores 1 y 0) que indica la anidación de las cuencas. 
La primera columna contiene 516 filas con los códigos de las cuencas de CAMELS-CL. Las 516 columnas (una columna por cuenca). La celda (fila i, columna j) tiene un valor 1 si la cuenca de la fila i está contenida en la cuenca de la columna j, y un valor de 0 en caso contrario.  



---------------------------------------------------------------------------------------------
AGRADECIMIENTOS:

This research emerged from the collaboration with many colleagues at the Center for Climate and Resilience Research (CR2, CONICYT/FONDAP/15110009). Camila Alvarez-Garreton is funded by FONDECYT Postdoctoral Grant N°3170428. Pablo Mendoza received additional support from FONDECYT Postdoctoral Grant N° 3170079. Mauricio Zambrano-Bigiarini thanks FONDECYT 11150861 for financial support.



---------------------------------------------------------------------------------------------
BIBLIOGRAFIA:

Cortés, G. and Margulis, S. (2017) ‘Impacts of El Niño and La Niña on interannual snow accumulation in the Andes: Results from a high-resolution 31 year reanalysis’, Geophysical Research Letters, pp. 1–9. doi: 10.1002/2017GL073826.
Hargreaves, G. H. and Samani, Z. a. (1985) ‘Reference crop evapotranspiration from temperature’, Applied Engineering in Agriculture, 1(2), pp. 96–99. doi: 10.13031/2013.26773.
Zhao, Y., Feng, D., Yu, L., Wang, X., Chen, Y., Bai, Y., Hernández, H. J., Galleguillos, M., Estades, C., Biging, G. S., Radke, J. D. and Gong, P. (2016) ‘Detailed dynamic land cover mapping of Chile: Accuracy improvement by integrating multi-temporal data’, Remote Sensing of Environment, 183, pp. 170–185. doi: 10.1016/j.rse.2016.05.016.
