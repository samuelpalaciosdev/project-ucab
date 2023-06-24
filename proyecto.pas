
Program proyectoProgram;

Uses crt;

Const 
  // Prueba
  NUM_MENUPRINCIPAL = 3;
  NUM_SUBMENU = 4;
  NUM_TUTORIAL = 3;

  // MAIN

  LIMITE = 30;
  LIMITE_ESTRELLAS = 15;
  CELDA = '#';
  PARED = '|';
  PISO = '_';
  PERSONAJEPOS = 'A';
  BANDERA = '~';
  BOMBA = 'D';
  STAR = 'E';
  // Caracteres Especiales
  ARRIBA = 72;
  ABAJO = 80;
  IZQUIERDA = 75;
  DERECHA = 77;
  ENTER = 13;
  ESC = 27;

  // FLECHAS
  FL_IZQ = 75;
  FL_DER = 77;
  FL_ABJ = 80;

  // Letras
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
  vectorString = array[1..LIMITE] Of string;
  mapa = array[1..LIMITE, 1..LIMITE] Of char;
  matriz = array[1..LIMITE_ESTRELLAS, 1..LIMITE_ESTRELLAS] Of Integer;

  Victoria = (sigue, gano);
  Estado = (archivoPrinc, randomPrinc, personalizadoPrinc);
  menuBoolean = (seguir, marchar);

  // Tipo de dato usado en varias keys del objeto
  coordenada = Record
    posicionX: Integer;
    posicionY: Integer;
  End;

  ArrayDinamico = Array[1..LIMITE_ESTRELLAS] Of coordenada;

  // Objeto donde se almacena toda la info del archivo
  dataMapa = Record
    plano: mapa;
    dimensiones: Record
      fil: Integer;
      col: Integer;
    End;
    naveT: vector;
    planetaT: vector;
    estrellas: Record
      cantidad: Integer;
      coordenadas: ArrayDinamico;
    End;
    destructores: Record
      cantidad: Integer;
      coordenadas: ArrayDinamico;
    End;
    estadoJuego: Estado;
  End;

  dataJuego = Record
    dataArchivo: dataMapa;
    dataRandom: dataMapa;
    dataPersonalizada: dataMapa;
  End;

Var 
  archivo: text;
  // Archivo
  baseArchivo: string;


  // Generador

Procedure Generador(Var estaDOCAMBIAELNOMBREDESTAMIERDAXDD: Estado; Var
                    cant: integer; Var param:
                    ArrayDinamico; fil, col: integer)
;

Var 
  i, j: integer;

Begin
  randomize;
  cant := random(10)+1;

  // Cono si es dificil vale = 4
  // Cono si es medio vale = 6
  // Cono si es facil vale = 8

  For i := 1 To cant Do
    Begin
      param[i].posicionX := random(fil)+1;
      param[i].posicionY := random(col)+1;

      writeln('Coordenada X: ', param[i].posicionX,
              ' Coordenada Y: ', param[i].posicionY);
    End;

End;


// ARCHIVOS
//
//















// Procedimiento reutilizable para leer info de las (ESTRELLAS Y DESTRUCTORES) del archivo
Procedure leerCantidadYCoordenadas(Var archivo: Text; Var cantidad: Integer;
                                   Var
                                   coordenadas: Array Of coordenada);

Var 
  i, cant_1, cant_2: Integer;
Begin













// Leer el primer numero de la cantidad de (estrellas o destructores) del archivo y comprobar si es > 10 o < 10
  // Nro < a 10 (0 n) (ej. 0 7) = 7
  Read(archivo, cant_1);
  If (cant_1 = 0) Then
    Begin
      Read(archivo, cantidad);
    End












// Nro > a 10 (1 n � 2 n) Agarra el primer nro de la linea y lo une con el sig (ej 1 5) = 15
  Else
    Begin
      Read(archivo, cant_2);
      cantidad := cant_1 * 10 + cant_2;
    End;














{ ---- Leer coordenadas de (estrellas o destructores), guarda la posicion de cada elemento como un
	       obj de coordenadas dentro de un array}
  For i := 1 To cantidad Do
    Begin
      Read(archivo, coordenadas[i].posicionX, coordenadas[i].posicionY);
    End;
