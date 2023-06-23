
Program proyectoProgram;

Uses crt;

Const 
  LIMITE = 30;
  LIMITE_ESTRDEST = 15; // Limite estrellas y destructores 
  CELDA = '#';
  PARED = '|';
  PISO = '_';
  PERSONAJEPOS = 'A';
  BANDERA = '~';
  BOMBA = 'D';
  STAR = 'E';
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
  matriz = array[1..LIMITE_ESTRDEST, 1..LIMITE_ESTRDEST] Of Integer;

  Victoria = (sigue, gano);
  Estado = (archivoPrinc, randomPrinc, personalizadoPrinc);
  menuBoolean = (seguir, marchar);

  // Tipo de dato usado en varias keys del objeto
  coordenada = Record
    posicionX: Integer;
    posicionY: Integer;
  End;

  ArrayDinamico = Array[1..LIMITE_ESTRDEST] Of coordenada;

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

// Generador random de estrellas y destructores

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

// Menu tutorial
Procedure menuTutorial(Var opc: integer; Var volver, salir: menuBoolean);
Begin

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
      4: volver := marchar;
      5: salir := marchar;
      Else
        Begin
          writeLn('La opcion ', opc, ' no existe');
          readLn;
        End;
    End;
  Until (salir = marchar) Or (volver = marchar);
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

{ PASAR AL GENERADOR!!!!!!!!!!!!!
{Randomizo la nave}
  nave[1] := random(fil)+1; // X
  nave[2] := random(col)+1; // Y

{Randomizo el planeta}
  Repeat
    planeta[1] := random(fil)+1; // X
    planeta[2] := random(col)+1; // Y
  Until ((planeta[1] <> nave[1]) Or (planeta[2] <> nave[2]));
}
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
      Personaje(nave, fil, col, tecla); // Muevo el personaje
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
  leerMapa(terreno, nave, fil, col, 0); // El cero es para que no se mueva el personaje 

{Bucle donde se desarollan los movimientos}
// Regenera el mapa con cada movimiento
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

// MENU JUGAR::

Procedure bloqueMenuJugar(Var data: dataMapa; Var plano: mapa; Var nave, planeta
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

Begin

  Repeat
    clrscr;
    Delay(300);
    writeLn('---LE NAVE---');
    writeLn('Selecciona una de las siguientes modalidades de juego: ');
    writeLn('1. Generar mapa con archivo');
    writeln('2. Mapa personalizado');
    writeln('3. Mapa al azar');
    writeln('4. Volver');
    writeln('5. Salir');
    Readln(opc);
    Case opc Of 
      // 1: CREAR MAPA CON ARCHIVO FUNCTIONALITY ACA
      1:
         Begin
           bloqueMenuJugar(data.dataArchivo, data.dataArchivo.plano,
                           data.dataArchivo.naveT, data.dataArchivo.
                           planetaT, data.dataArchivo.dimensiones.fil,
                           data.dataArchivo.dimensiones.col);
         End;
      //  Personalizada
      2:
         Begin
           bloqueMenuJugar(data.dataPersonalizada, data.dataPersonalizada.plano,
                           data.dataPersonalizada.naveT, data.dataPersonalizada.
                           planetaT, data.dataPersonalizada.dimensiones.fil,
                           data.dataPersonalizada.dimensiones.col);
         End;
      // Random
      3:
         Begin
           bloqueMenuJugar(data.dataRandom, data.dataRandom.plano,
                           data.dataRandom.naveT, data.dataRandom.
                           planetaT, data.dataRandom.dimensiones.fil,
                           data.dataRandom.dimensiones.col);
         End;
      4: volver := marchar;
      5: salir := marchar;
      Else
        Begin
          writeLn('Error, la opcion', opc, ' no existe');
          readLn;
        End;
    End;
  Until (volver = marchar) Or (salir = marchar);
End;

// Menu
Procedure Menu(Var data: dataJuego; Var opc: integer; Var volver, salir:
               menuBoolean)
;

Begin

  // Declarar booleanos del Menu
  volver := seguir;
  salir := seguir;


  Repeat
    clrscr;
    writeln('---Bienvenido a L nave---');
    writeln('1. Jugar');
    writeln('2. Tutorial');
    writeln('3. Salir');
    readln(opc);
    writeLn;
    Case opc Of 
      1: menuJugar(data, opc, volver, salir);
      2: menuTutorial(opc, volver, salir);
      3: salir := marchar;
      Else
        Begin
          writeLn('Error, la opcion ', opc, ' no existe');
          Readln;
        End;
    End;
  Until (salir = marchar);

End;

Var 
  // Archivo
  archivo: text;
  baseArchivo: string;
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