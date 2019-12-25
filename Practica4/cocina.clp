;
;				  LOGICA DEL PROGRAMA
;			   ____________________________
;
; El programa se ha diseñado para diagnosticar un problema con una cocina
; electrica o de gas stove y recomienda la mejor forma de arreglarlos.
; Los problemas y formas de arreglarlos son los siguientes.
;
; Primero el programa determina si la cocina es electrica o de gas y si
; el problema es con los quemadores o con el horno.
;
;					PROBLEMA				
;
; No llega electricidad a la cocina	
;
;	Compruebe la caja de fusibles, reemplazando cualquiera que este
;	fundido. Si esto no funciona bien, llame a un profesional.
;
; COCINA ELECTRICA
;
; Los quemadores no funcionan
;
;	Intercambie los lugares con un elemento en buen estado. Si el elemento
; 	aun no funciona, sustituyalo. Si el elemrnto funciona, quitelo y com
; 	pruebe los terminales para ver si estan doblados, teñidos de azulado o
;	recubiertos de negro. Todo ello puede significar que la unidad bloque
;	terminal esta mal. Compruebe marcas de quemado en la unidad y, si las
; 	encuentra, reemplacela. Si no, compruebe el quemador y compruebelo si 
;	funciona. Si no, es que hay un cable defectuoso y debe rastrearlo desde
;	el enchufe hasta el interruptor para encontrar el problema.
;
; El horno no funciona
;
;	Compruebe la resistencia del horno para comprobar si esta mal, reempla
;	cela en ese caso. Si no, compruebe el interruptor y reemplacelo si esta 
;	mal. Si no, compruebe el cable.
;
; COCINA DE GAS
;
; Los quemadores no funcionan
;
;	Compruebe los del quemador y reemplacelos si estan rotos. Si no, compruebe
;	el regulador y reemplacelo si esta roto. Si no, compruebe la unidad de 
;	electrodo y reemplacela si esta mal. Si no, llame a un profesional.
;
; El horno no funciona
;
;	Compruebe si el encendedor está incandescente. Si no es asi, reemplacelo.
;	En caso contrario, compruebe y limpie el orificio y reemplacelo. Compruebe
;	que no hay fugas durante la instalacion. Si nada de eso funciona, llame a
;	un profesional.
; 
;
;********************************************************************************
;
;
;
;********************************
;regla 1:
;	Inicializa el programa
;********************************
 
(defrule iniciar
 (declare (salience 9980))
 ?x <- (initial-fact) 
=>
 (retract ?x)
 (assert (necesita profesional no))
 (assert (empezar))
)


;*********************************************************
;regla 2:
;	Usada para finalizar el programa y llamar a 
;	la regla inicial despues de resetear el programa
;
;*********************************************************

(defrule fin1
 (declare (salience 9200))
 ?w <- (parar)
 =>
 (retract ?w)
 (reset)
 (halt)
)
 

;********************************************************************
;regla 3:
;     	Da el mensaje de apertura y pregunta que tipo de cocina tiene
;
;********************************************************************

(defrule inicio
 (declare (salience -9000))
 ?x <- (empezar) 
=>
 (printout t crlf crlf crlf
	"El programa esta diseñado para ayudarlo a reparar una cocina electrica" crlf
	"o de gas.  El programa le indicara paso a paso los procedimientos" crlf
	" que ha de realizar para reparar la cocina." crlf crlf
	"Tiene usted una" crlf
      "  1) Cocina electrica" crlf
	"  2) Cocina de gas" crlf
      "  3) o salir del programa" crlf 
	"Elija 1 - 3 -> ")
 (retract ?x)
 (assert (tipo cocina =(read)))
)


;**********************************************************************
;regla 4:
;	Comprueba que se ha realizado una seleccion correcta del menu
;	de apertura; en caso contrario, muestra mensaje
;
;**********************************************************************
 
(defrule comprueba-seleccion
 (declare (salience 9998))
 ?x <- (tipo cocina ?ch&:(not (numberp ?ch)))
 (or (test (<= ?ch 0)) (test (> ?ch 3))) 
=>
 (printout t crlf crlf
	"*** Su seleccion debe ser 1,2, o 3 ***" crlf)
 (retract ?x)
 (assert (empezar))
)