End;


















// Mostrar cantidad y coordenadas Procedure reutilizable para (ESTRELLAS Y DESTRUCTORES)
Procedure MostrarCantidadYCoordenadas(cantidad: Integer; coordenadas: Array
                                      Of
                                      coordenada; mensaje: String);

Var 
  i: Integer;
Begin
  writeLn('Cantidad de ', mensaje, ': ', cantidad);
  writeln('Coordenadas de ', mensaje, ':');
  For i := 1 To cantidad Do
    Begin
      writeln(i, ': X=', coordenadas[i].posicionX, ', Y=', coordenadas[i].
              posicionY);
    End;
End;

// Leer Archivo Principal
Procedure leerArchivo(Var archivo: text; Var datosMapa: dataMapa);

Begin
  // Abrir archivo
  reset(archivo);
  // Guardar fila y columna en el objeto
  Read(archivo, datosMapa.dimensiones.fil, datosMapa.dimensiones.col);
  // Guardar posicion nave     (X,Y)
  Read(archivo, datosMapa.naveT[1], datosMapa.naveT[2]);
  // Guardar posicion planetaT (X,Y)
  Read(archivo, datosMapa.planetaT[1], datosMapa.planetaT[2]);

  // Guarda cantidad y coordenadas de estrellas
  leerCantidadYCoordenadas(archivo, datosMapa.estrellas.cantidad, datosMapa.
                           estrellas.coordenadas);
  // Guardar cantidad y coordenadas de destructores
  leerCantidadYCoordenadas(archivo, datosMapa.destructores.cantidad,
                           datosMapa.
                           destructores.coordenadas);

  Close(archivo);
End;

// Procesar datos del Archivo
// 

Procedure procesarArchivo(Var archivo: Text; Var datosMapa: dataMapa;
                          baseArchivo: String);
Begin
  Assign(archivo, baseArchivo);
  leerArchivo(archivo, datosMapa);
  writeLn('El valor de filas es ', datosMapa.dimensiones.fil,
          ' y de columnas ',
          datosMapa.dimensiones.col);
  writeLn('Las coordenadas de la nave son: ', datosMapa.naveT[1], ' y ',
          datosMapa.naveT[2]);
  writeLn('Las coordenadas de el planeta T son: ', datosMapa.planetaT[1],
          ' y ', datosMapa.planetaT[2]);
  MostrarCantidadYCoordenadas(datosMapa.estrellas.cantidad, datosMapa.
                              estrellas.
                              coordenadas, 'estrellas');
  MostrarCantidadYCoordenadas(datosMapa.destructores.cantidad, datosMapa.
                              destructores.coordenadas, 'destructores');
End;


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

// POR HACER RELLENO ESTATICO
// 
// 

Procedure relleno(Var terreno: mapa; Var data: dataMapa; Var nave, planeta:
                  vector; fil, col:
                  integer);

Var 
  i, j: integer;
  coordEst, coordDest: ArrayDinamico;

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

{Genero las posiciones de los destructores y estrellas}

  writeln('Estrellas: ');
  Generador(data.estadoJuego, data.estrellas.cantidad, data.estrellas.
            coordenadas, fil, col);
  writeln;
  writeln('Destructores: ');
  Generador(data.estadoJuego, data.destructores.cantidad, data.destructores.
            coordenadas, fil,
            col)
  ;

  coordEst := data.estrellas.coordenadas;
  coordDest := data.destructores.coordenadas;

  readkey;

  For i := 1 To fil Do
    For j:= 1 To col Do
      Begin
        If ((nave[1] = i) And (nave[2] = j) Or (planeta[1] = i) And (planeta
           [2]
           = j)) Then
          Begin
            If ((nave[1] = i) And (nave[2] = j)) Then
              terreno[i, j] := PERSONAJEPOS;

            If ((planeta[1] = i) And (planeta[2] = j)) Then
              terreno[i, j] := BANDERA;
          End
        Else
          terreno[i, j] := CELDA;

      End;

  // Estrellas
  For i := 1 To data.estrellas.cantidad Do
    terreno[coordEst[i].posicionX, coordEst[i].posicionY] := STAR;

  // Destructores
  For i:= 1 To data.destructores.cantidad Do
    terreno[coordDest[i].posicionX, coordDest[i].posicionY] := BOMBA;
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
  writeln('No dejes presionado ninguna tecla...');

  writeln;
  writeln('Presiona ESC para salir');
