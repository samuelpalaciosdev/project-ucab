
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
  Victoria = (sigue, gano);

  // Funci�n que valida tanto filas como columnas
Function validarDim(n: Integer; mensaje: String): Integer;
Begin
  Repeat
    Write('Indique la cantidad de ', mensaje, ' a ingresar: ');
    ReadLn(n);
    If (n < 0) Or (n > LIMITE) Then
      writeLn('Error, la cantidad de ', mensaje,
              ' debe estar comprendido entre 1 y ', LIMITE);
  Until (n>=1) And (n<=LIMITE);

  validarDim := n;
End;

// Menu tutorial
Procedure menuTutorial(Var opc: integer; Var volver, salir: boolean);
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
    Case opc Of 
      1: writeLn('Los controles son...');
      2: writeLn('Como tu quieras');
      3: writeLn('No hay truquitos');
      4: volver := True;
      5: salir := True;
      Else
        Begin
          writeLn('La opcion ', opc, ' no existe');
          readLn;
        End;
    End;
  Until (salir) Or (volver);
End;


Procedure relleno(Var terreno: mapa; Var nave, planeta: vector; fil, col:
                  integer);

Var 
  i, j: integer;
Begin

  randomize;

  nave[1] := random(fil)+1;
  nave[2] := random(col)+1;
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
//
// 

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
//
//

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
//
//

Procedure Partida(Var terreno: mapa; nave, planeta: vector; fil, col, tecla:
                  integer);

Var 
  ch: char;
  desarrollo: Victoria;

Begin
  clrscr;

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

// MENU JUGAR::

// Menu opcion jugar
Procedure menuJugar(terreno: mapa; nave, planeta: vector; Var opc: integer;
                    Var volver, salir: boolean;
                    Var fil, col:
                    integer);


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
    Case opc Of 
      1:
         Begin
           Clrscr;
           Delay(300);
           fil := validarDim(fil, 'filas');
           col := validarDim(col, 'columnas');
           Partida(terreno, nave, planeta, fil, col, 0);
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
  Until (salir) Or (volver);
End;

// Muestra

Var 
  fil, col: integer;
  // Juego
  terreno: mapa;
  // MAPA SAMUEL
  ch: char;
  nave, planeta: vector;
  opc: Integer;
  // Menu
  salir, volver: Boolean;

Begin
  clrscr;
  salir := false;
  // Inicializando estados de salir y volver
  volver := false;


  fil := 8;
  col := 9;

{Inicializar las variables de la nave}
  nave[1] := 1;
  nave[2] := 2;

{Inicializar variables del planeta}
  planeta[1] := 1;
  planeta[2] := 2;


  Repeat
    clrscr;
    writeln('---Bienvenido a L nave---');
    writeln('1. Jugar');
    writeln('2. Tutorial');
    writeln('3. Salir');
    readln(opc);
    writeLn;
    Case opc Of 
      1: menuJugar(terreno, nave, planeta, opc, volver, salir, fil, col);
      2: menuTutorial(opc, volver, salir);
      3: salir := true;
      Else
        Begin
          writeLn('Error, la opcion ', opc, ' no existe');
          Readln;
        End;
    End;
  Until (salir);
End.