;********************************************************************
;regla 5:
;	Pregunta si hay problemas con los quemadores
;
;********************************************************************
 
(defrule prob-quemadores
 (declare (salience -500))
 (tipo cocina ?) 
=>
 (printout t crlf crlf "¿Hay problemas con los quemadores?. Conteste si o no ")
 (assert (problema quemadores =(read)))
)


;*************************************************
;regla 6:
;	Pregunta si hay problemas con el horno
;
;*************************************************
 
(defrule prob-horno 
 (declare (salience -1000))
 (tipo cocina ?) 
=>
 (printout t crlf crlf "¿Hay problemas con el horno?. Conteste si o no ")
 (assert (problema horno =(read)))
)


;*********************************************************************
;rule7
;	Pregunta si hay algun problema de electricidad en la cocina
;
;*********************************************************************

(defrule comprobar-energia
 (declare (salience 1500))
 (tipo cocina 1) 
=>
 (printout t crlf crlf "¿Llega a la cocina electricidad?. Conteste si o no ")
 (assert (energia =(read)))
)


;*************************************************************
;rule8
;	tells the user to check the breaker for a blown fuse
;
;*************************************************************

(defrule comprobar-cajafusibles
 (declare (salience 100))
 ?x <- (energia no) =>
 (printout t crlf crlf
	"Vaya a su caja de fusibles y compruebe el fusible de la" crlf
	"cocina para ver si esta fundido. Si es asi, cambielo" crlf
	"e intente encenderla de nuevo." crlf crlf
	"¿Esta todavia la cocina sin electricidad?. Conteste si o no ")
 (retract ?x)
 (assert (todavia sin energia =(read)))
)


;********************************************************************
;regla 9:
;	comprueba si despues de comprobar fusibles esta sin energia
;
;********************************************************************

(defrule prob-todavia
 ?x <- (todavia sin energia si) 
=>
 (retract ?x)
 (assert (necesita profesional si))
 (assert (parar))
)


;*****************************************************************
;regla 10:
;	dice al usuario que deje a un profesional el problema 
;	para evitar peligros
;
;*****************************************************************

(defrule pida-ayuda
 (declare (salience 9999))
 (necesita profesional si) 
=>
 (printout t crlf crlf
	"Este problema puede ser serio y deberia dejarse a un " crlf
	"profesional. Seguir intentando reparar la cocina podria ser" crlf
	"peligroso." crlf crlf)
 (assert (parar))
)

  
;*********************************************************************
;regla 11:
;	pregunta al usuario que tipo de elemento quemador tiene
;
;*********************************************************************

(defrule tipo-elemento
 (tipo cocina 1)
 (problema quemadores si) =>
 (printout t crlf crlf "De que tipo es el quemador de la cocina? " crlf crlf
		     " 1) Insertado" crlf    
		     " 2) Atornillado" crlf crlf
		     "Elija opcion -> ")
 (assert (tipo quemador =(read)))
)        


;*************************************************************
;regla 12:
;	comprueba si un quemador del mismo tamaño del que da 
;	problemas esta funcionando
;
;*************************************************************
	 
(defrule otro-igual-funcionando
 (tipo cocina 1)
 (problema quemadores si) 
=>
 (printout t crlf crlf
	"¿Hay al menos un quemador del mismo tamaño que este todavia funcionando?. Conteste si o no ")
 (assert (igual funcionando =(read)))
)


;*********************************************************
;rule 13
;	regla para intercambiar un elemento que funciona 
;	con otro que no para comprobacion
;
;*********************************************************

(defrule intercambiar-elemento
 ?x <- (igual funcionando si) 
=>
 (printout t crlf crlf
	"Quite el elemento que no funciona correctamente e intercambielo" crlf
	"con otro quemador del mismo tamaño." crlf crlf
   	"***  asegurese de apagar la cocina durante la operacion ***" crlf crlf
	"Ponga ahora al maximo los controles del elemento. El elemento que " crlf
	"no trabajaba correctamente lo hace ahora?. Conteste si o no ")
 (retract ?x)
 (assert (elemento roto =(read)))
)


