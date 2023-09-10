Program InterseccionLegajo;
Uses
	Crt;

Type
	ARCH = File of Integer;
	ARREGLO = Array of Integer;

Const
	PATH_IP2 = 'IP2.dat'; // Ruta archivo "IP2.dat".
	PATH_CDC1 = 'CDC1.dat'; // Ruta archivo "CDC1.dat".
	PATH_INTER = 'INTER.dat'; // Ruta archivo "INTER.dat".

Var
	ARCHIP2, ARCHCDC1, ARCHINTER : ARCH;
	ARRAYENTERO : ARREGLO;
	ERROR : Integer;

// ============================================================================================
// Sección de Procedimientos
// ============================================================================================

Procedure ConfirmarExistencia (var para_ARCHIP2 : ARCH ; var para_ARCHCDC1 : ARCH ; var para_ERROR : Integer);
// Verifica si existen los archivos "IP2.dat" y "CDC1.dat", o si no contienen datos.
Var
	i : Integer;

Begin
	para_ERROR := 0;
	i := 0;
	Assign(para_ARCHIP2, PATH_IP2);
	Assign(para_ARCHCDC1, PATH_CDC1);
	{$I-} // Deshabilita la detección de errores.
	Reset(para_ARCHIP2);
	{$I+} // Habilita la detección de errores.
	If IOResult <> 0 then // Si no existen, modifica el valor de la variable ERROR.
		para_ERROR := 1;
	{$I-}
	Reset(para_ARCHCDC1);
	{$I+}
	If IOResult <> 0 then // Si no existen, modifica el valor de la variable ERROR.
		para_ERROR := para_ERROR + 2;
	{$I-}
	Read(para_ARCHIP2, i);
	{$I+}
	If IOResult <> 0 then // Si no se pueden leer valores, modifica el valor de la variable ERROR.
		para_ERROR := para_ERROR + 4;
	{$I-}
	Read(para_ARCHCDC1, i);
	{$I+}
	If IOResult <> 0 then // Si no se pueden leer valores, modifica el valor de la variable ERROR.
		para_ERROR := para_ERROR + 5;
	Case para_ERROR of // Dependiendo del valor de ERROR, imprime un mensaje de error específico.
		4: WriteLn('USUARIO, el archivo "IP2.dat" no contiene datos.');
		5: WriteLn('USUARIO, el archivo "IP2.dat" no existe o el archivo "CDC1.dat" no contiene datos.');
		7: WriteLn('USUARIO, el archivo "CDC1.dat" no existe.');
		9: WriteLn('USUARIO, los archivos "IP2.dat" y "CDC1.dat" no contienen datos.');
		10: WriteLn('USUARIO, el archivo "IP2.dat" no existe y el archivo "CDC1" no contiene datos.');
		11: WriteLn('USUARIO, el archivo "IP2.dat" no contiene datos y el archivo "CDC1.dat" no existe.');
		12: WriteLn('USUARIO, los archivos "IP2.dat" y "CDC1.dat" no existen.');
	End;
End;

Procedure CompararLegajos(var para_ARCHIP2 : ARCH ; var para_ARCHCDC1 : ARCH ; var para_ARRAYENTERO : ARREGLO);
// Compara los archivos y busca números iguales, los cuales almacena en un array.
Var
	NUMLEGAJO1, NUMLEGAJO2, i: Integer;

Begin
	i := 0;
	Assign(para_ARCHIP2, PATH_IP2);
	Assign(para_ARCHCDC1, PATH_CDC1);
	Reset(para_ARCHIP2);
	Reset(para_ARCHCDC1);
	Read(para_ARCHCDC1, NUMLEGAJO2); // Lee el primer valor del archivo "CDC.dat" y lo almacena en NUMLEGAJO2.
	While not EOF(para_ARCHIP2) do // Bucle hasta llegar al final de "IP2.dat".
		Begin
			Read(para_ARCHIP2, NUMLEGAJO1); // Lee el primer valor del archivo "IP2.dat" y lo almacena en NUMLEGAJO1.
			While (not EOF(para_ARCHCDC1)) and (NUMLEGAJO1 > NUMLEGAJO2) do // Bucle hasta llegar al final de "CDC.dat" y que NUMLEGAJO1 sea MENOR o IGUAL que NUMLEGAJO2.
				Begin
					Read(para_ARCHCDC1, NUMLEGAJO2); // Lee el valor del archivo "CDC1.dat" y lo guarda en NUMLEGAJO2, aumentando en uno la posicion del puntero.
				End;
			If NUMLEGAJO1 = NUMLEGAJO2 Then
				Begin
					SetLength(para_ARRAYENTERO, i + 1); // Aumenta las dimensiones del ARRAYENTERO en 1.
					para_ARRAYENTERO[i] := NUMLEGAJO1; // Guarda la coincidencia en el ARRAYENTERO.
					i := i + 1; // Incrementa el valor de la variable auxiliar (i) en 1.
				End;
		End;
	Close(para_ARCHIP2);
	Close(para_ARCHCDC1);
End;

Procedure GuardarArchivos(var para_ARCHINTER : ARCH ; var para_ARRAYENTERO : ARREGLO);
// Inserta los números del ARRAYENTERO en un nuevo archivo, "INTER.dat".
Var
	LEGAJONUM, i : Integer;

Begin
	Assign(para_ARCHINTER, PATH_INTER);
	ReWrite(para_ARCHINTER); // Crea el archivo "INTER.dat".
	Reset(para_ARCHINTER);
	For i := 0 to High(para_ARRAYENTERO) do // Bucle FOR desde 0 hasta la longitud del ARRAYENTERO.
		Begin
			LEGAJONUM := para_ARRAYENTERO[i]; // Inserta el valor del ARRAYENTERO en la variable LEGAJONUM.
			Write(para_ARCHINTER, LEGAJONUM); // Inserta el valor de LEGAJONUM en el archivo "INTER.dat".
		End;
	Close(para_ARCHINTER);
End;

// ============================================================================================
// Programa Principal
// ============================================================================================

Begin
	ConfirmarExistencia(ARCHIP2, ARCHCDC1, ERROR);
	If ERROR = 0 then // Verifica si ConfirmarExistencia no detectó errores.
		Begin
			Close(ARCHIP2);
			Close(ARCHCDC1);
			CompararLegajos(ARCHIP2, ARCHCDC1, ARRAYENTERO);
			GuardarArchivos(ARCHINTER, ARRAYENTERO);
		End;
End.

{ DESARROLLADORES:
Arribas Clar, Santiago
Bartol Monje, Lautaro
Bellagamba, Julian
Idiarte, Leandro Ariel
Paul Rancez, Gastón
Torres, Juan Ignacio }