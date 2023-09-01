Program InterseccionLegajo;
Uses
    Crt;

Type
    ARCH = File of Integer;
    ARREGLO = Array of Integer;

Const
    PATH_IP2 = 'IP2.dat'; // Direccion archivo "IP2.dat"
    PATH_CDC1 = 'CDC1.dat'; // Direccion archivo "CDC1.dat"
    PATH_INTER = 'INTER.dat'; // Direccion archivo "INTER.dat"

Var
    ARCHIP2, ARCHCDC1, ARCHINTER : ARCH;
    ARRAYENTERO : ARREGLO;
    ERROR : Integer;

Procedure ConfirmarExistencia (var para_ARCHIP2 : ARCH ; var para_ARCHCDC1 : ARCH ; var para_ERROR : Integer);
// Verifica si existen los archivos "IP2.dat" y "CDC1.dat", o si no poseen datos.
Var
		i : Integer;

Begin 
    para_ERROR := 0;
		i := 0;
    Assign(para_ARCHIP2, PATH_IP2);
    Assign(para_ARCHCDC1, PATH_CDC1);
    {$I-} // Deshabilitar deteccion de errores
    Reset(para_ARCHIP2);
    {$I+} // Habilitar deteccion de errores
    If IOResult <> 0 then // Si no existe, modifica el valor de la variable ERROR
    		para_ERROR := 1;
    {$I-}
    Reset(para_ARCHCDC1);
    {$I+}
    If IOResult <> 0 then //Si no existe, modifica el valor de la variable ERROR
    		para_ERROR := para_ERROR+2;
		{$I-}
  	Read(para_ARCHIP2,i);
    {$I+}
		If IOResult <> 0 then // Si no puede leer valores, modifica el valor de la variable ERROR
    		para_ERROR := para_ERROR+4;
		{$I-}
    Read(para_ARCHCDC1,i);
    {$I+}
    If IOResult <> 0 then // Si no puede leer valores, modifica el valor de la variable ERROR
    		para_ERROR := para_ERROR+5;
		Case para_ERROR of // Dependiendo del valor de ERROR, imprime un determinado mensaje de error
				4: WriteLn('USUARIO, el archivo "IP2.dat" no posee datos.');
				5: WriteLn('USUARIO, el archivo "IP2.dat" no existe o el archivo "CDC1.dat" no posee datos.');
				7: WriteLn('USUARIO, el archivo "CDC1.dat" no existe.');
				9: WriteLn('USUARIO, los archivos "IP2.dat" y "CDC1.dat" no poseen datos.');
				10: WriteLn('USUARIO, el archivo "IP2.dat" no existe y el archivo "CDC1" no posee datos.');
				11: WriteLn('USUARIO, el archivo "IP2.dat" no posee datos y el archivo "CDC1.dat" no existe.');
				12: WriteLn('USUARIO, los archivos "IP2.dat" y "CDC1.dat" no existen.');
				Else
		End;
End;

Procedure CompararLegajos(var para_ARCHIP2 : ARCH ; var para_ARCHCDC1 : ARCH ; var para_ARRAYENTERO : ARREGLO);
// Compara los archivos y busca numeros iguales, los cuales almacena en un array
Var
    NUMLEGAJO1, NUMLEGAJO2, i: Integer;

Begin
		i := 0;
		Assign(para_ARCHIP2, PATH_IP2);
    Assign(para_ARCHCDC1, PATH_CDC1);
    Reset(para_ARCHIP2);
    Reset(para_ARCHCDC1);
    Read(para_ARCHCDC1, NUMLEGAJO2); // Lee el primer valor del archivo "CDC.dat" y lo almacena en NUMLEGAJO02
    While not EOF(para_ARCHIP2) do // Bucle hasta llegar al final de "IP2.dat"
    Begin
        Read(para_ARCHIP2, NUMLEGAJO1); // Lee el primer valor del archivo "IP2.dat" y lo almacena en NUMLEGAJO01
        While (not EOF(para_ARCHCDC1)) and (NUMLEGAJO1 > NUMLEGAJO2) do // Bucle hasta llegar al final de "CDC.dat" y que NUMLEGAJO01 sea MENOR o IGUAL que NUMLEGAJO02
        Begin
            Read(para_ARCHCDC1, NUMLEGAJO2); // Guarda el valor en NUMLEGAJO02 y aumenta en uno su posicion
        End;
        If NUMLEGAJO1 = NUMLEGAJO2 Then
        Begin
            SetLength(para_ARRAYENTERO, i+1); // Aumenta las dimensiones del array en 1
            para_ARRAYENTERO[i] := NUMLEGAJO1; // Guarda la coincidencia en el ARRAYENTERO
            i:= i +1; // +1 a la variable auxiliar
        End;
    End;
    Close(para_ARCHIP2);
    Close(para_ARCHCDC1);
End;

Procedure GuardarArchivos(var para_ARCHINTER : ARCH ; var para_ARRAYENTERO : ARREGLO);
// Inserta los numeros del array en un nuevo archivo
Var
    LEGAJONUM, i : Integer;

Begin
		Assign(para_ARCHINTER, PATH_INTER);
    ReWrite(para_ARCHINTER); // Crea el archivo "INTER.dat"
		Reset(para_ARCHINTER);
    For i := 0 to High(para_ARRAYENTERO) do // Bucle desde 0 a la longitud del ARRAYENTERO
    Begin
        LEGAJONUM := para_ARRAYENTERO[i]; // Ingresa el valor del ARRAYENTERO en la variable LEGAJONUM
        Write(para_ARCHINTER, LEGAJONUM); // Escribe el valor de la variable LEGAJONUM en el archivo "INTER.dat"
    End;
    Close(para_ARCHINTER);
End;

Begin
    ConfirmarExistencia(ARCHIP2,ARCHCDC1,ERROR);
    If ERROR = 0 then // Verifica si ConfirmarExistencia no detecto errores
    Begin
				Close(ARCHIP2);
				Close(ARCHCDC1);
				CompararLegajos(ARCHIP2,ARCHCDC1,ARRAYENTERO);
        GuardarArchivos(ARCHINTER,ARRAYENTERO);
    End;
End.

{ DESARROLLADORES:
Arribas Clar, Santiago
Bartol Monje, Lautaro
Bellagamba, Julian
Idiarte, Leandro Ariel
Paul Rancez, Gastón }