;********************************************
;rule14
;	Determina que el elemento esta roto
;
;********************************************

(defrule elemento-roto
 ?x <- (elemento roto si)
 =>
 (printout t crlf crlf
	"El elemento del quemador esta roto. Debe reemplazar el elemento roto" crlf
	"Despues, compruebe el quemador y, si hay algun problema, vuelva a " crlf
	"ejecutar este programa." crlf)
 (retract ?x)
 (assert (parar))
)

 
;**********************************************************************
;regla 15:
;	Dice al usuario que use un ohmetro para comprobar el elemento
;
;**********************************************************************

(defrule intercambiar-elemento2
 ?x <- (igual funcionando no)
=>
 (printout t crlf crlf
 	"Como no hay otro elemento igual funcionando para intercambiar" crlf
	"con el que no funciona, tendra que comprobar el elemento con un" crlf
	"ohmetro. Desconecte la cocina y quite el quemador. Ponga una sonda" crlf
	"del ohmetro sobre cada uno de los terminales del elemento." crlf
	"¿Registr el ohmetro resistencia 0 para el elemento?. Conteste si o no. ")
 (retract ?x)
 (assert (elemento roto =(read)))
)


;*****************************************************
;regla 16:
;	Comprueba si los terminales estan doblados
;
;*****************************************************

(defrule comprobar-elemento1
 (declare (salience -20))
 (problema quemadores si)
 (tipo quemador 1) 
=>
 (printout t crlf crlf
	"Compruebe los extremos de los terminales." crlf
	"¿Se ven doblados?. Conteste si o no. ")
 (assert (terminales doblados =(read)))
)


;***************************************************
;regla 17
;	regla para cuando haya un terminal doblado
;
;***************************************************

(defrule terminales-doblados
 ?x <- (terminales doblados si) =>
 (printout t crlf crlf
	"Este muestra que el elemento ha sido instalado incorrectamente." crlf
	"Esto puede provocar fallos en el bloque terminal." crlf)
 (retract ?x)
 (assert (comprobar bloque terminal)))


;*************************************************************
;regla 18
;	Comprueba si hay una capa negra sobre los terminales
;
;*************************************************************

(defrule comprobar-elemento2
 (declare (salience -10))
 (problema quemadores y)
 (tipo quemador 1) =>
 (printout t crlf crlf
	"Compruebe los extremos de los terminales." crlf
	"¿Hay algún rastro negro sobre los terminales?. Conteste si o no ")
 (assert (capa negra =(read)))
)  
 

;**********************************************************************
;regla 19
;	regla por si se ha encontrado una capa negra en los terminales
;
;**********************************************************************

(defrule capa-negra
 ?x <- (capa negra si)
 =>
 (printout t crlf crlf
 	"Esto es debido a un mal contacto con los terminales" crlf
	"del bloque terminal." crlf)
 (assert (comprobar bloque terminal))
 (retract ?x)
)


;***********************************************************************
;regla 20:
;	regla para comprobar si hay una capa azul sobre los terminales
;
;***********************************************************************

(defrule capa-azul
 (declare (salience -10))
 (problema quemadores si)
 (tipo quemador ?) 
=>
 (printout t crlf crlf
	"Compruebe en los extremos de los terminales algun rastro de color azul" crlf
	"¿Existe o no?. Conteste si o no ")
 (assert (capa azul =(read)))
)


;**********************************************************************
;regla 21:
;	regla para cuando se encuentre una capa azul sobre terminales
;
;**********************************************************************

(defrule existe-capa-azul
 ?x <- (capa azul si) 
=>
 (printout t crlf crlf
 	"Esto es debido a que la grasa ha salpicado los terminales" crlf
	"y se han calentado a una temperatura muy elevada. Esto puede causar" crlf
	"fallos en el bloque terminal" crlf)
 (retract ?x)
 (assert (comprobar bloque terminal))
)
 

