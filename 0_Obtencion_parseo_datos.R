# EN ESTA CLASE SE DETALLA LA SIMULACIÓN REALIZA PARA EL MUNDIAL DE RUSIA 2018.

# LIBRERIAS UTILIZADAS DURANTE EL DESARROLLO
library("readxl")
library("sqldf")
library("XLConnect")


# 1.1 - CARGAMOS EN UN EXCEL EL LISTADO DE LOS EQUIPOS PARTICIPANTES Y AL GRUPO AL QUE HAN SIDO ASIGNADOS EN EL MUNDIAL. 
  # Equipo -> Descripción de las selecciones.
  # Grupo -> Identificativo del grupo asignado en la fase de grupos.
equipos_grupos <- read_excel("C://Users/e048253/Desktop/WORLD_CUP/EQUIPOS_GRUPO.xlsx")

# 1.2 - CARGAMOS DE UN EXCEL INFORMACION DE LOS EQUIPOS
  # Equipo -> Descripción de las selecciones.
  # Experencia_Mundiales -> Indicador con el número de participaciones en mundiales.
  # Valor_Mercado -> Suma del valor de mercado de los jugadores.
  # Campeonatos_Ganados -> Indicador con el número de mundiales ganados.
equipos_informacion <- read_excel("C://Users/e048253/Desktop/WORLD_CUP/INFORMACION_EQUIPOS.xlsx")

# ELIMINAMOS N/A DE LA SUBIDA
equipos_informacion[is.na(equipos_informacion)] <- 0

# 1.3 - CARGAMOS DE UN EXCEL LOS RESULTADOS HISTORICOS
resultados_historicos <- read_excel("C://Users/e048253/Desktop/WORLD_CUP/RESULTADO_HISTORICOS.xlsx")

# 1.4 - CARGAMOS DE UN EXCEL LA PLANTILLA PARA LA TABLA DE LOS RESULTADO HISTORICOS
resultados_historicos_plantilla <- read_excel("C://Users/e048253/Desktop/WORLD_CUP/BASE_RESULTADOS.xlsx")

# 1.5 - CARGAMOS TABLA PUNTUACIONES SELECCIONES
puntuaciones <- read_excel("C://Users/e048253/Desktop/WORLD_CUP/T1_FIFA_Puntuaciones.xlsx")

# 2 - INICIALIZAMOS LAS VARIBALES DE PUNTOS Y DE GOLAVERAGE DEL LOS EQUIPOS.
equipos_grupos$PUNTOS <- 0
equipos_grupos$GA <- 0

# 3 - MODIFICAMOS LA TABLA DE RESULTADOS HISTORICOS
mundial_local <- sqldf("select a.EQUIPO_1 as EQUIPO_MUNDIAL, a.EQUIPO_2 as RIVAL, RESULTADO_EQUIPO_1 as RESULTADO, RANKING_2 as RANKING_RIVAL, a.ANIO from resultados_historicos as a join (select * from equipos_grupos) as b on (a.EQUIPO_1=b.EQUIPO) order by EQUIPO_MUNDIAL")
mundial_visitante <- sqldf("select a.EQUIPO_2 as EQUIPO_MUNDIAL, a.EQUIPO_1 as RIVAL, RESULTADO_EQUIPO_2 as RESULTADO, RANKING_1 as RANKING_RIVAL, a.ANIO from resultados_historicos as a join (select * from equipos_grupos) as b on (a.EQUIPO_2=b.EQUIPO) order by EQUIPO_MUNDIAL")
resultados <- sqldf("select * from mundial_local union all select * from mundial_visitante order by EQUIPO_MUNDIAL")
resultados_1_10 <- sqldf("select EQUIPO_MUNDIAL, RESULTADO, count(*) as contador from resultados where RANKING_RIVAL>=1 AND RANKING_RIVAL<=10 group by EQUIPO_MUNDIAL, RESULTADO ")
resultados_1_10$trancha <- 1
resultados_10_20 <- sqldf("select EQUIPO_MUNDIAL, RESULTADO, count(*) as contador from resultados where RANKING_RIVAL>10 AND RANKING_RIVAL<=30 group by EQUIPO_MUNDIAL, RESULTADO ")
resultados_10_20$trancha <- 2
resultados_20_50 <- sqldf("select EQUIPO_MUNDIAL, RESULTADO, count(*) as contador from resultados where RANKING_RIVAL>31 AND RANKING_RIVAL<=50 group by EQUIPO_MUNDIAL, RESULTADO ")
resultados_20_50$trancha <- 3
resultados_50_100 <- sqldf("select EQUIPO_MUNDIAL, RESULTADO, count(*) as contador from resultados where RANKING_RIVAL>51 AND RANKING_RIVAL<=100 group by EQUIPO_MUNDIAL, RESULTADO ")
resultados_50_100$trancha <- 4
resultados_100 <- sqldf("select EQUIPO_MUNDIAL, RESULTADO, count(*) as contador from resultados where RANKING_RIVAL>100 group by EQUIPO_MUNDIAL, RESULTADO ")
resultados_100$trancha <- 5

