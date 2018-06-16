# Modelo de predicci�n del mundial de f�tbol en Rusia 2018

# 1. Introducci�n

Este modelo ha sido desarrollado por Andoni Ibargutxi, Guillermo Sosa y Miguel Fern�ndez. Surge a ra�z de una competici�n con el objetivo de predecir el resultado del mundial: clasificados 1-4, 8, 16 y 32.

El modelo es muy simple, ya que fue desarrollado en menos de una semana (aprox. 20 horas) para cumplir con el plazo de la competici�n, por lo que existen multitud de mejoras que se pueden aplicar.

# 2. Bases del modelo

El modelo consiste en un algoritmo mediante el cual se pretende predecir el resultado de un partido conocidos los equipos participantes. Por tanto, mediante un conjunto de resultados de partidos hist�ricos entre partidos, nos encontramos con un problema de clasificaci�n en el que las clases son:

* Victoria del equipo local (+1)
* Empate (0)
* Victoria del equipo visitante (-1)

Cabe destacar que el modelo no es capaz de predecir el n�mero de goles de un partido, sino simplemente qu� equipo ganar�, o si terminar� en empate.

Una vez elaborada una funci�n que predice el resultado de un partido, hemos simulado los cruces del mundial desde la fase de grupos a la final.

# 3. Datos utilizados

Los datos utilizados en el modelo son:

* Partidos amistosos y oficiales de selecciones en los a�os 2015-2018.
* Ranking FIFA de los equipos: en funci�n del a�o en el que se disput� cada partido.
* Puntuaci�n de los equipos en el videojuego FIFA 18: dividida en Ataque, Media y Defensa.
* Porcentaje de victorias del Equipo 1 contra equipos de la trancha del ranking a la que pertenece el Equipo 2 (y por tanto, equipos "similares").
* Cuotas de las apuestas de los partidos.

Con todos estos datos hemos generado una base de datos hist�rica de partidos en el que cada uno tiene pegadas las caracter�sticas de ambos equipos participantes. Las variables se han construido en diferencias.

# 4. Algoritmo de predicci�n

Para clasificar los partidos hemos probado tres modelos de clasificaci�n:

* Regresi�n log�stica multiclase
* Random Forest
* K vecinos m�s pr�ximos

Tras un proceso de prueba hemos observado que el algoritmo con mayor precisi�n es **K vecinos m�s pr�ximos**, por lo que ha sido �ste el utilizado para clasificar.

# 5. Resultados

Los resultados de la fase de grupos, octavos, cuartos, semifinales y finales se encuentran en el notebook *4_Simulacion_mundial*. A modo de resumen, los 4 mejores equipos de acuerdo con el modelo son:

* Primer puesto: Brasil
* Segundo puesto: Espa�a
* Tercer puesto: Alemania
* Cuarto puesto: Portugal

# 6. Asunciones, limitaciones y posibles mejoras del modelo

En primer lugar, la asunci�n m�s importante es la utilizaci�n de las cuotas de las apuestas deportivas de cada partido como proxy del resultado del mismo. Debido a la naturaleza del f�tbol, en el hist�rico de partidos con el que se ha entrenado el modelo existen casos de resultados at�picos (derrotas de las selecciones m�s favoritas contra otras muy inferiores). Por tanto, podemos encontrarnos con un Brasil - Corea en el que gana Corea. Pese a ser �sta la realidad de este partido, lo que esperar�amos obtener del modelo al intentar predecir ese partido ser�a, naturalmente, una victoria de Brasil. Por tanto, estos partidos pueden empeorar la capacidad de predicci�n. Es cierto que, de 10 partidos as�, la mayor�a los ganar�a Brasil, por lo que con un conjunto de entrenamiento lo suficientemente grande no tendr�amos este problema. No obstante, debido a que �nicamente contamos con 658 partidos en 4 a�os, este comportamiento conduc�a a modelos de predicci�n muy poco precisos (en torno al 50-60%). Por este motivo, hemos asumido que el resultado de cada partido es aqu�l que indicaran las cuotas de apuestas previas al mismo (en nuestro ejemplo, las cuotas indicar�an como claro favorito a Brasil, con lo cual asumir su victoria conduce al resultado que queremos predecir con el modelo). Concretamente, en el caso de que la diferencia entre las cuotas de la victoria de los equipos sea menor que 2.5, se ha asumido una victoria del equipo con menor cuota. En caso contrario, se ha asumido un empate.

Otra limitaci�n del modelo es la poca cantidad de partidos para entrenarlo. No obstante, hemos preferido no utilizar partidos de 2014 hacia atr�s ya que las condiciones de los equipos hace m�s de 4 a�os pueden considerarse bastante diferentes a las actuales.

Adicionalmente, en el caso de predecir empates en fases eliminatorias, hemos considerado que gana el equipo que m�s media de acuerdo al FIFA 18 tiene.

Una posible mejora del modelo podr�a ser la siguiente: el modelo en su versi�n actual es determinista, de manera que la simulaci�n del mundial siempre va a arrojar el mismo resultado. Una manera de realizar una simulaci�n con repeticiones ser�a fijar la divisi�n entre set de entrenamiento y validaci�n de manera aleatoria, de manera que en cada iteraci�n el modelo se entrenase con un conjunto de datos distinto. Repitiendo el experimento N veces y calculando probabilidades podr�amos obtener los resultados del mundial de una forma m�s robusta.

Otra posible mejora del modelo podr�a ser la utilizaci�n de la regresi�n log�stica para obtener un resultado continuo entre -1 y 1, de manera que en funci�n de lo cerca que quede el resultado de estos valores se podr�a estimar una distancia en goles en el partido. Esto permitir�a calcular el gol average en fase de grupos, y deshar�a empates en las eliminatorias.


















