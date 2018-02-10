%%%%%%% Sistema experto clasificador de heroes de DotA
%%%%%%% Ver el archivo dota.txt para una introducción al dominio  


%%%%%%%%%%%%%%%%%%%%% PREDICADOS PARA ADIVINAR %%%%%%%%%%%%%%%%%%%%%%%%%
% Gestionan el proceso de adivinar el personaje del usuario, preguntando
% las cosas necesarias.

%%%%  Predicado satisface
%%%%  averigua si un atributo es válido o no, si no lo sabe lo pregunta.

:- dynamic si/1,no/1.

satisface(Atributo,_) :-
(
	si(Atributo) -> true ;
	(
		no(Atributo) -> fail ;
		pregunta(Atributo),satisface(Atributo,_)
	)
).


%%%% Predicado pregunta
%%%% consulta al usuario si es un atributo se cumple o no.

pregunta(A) :-
	write('¿Tiene el heroe este atributo?: '), write(A), write(' '), read(Resp), nl,
 	(
		(Resp == s ; Resp == si ; Resp == sí) -> assert(si(A));
		assert(no(A))
	).


%%%% Predicado borraResp
%%%% deshace todas las aserciones si-no agregadas por el predicado pregunta.
 
borraResp :- retract_yes, retract_no.
retract_yes :- retractall(si(_)).
retract_no  :- retractall(no(_)).


%%%% Predicado hero
%%%% el predicado principal, se encarga de adivinar qué personaje está pensando el usuario.

hero :- adivina(Hero,_), write('El heroe es: '), write(Hero), nl, borraResp.

%%%% Predicados adivina
%%%% auxiliares del predicado hero

adivina(omniknight,X)  :- omniknight(X).
adivina(earthshaker,X) :- eartshaker(X).
adivina(timbersaw,X)   :- timbersaw(X).
adivina(juggernaut,X)  :- juggernaut(X).
adivina(void,X)        :- void(X).
adivina(mirana,X)      :- mirana(X).
adivina(lina,X)        :- lina(X).
adivina(rubick,X)      :- rubick(X).
adivina(ogre,X)        :- ogre(X).
adivina(venge,X)       :- venge(X).

/* Obs: eliminamos el predicado adivina(_,desconocido), pues nos impedía
agregar nuevos personajes a la base de conocimiento.
   Por lo tanto, si el usuario intenta adivinar un personaje que no está
incluído aún en la KB, símplemente recibirá como respuesta "false".   */


%%%%%%%%%%%%%%%%%%%%%%%%%  BASE DE CONOCIMIENTO %%%%%%%%%%%%%%%%%%%%%%%%

% Nuestro sistema clasifica heroes del juego DotA.
dotaHero(X)  :- satisface(es_un_heroe_de_dota,X),satisface(tiene_skills,X).


% Subcategorias de heroes segun su atributo principal.
inteligencia(X) :- dotaHero(X), satisface(tiene_mucho_mana,X) , satisface(tiene_muchos_skills,X).
agilidad(X)     :- dotaHero(X), satisface(ataca_muy_rapido,X) , satisface(tiene_mucha_armadura,X).
fuerza(X)       :- dotaHero(X), satisface(resistente,X)       , satisface(se_recupera_rapidamente,X).

% Distintos heroes (individuos) de nuestra KB:

eartshaker(X)   :- fuerza(X),satisface(iniciador,X),satisface(incapacitador,X),satisface(devastador,X),satisface(asistente,X).
omniknight(X)   :- fuerza(X),satisface(devastador,X),satisface(asistente,X).
timbersaw(X)    :- fuerza(X),satisface(devastador,X),satisface(escapista,X).
juggernaut(X)   :- agilidad(X),satisface(devastador,X),satisface(escapista,X).
void(X)         :- agilidad(X),satisface(iniciador,X),satisface(escapista,X),satisface(incapacitador,X).
venge(X)        :- agilidad(X),satisface(rango,X),satisface(asistente,X),satisface(incapacitador,X).
mirana(X)       :- agilidad(X),satisface(incapacitador,X),satisface(escapista,X),satisface(devastador,X),satisface(rango,X),satisface(asistente,X).
lina(X)         :- inteligencia(X),satisface(incapacitador,X),satisface(devastador,X),satisface(rango,X),satisface(asistente,X).
rubick(X)       :- inteligencia(X),satisface(incapacitador,X),satisface(rango,X),satisface(asistente,X),satisface(iniciador,X).
ogre(X)         :- inteligencia(X),satisface(incapacitador,X),satisface(devastador,X),satisface(asistente,X).

%%%%%%%%%%%%%%%%%%%%%% AGREGADO DE DATOS A LA KB %%%%%%%%%%%%%%%%%%%%%%%
% Predicados que permiten agregar nuevos personajes a la KB.

% obs: deberá volver a cargarse el programa ([dota].) para que el(los) nuevo personaje sea reconocido.


% Pregunta el nombre y escribe al final de este archivo el predicado "adivina" correspondiente.
% Luego continúa preguntando por atributos.
addNewHero :- write('Agregando un nuevo heroe al sistema experto...'),nl,
			  write('No usar mayusculas en el proceso.'),nl,
			  open('dota.pl', append, Handle), 
			  write('Ingrese el nombre del heroe:'),
			  read(Nombre),nl,
	          write(Handle, 'adivina('),
	          write(Handle,Nombre),
			  write(Handle, ',X) :- '),
	          write(Handle, Nombre),
	          write(Handle, '(X).'),
	          nl(Handle),
	          close(Handle),
	          askAtt(Nombre).
	
% Comienza preguntando la subclase a la que pertenece el personaje: su atributo primario.
askAtt(Nombre) :- write('Su atributo primario es inteligencia?'),read(Resp),nl,
				  open('dota.pl', append, Handle),
				  write(Handle,Nombre),
				  (
					(Resp == s ; Resp == si) ->  write(Handle, '(X):-')          ,
												 write(Handle, 'inteligencia(X)');
												 
					write('Su atributo primario es fuerza?'),read(Resp2),nl,
					( 					
						(Resp2 == s ; Resp2 == si) ->  write(Handle, '(X):-')      ,
                       						           write(Handle, 'fuerza(X)')  ;
						write(Handle, '(X):-'),
                       	write(Handle, 'agilidad(X)')  
					)
				  ),
				  close(Handle),
			      addFeatures.

% Termina la linea con los atributos que el usuario va indicando.
addFeatures :- write('Desea agregar alguna caracteristica mas del heroe?'),
		       read(Resp),nl,
			   open('dota.pl', append, Handle),				   
			   ( 
				  (Resp==n; Resp==no) -> write(Handle, '.'),
										 nl(Handle),
										 close(Handle);
				  write('Escriba la caracteristica (solo letras y guiones):'),
				  read(Feature),
				  write(Handle, ',satisface('),
				  write(Handle, Feature),
				  write(Handle, ',X)'),
				  close(Handle),
				  addFeatures
			   ).

%%%%%%%%%%%%%% NUEVOS PERSONAJES AGREGADOS POR EL USUARIO %%%%%%%%%%%%%%
% Aquí comenzarán a agregarse predicados agregados por el usuario, para ampliar la KB.
% Se verán warnings ocasionados por el desorden de las cláusulas adivina.

