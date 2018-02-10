addNewHero :- write('Agregando un nuevo heroe al sistema experto...'),nl,
			 write('No usar mayusculas en el proceso.'),nl,
			 open('writing.pl', append, Handle), 
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
	
askAtt(Nombre) :- write('Su atributo primario es inteligencia?'),read(Resp),nl,
				  open('writing.pl', append, Handle),
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


addFeatures :- write('Desea agregar alguna caracteristica mas del heroe?'),
		       read(Resp),nl,
			   open('writing.pl', append, Handle),				   
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
		   


adivina(venge,X) :- venge(X).
