/* Sistema experto clasificador de animales */
/* Extraido del enunciado del tp */

%predicado satisface

:- dynamic si/1,no/1.

satisface(Atributo,_) :-
(
	si(Atributo) -> true ;
	(
		no(Atributo) -> fail ;
		pregunta(Atributo),satisface(Atributo,_)
	)
).

pregunta(A) :-
	write('¿Tiene el animal este atributo?: '), write(A), write(' '), read(Resp), nl,
 	(
		(Resp == s ; Resp == si ; Resp == sí) -> assert(si(A));
		assert(no(A))
	).


%predicado animal
animal :- adivina(Animal,_), write('El animal es: '), write(Animal), nl, borraResp.



%predicados adivina

adivina(tigre,X)    :- tigre(X).
adivina(chita,X)    :- chita(X).
adivina(jirafa,X)   :- jirafa(X).
adivina(cebra,X)    :- cebra(X).
adivina(avestruz,X) :- avestruz(X).
adivina(pinguino,X) :- pinguino(X).
adivina(albatros,X) :- albatros(X).
adivina(_,desconocido).

% undo all yes/no assertions 
borraResp :- retractall(yes(X)),retractall(no(_)).

% Animal
animal(X):-satisface(esta_vivo,X),satisface(puede_sentir,X),satisface(puede_moverse,X).

% Categorías de animales
mamifero(X)  :- animal(X),satisface(da_leche,X),satisface(tiene_pelo,X).
pajaro(X)    :- animal(X),satisface(tiene_alas,X),satisface(pone_huevos,X).
pajaro(X)    :- animal(X),satisface(vuela,X),satisface(pone_huevos,X).
canivoro(X)  :- animal(X),satisface(come_carne,X).
carnivoro(X) :- animal(X),satisface(dientes_afilados,X),satisface(tiene_garras,X).
ungulado(X)  :- mamifero(X),satisface(tiene_pesuñas,X).
ungulado(X)  :- mamifero(X),satisface(tiene_caparazon,X).

% Reglas de clasificación para animales

tigre(X)    :- mamifero(X),satisface(come_carne,X).
chita(X)    :- mamifero(X),satisface(tiene_color_tostado,X),satisface(tiene_manchas_oscuras,X).
jirafa(X)   :- ungulado(X),satisface(tiene_cuello_largo,X),satisface(tiene_piernas_largas,X).
cebra(X)    :- ungulado(X),satisface(tiene_rayas_negras,X).
avestruz(X) :- pajaro(X),satisface(no_vuela,X),satisface(cuello_largo,X).
pinguino(X) :- pajaro(X),satisface(nada,X),satisface(tiene_color_blanco_y_negro,X).
albatros(x) :- pajaro(X),satisface(vuela_bien,X),satisface(aparece_historias_marineros,X).

