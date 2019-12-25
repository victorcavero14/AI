(defrule nombreJuan
(nombre Juan)
=>
(printout t "Tu nombre de pila es Juan" crlf)
)
(defrule Hola
(nombre Juan)
(apellido-1 Perez)
(apellido-2 Lopez)
=>
(printout t "Hola Juan Perez Lopez" crlf)
)
