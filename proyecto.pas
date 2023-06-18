
Program proyectoProgram;

Uses crt;

Const 
  LIMITE = 30;
  CELDA = '#';
  PARED = '|';
  PISO = '_';
  // Letras
  ENTER = 13;

Type 
  vector = array[1..LIMITE] Of integer;
  mapa = array[1..LIMITE, 1..LIMITE] Of char;
	
Var
  fil, col: Integer;

Function validarDim(n: Integer; mensaje: String):Integer;
Begin
   Repeat
	    Write('Indique la cantidad de ', mensaje, ' a ingresar: ');
			ReadLn(n);
			if (n < 0) or (n > LIMITE) Then
			   writeLn('Error, la cantidad de ', mensaje, ' debe estar comprendido entre 1 y ', LIMITE);
	 Until (n>=1) and (n<=LIMITE);

	 validarDim:= n;
End;	 

Procedure relleno(Var terreno: mapa; n: integer);

Var 
  i, j: integer;
Begin
  For i := 1 To n Do
    Begin
      j := 1;
      For j:= 1 To n Do
        Begin
          terreno[i, j] := CELDA;
        End;
    End;
End;

Procedure leerMapa(terreno: mapa; n: integer);

Var 
  i, j: integer;
Begin
  clrscr;

  writeln('!!Intenta encontrar el Planeta!!');
  writeln;

  // Colocar Celdas:

  For i := 1 To n Do
    Begin
      j := 0;
      For j := 1 To n Do
        Begin
          If ((j = 1) And (i < 10)) Then
            write(i, '  ', PARED, ' ');
          If ((j = 1) And (i >= 10)) Then
            write(i, ' ', PARED, ' ');
          write(terreno[i, j], ' ');
        End;
      writeln;

    End;

  // Muestra

  writeln;
  writeln('Presiona la letra para moverte: ');
  writeln;
  writeln('    ^       ^         ^');
  writeln('     \Q     W       E/');
  writeln('   <- A             D ->');
  writeln('       /Z         X\');
  writeln('      v      S      v');
  writeln('             v');

  writeln;
  writeln('Presiona ENTER para salir')

End;

Var 
  n: integer;
  terreno: mapa;
  ch: char;

Begin
  clrscr;

	// Pedir filas y columnas al usuario
	fil:= validarDim(fil, 'filas');
	col:= validarDim(col, 'columnas');

  n := 10;
  relleno(terreno, n);

  Repeat
    leerMapa(terreno, n);
    ch := readkey;
  Until (ord(ch) = ENTER);
End.