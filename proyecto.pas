
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
  {Aqui esta el booleano de si la partida sigue o acaba porque llego al planeta}
  Victoria = (sigue, gano);

Procedure relleno(Var terreno: mapa; Var nave, planeta: vector; fil, col:
                  integer);

Var 
  i, j: integer;
Begin

  randomize;

{Randomizo la nave}
  nave[1] := random(fil)+1;
  nave[2] := random(col)+1;

{Randomizo el planeta}
  Repeat
    planeta[1] := random(fil)+1;
    planeta[2] := random(col)+1;
  Until ((planeta[1] <> nave[1]) Or (planeta[2] <> nave[2]));

  For i := 1 To fil Do
    Begin
      j := 1;
      For j:= 1 To col Do
        Begin
        {Posiciono la nave o el planeta en el terreno}
          If ((nave[1] = i) And (nave[2] = j) Or ((planeta[1] = i) And (planeta[
             2] = j))) Then
            Begin
            {Nave}
              If ((nave[1] = i) And (nave[2] = j)) Then
                terreno[i, j] := PERSONAJEPOS;
             {Planeta}
              If ((planeta[1] = i) And (planeta[2] = j)) Then
                terreno[i, j] :=  BANDERA;
            End
          Else
            terreno[i, j] := CELDA;
        End;
    End;
End;

// Funciones

Procedure Personaje(Var nave: vector; fil, col, tecla: integer);

Begin










{Aqui procedemos a modificar el vector de la nave de Posicion de X e Y dependiendo del ASCII}

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

// ANIMACIONES 

Procedure AnimacionGanar(desarrollo: Victoria);
Begin

  {Si el personaje llego a el planeta}
  If (desarrollo = gano) Then
    Begin
      clrscr;

      textcolor(red);
      writeln('!Ganaste!, Felicitaciones');

      writeln;
      writeln;

      readkey;

    End;

End;

// LEER EL MAPA FINAL PROCEDIMIENTO

Procedure leerMapa(Var terreno: mapa; Var nave: vector; fil, col, tecla
                   :
                   integer)
;

Var 
  i, j: integer;
Begin
  clrscr;

  writeln('!!Intenta encontrar el Planeta!!');
  writeln;

  {Procedo a mover el personaje}
  If (tecla > 0) Then
    Begin
      Personaje(nave, fil, col, tecla);
      terreno[nave[1], nave[2]] := PERSONAJEPOS;
    End;

  {Coloco las celdas}
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
  writeln('Presiona ESC para salir');
End;

{Aqui se desarrolla el bucle principal del juego}

Procedure Partida(Var terreno: mapa; nave, planeta: vector; fil, col, tecla:
                  integer);

Var 
  ch: char;
  desarrollo: Victoria;

Begin
{Se declara la partida}
  desarrollo := sigue;

{Se renderiza el mapa inicial}
  leerMapa(terreno, nave, fil, col, 0);

{Bucle donde se desarollan los movimientos}
  Repeat
    terreno[nave[1], nave[2]] := CELDA;
    ch := upcase(readkey);
    leerMapa(terreno, nave, fil, col, ord(ch));
    If ((nave[1] = planeta[1]) And (nave[2] = planeta[2])) Then
      desarrollo := gano;
  Until ((ord(ch) = ESC) Or (desarrollo = gano));


  {Victoria}
  If (desarrollo = gano) Then
    AnimacionGanar(desarrollo);

End;

// Muestra

Var 
  fil, col: integer;
  terreno: mapa;
  nave, planeta, destructor: vector;

Begin
  clrscr;

  fil := 8;
  col := 9;

{Inicializar las variables de la nave}
  nave[1] := 1;
  nave[2] := 1;

{Inicializar las variables de la bandera}
  planeta[1] := 1;
  planeta[2] := 2;

{Relleno del mapa}
  relleno(terreno, nave, planeta, fil, col);

{PARTIDA PRINCIPAL}
  Partida(terreno, nave, planeta, fil, col, 0);

End.