;*************************************************************************
;regla 22:
;	Dice al usuario que compruebe si la unidad bloque terminal tiene 
;	marcas de quemaduras
;
;*************************************************************************

(defrule comprobar-bloque-terminal
 ?x <- (comprobar bloque terminal) 
=>
 (printout t crlf crlf
 	"Ilumine con una luz dentro del bloque temrminal." crlf
	"¿Se ven los contactos quemados por dentro?. Conteste si o no ")
 (retract ?x)
 (assert (contactos quemados =(read)))
)


;********************************************************************
;regla 23
;	regla por si hay marcas de quemaduras en el bloque terminal
;
;********************************************************************

(defrule contactos-quemados
 ?x <- (contactos quemados si)
 =>
 (printout t crlf crlf
 	"Sustituya el bloque terminal para el quemador. Despues" crlf
	"lije el final del terminal con un papel de lija fino o con lana de acero." crlf
	"Reinstale la unidad y compruebe el quemador. Si todavia hay problemas" crlf
	"vuelva a ejecutar este programa." crlf)
 (retract ?x)
 (assert (parar))
)

;*************************************************************************
;regla 24:
;	comprueba si hay algun desgaste sobre la superficie del elemento
;
;*************************************************************************

(defrule comprobar-desgaste-elemento
 (declare (salience -10))
 (tipo cocina 1)
 (problema quemadores si) =>
 (printout t crlf crlf
	"Los elementos electricos usan alambres de una aleacion hecha" crlf
	"de niquel y cromo cubierta por una funda metalica con una capa" crlf
	"negra. ¿Se ve desgastada dicha capa en cualquier punto?." crlf
	"Conteste si o no ")
 (assert (elemento desgastado =(read)))
)

;*************************************************
;regla 25:
;	Regla por si el elemento esta desgastado
;
;*************************************************

(defrule elemento-desgastado
 ?x <- (elemento desgastado si)
 =>
 (printout t crlf crlf
	"El alambre de niquel-cromo ha tocado la funda y se ha quemado." crlf
	"Sustituya el elemento. Despues vuelva a comprobar el quemador." crlf
	"Si todavia hay problemas, vuelva a ejecutar este programa." crlf)
 (retract ?x)
 (assert (parar)))

;******************************************************
;rule26:
;	Regla para comprobar si hay alambres doblados
;
;******************************************************

(defrule comprobar-alambres
 (declare (salience -100))
 (elemento roto no) 
=>
 (printout t crlf crlf
	"Ahora debe usted levantar la parte superior de la cocina" crlf
	"y comprobar los alambres que conducen al elemento que no funciona." crlf
        "¿Se ven doblados los alambres?. Conteste si o no ")
 (assert (alambre doblado =(read)))
)

;*********************************************
;rule27:
;	Regla por si hay un alambre doblado
;
;*********************************************

(defrule alambre-doblado
 ?x <- (alambre doblado si)
 =>
 (printout t crlf crlf
	"Primero asegurese de que la cocina esta apagada. Despues elimine" crlf
        "el aislamiento del area ""rizada"" y doble el extremo suelto." crlf
	"Suelde el cable y cubra la union con un revestimento ceramico." crlf
	"*** PRECAUCION - no use un recubrimiento plastico, ya que esta" crlf
	"                 temperatura tan alta provocaria que se fundiera" crlf
	"Despues, enchufe la cocina y vuelva a comprobar el elemento." crlf
	"Si todavia hay problemas, vuelva a ejecutar este programa." crlf)
 (retract ?x)
 (assert (parar))
)

;************************************************
;rule27:
;	regla por si no hay alambre doblado
;
;************************************************

(defrule no-alambre-doblado
 ?x <- (alambre doblado no) 
=>
 (printout t crlf crlf
	"Desenchife la cocina. Despues, quite los tornillos del panel de control" crlf
	"e inclinelo. Puede que sea necesario quitar los tornillos de la  " crlf
	"parte posterior del panel.  Etiquete los cables que van al interruptor" crlf
	"del elemento que no funciona y los que van al que si funciona. Intercambie " crlf
	"los cables y enchufe la cocina. Ponga el elemento al maximo. ¿Funciona" crlf
	"ahora el elemento malo y el bueno no?. Conteste si o no ")
 (retract ?x)
 (assert (interruptor roto =(read)))
)