End;

{Aqui se desarrolla el bucle principal del juego}
//
//

Procedure Partida(Var terreno: mapa; Var data: dataMapa; nave, planeta:
                  vector;
                  fil, col, tecla:
                  integer);

Var 
  ch: char;
  desarrollo: Victoria;

Begin
  clrscr;

{Se declara la partida}
  desarrollo := sigue;

{Relleno el Mapa}
  relleno(terreno, data, nave, planeta, fil, col);


{Se lee el mapa inicial}
  leerMapa(terreno, nave, fil, col, 0);

{Bucle donde se desarollan los movimientos}

  Repeat
    Begin
      terreno[nave[1], nave[2]] := CELDA;
      ch := upcase(readkey);
      leerMapa(terreno, nave, fil, col, ord(ch));
      If ((nave[1] = planeta[1]) And (nave[2] = planeta[2])) Then
        desarrollo := gano;
    End;

  Until ((ord(ch) = ESC) Or (desarrollo = gano));


  {Victoria}
  If (desarrollo = gano) Then
    AnimacionGanar(desarrollo);

End;

// Animacion de los colores en los menus...

Procedure AnimacionMenu(activo, max: integer; Var menuVector: vectorString);

Var 
  i: integer;

Begin
  clrscr;

  writeln('---Bienvenido a L nave---');
  writeln;

  For i := 1 To max Do
    Begin
      textBackground(green);
      textcolor(red);
      If (i = activo) Then
        Begin
          textBackground(green);
          textColor(white);
        End;
      writeln(menuVector[i]);
    End;

End;

// Menu tutorial
Procedure menuTutorial(Var opc: integer; Var volver, salir: menuBoolean);

Var 
  keyPad: char;
  menuVector: vectorString;
  activo: integer;

Begin
  clrscr;

  // Inicializo variables
  activo := 1;
  keyPad := 'Q';

  // Booleanos del menu
  volver := seguir;
  salir := seguir;

  // Declarar las opciones
  menuVector[1] := 'Controles';
  menuVector[2] := 'Como funciona?';
  menuVector[3] := 'Volver';

  textBackground(Green);
  writeln('---L nave---');
  writeln;


  Repeat

    If ((ord(keyPad) = Q) Or (ord(keyPad) = DERECHA) Or (ord(keyPad) = D)) Then
      Begin
        AnimacionMenu(activo, NUM_TUTORIAL, menuVector);
        keyPad := 'a';
      End
    Else
      keyPad := upcase(readkey);

    Case ord(keyPad) Of 
      0:
         Begin
           keyPad := readkey;
           Case ord(keyPad) Of 
             ARRIBA:
                     Begin
                       If (activo > 1) Then
                         activo := activo -1;
                       AnimacionMenu(activo, NUM_TUTORIAL, menuVector);
                     End;
             ABAJO:
                    Begin
                      If (activo < 3) Then
                        activo := activo + 1;
                      AnimacionMenu(activo, NUM_TUTORIAL, menuVector);
                    End;
             DERECHA:
                      Begin
                        If (activo = 1) Then
                          Begin
                            clrscr;
                            writeln('Gud Lock');
                            readkey;
                          End;
                        If (activo = 2) Then
                          Begin
                            clrscr;
                            writeln('BUENA SUERTE');
                            readkey;
                          End;
                        If (activo = 3) Then
                          volver := marchar;
                      End;

             IZQUIERDA: volver := marchar;
           End;
         End;

      W:
         Begin
           If (activo > 1) Then
             activo := activo - 1;
           AnimacionMenu(activo, NUM_TUTORIAL, menuVector);
         End;

      S:
         Begin
           If (activo < 3) Then
             activo := activo + 1;
           AnimacionMenu(activo, NUM_TUTORIAL, menuVector);
         End;

      A: volver := marchar;

      ENTER, D:
                Begin
                  If (activo = 1) Then
                    Begin
                      clrscr;
                      writeln('Gud Lock');
                      readkey;
                    End;
                  If (activo = 2) Then
                    Begin
                      clrscr;
                      writeln('BUENA SUERTE');
                      readkey;
                    End;
                  If (activo = 3) Then
                    volver := marchar;
                End;
    End;

  Until (salir = marchar) Or (volver = marchar);