resultados_historicos_plantilla_1 <- sqldf("select a.EQUIPO as EQUIPO_MUNDIAL, A.RESULTADO as RESULTADO, A.TRANCHA as TRANCHA, B.CONTADOR AS CONTADOR from resultados_historicos_plantilla as A
                                         left join (select * from resultados_1_10) as B
                                         on (a.EQUIPO = b.EQUIPO_MUNDIAL and A.RESULTADO= B.RESULTADO and A.TRANCHA=B.TRANCHA)
                                         where a.TRANCHA = 1")

resultados_historicos_plantilla_2 <- sqldf("select a.EQUIPO as EQUIPO_MUNDIAL, A.RESULTADO as RESULTADO, A.TRANCHA as TRANCHA, B.CONTADOR AS CONTADOR from resultados_historicos_plantilla as A
                                         left join (select * from resultados_10_20) as B
                                           on (a.EQUIPO = b.EQUIPO_MUNDIAL and A.RESULTADO= B.RESULTADO and A.TRANCHA=B.TRANCHA)
                                           where a.TRANCHA = 2")

resultados_historicos_plantilla_3 <- sqldf("select a.EQUIPO as EQUIPO_MUNDIAL, A.RESULTADO as RESULTADO, A.TRANCHA as TRANCHA, B.CONTADOR AS CONTADOR from resultados_historicos_plantilla as A
                                         left join (select * from resultados_20_50) as B
                                         on (a.EQUIPO = b.EQUIPO_MUNDIAL and A.RESULTADO= B.RESULTADO and A.TRANCHA=B.TRANCHA)
                                         where a.TRANCHA = 3")

resultados_historicos_plantilla_4 <- sqldf("select a.EQUIPO as EQUIPO_MUNDIAL, A.RESULTADO as RESULTADO, A.TRANCHA as TRANCHA, B.CONTADOR AS CONTADOR from resultados_historicos_plantilla as A
                                         left join (select * from resultados_50_100) as B
                                           on (a.EQUIPO = b.EQUIPO_MUNDIAL and A.RESULTADO= B.RESULTADO and A.TRANCHA=B.TRANCHA)
                                           where a.TRANCHA = 4")

resultados_historicos_plantilla_5 <- sqldf("select a.EQUIPO as EQUIPO_MUNDIAL, A.RESULTADO as RESULTADO, A.TRANCHA as TRANCHA, B.CONTADOR AS CONTADOR from resultados_historicos_plantilla as A
                                         left join (select * from resultados_100) as B
                                           on (a.EQUIPO = b.EQUIPO_MUNDIAL and A.RESULTADO= B.RESULTADO and A.TRANCHA=B.TRANCHA)
                                           where a.TRANCHA = 5")

resultados_historicos_plantilla <- sqldf("select * from resultados_historicos_plantilla_1 
                                          union all select * from resultados_historicos_plantilla_2
                                          union all select * from resultados_historicos_plantilla_3
                                          union all select * from resultados_historicos_plantilla_4
                                          union all select * from resultados_historicos_plantilla_5
                                          order by EQUIPO_MUNDIAL")

resultados_historicos_plantilla[is.na(resultados_historicos_plantilla)] <- 0


resultados_historicos_plantilla_1 <- sqldf("select distinct a.equipo_mundial as EQUIPO_MUNDIAL, a.trancha as TRANCHA, b.contador as GANA, c.contador as EMPATA, d.contador as PIERDE 
                                           from resultados_historicos_plantilla as a
                                           join (select * from resultados_historicos_plantilla where resultado='GANA') as b
                                           on(a.equipo_mundial = b.equipo_mundial and a.trancha = b.trancha)
                                           join (select * from resultados_historicos_plantilla where resultado='EMPATA') as c 
                                           on(a.equipo_mundial = c.equipo_mundial and a.trancha = c.trancha)
                                           join (select * from resultados_historicos_plantilla where resultado='PIERDE') as d 
                                           on(a.equipo_mundial = d.equipo_mundial and a.trancha = d.trancha)")

resultados_historicos_plantilla_2 <- sqldf("select EQUIPO_MUNDIAL, TRANCHA, GANA, EMPATA, PIERDE, (GANA + EMPATA + PIERDE) as TOTAL
                                           from resultados_historicos_plantilla_1")


resultados_historicos_plantilla_2$POR_GANA <- resultados_historicos_plantilla_2$GANA / resultados_historicos_plantilla_2$TOTAL 
resultados_historicos_plantilla_2$POR_EMPATA <- resultados_historicos_plantilla_2$EMPATA / resultados_historicos_plantilla_2$TOTAL 
resultados_historicos_plantilla_2$POR_PIERDE <- resultados_historicos_plantilla_2$PIERDE / resultados_historicos_plantilla_2$TOTAL 

# CREAMOS TABLA ENTRENAMIENTO
resultados_puntuaciones_1 <- sqldf("select a.ANIO AS ANIO, A.EQUIPO_1 AS EQUIPO_1, B.Punt_Ataque AS ATAQUE_1, B.Punt_Med AS MEDIA_1, B.Punt_Def AS DEF_1,
                                    A.EQUIPO_2 AS EQUIPO_2, A.RES_1 AS RES_1, A.RES_2 AS RES_2, A.TIPO AS TIPO
                                    from resultados_historicos as a
                                    left join (select * from puntuaciones) as b
                                    on (A.EQUIPO_1 = B.COUNTRY)
                                    WHERE B.Punt_Ataque IS NOT NULL")

resultados_puntuaciones_2 <- sqldf("select a.ANIO AS ANIO, A.EQUIPO_1 AS EQUIPO_1, A.ATAQUE_1 as ATAQUE_1, A.MEDIA_1 as MEDIA_1, A.DEF_1 as DEF_1,
                                    A.EQUIPO_2 AS EQUIPO_2, A.RES_1 AS RES_1, A.RES_2 AS RES_2, B.Punt_Ataque AS ATAQUE_2, B.Punt_Med AS MEDIA_2, B.Punt_Def AS DEF_2, A.TIPO AS TIPO
                                   from resultados_puntuaciones_1 as a
                                   left join (select * from puntuaciones) as b
                                   on (A.EQUIPO_2 = B.COUNTRY)
                                   WHERE B.Punt_Ataque IS NOT NULL")


resultados_puntuaciones_2$RES_1 <- as.numeric(resultados_puntuaciones_2$RES_1)
resultados_puntuaciones_2$RES_2 <- as.numeric(resultados_puntuaciones_2$RES_2)


for (i in 1:nrow(resultados_puntuaciones_2)){
  if(resultados_puntuaciones_2$RES_1[i]>resultados_puntuaciones_2$RES_2[i]){
    resultados_puntuaciones_2$RESULTADO[i] <- 1
  }else if (resultados_puntuaciones_2$RES_1[i]<resultados_puntuaciones_2$RES_2[i]){
    resultados_puntuaciones_2$RESULTADO[i] <- -1
  }else{
    resultados_puntuaciones_2$RESULTADO[i] <- 0
  }
}

resultados_puntuaciones_3 <- sqldf("select distinct a.*, b.RANKING_1 as RANKING_1 from resultados_puntuaciones_2 as a
                                   join (select * from resultados_historicos) as b
                                   on (a.anio=b.anio and a.equipo_1=b.equipo_1)")

resultados_puntuaciones_4 <- sqldf("select distinct a.*, b.RANKING_2 as RANKING_2 from resultados_puntuaciones_3 as a
                                   join (select * from resultados_historicos) as b
                                   on (a.anio=b.anio and a.equipo_2=b.equipo_2)")

for (i in 1:nrow(resultados_puntuaciones_4)){
  if(resultados_puntuaciones_4$RANKING_1[i]<= 10){
    resultados_puntuaciones_4$TRANCHA_1[i] <- 1
  }else if (resultados_puntuaciones_4$RANKING_1[i]> 10 & resultados_puntuaciones_4$RANKING_1[i]<= 20){
    resultados_puntuaciones_4$TRANCHA_1[i] <- 2
  }else if (resultados_puntuaciones_4$RANKING_1[i]> 20 & resultados_puntuaciones_4$RANKING_1[i]<= 50){
    resultados_puntuaciones_4$TRANCHA_1[i] <- 3
  }else if (resultados_puntuaciones_4$RANKING_1[i]> 50 & resultados_puntuaciones_4$RANKING_1[i]<= 100){
    resultados_puntuaciones_4$TRANCHA_1[i] <- 4
  }else if (resultados_puntuaciones_4$RANKING_1[i]> 100){
    resultados_puntuaciones_4$TRANCHA_1[i] <- 5
  }
}

for (i in 1:nrow(resultados_puntuaciones_4)){
  if(resultados_puntuaciones_4$RANKING_2[i]<= 10){
    resultados_puntuaciones_4$TRANCHA_2[i] <- 1
  }else if (resultados_puntuaciones_4$RANKING_2[i]> 10 & resultados_puntuaciones_4$RANKING_2[i]<= 20){
    resultados_puntuaciones_4$TRANCHA_2[i] <- 2
  }else if (resultados_puntuaciones_4$RANKING_2[i]> 20 & resultados_puntuaciones_4$RANKING_2[i]<= 50){
    resultados_puntuaciones_4$TRANCHA_2[i] <- 3
  }else if (resultados_puntuaciones_4$RANKING_2[i]> 50 & resultados_puntuaciones_4$RANKING_2[i]<= 100){
    resultados_puntuaciones_4$TRANCHA_2[i] <- 4
  }else if (resultados_puntuaciones_4$RANKING_2[i]> 100){
    resultados_puntuaciones_4$TRANCHA_2[i] <- 5
  }
}

resultados_puntuaciones_5 <- sqldf("select A.ANIO AS ANIO, A.EQUIPO_1 AS EQUIPO_1, A.RANKING_1 AS RANKING_1, A.TRANCHA_1 AS TRANCHA_1, A.ATAQUE_1 AS ATAQUE_1, A.MEDIA_1 AS MEDIA_1, A.DEF_1 AS DEF_1,
                                   A.RES_1 AS RES_1, A.RES_2 AS RES_2, A.EQUIPO_2 AS EQUIPO_2, A.RANKING_2 AS RANKING_2, A.TRANCHA_2 AS TRANCHA_2, A.ATAQUE_2 AS ATAQUE_2, A.MEDIA_2 AS MEDIA_2, A.DEF_2 AS DEF_2,
                                   A.TIPO AS TIPO, A.RESULTADO AS RESULTADO, B.POR_GANA AS POR_GANA_1, B.POR_PIERDE AS POR_PIERDE_1, C.POR_GANA AS POR_GANA_2, C.POR_PIERDE AS POR_PIERDE_2
                                   FROM resultados_puntuaciones_4 as a
                                   join (select * from resultados_historicos_plantilla_2) as b on (B.EQUIPO_MUNDIAL = A.EQUIPO_1 AND B.TRANCHA = A.TRANCHA_2)
                                   join (select * from resultados_historicos_plantilla_2) as c on (C.EQUIPO_MUNDIAL = A.EQUIPO_2 AND C.TRANCHA = A.TRANCHA_1)")

wb <- loadWorkbook("ENTRENAMIENTO.xlsx", create = TRUE)
createSheet(wb, name = "PARTIDOS")
writeWorksheet(wb, resultados_puntuaciones_4, sheet = "PARTIDOS", startRow = 1, startCol = 1)
saveWorkbook(wb)



# 3 - GENERAMOS UN MÉTODO EN EL QUE DESPUÉS DE CADA PARTIDO SIMULADO ACTUALICE LA INFORMACIÓN DE LOS EQUIPOS EN LA TABLA.
  # Equipo1 -> Descripción del equipo local en el partido
  # Equipo2 -> Descripción del equipo local en el partido
  # Ga -> Golaverge del partido, se toma el valor respecto al equipo local. Ejemplo: Un golaverge negativo en el partido, significa que el Equipo2
  # ha ganado.
actualizarResultado<-function(equipo1, equipo2, ga){
  if (ga>0){
    
  }else{
    
  }
  
}

# GENERAMOS LAS TABLAS ACTUALIZADAS PARA CADA UNO DE LOS GRUPOS
grupoA <- sqldf("select * from equipos_grupos where GRUPO='A' order by PUNTOS, GA DESC")
grupoB <- sqldf("select * from equipos_grupos where GRUPO='B' order by PUNTOS, GA DESC")
grupoC <- sqldf("select * from equipos_grupos where GRUPO='C' order by PUNTOS, GA DESC")
grupoD <- sqldf("select * from equipos_grupos where GRUPO='D' order by PUNTOS, GA DESC")
grupoE <- sqldf("select * from equipos_grupos where GRUPO='E' order by PUNTOS, GA DESC")
grupoF <- sqldf("select * from equipos_grupos where GRUPO='F' order by PUNTOS, GA DESC")
grupoG <- sqldf("select * from equipos_grupos where GRUPO='G' order by PUNTOS, GA DESC")
grupoH <- sqldf("select * from equipos_grupos where GRUPO='H' order by PUNTOS, GA DESC")

# CALCULAMOS EL EQUIPOS QUE HA QUEDADO EL ÚLTIMA POSICIÓN (32)
equipos_liguilla <- rbind(grupoA[3,], grupoA[4,],
                          grupoB[3,], grupoB[4,],
                          grupoC[3,], grupoC[4,],
                          grupoD[3,], grupoD[4,],
                          grupoE[3,], grupoE[4,],
                          grupoF[3,], grupoF[4,],
                          grupoG[3,], grupoG[4,],
                          grupoH[3,], grupoH[4,])
equipos_liguilla <- sqldf("select * from equipos_liguilla order by PUNTOS desc, GA des")

# MOSTRAMOS POR PANTALLA EL ÚLTIMO CLASIFICADO
print(paste0("EQUIPO QUE QUEDA EN EL ÚLTIMA POSICION ", equipos_liguilla[1,1]))

# GENERAMOS EL CUADRO DE CUARTOS DE FINAL