;***********************************************************
;regla 28
;	Regla para el caso de que haya un interruptor roto
;
;***********************************************************

(defrule interruptor-roto
 ?x <- (interruptor roto si)
=>
 (printout t crlf crlf
	"Sustituya el interruptor del elemento que no funciona y enganche" crlf
	"los alambres en sus lugares originales. Despues vuelva a comprobar" crlf
	"el elemento. Si ay algun otro problema vuelva a ejecutar este programa." crlf)
 (retract ?x)
 (assert (parar))
)

;**************************************************************
;regla 29
;	Regla para el caso de que el interruptor no este roto
;
;**************************************************************

(defrule interruptor-bueno
 ?x <- (interruptor roto no)
=>
 (printout t crlf crlf
	"Tiene un alambre roto en algun lugar entre el interruptor y el " crlf
	"elemento que no funciona. Debe buscar la zona defectuosa y sustituirla." crlf
	"Despues vuelva a comprobar la cocina. Si todavia hay algun problema" crlf
	"vuelva a ejecutar este programa." crlf)
 (retract ?x)
 (assert (parar))
)

 
;********************************************************************
;regla 30
;	Da el primer paso si hay problemas con un horno electrico
;	
;********************************************************************

(defrule comprobar-horno
 (tipo cocina 1)
 (problema horno si) 
=>
 (printout t crlf crlf
	"Encienda el horno a 400 grados y determine que elementos" crlf
	"no funcionan. Apague el horno y deje que se enfrie Desenchufe." crlf
	"la cocina y quite la placa que tiene la resistencia que no" crlf
	"funciona. Tire de la resistencia hacia usted. La resistencia" crlf
	"estara sujeta por cables de alimentacion con conectores o tornillos." crlf
	"Quite los cables y saque la resistencia. Compruebe la resistencia " crlf
	"con un ohmetro poniendo una sonda en cada terminal." crlf
	"Registra el medidor una resistencia 0?. Conteste si o no ")
 (assert (elemento horno roto =(read)))
)

;*****************************************************
;regla 31
;	Regla por si hay un elemento del horno roto
;
;*****************************************************

(defrule elemento-horno-roto	
 ?x <- (elemento horno roto si) 
=>
 (printout t crlf crlf
	"El elemento del horno esta roto y debe ser sustituido. Sustituya el " crlf
	"elemento y vuelva a intentar que el horno funcione. Si sigue habiendo problemas" crlf
	"vuelva a ejecutar este programa." crlf)
 (retract ?x)
 (assert (parar))
)

;***************************************************
;rule32
;	Regla si el elemento del horno esta bien
;
;***************************************************

(defrule elemento-horno-bien
 (declare (salience 100))
 (elemento horno roto no) 
=>
 (printout t crlf crlf
 	"Busque un diagrama del cableado del interruptor de seleccion." crlf
	"Este suele estar pegado en la parte interior trasera del panel" crlf
	"o en el manual del propietario. Si no hay ningun diagrama del cableado" crlf
	"utilice el que viene en el manual de este programa. Utilizando el " crlf
	"grafico compruebe el interruptor con un ohmetro. Desenchufe el horno." crlf
	"Abra el panel de control para acceder a los contactos del interruptor." crlf
        "Etiquete los cables y desconectelos. Conecte el ohmetro a los terminales"crlf
	"L1 y BK. ¿Hay resistencia 0?. Conteste si o no")  
 (assert (interruptor falla =(read)))
)

;********************************************************
;regla 33
;	Regla para comprobar el interruptor del horno
;
;********************************************************

(defrule comprobar-interruptor1
 (elemento horno roto no)
 (interruptor falla ~si)
=>
 (printout t crlf crlf
	"Conecte ahora a los terminales PL y N. ¿Hay resistencia 0?. Conteste si o no" crlf)
 (assert (interruptor falla =(read)))
)

;*******************************************************
;regla 34
;	Regla para comprobar el interruptor del horno
;
;*******************************************************

