# Modelo de predicción del mundial de fútbol en Rusia 2018

# 1. Introducción

Este modelo ha sido desarrollado por Andoni Ibargutxi, Guillermo Sosa y Miguel Fernández. Surge a raíz de una competición con el objetivo de predecir el resultado del mundial: clasificados 1-4, 8, 16 y 32.

El modelo es muy simple, ya que fue desarrollado en menos de una semana (aprox. 20 horas) para cumplir con el plazo de la competición, por lo que existen multitud de mejoras que se pueden aplicar.

# 2. Bases del modelo

El modelo consiste en un algoritmo mediante el cual se pretende predecir el resultado de un partido conocidos los equipos participantes. Por tanto, mediante un conjunto de resultados de partidos históricos entre partidos, nos encontramos con un problema de clasificación en el que las clases son:

* Victoria del equipo local (+1)
* Empate (0)
* Victoria del equipo visitante (-1)

Cabe destacar que el modelo no es capaz de predecir el número de goles de un partido, sino simplemente qué equipo ganará, o si terminará en empate.

Una vez elaborada una función que predice el resultado de un partido, hemos simulado los cruces del mundial desde la fase de grupos a la final.

# 3. Datos utilizados

Los datos utilizados en el modelo son:

* Partidos amistosos y oficiales de selecciones en los años 2015-2018.
* Ranking FIFA de los equipos: en función del año en el que se disputó cada partido.
* Puntuación de los equipos en el videojuego FIFA 18: dividida en Ataque, Media y Defensa.
* Porcentaje de victorias del Equipo 1 contra equipos de la trancha del ranking a la que pertenece el Equipo 2 (y por tanto, equipos "similares").
* Cuotas de las apuestas de los partidos.

Con todos estos datos hemos generado una base de datos histórica de partidos en el que cada uno tiene pegadas las características de ambos equipos participantes. Las variables se han construido en diferencias.

# 4. Algoritmo de predicción

Para clasificar los partidos hemos probado tres modelos de clasificación:

* Regresión logística multiclase
* Random Forest
* K vecinos más próximos

Tras un proceso de prueba hemos observado que el algoritmo con mayor precisión es **K vecinos más próximos**, por lo que ha sido éste el utilizado para clasificar.

# 5. Resultados

Los resultados de la fase de grupos, octavos, cuartos, semifinales y finales se encuentran en el notebook *4_Simulacion_mundial*. A modo de resumen, los 4 mejores equipos de acuerdo con el modelo son:

* Primer puesto: Brasil
* Segundo puesto: España
* Tercer puesto: Alemania
* Cuarto puesto: Portugal

# 6. Asunciones, limitaciones y posibles mejoras del modelo

En primer lugar, la asunción más importante es la utilización de las cuotas de las apuestas deportivas de cada partido como proxy del resultado del mismo. Debido a la naturaleza del fútbol, en el histórico de partidos con el que se ha entrenado el modelo existen casos de resultados atípicos (derrotas de las selecciones más favoritas contra otras muy inferiores). Por tanto, podemos encontrarnos con un Brasil - Corea en el que gana Corea. Pese a ser ésta la realidad de este partido, lo que esperaríamos obtener del modelo al intentar predecir ese partido sería, naturalmente, una victoria de Brasil. Por tanto, estos partidos pueden empeorar la capacidad de predicción. Es cierto que, de 10 partidos así, la mayoría los ganaría Brasil, por lo que con un conjunto de entrenamiento lo suficientemente grande no tendríamos este problema. No obstante, debido a que únicamente contamos con 658 partidos en 4 años, este comportamiento conducía a modelos de predicción muy poco precisos (en torno al 50-60%). Por este motivo, hemos asumido que el resultado de cada partido es aquél que indicaran las cuotas de apuestas previas al mismo (en nuestro ejemplo, las cuotas indicarían como claro favorito a Brasil, con lo cual asumir su victoria conduce al resultado que queremos predecir con el modelo). Concretamente, en el caso de que la diferencia entre las cuotas de la victoria de los equipos sea menor que 2.5, se ha asumido una victoria del equipo con menor cuota. En caso contrario, se ha asumido un empate.

Otra limitación del modelo es la poca cantidad de partidos para entrenarlo. No obstante, hemos preferido no utilizar partidos de 2014 hacia atrás ya que las condiciones de los equipos hace más de 4 años pueden considerarse bastante diferentes a las actuales.

Adicionalmente, en el caso de predecir empates en fases eliminatorias, hemos considerado que gana el equipo que más media de acuerdo al FIFA 18 tiene.

Una posible mejora del modelo podría ser la siguiente: el modelo en su versión actual es determinista, de manera que la simulación del mundial siempre va a arrojar el mismo resultado. Una manera de realizar una simulación con repeticiones sería fijar la división entre set de entrenamiento y validación de manera aleatoria, de manera que en cada iteración el modelo se entrenase con un conjunto de datos distinto. Repitiendo el experimento N veces y calculando probabilidades podríamos obtener los resultados del mundial de una forma más robusta.

Otra posible mejora del modelo podría ser la utilización de la regresión logística para obtener un resultado continuo entre -1 y 1, de manera que en función de lo cerca que quede el resultado de estos valores se podría estimar una distancia en goles en el partido. Esto permitiría calcular el gol average en fase de grupos, y desharía empates en las eliminatorias.


















