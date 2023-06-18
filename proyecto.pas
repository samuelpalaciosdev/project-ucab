
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

Procedure relleno(Var terreno: mapa; nave: vector; fila, colum: integer);

Var 
  i, j: integer;
Begin

  randomize;

  nave[1] := random(fila)+1;
  nave[2] := random(colum)+1;

  For i := 1 To fila Do
    Begin
      j := 1;
      For j:= 1 To colum Do
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

Procedure Personaje(Var nave: vector; fila, colum, tecla: integer);

Var 
  i: integer;

Begin

  // Normales

  If ((tecla = W) And (nave[1] > 1)) Then
    nave[1] := nave[1] - 1;

  If ((tecla = S) And (nave[1] < fila)) Then
    nave[1] := nave[1] + 1;

  If ((tecla = A) And (nave[2] > 1)) Then
    nave[2] := nave[2] - 1;

  If ((tecla = D) And (nave[2] < colum)) Then
    nave[2] := nave[2] + 1;


  // Diagonales

  If ((tecla = Q) And (nave[1] > 1) And (nave[2] > 1)) Then
    Begin
      nave[1] := nave[1] - 1;
      nave[2] := nave[2] - 1;
    End;

  If ((tecla = E) And (nave[1] > 1) And (nave[2] < colum)) Then
    Begin
      nave[1] := nave[1] - 1;
      nave[2] := nave[2] + 1;
    End;

  If ((tecla = Z) And (nave[1] < fila) And (nave[2] > 1)) Then
    Begin
      nave[1] := nave[1] + 1;
      nave[2] := nave[2] - 1;
    End;

  If ((tecla = X) And (nave[1] < fila) And (nave[2] < colum)) Then
    Begin
      nave[1] := nave[1] + 1;
      nave[2] := nave[2] + 1;
    End;


End;

// LEER EL MAPA FINAL PROCEDIMIENTO

Procedure leerMapa(terreno: mapa; fila, colum: integer);

Var 
  i, j: integer;
Begin
  clrscr;

  writeln('!!Intenta encontrar el Planeta!!');
  writeln;

  // Colocar Celdas:

  For i := 1 To fila Do
    Begin
      j := 0;
      For j := 1 To colum Do
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

// Muestra

Var 
  fila, colum: integer;
  terreno: mapa;
  ch: char;
  nave: vector;

Begin
  clrscr;

  fila := 8;
  colum := 9;
  nave[1] := 1;
  nave[2] := 2;


  relleno(terreno, nave, fila, colum);
  Personaje(nave, fila, colum, 86);

  Repeat
    leerMapa(terreno, fila, colum);
    ch := readkey;
  Until (ord(ch) = ENTER);
End.