(defrule comprobar-interruptor2
 (declare (salience -10))
 (elemento horno roto no)
 (interruptor falla ~si)
=>
 (printout t crlf crlf
	"Conecte ahora a los terminales PL y BR. ¿Hay resistencia 0?. Conteste si o no." crlf)
 (assert (interruptor falla =(read)))
)


;*********************************************************************
;regla 35
;	Regla para comprobar el interruptor del gratinador del horno
;
;*********************************************************************

(defrule comprobar-interruptor3
 (declare (salience -100))
 (elemento horno roto no)
 (interruptor falla ~si)
=>
 (printout t crlf crlf
	"Para comprobar el gratinador:" crlf
	"Conecte ahora a los terminales L1 y BR.¿Hay resistencia 0?. Conteste si o no." crlf)
 (assert (interruptor falla =(read)))
)

;***********************************************************************
;regla 36
;	Regla para comprobar el interruptor del gratinador del horno
;
;***********************************************************************

(defrule comprobar-interruptor4
 (declare (salience -150))
 (elemento horno roto no)
 (interruptor falla ~si)
=>
 (printout t crlf crlf
	"Conecte ahora a los terminales L1 y PL.¿Hay resistencia 0?. Conteste si o no." crlf)
 (assert (interruptor falla  =(read)))
)


;***********************************************************
;regla 37
;	Regla por si hay un interruptor del horno averiado
;
;***********************************************************

(defrule switch-failed
 (declare (salience 10))
 ?x <- (interruptor falla si)
=>
 (printout t crlf crlf
	"Debe usted reemplazar el interruptor. Despues, situe los cables" crlf
	"en su posicion original y vuelva a comprobar el horno. Si todavia" crlf
	"hay problemas, vuelva a ejecutar este programa." crlf)
 (retract ?x)
 (assert (parar))
)

;**************************************************
;regla 38
;	regla para ver si el reloj esta activado
;
;**************************************************

(defrule comprobar-reloj
 (declare (salience 200))
 (elemento horno roto no) 
=>
 (printout t crlf crlf
	"Compruebe el temporizador del horno. Esta puesto en AUTOMATIC?. Conteste si o no ")
 (assert (reloj activo =(read)))
)


;**********************************************
;regla 39
;	regla por si el reloj esta activado
;
;**********************************************

(defrule reloj-activado
 (declare (salience 200))
 ?x <- (reloj activo si)
=>
 (printout t crlf crlf
	"El horno no funcionara hasta que se alcance la hora fijada en el reloj." crlf
	"Ponga el interruptor en modo manual y compruebe de nuevo. Si todavia hay" crlf 
	"problemas, vuelva a ejecutar este programa." crlf)
 (retract ?x)
 (assert (parar))
)  

;*********************************************************
;regla 40
;	regla para comprobar el selector de temperatura
;
;*********************************************************

(defrule control-temperatura
 (declare (salience -100))
 (tipo cocina 1)
 (problema horno si) 
=>
 (printout t crlf crlf
	"Ahora vamos a comprobar el selector de temperatura del horno." crlf
	"Mire si hay un diagrama del cableado pegado en el horno" crlf
	"o en el manual del propietario relativo al interruptor de control"crlf
	"de temperatura. Si no hay utilice el que hay en el manual de este."crlf
	"libro. Desenchufe el horno, quite los tornillos y abra el panel de control." crlf
	"Etiquete los cables. Ponga el selector a 300 grados. Utilizando un " crlf
	"ohmetro, situe los terminales en los contactos 1 y 2 y accione el interruptor" crlf
	"para gratinar. Es 0 la resistencia? Conteste si o no ")
 (assert (selector temperatura bueno =(read)))
)


;*********************************************************
;regla 41
;	regla para comprobar el selector de temperatura
;
;*********************************************************

(defrule control-temperatura2
 (selector temperatura bueno ~no) 
=>
 (printout t crlf crlf
	"Mantenga los conectores en los terminales 1 y 3 y ponga el control" crlf
	"en hornear. Es 0 la resistencia? Conteste si o no ")
 (assert (selector temperatura bueno =(read)))
)