End;


// MENU JUGAR::

Procedure bloqueMenuJugar(Var data: dataMapa; Var plano: mapa; Var nave,
                          planeta
                          : vector; Var fil, col: integer);
Begin
  clrscr;
  Delay(300);

  fil := validarDim(fil, 'filas');
  col := validarDim(col, 'columnas');

  Partida(plano, data, nave, planeta, fil, col, 0);
End;

// Menu opcion jugar
Procedure menuJugar(Var data: dataJuego;
                    Var opc: integer;
                    Var volver, salir: menuBoolean);

Var 
  keyPad: char;
  menuVector: vectorString;
  activo: integer;

Begin

  clrscr;

  // Inicializo
  activo := 1;
  keyPad := 'Q';

  // Declarar booleanos del Menu
  volver := seguir;
  salir := seguir;

  // Declarar las opciones:

  menuVector[1] := 'Generar Mapa con Archivo';
  menuVector[2] := 'Mapa Personalizado';
  menuVector[3] := 'Mapa al Azar';
  menuVector[4] := 'Volver';

  textBackground(Green);
  writeln('---L nave---');
  writeln;

  Repeat

    If ((ord(keyPad) = Q) Or (ord(keyPad) = ESC) Or (ord(keyPad) = DERECHA) Or (
       ord(keyPad) = ENTER) Or (ord(keyPad) = D))
      Then
      Begin
        AnimacionMenu(activo, NUM_SUBMENU, menuVector);
        keyPad := '0';
      End
    Else
      keyPad := upcase(readkey);

    Case ord(keyPad) Of 
      0:
         Begin
           keyPad := readkey;
           Case ord(keyPad) Of 
             ARRIBA:
                     Begin
                       If (activo > 1) Then
                         activo := activo -1;
                       AnimacionMenu(activo, NUM_SUBMENU, menuVector);
                     End;
             ABAJO:
                    Begin
                      If (activo < 4) Then
                        activo := activo + 1;
                      AnimacionMenu(activo, NUM_SUBMENU, menuVector);
                    End;

             DERECHA:
                      Begin
                        If (activo = 1) Then
                          bloqueMenuJugar(data.dataArchivo, data.dataArchivo.
                                          plano,
                                          data.dataArchivo.naveT, data.
                                          dataArchivo.
                                          planetaT, data.dataArchivo.
                                          dimensiones
                                          .
                                          fil,
                                          data.dataArchivo.dimensiones.col);
                        If (activo = 2) Then
                          bloqueMenuJugar(data.dataPersonalizada, data.
                                          dataPersonalizada.plano,
                                          data.dataPersonalizada.naveT, data.
                                          dataPersonalizada.
                                          planetaT, data.dataPersonalizada.
                                          dimensiones.fil,
                                          data.dataPersonalizada.dimensiones.
                                          col
                          )
                        ;
                        If (activo = 3) Then
                          bloqueMenuJugar(data.dataRandom, data.dataRandom.
                                          plano
                                          ,
                                          data.dataRandom.naveT, data.
                                          dataRandom
                                          .
                                          planetaT, data.dataRandom.
                                          dimensiones.
                                          fil,
                                          data.dataRandom.dimensiones.col);
                        If (activo = 4) Then
                          volver := marchar;
                      End;

             IZQUIERDA: volver := marchar;
           End;

         End;

      W:
         Begin
           If (activo > 1) Then
             activo := activo - 1;
           AnimacionMenu(activo, NUM_SUBMENU, menuVector);
         End;


      S:
         Begin
           If (activo < 4) Then
             activo := activo + 1;
           AnimacionMenu(activo, NUM_SUBMENU, menuVector);
         End;

      A: volver := marchar;

      ENTER, D:
                Begin
                  If (activo = 1) Then
                    bloqueMenuJugar(data.dataArchivo, data.dataArchivo.
                                    plano,
                                    data.dataArchivo.naveT, data.
                                    dataArchivo.
                                    planetaT, data.dataArchivo.
                                    dimensiones
                                    .
                                    fil,
                                    data.dataArchivo.dimensiones.col);
                  If (activo = 2) Then
                    bloqueMenuJugar(data.dataPersonalizada, data.
                                    dataPersonalizada.plano,
                                    data.dataPersonalizada.naveT, data.
                                    dataPersonalizada.
                                    planetaT, data.dataPersonalizada.
                                    dimensiones.fil,
                                    data.dataPersonalizada.dimensiones.
                                    col
                    )
                  ;
                  If (activo = 3) Then
                    bloqueMenuJugar(data.dataRandom, data.dataRandom.
                                    plano
                                    ,
                                    data.dataRandom.naveT, data.
                                    dataRandom
                                    .
                                    planetaT, data.dataRandom.
                                    dimensiones.
                                    fil,
                                    data.dataRandom.dimensiones.col);
                  If (activo = 4) Then
                    volver := marchar;
                End;
    End;

  Until (volver = marchar) Or (salir = marchar);
