Program ListaAlumnos;
Uses
	Crt;

Type
	ALUMREG = Record
		NUMLIB : 1000..9999;
		NOMBRE : String[30];
		CODFAC : 1..10;
		CODCAR : 10..99;
		ANIOCUR : 1..5;
	End;

	ARCHALUM = File of ALUMREG;
	DINARRAY = Array of Integer;

Const
	PATH_ALUM = 'ALUMNOS.dat'; // Ruta archivo "ALUMNOS.dat".

Var
	ALUM : ARCHALUM;
	ERROR : Integer;
	CARARRAY : Array[10..99] of DINARRAY;
	ANIOARRAY : Array[1..5] of DINARRAY;

// ============================================================================================
// Sección de Procedimientos
// ============================================================================================

Procedure ConfirmarExistencia (var para_ALUM : ARCHALUM ; var para_ERROR : Integer);
// Verifica si existe el archivo "ALUMNOS.dat", o si no contiene datos.
Var
	ALUMNO : ALUMREG;

Begin
	para_ERROR := 0;
	Assign(para_ALUM, PATH_ALUM);
	{$I-} // Deshabilitar detección de errores.
	Reset(para_ALUM);
	{$I+} // Habilitar detección de errores.
	If IOResult <> 0 then // Si no existe, modifica el valor de la variable ERROR.
		para_ERROR := 1;
	{$I-}
	Read(para_ALUM, ALUMNO);
	{$I+}
	If IOResult <> 0 then // Si no puede leer valores, modifica el valor de la variable ERROR.
		para_ERROR := para_ERROR + 1;
	Case para_ERROR of // Dependiendo del valor de ERROR, imprime un mensaje de error específico.
		1: WriteLn('USUARIO, el archivo "ALUMNOS.dat" no contiene datos.');
		2: WriteLn('USUARIO, el archivo "ALUMNOS.dat" no existe.');
	End;
End;

Procedure ListaFACULTAD(var para_ALUM : ARCHALUM);
// Imprime la lista de alumnos por N.º de facultad.
Var
	ALUMNO : ALUMREG;
	i, COD, TOTAL, BUCLE : Integer;

Begin
	COD := 0;
	TOTAL := 0;
	Assign(para_ALUM, PATH_ALUM);
	Reset(para_ALUM);
	Read(para_ALUM, ALUMNO); 
	For i := 1 to 10 do
		Begin
			COD := ALUMNO.CODFAC;
			TOTAL := 0;
			BUCLE := 0;
			While (COD = i) and (BUCLE = 0) do // Bucle WHILE que impide que imprima infinitamente el título de la facultad, la variable BUCLE existe para ello.
				Begin
					WriteLn('FACULTAD N.º: ', i);
					BUCLE := 1;
				End;
			While COD = i do // Bucle WHILE que se ejecuta siempre que el código de la facultad del alumno sea igual a la variable de iteración del bucle FOR.
				Begin
					If not EOF(para_ALUM) then // Verifica si no se ha llegado al final del archivo "ALUMNOS.dat".
						Begin
							WriteLn('NOMBRE: ',ALUMNO.NOMBRE,'. N.º LIBRETA: ',ALUMNO.NUMLIB);
							TOTAL := TOTAL + 1;
							Read(para_ALUM, ALUMNO); // *1
							COD := ALUMNO.CODFAC;
						End
						Else // Si en el último Read *1, el puntero ha llegado al final del archivo, ejecuta este fragmento de código.
							Begin
								WriteLn('NOMBRE: ',ALUMNO.NOMBRE,'. N.º LIBRETA: ',ALUMNO.NUMLIB);
								TOTAL := TOTAL + 1;
								Break;
							End;
				End;
			If BUCLE = 1 then // Verifica el valor de BUCLE e imprime el total de alumnos de la facultad.
				Begin
					WriteLn('TOTAL DE ALUMNOS: ',TOTAL);
					WriteLn();
				End;
		End;
	Close(para_ALUM);
End;

Procedure AnalizarArchivo(var para_ALUM : ARCHALUM ; var para_ARRAY : Array of DINARRAY ; const para_DATORECORD : String);
// Inserta las posiciones de los registros de los alumnos en el archivo "ALUMNOS.dat" en diferentes arrays, dependiendo de los parámetros ingresados.
Var
	ALUMNO : ALUMREG;
	COD, FILEPOS, ARRAYPOS : Integer;