;*********************************************************
;regla 42
;	regla para comprobar el selector de temperatura
;	
;*********************************************************

(defrule tenp-control3
 ?x <- (selector temperatura no) 
=>
 (printout t crlf crlf
    "Debe usted reemplazar el interruptor. Despues, situe los cables en su" crlf
    "posicion original, enchufe la cocina y compruebe el horno. Si todavia" crlf
    "tiene problemas, vuelva a ejecutar este programa.")
 (retract ?x)
 (assert (parar))
)


;********************************************************
;*                                                      *   
;* Las reglas para las cocinas de gas comienzan aqui ****
;*                                                      *
;********************************************************

;***********************************************
;regla 43
;	Primera regla si hay una cocina de gas
;
;***********************************************

(defrule cocina-de-gas
 (declare (salience 100))
 (tipo cocina 2)
 (problema quemadores si) 
=>
 (printout t crlf crlf
	"Que encendedores tiene? " crlf
	"  1) alimentados son gas" crlf
	"  2) tipo bujía" crlf crlf
	"Choose 1 or 2 ")
 (assert (tipo encendedor =(read)))
)

;***********************************************************
;regla 44
;	Regla por si el encendedor esta alimentado por gas
;
;***********************************************************

(defrule alimentado-gas
 (declare (salience 100))
 ?x <- (tipo encendedor 1) 
=>
 (printout t crlf crlf
	"Desconecte el gas mientras manipula cualquier parte de la cocina" crlf)
 (retract ?x)
)


;*************************************************
;regla 45
;	Regla por si el encendedor es electrico
; 
;*************************************************

(defrule tipo-encendedor
 (declare (salience 100))
 ?x <- (tipo encendedor 2) 
=>
 (printout t crlf crlf
	"Desenchufe la cocina mientras manipula cualquier elemento" crlf)
 (retract ?x)
)

;*****************************************
;regla 46
;	Comprueba los quemadores de gas
;
;*****************************************

(defrule quemadores-gas
 (tipo cocina 2)
 (problema quemadores si) 
=>
 (printout t crlf crlf
	"Cada pareja de quemadores utiliza un encendedor comun." crlf
	"Esta un quemador apagado mientras que el otro que usa el mismo" crlf
	"encendedor funciona?. Conteste si o no ")
 (assert (llave gas averiada =(read)))
)


;************************************************
;regla 47
;	Regla por si hay un encendedor averiado
;
;************************************************

(defrule encendedor-malo
 ?x <- (llave gas averiada si)
 ?y <- (problema quemadores ?)
=>
 (printout t crlf crlf
 	"Sustituya el interruptor del quemador que no funciona ya que, " crlf
	"probablemente, el agua ha penetrado en el causando un cortocircuito ." crlf
	"Reemplacelo y compruebe el quemador. Si todavia tiene problemas, " crlf
	"vuelva a ejecutar este programa.")
 (retract ?x ?y)
 (assert (parar))
)

;********************************************
;regla 48
;	Regla para comprobar el encendedor
;
;********************************************

(defrule comprobar-encendedor
 (declare (salience -100))
 (tipo cocina 2)
 ?x <- (problema quemadores si)
=>
 (printout t crlf crlf
	"Si los dos quemadores que comparten el mismo encendedor no funcionan," crlf
	"desconecte el horno. En el modulo, desconecte e invierta los cables de" crlf
	"los dos electrodos. Vuelva a conectar el horno y compruebe todos los" crlf
	"quemadores. Si el problema estaba en los quemadores de un lado y ahora" crlf 
	"esta en los del otro, o viceversa, reemplace el electrodo del lado que" crlf
	"no funciona. Antes de extraer el ensamblaje electrodo/cable fuera del" crlf
	"hornillo, corte el antiguo electrodo, una con una cinta aislante los" crlf
	"cables viejos fuera del tornillo mientras esta poniendo los nuevos." crlf
 	"Si todavia tiene problemas, vuelva a ejecutar este programa." crlf)
 (retract ?x)
 (assert (parar))
)