End;

// Menu
Procedure Menu(Var data: dataJuego; Var opc: integer; Var volver, salir
               :
               menuBoolean)
;

Var 
  keyPad: char;
  menuVector: vectorString;
  activo: integer;

Begin

  clrscr;

  // Activo
  activo := 1;
  keyPad := 'Q';

  // Declarar booleanos del Menu
  volver := seguir;
  salir := seguir;

  // opciones del Menu
  menuVector[1] := 'Jugar';
  menuVector[2] := 'Tutorial';
  menuVector[3] := 'Salir';

  textBackground(Green);
  writeln('---Bienvenido a L nave---');
  writeln;
  writeln('Presiona cualquier tecla para comenzar...');

  readkey;

  Repeat

    If ((ord(keyPad) = IZQUIERDA) Or (ord(keyPad) = DERECHA) Or (ord(keyPad) =
       ENTER) Or (ord(keyPad) = Q) Or (ord(keyPad) = D)) Then
      Begin
        AnimacionMenu(activo, NUM_MENUPRINCIPAL, menuVector);
        keyPad := 'k';

      End
    Else
      keyPad := upcase(readkey);

    Case ord(keyPad) Of 

      0:
         Begin
           keyPad := readkey;
           Case ord(keyPad) Of 
             ARRIBA:
                     Begin
                       If (activo > 1) Then
                         activo := activo -1;
                       AnimacionMenu(activo, NUM_MENUPRINCIPAL, menuVector);
                     End;
             ABAJO:
                    Begin
                      If (activo < 3) Then
                        activo := activo + 1;
                      AnimacionMenu(activo, NUM_MENUPRINCIPAL, menuVector);
                    End;
             DERECHA:
                      Begin
                        If (activo = 1) Then
                          menuJugar(data, opc, volver, salir);
                        If (activo = 2) Then
                          menuTutorial(opc, volver, salir);
                        If (activo = 3) Then
                          salir := marchar;
                      End;
           End;

         End;

      W:
         Begin
           If (activo > 1) Then
             activo := activo - 1;
           AnimacionMenu(activo, NUM_MENUPRINCIPAL, menuVector);
         End;

      S:
         Begin
           If (activo < 3) Then
             activo := activo + 1;
           AnimacionMenu(activo, NUM_MENUPRINCIPAL, menuVector);
         End;

      ENTER, D:
                Begin
                  If (activo = 1) Then
                    menuJugar(data, opc, volver, salir);
                  If (activo = 2) Then
                    menuTutorial(opc, volver, salir);
                  If (activo = 3) Then
                    salir := marchar;
                End;

    End;

  Until (salir = marchar);

End;

Var 
  // Data Principal
  dataPrincipal: dataJuego;
  // Menu Opcion
  opc: Integer;
  // Menu
  salir, volver: menuBoolean;

Begin
  clrscr;

  // base archivo estatico
  baseArchivo := 'est.dat';

  // Paortida Completa
  Menu(dataPrincipal, opc, volver, salir);

End.