Begin
	COD := 0;
	FILEPOS := 0;
	ARRAYPOS := 0;
	Assign(para_ALUM, PATH_ALUM);
	Reset(para_ALUM);
	While not EOF(para_ALUM) do // Recorre el archivo 'ALUMNOS.dat' hasta el final.
		Begin
			Read(para_ALUM,ALUMNO);
			Case para_DATORECORD of // Dependiendo del parámetro ingresado, el valor insertado en COD será uno u otro.
				'CODCAR' : COD := ALUMNO.CODCAR;
				'ANIOCUR' : COD := ALUMNO.ANIOCUR;
				End;
			ARRAYPOS := Length(para_ARRAY[COD]); // Inserta en ARRAYPOS la cantidad de elementos del ARRAY dinámico indicado con COD.
			SetLength(para_ARRAY[COD],Length(para_ARRAY[COD]) + 1); // Aumenta en 1 la dimensión del ARRAY dinámico indicado con COD.
			para_ARRAY[COD,ARRAYPOS] := FILEPOS; // Inserta en el ARRAY dinámico indicado con COD y en la posición indicada por ARRAYPOS, la posición en la que se encuentra el registro del alumno dentro del archivo "ALUMNOS.dat".
			FILEPOS := FILEPOS + 1; // Aumenta el valor de FILEPOS en 1.
		End;
	Close(para_ALUM);
End;

Procedure ImprimirLista(var para_ALUM : ARCHALUM ; var para_ARRAY : Array of DINARRAY ; const para_DATORECORD : String ; const para_MOD : Integer);
// Imprime los datos de los alumnos de diferentes arrays, dependiendo de los parámetros ingresados.
Var
	ALUMNO : ALUMREG;
	i, j, TOTAL : Integer;

Begin
	TOTAL := 0;
	Assign(para_ALUM,PATH_ALUM);
	Reset(para_ALUM);
	For i := Low(para_ARRAY) + para_MOD to High(para_ARRAY) + para_MOD do // Bucle FOR que itera desde el principio hasta el final del ARRAY, con un modificador MOD de valor variable dependiendo de las dimensiones de cada ARRAY.
		Begin
			If Length(para_ARRAY[i]) > 0 then // Verifica que el ARRAY dinámico tenga elementos.
				Begin
					Case para_DATORECORD of // Dependiendo del parámetro ingresado, se imprime un título u otro.
						'CODCAR' : WriteLn('CARRERA N.º: ',i);
						'ANIOCUR' : WriteLn('ANIO N.º: ',i);
					End;
					For j := Low(para_ARRAY[i]) to High(para_ARRAY[i]) do // Bucle FOR que itera desde el principio hasta el final del ARRAY dinámico.
						Begin
							Seek(para_ALUM,para_ARRAY[i,j]); // Posiciona el puntero del archivo "ALUMNOS.dat" en la posición almacenada en el ARRAY dinámico.
							Read(para_ALUM,ALUMNO);
							WriteLn('NOMBRE: ',ALUMNO.NOMBRE,'. N.º LIBRETA: ',ALUMNO.NUMLIB);
						End;
					TOTAL := Length(para_ARRAY[i]); // Inserta en TOTAL la cantidad de elementos del ARRAY dinámico.
					WriteLn('TOTAL DE ALUMNOS: ',TOTAL); // Imprime el total de alumnos de esa categoría.
					WriteLn;
				End;
		End;
	Close(para_ALUM);
End;

// ============================================================================================
// Programa Principal
// ============================================================================================

Begin
	ConfirmarExistencia(ALUM,ERROR);
	If ERROR = 0 then // Verifica si ConfirmarExistencia no detectó errores
		Begin
			Close(ALUM);
			WriteLn('Bienvenido al creador de listas.');
			WriteLn;
			WriteLn('Pulse ENTER para mostrar la lista de alumnos por N.º de facultad.');
			ReadLn;
			Clrscr;
			ListaFACULTAD(ALUM);
			WriteLn;
			WriteLn('Pulse ENTER para mostrar la lista de alumnos por N.º de carrera.');
			ReadLn;
			Clrscr;
			AnalizarArchivo(ALUM,CARARRAY,'CODCAR');
			ImprimirLista(ALUM,CARARRAY,'CODCAR',10);
			WriteLn;
			WriteLn('Pulse ENTER para mostrar la lista de alumnos por ANIO.');
			ReadLn;
			Clrscr;
			AnalizarArchivo(ALUM,ANIOARRAY,'ANIOCUR');
			ImprimirLista(ALUM,ANIOARRAY,'ANIOCUR',1);
			WriteLn;
			WriteLn('Pulse ENTER para cerrar el programa.');
			ReadLn;
		End;
End.

{ DESARROLLADORES:
Arribas Clar, Santiago
Bartol Monje, Lautaro
Bellagamba, Julian
Idiarte, Leandro Ariel
Paul Rancez, Gastón
Torres, Juan Ignacio }