;******************************************************
;regla 49
;	Regla para comprobar el encendedor del horno
;
;******************************************************

(defrule horno-gas
 (tipo cocina 2)
 (problema horno si) 
=>
 (printout t crlf crlf
	"Encienda el horno y mire dentro. Brilla el extremo del encendedor?." crlf
	"Conteste si o no ")
 (assert (encendedor horno bueno =(read)))
)


;***********************************************************
;regla 50
;	Regla por si hay un encendedor del horno averiado
;
;***********************************************************

(defrule encendedor-horno-averiado
 ?x <- (encendedor horno bueno no) 
=>
 (printout t crlf crlf
	"Reemplace la bobina del encendedor del horno." crlf crlf
	"** ATENCION - no toque la bobina durante la instalacion" crlf
	"              ya que el aceite de sus dedos la estropearia ***" crlf crlf
	"Despues de ello, si todavia persiste el problema, vuelva a ejecutar este programa. " crlf)
 (retract ?x)
 (assert (parar))
)

;********************************************************
;regla 51
;	Regla por si el encendedor del horno esta bien
;
;********************************************************

(defrule encendedor-horno-bien
 (encendedor horno bueno si) 
=>
 (printout t crlf crlf
	"Tiene usted un encendedor alimentado por gas?. Conteste si o no ")
 (assert (encendedor alimentado gas =(read)))
)


;***********************************************************
;regla 52
;	Regla por si hay un encendedor alimentado por gas 
;
;***********************************************************

(defrule encendedor-alimentado-gas
 ?x <- (encendedor alimentado gas si) 
=>
 (printout t crlf crlf
	"Las salpicaduras pueden haber obstruido el orificio." crlf
	"Desenrosque el quemador y limpielo. Extienda jabón detergente" crlf
	"y agua alrededor de la salida del quemador, y conecte de nuevo el gas." crlf
	"Si se empiezan a formar burbujas en la base reajuste el quemador" crlf
	"y vuelva a comprobar. Si las burbujas persisten, apague el gas, quite" crlf
	"la tapa del quemador y aplique un producto para unir tuberias en" crlf
	"toda la trama. Reinstale la tapa y compruebe si hay perdidas." crlf
	"Se siguen formando burbujas? Conteste si o no ")
 (retract ?x )
 (assert (burbujas =(read)))
)
 	
;*******************************************************************************
;regla 53
;	Regla para comprobar perdidas de gas durante la limpieza del orificio
;
;*******************************************************************************

(defrule burbujas
 ?x <- (burbujas si)
 ?y <- (necesita profesional ?) 
=>
 (retract ?x ?y)
 (assert (necesita profesional si))
)


;*************************************
;rule54:
;	regla por si no hay burbujas
;
;*************************************

(defrule no-burbujas
 ?x <- (burbujas no) 
=>
 (printout t crlf crlf
   "Vuelva a comprobar la cocina."crlf
   "Si hay todavia problemas vuelva a ejecutar este programa." crlf)
 (retract ?x)
 (assert (parar))
)


;**********************************************************************
;rule55:
;	Regla por si el problema es mas apropiado para un profesional
;
;**********************************************************************

(defrule no-gas-fed-pilot
 (encendedor alimentado gas no)
 ?x <- (necesita profesional ?) 
=>
 (printout t crlf crlf
 	"El problema deberia ser tratado por un profesional" crlf
	"ya que es peligroso trabajar con las partes restantes " crlf
	"relacionadas con gas.")
 (retract ?x)
 (assert (necesita profesional si))
)


;**********************************************************
;rule56:
;	Regla cuando el usuario quiere salir del programa 
;	
;**********************************************************

(defrule salir
 (declare (salience 9700))
 (tipo cocina 3)
=>
 (printout t crlf crlf crlf crlf
	"Saliendo del programa " crlf crlf)
 (assert (parar))
 (assert (salir))
)

 
;*********************************************************
;rule57:
;	Regla para cuando el usuario abandone el sistema
;
;*********************************************************

(defrule finalizado
 (declare (salience 9990))
 ?w <- (salir)
=>
 (retract ?w)
 (halt)
)
