Program proyectoProgram;

Uses crt;

Const
  LIMITE = 30;
  CELDA = '#';
  PARED = '|';
  PISO = '_';
  PERSONAJEPOS = 'A';
  BANDERA = '~';
  BOMBA = 'O';
  // Letras
  ENTER = 13;
  Q = 81;
  W = 87;
  E = 69;
  A = 65;
  S = 83;
  D = 68;
  Z = 90;
  X = 88;

Type
  vector = array[1..LIMITE] Of integer;
  mapa = array[1..LIMITE, 1..LIMITE] Of char;
  mapa2 = array[1..LIMITE, 1..LIMITE] Of Integer;    // MAPA SAMUEL

// Variables principales
Var
  fil, col: integer; // Juego
  terreno: mapa;
	terreno2: mapa2;   // MAPA SAMUEL
  ch: char;
	nave: vector;
	opc: Integer; // Menu
	salir, volver: Boolean;

// Función que valida tanto filas como columnas
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

procedure generarMapa(var terreno: mapa2; fil,col:integer);
var
  i,j:integer;
begin
  randomize;
  for i:=1 to fil do
     begin
       for j:=1 to col do
         begin
            terreno[i,j]:=random(9)+1;
         end;
     end;
end;

Procedure imprimirMapa(terreno: mapa2; fil, col:Integer);
Var
   i, j: Integer;
Begin

   for i:=1 to fil Do
	 Begin
	    for j:=1 to col Do
			Begin
			   write(terreno[i,j], ' ');
			End;
			writeLn;
	 End;
End;
			   

// Menu tutorial
Procedure menuTutorial;
Begin

  salir := false;
  volver := false;
  Repeat
	  clrscr;
	  Delay(300);
		writeLn('---Bienvenido al tutorial de LE NAVE---');
		writeLn('Selecciona una opcion: ');
		writeLn('1. Controles');
		writeLn('2. Como funciona?');
		writeLn('3. Truquitos');
		writeLn('4. Volver');
		writeLn('5. Salir');
		Readln(opc);
		case opc of
		  1: writeLn('Los controles son...');
			2: writeLn('Como tu quieras');
			3: writeLn('No hay truquitos');
			4: volver:= True;
			5: salir:= True;
			Else
			Begin
			  writeLn('La opcion ', opc, ' no existe');
				readLn;
			End;
		End;
	Until (salir) or (volver);
End;
// Menu opcion jugar
Procedure menuJugar;
Begin

  salir := false;
  volver := false;
  Repeat
	  clrscr;
		Delay(300);
		writeLn('---LE NAVE---');
		writeLn('Selecciona una de las siguientes modalidades de juego: ');
		writeln('1. Mapa personalizado');
    writeln('2. Mapa al azar');
    writeln('3. Volver');
    writeln('4. Salir');
    Readln(opc);
    case opc of
		  1: Begin
			      Clrscr;
						Delay(300);
				    fil:= validarDim(fil, 'filas');
						col:= validarDim(col, 'columnas');
						generarMapa(terreno2, fil,col);
						imprimirMapa(terreno2,fil,col);
						Readln;
			   End;
      2: writeln('Mapa al azar');
      3: volver := true;
      4: salir := true;
		  Else
			Begin
			   writeLn('Error, la opcion', opc, ' no existe');
				 readLn;
			End;
	  End;
	Until(salir) or (volver);
End;

Procedure relleno(Var terreno: mapa; nave: vector; fil, col: integer);

Var
  i, j: integer;
Begin

  randomize;

  nave[1] := random(fil)+1;
  nave[2] := random(col)+1;

  For i := 1 To fil Do
    Begin
      j := 1;
      For j:= 1 To col Do
        Begin
          If ((i = nave[1]) And (j = nave[2])) Then
            Begin
              terreno[i, j] := PERSONAJEPOS;
            End
          Else
            terreno[i, j] := CELDA;
        End;
    End;
End;

// Funciones

Procedure Personaje(Var nave: vector; fil, col, tecla: integer);

Var
  i: integer;

Begin

  // Normales

  If ((tecla = W) And (nave[1] > 1)) Then
    nave[1] := nave[1] - 1;

  If ((tecla = S) And (nave[1] < fil)) Then
    nave[1] := nave[1] + 1;

  If ((tecla = A) And (nave[2] > 1)) Then
    nave[2] := nave[2] - 1;

  If ((tecla = D) And (nave[2] < col)) Then
    nave[2] := nave[2] + 1;


  // Diagonales

  If ((tecla = Q) And (nave[1] > 1) And (nave[2] > 1)) Then
    Begin
      nave[1] := nave[1] - 1;
      nave[2] := nave[2] - 1;
    End;

  If ((tecla = E) And (nave[1] > 1) And (nave[2] < col)) Then
    Begin
      nave[1] := nave[1] - 1;
      nave[2] := nave[2] + 1;
    End;

  If ((tecla = Z) And (nave[1] < fil) And (nave[2] > 1)) Then
    Begin
      nave[1] := nave[1] + 1;
      nave[2] := nave[2] - 1;
    End;

  If ((tecla = X) And (nave[1] < fil) And (nave[2] < col)) Then
    Begin
      nave[1] := nave[1] + 1;
      nave[2] := nave[2] + 1;
    End;


End;

// LEER EL MAPA FINAL PROCEDIMIENTO

Procedure leerMapa(terreno: mapa; fil, col: integer);

Var
  i, j: integer;
Begin
  clrscr;

  writeln('!!Intenta encontrar el Planeta!!');
  writeln;

  // Colocar Celdas:

  For i := 1 To fil Do
    Begin
      j := 0;
      For j := 1 To col Do
        Begin
          If ((j = 1) And (i < 10)) Then
            write(i, '  ', PARED, ' ');
          If ((j = 1) And (i >= 10)) Then
            write(i, ' ', PARED, ' ');
          write(terreno[i, j], ' ');
        End;
      writeln;

    End;


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
  writeln('Presiona ENTER para salir');
End;

// PROGRAMA PRINCIPAL ------------------------------
Begin
  clrscr;
	salir:= false; // Inicializando estados de salir y volver
	volver:= false;

	{// Pedir filas y columnas al usuario
	fil:= validarDim(fil, 'filas');
	col:= validarDim(col, 'columnas');

  fil := 8;
  col := 9;
  nave[1] := 1;
  nave[2] := 2;


  relleno(terreno, nave, fil, col);
  Personaje(nave, fil, col, 86); }

 { Repeat
    leerMapa(terreno, fil, col);
    ch := readkey;
  Until (ord(ch) = ENTER);}

	// MENU PRINCIPAL

  Repeat
	   clrscr;
     writeln('---Bienvenido a L nave---');
     writeln('1. Jugar');
     writeln('2. Tutorial');
     writeln('3. Salir');
     readln(opc);
		 writeLn;
		 case opc of
		    1: menuJugar;
		    2: menuTutorial;
		    3: salir:= true;
				Else
				Begin
				   writeLn('Error, la opcion ', opc, ' no existe');
					 Readln;
				End;
		 End;
  Until(salir);
End.