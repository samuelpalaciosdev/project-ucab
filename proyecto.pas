
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
  ESC = 27;
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

Procedure relleno(Var terreno: mapa; Var nave: vector; fila, colum: integer);

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


{Aqui procedemos a modificar el vector de la nave de Posicion de X e Y dependiendo del ASCII}

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

Procedure leerMapa(Var terreno: mapa; Var nave: vector; fila, colum, tecla:
                   integer)
;

Var 
  i, j: integer;
Begin
  clrscr;

  writeln('!!Intenta encontrar el Planeta!!');
  writeln;

  // Movimiento del personaje:

  If (tecla > 0) Then
    Begin
      Personaje(nave, fila, colum, tecla);
      terreno[nave[1], nave[2]] := PERSONAJEPOS;
      writeln(nave[1], nave[2]);
    End;

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
  writeln('Presiona ESC para salir');
End;

// Aqui se desarrolla el bucle principal del juego

Procedure Partida(Var terreno: mapa; nave: vector; fila, colum, tecla: integer);
{Entero de la tecla}

Var 
  ch: char;

Begin

{Se renderiza el mapa inicial}
  leerMapa(terreno, nave, fila, colum, 0);

{Bucle para detectar los movimientos}
  Repeat
    terreno[nave[1], nave[2]] := CELDA;
    ch := upcase(readkey);
    leerMapa(terreno, nave, fila, colum, ord(ch));
  Until (ord(ch) = ESC);

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

  // Inicializar las variables de las naves
  nave[1] := 1;
  nave[2] := 1;

  relleno(terreno, nave, fila, colum);

  // Partida principal
  Partida(terreno, nave, fila, colum, 0);

End.
