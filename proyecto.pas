
Program proyectoProgram;

Uses crt;

Const 
  // Prueba
  NUM_MENUPRINCIPAL = 3;
  NUM_SUBMENU = 4;
  NUM_TUTORIAL = 3;
  // MAIN
  LIMITE = 15;
  LIMITE_PERSONALIZADO = 15;
  // LIMITE_ELEMENTOS = 10;
  LIMITE_ELEMENTOS = 10;
  LIMITE_MOVIMIENTOS = 200;
  MOVIMIENTOS_MAXIMO = 8;
  CELDA = '.';
  PARED = '|';
  PISO = '_';
  PERSONAJEPOS = 'A';
  BANDERA = '#';
  BOMBA = 'D';
  STAR = 'E';
  POSMOV = '?';
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

  // Colores
  AZUL = 1;
  VERDE = 3;
  ROJO = 4;
  MORADO = 5;
  FONDO = 7;
  COLOR_NORMAL = 8;
  TURQUESA = 9;
  BLANCO = 15;

Type 
  vector = Array[1..LIMITE] Of Integer;
  vectorString = Array[1..LIMITE] Of String;
  mapa = Array[1..LIMITE, 1..LIMITE] Of Char;
  matriz = Array[1..LIMITE_ELEMENTOS, 1..LIMITE_ELEMENTOS] Of Integer;
  Victoria = (sigue, gano, perder, navePerdida, abandono);
  TipoGeneracionMapa = (TipoArchivo, TipoAleatorio, TipoPersonalizado);
  menuBoolean = (seguir, marchar);
  // Tipo de dato usado en varias keys del objeto
  coordenada = Record
    posicionX: Integer;
    posicionY: Integer;
  End;
  // Array de ordenadas
  ArrayDinamico = Array[1..LIMITE_ELEMENTOS] Of coordenada;

  // Array De movimientos
  ArrayMovimientos = Array[1..8] Of string;

  // Array de historial de movimientos
  ArrayHistorialMovimientos = Array[1..LIMITE_MOVIMIENTOS] Of Coordenada;

  // Objeto donde se almacena toda la info del archivo
  dataMapa = Record
    archivoValidado: boolean;
    contErrores: Integer;
    score: Integer;
    contadorMovimientos: Integer;
    historialMovimientos: ArrayHistorialMovimientos;
    // HistorialMovimientos[contadorMovimientos] := nave[1],nave[2]
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
    tipoMapa: TipoGeneracionMapa;
  End;
  dataJuego = Record
    dataArchivo: dataMapa;
    dataRandom: dataMapa;
    dataPersonalizada: dataMapa;
  End;

  // VARIABLES ARCHIVO

Var 
  entrada, salida: Text;
  rutaArchivoEntrada, rutaArchivoSalida: String;
  validadorIndividual: boolean;

Function validarElemento(elemento: Integer; lim: integer; mensaje: String): Boolean;

Var 
  elementoValido: Boolean;
Begin

  elementoValido := True;

  If (elemento < 1) Or (elemento > lim) Then
    Begin
      writeLn('Error, el valor de ', mensaje, ' debe estar comprendida entre 1 y ', lim);
      elementoValido := False;
    End;

  validarElemento := elementoValido;
End;

// Procedimiento reutilizable para mostrar la cantidad y las coordenadas de las estrellas y destructores

Procedure MostrarCantidadYCoordenadas(cantidad: Integer; coordenadas:
                                      ArrayDinamico; validadorIndividual: Boolean;mensaje: String);

Var 
  i: Integer;
Begin
  Writeln('Cantidad de ', mensaje, ': ', cantidad);
  // Mostrar la cantidad de estrellas o destructores
  Writeln('Coordenadas de ', mensaje, ':');
  // Mostrar las coordenadas de estrellas o destructores
  If (validadorIndividual = true) Then
    Begin
      For i := 1 To cantidad Do
        Begin
          Writeln(i, ': X=', coordenadas[i].posicionX, ', Y=', coordenadas[i].
                  posicionY);
          // Mostrar las coordenadas de cada elemento
        End;
    End;
End;

Procedure bloqueDestructores(Var destructores: ArrayDinamico; niveles: integer; tipo: TipoGeneracionMapa; nave, planeta: vector; fil, col: Integer; Var cantDestructores: Integer);

Var 
  i, promedio: integer;

Begin

  randomize;

  niveles := niveles - 2;

  // Determino la cantidad de destructores
  promedio := (fil+col) Div 2;

  // Generacion de destructores dependiendo del nivel

  If (niveles >= 3) Then
    cantDestructores := (promedio Div 2)+(niveles)
  Else
    cantDestructores := (promedio Div 2)-2;


  For i:= 1 To cantDestructores Do
    Begin
      Repeat

        // Destructor junto del 1ro

        If (i = 1) Then
          Begin
            Repeat
              destructores[i].posicionX := Random(fil-6)+4;
              destructores[i].posicionY := Random(col-6)+4;
            Until (Abs(destructores[i].posicionX - fil) > 2) And (Abs(destructores[i].posicionY - col) > 2);
          End

          // Destructor junto del 1ro
        Else If (i = 2) Then
               Begin
                 destructores[i].posicionX := destructores[1].posicionX + 1;
                 destructores[i].posicionY := destructores[1].posicionY;
               End

               // Destructor junto del 1ro
        Else If (i = 3) Then
               Begin
                 destructores[i].posicionX := destructores[1].posicionX;
                 destructores[i].posicionY := destructores[1].posicionY - 1;
               End
               //  Demas destructores despues de los 3 primeros
        Else
          Begin
            Repeat

              destructores[i].posicionX := Random(fil)+1;
              destructores[i].posicionY := Random(col)+1;

              // Este condicional me evita un posible destructor detras del planeta
              If (destructores[i].posicionX = 1) And ((destructores[i].posicionY = (planeta[2]-1)) Or (destructores[i].posicionY = (planeta[2]+1))) Then
                destructores[i].posicionX := destructores[i].posicionX + 3;

            Until (Abs(destructores[i].posicionX - fil) > 1) And (Abs(destructores[i].posicionY - col) > 1);
          End;

      Until ((destructores[i].posicionX <> nave[1]) Or (destructores[i].posicionY <> nave[2])
            ) And ((destructores[i].posicionX <> planeta[1]) Or (destructores[i].posicionY <>
            planeta[2]));
    End;
  Writeln;
  Writeln('Cargando...');
  Delay(400);
  writeln;
  Writeln('!Presiona para jugar!');
  readkey;
End;

// Bloque del generador de estrellas (No repetir codigo)
Procedure bloqueEstrellas(Var estrella: ArrayDinamico; niveles: integer; tipo: TipoGeneracionMapa;
                          nave, planeta: vector; fil
                          , col: Integer; Var cantEstrellas: Integer);

Var 
  i, promedio, estrellaPlaneta, difDiagIzquierda: Integer;
Begin
  Randomize;

  // Determino la cantEstrellas de estrellas en el mapa con la formula Magica
  promedio := (fil+col) Div 2;

  // Generacion de estrellas dependiendo del nivel
  If (niveles >= 3) Then
    Begin
      cantEstrellas := (promedio Div 2);
    End
  Else
    cantEstrellas := ((promedio Div 2)+3)-(niveles);


  // estrellaPlaneta si es 1 = diagonal Arriba izquierda del planeta
  // estrellaPlaneta si es 2 = diagonal Arriba derecha del planeta
  estrellaPlaneta := Random(2)+1;

  For i := 1 To cantEstrellas Do
    Begin
      Repeat

        // Condicional de la estrella detras del planeta

        If (i = 1) Then
          Begin
            estrella[i].posicionX := 1;
            If (estrellaPlaneta = 1) Then
              estrella[i].posicionY := planeta[2]-1;

            If (estrellaPlaneta = 2) Then
              estrella[i].posicionY := planeta[2]+1;
          End

        Else If (i = 2) Then
               Begin

                 // Diagonal Estrella derecha
                 If (estrellaPlaneta = 1) Then
                   Begin
                     //  Lo que le falta a la Y para llegar a la columna
                     difDiagIzquierda := col - nave[2];

                     //  En caso de que la difDiagIzquierda sea mayor que la nave[1] (Habria un conflicto al no tener los suficientes movimientos)
                     If (difDiagIzquierda >= nave[1]) Then
                       Begin
                         estrella[i].posicionX := nave[1] - (nave[1] - 1);
                         estrella[i].posicionY := nave[2] + (nave[1] - 1);
                       End;

                     // En caso de que difDiagIzquierda sea menor que la nave[1] (Habrian suficientes movimientos para poder restar DifDiagIzquierda)
                     If (difDiagIzquierda < nave[1]) Then
                       Begin
                         estrella[i].posicionX := nave[1] - difDiagIzquierda;
                         estrella[i].posicionY := nave[2] + difDiagIzquierda;
                       End;
                   End;

                 // Diagonal estrella Izquierda

                 If (estrellaPlaneta = 2) Then
                   Begin
                     // Si X es mayor a Y en la nave
                     If (nave[1] > nave[2]) Then
                       Begin
                         estrella[i].posicionX := nave[1] - (nave[2] - 1);
                         estrella[i].posicionY := nave[2] - (nave[2] - 1);
                       End;


                     // Si Y es mayor a X en la nave
                     If (nave[2] > nave[1]) Then
                       Begin
                         estrella[i].posicionX := nave[1] - (nave[1] - 1);
                         estrella[i].posicionY := nave[2] - (nave[1] - 1);
                       End;

                     // Si X es igual a Y 
                     If (nave[1] = nave[2]) Then
                       Begin
                         estrella[i].posicionX := nave[1] - (nave[1] - 1);
                         estrella[i].posicionY := nave[2] - (nave[2] - 1);
                       End;

                   End;
               End

               // Estrella en la misma columna que el planeta

        Else If (i = 3) Then
               Begin
                 estrella[i].posicionX := planeta[1];
                 Repeat
                   If (estrellaPlaneta = 1) Then
                     estrella[i].posicionY := random(col-planeta[2])+planeta[2];

                   If (estrellaPlaneta = 2) Then
                     estrella[i].posicionY := random(planeta[2])+1;

                   // No quiero que este en la misma posicion que el planeta y una diferencia considerable entre las mismas
                 Until (estrella[i].posicionY <> planeta[2]) And (Abs(estrella[i].posicionY - planeta[2]) > 1);
               End

        Else
          Begin
            estrella[i].posicionX := Random(fil)+1;
            estrella[i].posicionY := Random(col)+1;

            // Hacer el intento que las estrellas randomizadas no coincidan con el camino de la diagonal de la estrella[2] y la estrella[1]
            If (Abs(estrella[2].posicionX - estrella[i].posicionX) = Abs(estrella[2].posicionY - estrella[i].posicionY)) Or (Abs(estrella[1].posicionX - estrella[i].posicionX) =
               Abs(estrella[1].posicionY - estrella[i].posicionY)) Then
              Begin
                // En caso de que la columna sea mayor a 3 la muevo 2 posiciones hacia la izquierda
                If (estrella[i].posicionY > 3) Then
                  estrella[i].posicionY := estrella[i].posicionY - 2
                Else
                  estrella[i].posicionY := estrella[i].posicionY + 2;
              End;

            // En caso de que la estrella[i] este muy cerca de estrella[2]
            If (Abs(estrella[2].posicionX - estrella[i].posicionX) <= 1) Then
              Begin
                // En caso de que la fila sea mayor a 3 la muevo 2 posiciones hacia la izquierda

                If (estrella[i].posicionY > 3) Then
                  estrella[i].posicionY := estrella[i].posicionY - 2
                Else
                  estrella[i].posicionY := estrella[i].posicionY + 2;
              End;

            // En caso de que hayan varias estrellas[i] en la fila columna del planeta

            If (planeta[1] = estrella[i].posicionX) Then
              Begin
                estrella[i].posicionX := estrella[i].posicionX + 2;
              End;

          End;
        // el condicional para romper el bucle verifica si las estrellas estan encima del planeta y/o la nave
      Until ((estrella[i].posicionX <> nave[1]) Or (estrella[i].posicionY <> nave[2])
            ) And ((estrella[i].posicionX <> planeta[1]) Or (estrella[i].posicionY <>
            planeta[2]));
    End;
End;
// Generador
Procedure Generador(Var data: dataMapa; Var tipo:TipoGeneracionMapa; Var nave,
                    planeta: vector;
                    Var cant, cant2: Integer; Var param1, param2: ArrayDinamico;
                    fil, col: Integer);

Var 
  i, j: Integer;
Begin
  Randomize;
  If ((tipo = TipoPersonalizado) Or (tipo = TipoAleatorio)) Then
    Begin

      // ---- Randomizar la posicion X,Y de la  nave

      // Va a agarrar la penultima o la ultima fila la posicion en X de la nave
      nave[1] := Random(2)+(fil-1);

      // Randomizar la posicion en Y de la de la nave, no puede tocar ningun extremo
      Repeat
        nave[2] := Random(col-4)+3;
      Until (nave[2] <> col) And (Abs(nave[2] - col) > 2);

      // ---- Randomizar la posición X,Y del planeta
      Repeat
        // Posiciono el planeta en la 2da fila
        planeta[1] := 2;
        // Asegurar que el planeta no toque ningun extremo de la columna
        Repeat
          planeta[2] := Random(col-4)+3;
        Until (planeta[2] <> col) And (Abs(planeta[2] - col) > 2);
        // Y
      Until ((planeta[1] <> nave[1]) Or (planeta[2] <> nave[2]));
      // Planeta y nave no pueden estar en la misma celda

   { Si es tipo aleatorio se puede hacer 2 llamadas a la funcion del bloque de una vez para que genere
		 las coordenadas de destructores y estrellas sin problema }
      If ((tipo = tipoAleatorio) Or (tipo = tipoPersonalizado)) Then
        Begin
          bloqueEstrellas(param1, data.score, tipo, nave, planeta, fil, col, cant);
          bloqueDestructores(param2, data.score, tipo, nave, planeta, fil, col, cant2);
        End;
    End;
End;
// ARCHIVOS
//

// Procedimiento reutilizable para leer la cantidad y las coordenadas de las estrellas y destructores desde un archivo
Procedure leerCantidadYCoordenadas(Var entrada: Text; Var cantidad: Integer; Var
                                   coordenadas: ArrayDinamico; fil, col: integer; Var validadorIndividual: Boolean; mensaje: String);

Var 
  i, cant_1, cant_2: Integer;
  // Cantidad
  contCoordenadasQueFaltan: Integer;
  // Condicional si cantidad > nrodecoordenadas dado
  singular: String;
Begin

  validadorIndividual := true;
  // Inicializar en true
  contCoordenadasQueFaltan := 0;

  // Convertidor de mensaje a singular
  If (mensaje = 'estrellas') Then
    singular := 'estrella'
  Else If (mensaje = 'destructores') Then
         singular := 'destructor';


  // Leer el primer numero de la cantidad de estrellas o destructores del archivo de entrada y comprobar si empieza con 0
  // El 0 como primer caracter de la linea denota cantidad y el segundo numero seria el valor de la cantidad

  // Agarra el primer numero de la linea
  Read(entrada, cant_1);
  // Verifica si es 0
  If (cant_1 = 0) Then
    Begin
      Read(entrada, cantidad);
      // Guarda el siguiente numero como la cantidad
    End
    // Si el primer numero no es 0, no denota cantidad
  Else
    validadorIndividual := false;

  // Asegurar que la cantidad esté entre el limite
  If (cantidad < 1) Or (cantidad > LIMITE_ELEMENTOS) Then
    Begin
      writeLn('Cantidad invalida de ', mensaje, ', debe estar entre 1 y ', LIMITE_ELEMENTOS);
      validadorIndividual := false;
    End;

  If (validadorIndividual = true) Then
    Begin
      // Rellena las posiciones faltantes en el array de coordenadas con ceros
      For i:= (cantidad + 1) To LIMITE_ELEMENTOS Do
        Begin
          coordenadas[i].posicionX := 5;
          coordenadas[i].posicionY := 5;
        End;
    End;

 {Leer las coordenadas de las estrellas o destructores y guarda la posicion de cada elemento
  como un objeto de coordenadas dentro de un array}
  If (validadorIndividual = true) Then
    Begin
      For i := 1 To cantidad Do
        Begin
          // Guarda las coordenadas X y Y en el array de objetos de tipo coordenada
          Read(entrada, coordenadas[i].posicionX, coordenadas[i].posicionY);

          // Si la coordenada x es 0 denota una cantidad
          If (coordenadas[i].posicionX = 0) And (coordenadas[i].posicionY <> 0)  Then
            Begin
              writeLn('Error, valor de posicion X (0) de ',singular,' en la posicion ',i, ' hace referencia a una cantidad ');
              validadorIndividual := false;
            End;

          // Si se dio una cantidad mayor al nro de coordenadas dado (se pone coordenadas x=0 y=0)
          If (coordenadas[i].posicionX = 0) And (coordenadas[i].posicionY = 0)  Then
            Begin
              contCoordenadasQueFaltan := contCoordenadasQueFaltan + 1;
              validadorIndividual := false;
            End;

          // ---- Validar coordenadas
          // Si la coordenada X es invalida
          If (coordenadas[i].posicionX < 1) Or (coordenadas[i].posicionX > fil) Then
            Begin
              writeLn('Error, valor de posicion X (', coordenadas[i].posicionX,') de ', singular,' en la posicion ', i ,' es invalido');
              validadorIndividual := false;
            End;
          // Si la coordenada Y es invalida
          If (coordenadas[i].posicionY < 1) Or (coordenadas[i].posicionY > col) Then
            Begin
              writeLn('Error, valor de posicion Y (', coordenadas[i].posicionY,') de ', singular,' en la posicion ', i ,' es invalido');
              validadorIndividual := false;
            End;
        End;

      // Imprimir cuantas coordenadas faltan (en caso de que falten)
      If (contCoordenadasQueFaltan > 0) Then
        Begin
          writeLn('Error, faltan ', contCoordenadasQueFaltan, ' coordenadas ', mensaje, ', se esperaban ', cantidad,
                  ' y solo hay ', (cantidad - contCoordenadasQueFaltan));
        End;
    End;
End;

// Leer archivo de entrada (guardar su data en el objeto de tipo dataMapa)
Procedure leerArchivo(Var entrada: Text; Var datosMapa: dataMapa; Var archivoValidado: boolean);
{
Var
  validadorIndividual: boolean;}

Begin

  archivoValidado := true;
  // Abrir archivo
  Reset(entrada);
  // Guardar fila y columna en el objeto
  Read(entrada, datosMapa.dimensiones.fil, datosMapa.dimensiones.col);
  // Validar fila y columna
  validadorIndividual := validarELemento(datosMapa.dimensiones.fil, LIMITE, 'las filas');

  If (validadorIndividual = false) Then
    archivoValidado := false;
  // Debe guardarse en una booleana
  validadorIndividual := validarELemento(datosMapa.dimensiones.col, LIMITE, 'las columnas');


  If (validadorIndividual = false) Then
    archivoValidado := false;
  // Debe guardarse en una booleana 
  // Guardar posicion nave     (X,Y)
  Read(entrada, datosMapa.naveT[1], datosMapa.naveT[2]);
  // Validar posicion X,Y nave
  validadorIndividual := validarELemento(datosMapa.naveT[1], datosMapa.dimensiones.fil, 'la posicion en X de la nave');

  If (validadorIndividual = false) Then
    archivoValidado := false;
  // Debe guardarse en una booleana
  validadorIndividual := validarELemento(datosMapa.naveT[2], datosMapa.dimensiones.col, 'la posicion en Y de la nave');


  If (validadorIndividual = false) Then
    archivoValidado := false;
  // Debe guardarse en una booleana 
  // Guardar posicion planetaT (X,Y)
  Read(entrada, datosMapa.planetaT[1], datosMapa.planetaT[2]);
  // Validar posicion X,Y planeta
  validadorIndividual := validarELemento(datosMapa.planetaT[1], datosMapa.dimensiones.fil, 'la posicion en X del planeta');

  If (validadorIndividual = false) Then
    archivoValidado := false;
  // Debe guardarse en una booleana
  validadorIndividual := validarELemento(datosMapa.planetaT[2], datosMapa.dimensiones.col, 'la posicion en Y del planeta');

  If (validadorIndividual = false) Then
    archivoValidado := false;
  // Debe guardarse en una booleana
  // Guarda cantidad y coordenadas de estrellas
  leerCantidadYCoordenadas(entrada, datosMapa.estrellas.cantidad, datosMapa.
                           estrellas.coordenadas, datosMapa.dimensiones.fil, datosMapa.dimensiones.col,
                           validadorIndividual, 'estrellas');


  If (validadorIndividual = false) Then
    archivoValidado := false;


  // Guardar cantidad y coordenadas de destructores
  If Not (eof(entrada)) Then
    Begin
      leerCantidadYCoordenadas(entrada, datosMapa.destructores.cantidad, datosMapa.
                               destructores.coordenadas, datosMapa.dimensiones.fil, datosMapa.dimensiones.col,
                               validadorIndividual, 'destructores');

      If (validadorIndividual = false) Then
        archivoValidado := false;
    End;

  // Cerrar archivo
  Close(entrada);
End;

// Procesar datos del archivo de entrada
Procedure procesarArchivoEntrada(Var entrada: Text; Var datosMapa: dataMapa;
                                 rutaArchivoEntrada: String);

Var 
  i: Integer;
Begin
  // Asignar la variable archivo al archivo en la ruta (rutaArchivoEntrada)
  Assign(entrada, rutaArchivoEntrada);
  // Extraer los datos del archivo y almacenarlos en el objeto "datosMapa"
  leerArchivo(entrada, datosMapa, datosMapa.archivoValidado);
  // Mostrar info del archivo de entrada
  Writeln('El valor de filas es ', datosMapa.dimensiones.fil,' y de columnas ',
          datosMapa.dimensiones.col);
  Writeln('Las coordenadas de la nave son: ', datosMapa.naveT[1], ' y ',
          datosMapa.naveT[2]);
  Writeln('Las coordenadas de el planeta T son: ', datosMapa.planetaT[1],' y ',
          datosMapa.planetaT[2]);
  MostrarCantidadYCoordenadas(datosMapa.estrellas.cantidad, datosMapa.estrellas.
                              coordenadas, validadorIndividual,'estrellas');
  MostrarCantidadYCoordenadas(datosMapa.destructores.cantidad, datosMapa.
                              destructores.coordenadas, validadorIndividual,'destructores');
  Delay(300);
  Writeln;

  If (datosMapa.archivoValidado) Then
    Writeln('Presiona para jugar si estas listo...')
  Else
    writeln('Error, ingresa los datos bien en el archivo.');
  Writeln;
  Readkey;
End;

// Historial de Movimientos del personaje

Procedure agregarAlHistorialDeMovimientos(nave: vector; Var historialMov:
                                          ArrayHistorialMovimientos; Var contMov
                                          :Integer);
Begin

  // [{X,Y}]



  // Como contMov empieza en 1, Si todavía no se ha movido, guardar esa como la posicion inicial
  If (contMov = 1) Then
    Begin
      historialMov[contMov].PosicionX := nave[1];
      historialMov[contMov].PosicionY := nave[2];
      contMov := contMov + 1;
    End;



  // Si alguna de las coordenadas (X o Y) son distintas (es un movimiento valido)
  If (nave[1] <> historialMov[contMov - 1].posicionX)Or (nave[2]<> historialMov[
     contMov - 1].posicionY) Then
    Begin
      historialMov[contMov].PosicionX := nave[1];
      historialMov[contMov].PosicionY := nave[2];
      contMov := contMov + 1;
    End;
End;

Procedure generarArchivoSalida(data: dataMapa);

Var 
  i, contMovs: Integer;
  historialMovs: ArrayHistorialMovimientos;
Begin

  contMovs := data.contadorMovimientos;
  historialMovs := data.historialMovimientos;

  rewrite(salida);

  For i:=1 To (contMovs - 1) Do
    Begin
      writeLn(salida, historialMovs[i].PosicionX, ' ' ,historialMovs[i].
              PosicionY);
    End;

  close(salida);
End;

Procedure procesarArchivoSalida(Var salida: Text;  datosMapa: dataMapa;
                                rutaArchivoSalida: String);
Begin
  Assign(salida, rutaArchivoSalida);
  generarArchivoSalida(datosMapa);
End;

// Historial de coordenadas de la nave

Procedure imprimirHistorialMovimientos(data: dataMapa);

Var 
  j: Integer;
Begin
  Clrscr;
  textColor(blue);
  writeLn('El historial de movimientos fue: ');
  writeLn('Historial de movimientos: ');
  For j:=1 To (data.contadorMovimientos-1) Do
    writeLn('[',data.historialMovimientos[j].PosicionX, ',',data.
            historialMovimientos[j].PosicionY,']');
  Writeln;
End;


// Funcion que valida tanto filas como columnas
Function validarDim(n: Integer; mensaje: String; lim: Integer): Integer;
Begin
  Repeat
    Write('Indique la cantidad de ', mensaje, ' a ingresar: ');
    Readln(n);
    If (n < 1) Or (n > lim) Then
      Writeln('Error, la cantidad de ', mensaje,
              ' debe estar comprendido entre 1 y ', lim);
  Until (n>=1) And (n<=lim);
  validarDim := n;
End;
// POR HACER RELLENO ESTATICO
//
//

// Funcion validadora del personalizado:

Procedure validarPersonalizado(Var fil, col: integer; lim: Integer);

Var 
  total, i: integer;

Begin

  i := 0;

  Repeat
    writeln('INSTRUCCIONES:');
    writeln;
    writeln('La suma de la cantidad de las FILAS y las COLUMNAS debe ser mayor a 12'
    );
    writeln(' igualmente las FILAS y las COLUMNAS deben ser mayor o igual a 6 y menor a 15.'
    );
    writeln;
    writeln('Presiona para continuar...');
    readkey;
    writeln;
    // Cantidad de filas no mayor a 15 ni menor a 3;
    Repeat
      write('Indica la cantidad de filas: ');
      readLn(fil);
      If (fil < 6) Then
        writeLn('Error, indique cantidad entre 6 y ', lim);
      writeLn;
    Until (fil >= 6) And (fil <= lim);
    writeln;
    // Cantidad de columnas no mayor a 15 ni menor a 3
    Repeat
      write('Indica la cantidad de columnas: ');
      readLn(col);
      If (col < 6) Then
        writeLn('Error, indique cantidad entre 6 y ', lim);
      writeLn;
    Until (col >= 6) And  (col <= lim);

  Until (fil+col >= 12);
End;

// Relleno
// 
// 
Procedure relleno(Var terreno: mapa; Var data: dataMapa; Var nave, planeta:
                  vector; fil, col:Integer);

Var 
  i, j: Integer;
  coordEst, coordDest: ArrayDinamico;
Begin
{Condicionales para saber que data voy a generar dependiendo del tipo de mapa}
  If ((data.tipoMapa = TipoAleatorio) Or (data.tipoMapa = TipoPersonalizado))
    Then
    Begin
      Generador(data, data.tipoMapa, nave, planeta, data.estrellas.cantidad,
                data.destructores.cantidad, data.estrellas.coordenadas, data.
                destructores.coordenadas, fil, col);
    End;
  coordEst := data.estrellas.coordenadas;
  coordDest := data.destructores.coordenadas;
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

// Condicional para la generacion de PosMov = '?'

Procedure generacionInterrogaciones(Var terrenoModificado: mapa; Var contMovimientos: integer; param:
                                    ArrayDinamico;
                                    cantidadEstrellas: integer; nave, planeta:
                                    vector);

Var 
  i: integer;
  difX, difY: Integer;
  difFila, difCol: Integer;

Begin

  contMovimientos := 1;

  For i:= 1 To cantidadEstrellas Do
    Begin
      // Diferencia cn valor absoluto 
      difX := Abs(nave[1] - param[i].posicionX);
      difY := Abs(nave[2] - param[i].posicionY);

      // Para determinar los numeros negativos
      difFila := param[i].posicionX - nave[1];
      difCol := param[i].posicionY - nave[2];

      // Si la estrella y nave están en la misma fila pero distinta columna
      If (nave[1] = param[i].posicionX) And (nave[2] <> param[i].posicionY) Then
        Begin

          // Estrella en misma columna hacia la derecha
          If (nave[2] < param[i].posicionY) Then
            Begin
              // Contador movimientos
              contMovimientos := contMovimientos + 1;
              // Poner interrogacion si la dist entre nave y estrella es > 1
              If (Abs(nave[2] - param[i].posicionY) > 1) Then
                terrenoModificado[nave[1], nave[2]+1] := POSMOV;
              //POSMOV := '?'
            End;

          // Estrella en misma columna hacia la izquierda
          If (nave[2] > param[i].posicionY) Then
            Begin
              // Contador movimientos
              contMovimientos := contMovimientos + 1;
              // Condicional para no sobreescribir la estrella
              If (Abs(nave[2] - param[i].posicionY) > 1) Then
                // Animacion de la interrogacion
                terrenoModificado[nave[1], nave[2]-1] := POSMOV;
            End;

        End

        // Misma fila, distinta columna
      Else If (nave[2] = param[i].posicionY) And (nave[1] <> param[i].posicionX)
             Then
             Begin

               //  Estrella misma fila hacia abajo
               If (nave[1] < param[i].posicionX) Then
                 Begin
                   // Contador movimientos
                   contMovimientos := contMovimientos + 1;
                   //  Condicional para no sobreescribir la estrella
                   If (Abs(nave[1] - param[i].posicionX) > 1) Then
                     //  Animacion de la interrogacion
                     terrenoModificado[nave[1]+1, nave[2]] := POSMOV;
                   // Fila hacia abajo (se pone interrogacion abajo)
                 End;

               // Estrella en misma fila hacia arriba

               If (nave[1] > param[i].posicionX) Then
                 Begin
                   // Contador movimientos
                   contMovimientos := contMovimientos + 1;
                   //  Condicional para no sobreescribir la estrella
                   If (Abs(nave[1] - param[i].posicionX) > 1) Then
                     //  Animacion de la interrogacion
                     Begin
                       terrenoModificado[nave[1]-1, nave[2]] := POSMOV;
                     End;

                   // Poner estrella arriba de la nave

                 End;
             End;

      // Dif CELDAS => nave[1] - estrellaX = nave[2] - estrellaY, [Arriba Derecha y Abajo Izquierda], IMPORTANTE USAR ABS()
      If (Abs(nave[1] - param[i].posicionX) = Abs(nave[2] -
         param[i].posicionY)) Then
        Begin
          // Diagonal Abajo Derecha

          If (difFila > 0) And (difCol > 0) And (nave[1] < param[i].posicionX)
            Then
            Begin
              // Contador movimientos
              contMovimientos := contMovimientos + 1;
              // Animacion para no sobreescribir la estrella
              If (Abs(nave[1] - param[i].posicionX) > 1) Then
                // Animacion de la interrogacion
                terrenoModificado[nave[1]+1, nave[2]+1] := POSMOV;
              // Poner interrogacion abajo derecha de la nave

            End;

          // Diagonal Arriba Izquierda
          If (difFila < 0) And (difCol < 0) And (nave[1] > param[i].posicionX)
            Then
            Begin
              // Contador movimientos
              contMovimientos := contMovimientos + 1;
              // Animacion para no sobreescrbir la estrella
              If (Abs(nave[1] - param[i].posicionX) > 1) Then
                // Animacion para la interrrogacion
                terrenoModificado[(nave[1])-1, nave[2]-1] := POSMOV;
              // Poner interrogacion arriba izquierda de la nave
            End;
        End;

      // Dif Igual => nave[1] - estrellaX = nave[2] - estrellaY, [Arriba Derecha y Abajo Izquierda], IMPORTANTE USAR ABS()

      If (Abs(nave[1] - param[i].posicionX) = Abs(nave[2] - param[i].posicionY))
        Then
        Begin
          // Diagonal Abajo izquierda
          If (difFila > 0) And (difCol < 0) And (nave[1] < param[i].posicionX)
            Then
            Begin
              // Contador movimientos
              contMovimientos := contMovimientos + 1;
              // Condicional para no sobreescrbir la estrella
              If (Abs(nave[1] - param[i].posicionX) > 1) Then
                // Animacion para la interrogacion
                terrenoModificado[nave[1]+1, nave[2]-1] := POSMOV;
              // Poner interrogacion abajo izquierda de la nave
            End;

          // Diagonal Arriba Derecha
          If (difFila < 0) And (difCol > 0 ) And (nave[1] > param[i].posicionX)
            Then
            Begin
              // Contador movimientos
              contMovimientos := contMovimientos + 1;
              // Condicional para no sobreescribir la estrella
              If (Abs(nave[1] - param[i].posicionX) > 1) Then
                // Animacion para la interrogacion
                terrenoModificado[nave[1]-1, nave[2]+1] := POSMOV;
              // Poner interrogacion arriba derecha de la nave
            End;
        End;
    End;
End;

// Condicional de la estrella:
Procedure condicionalEstrella(Var listaMovimientos: ArrayMovimientos; Var
                              contMovimientos: Integer;
                              param:
                              ArrayDinamico; cantidadEstrellas: integer; nave,
                              planeta:
                              vector);

Var 
  i, j: Integer;
  difX, difY: Integer;
  difFila, difCol: Integer;
  llaveDer, llaveIzq, llaveArr, llaveAbj, llaveArrIzq,llaveArrDer, llaveAbjIzq, llaveAbjDer: boolean;
Begin

  // Inicializo contador movimientos
  contMovimientos := 1;

  // Inicializo booleans
  llaveDer := true;
  llaveIzq := true;
  llaveAbj := true;
  llaveArr := true;
  llaveArrIzq := true;
  llaveArrDer := true;
  llaveAbjIzq := true;
  llaveAbjDer := true;

  // Inicializar array de Movimientos para evitar errores
  listaMovimientos[1] := '';
  listaMovimientos[2] := '';
  listaMovimientos[3] := '';
  listaMovimientos[4] := '';

  For i:=1 To cantidadEstrellas Do
    Begin
      // Diferencia con valor absoluto
      difX := Abs(nave[1] - param[i].posicionX);
      difY := Abs(nave[2] - param[i].posicionY);

      // Para determinar los numeros negativos
      difFila := param[i].posicionX - nave[1];
      difCol := param[i].posicionY - nave[2];

      // Dif normal => x1 = x2 or y1 = y2 (vertical u horizontal)

      // Si la estrella y nave están en la misma fila pero distinta columna
      If (nave[1] = param[i].posicionX) And (nave[2] <>
         param[i].posicionY) Then
        Begin

          // Estrella en misma columna hacia la derecha
          If (nave[2] < param[i].posicionY) And (llaveDer) Then
            Begin

              // Posibles movimientos que puede hacer el usuario
              listaMovimientos[contMovimientos] := 'Derecha';

              // Voy a meter el movimiento dentro del array
              contMovimientos := contMovimientos + 1;

              // Cierro la llave
              llaveDer := false;
            End;

          // Estrella en misma columna hacia la izquierda

          If (nave[2] > param[i].posicionY) And (llaveIzq) Then
            Begin
              // Lista de movimientos
              listaMovimientos[contMovimientos] := 'Izquierda';
              // Voy a meter el movimiento dentro de la variable
              contMovimientos := contMovimientos + 1;

              // Cierro la llave
              llaveIzq := false;
            End;

        End
        // Misma fila, distinta columna
      Else If (nave[2] = param[i].posicionY) And (nave[1]
              <> param[i].posicionX) Then
             Begin

               //  Estrella en misma fila hacia abajo

               If (nave[1] < param[i].posicionX) And (llaveAbj) Then
                 Begin
                   // Lista de movimientos
                   listaMovimientos[contMovimientos] := 'Abajo';

                   // Voy a meter el movimiento dentro de la variable
                   contMovimientos := contMovimientos + 1;

                   // Cierro la llave
                   llaveAbj := false;
                 End;

               // Estrella en misma fila hacia arriba

               If (nave[1] > param[i].posicionX) And (llaveArr) Then
                 Begin
                   //  Lista de movimientos
                   listaMovimientos[contMovimientos] := 'Arriba';

                   // Voy a meter el movimiento dentro de la variable
                   contMovimientos := contMovimientos + 1;

                   //  Cierro la llave
                   llaveArr := false;
                 End;
             End;

      // Dif celdas => nave[1] - nave[2] = estrellaX - estrellaY, [Abajo Derecha y Arriba Izquierda], IMPORTANTE USAR ABS()
      If (Abs(nave[1] - param[i].posicionX) = Abs(nave[2] -
         param[i].posicionY)) Then
        Begin
          // Diagonal Abajo Derecha
          If (difFila > 0) And (difCol > 0) And (nave[1] < param[i].posicionX) And (llaveAbjDer)
            Then
            Begin
              // Lista de movimientos
              listaMovimientos[contMovimientos] := 'abjDerecha';

              // Voy a meter el movimiento dentro de la variable
              contMovimientos := contMovimientos + 1;

              // Cierro la llave
              llaveAbjDer := false;
            End;

          // Diagonal Arriba Izquierda
          If (difFila < 0) And (difCol < 0) And (nave[1] > param[i].posicionX) And (llaveArrIzq)
            Then
            Begin
              // Lista de movimientos
              listaMovimientos[contMovimientos] := 'arrIzquierda';
              // Voy a meter el movimiento dentro de la variable
              contMovimientos := contMovimientos + 1;

              // Cierro la llave
              llaveArrIzq := false;
            End;
        End;

      // Dif Igual => nave[1] - estrellaX = nave[2] - estrellaY, [Arriba Derecha y Abajo Izquierda], IMPORTANTE USAR ABS()
      If (Abs(nave[1] - param[i].posicionX) = Abs(nave[2] -
         param[i].posicionY)) Then
        Begin
          // Diagonal Abajo Izquierda
          If (difFila > 0) And (difCol < 0) And (nave[1] < param[i].posicionX) And (llaveAbjIzq)
            Then
            Begin
              // Lista de movimientos
              listaMovimientos[contMovimientos] := 'abjIzquierda';
              // Voy a meter el movimiento dentro de la variable
              contMovimientos := contMovimientos + 1;

              // Cierro la llave
              llaveAbjIzq := false;
            End;

          // Diagonal Arriba Derecha
          If (difFila < 0) And (difCol > 0) And (nave[1] > param[i].posicionX) And (llaveArrDer)
            Then
            Begin
              // Lista de movimientos
              listaMovimientos[contMovimientos] := 'arrDerecha';
              // Voy a meter el movimiento dentro de la variable
              contMovimientos := contMovimientos + 1;

              // Cierro la llave
              llaveArrDer := false;
            End;
        End;
    End;
End;

// Personaje
// Funciones del Personaje
Procedure Personaje(listaMovimientos: ArrayMovimientos; Var errores: Integer; contMovimientos:
                    Integer; terreno: mapa; Var nave, planeta:
                    vector; fil, col, tecla:
                    Integer);

Var 
  bucle: boolean;
  i: integer;

Begin

  // Inicializo:

  i := 0;
  bucle := false;

  // Aqui procedemos a modificar el vector de la nave de Posicion de X e Y dependiendo del ASCII

  Repeat
    Begin
      // Normales
      If ((tecla = W) And (nave[1] > 1) And (listaMovimientos[i+1] = 'Arriba'))
        Then
        Begin
          // Condicional para no chocar la estrella
          // Estrella arriba de la nave (interrumpir movimiento)
          If (terreno[nave[1]-1, nave[2]] = 'E') Then
            Begin
              writeln('Ingresa otro movimiento, estrella interrumpe tu camino.');

            End
          Else
            Begin
              // Arriba
              nave[1] := nave[1] - 1;
              bucle := true;
            End;
        End;
      If ((tecla = S) And (nave[1] < fil)  And (listaMovimientos[i+1] = 'Abajo')
         ) Then
        Begin
          //  Abajo
          If (terreno[nave[1]+1, nave[2]] = 'E') Then
            Begin
              writeln('Ingresa otro movimiento, estrella interrumpe tu camino.');

            End
          Else
            Begin
              nave[1] := nave[1] + 1;
              bucle := true;
            End;
        End;
      If ((tecla = A) And (nave[2] > 1)  And (listaMovimientos[i+1] =
         'Izquierda'))
        Then
        Begin
          // Izquierda
          If (terreno[nave[1], nave[2]-1] = 'E') Then
            Begin
              writeln('Ingresa otro movimiento, estrella interrumpe tu camino.');

            End
          Else
            Begin
              nave[2] := nave[2] - 1;
              bucle := true;
            End;
        End;
      If ((tecla = D) And (nave[2] < col) And (listaMovimientos[i+1] = 'Derecha'
         ))
        Then
        // Derecha
        Begin
          If (terreno[nave[1], nave[2]+1] = 'E') Then
            Begin
              writeln('Ingresa otro movimiento, estrella interrumpe tu camino.');

            End
          Else
            Begin
              nave[2] := nave[2] + 1;
              bucle := true;
            End;
        End;
      // Diagonales
      If ((tecla = Q) And (nave[1] > 1) And (nave[2] > 1)  And (listaMovimientos
         [i+1] = 'arrIzquierda')) Then
        Begin
          //  Arriba Izquierda
          If (terreno[nave[1]-1, nave[2]-1] = 'E') Then
            Begin
              writeln('Ingresa otro movimiento, estrella interrumpe tu camino.');

            End
          Else
            Begin
              nave[1] := nave[1] - 1;
              nave[2] := nave[2] - 1;
              bucle := true;
            End;
        End;

      If ((tecla = E) And (nave[1] > 1) And (nave[2] < col)  And (
         listaMovimientos[i+1] = 'arrDerecha')) Then
        Begin
          //  Arriba Derecha
          If (terreno[nave[1]-1, nave[2]+1] = 'E') Then
            Begin
              writeln('Ingresa otro movimiento, estrella interrumpe tu camino.');

            End
          Else
            Begin
              nave[1] := nave[1] - 1;
              nave[2] := nave[2] + 1;
              bucle := true;
            End;
        End;

      If ((tecla = Z) And (nave[1] < fil) And (nave[2] > 1)  And (
         listaMovimientos[i+1] = 'abjIzquierda')) Then
        Begin
          //  Abajo Izquierda
          If (terreno[nave[1]+1, nave[2]-1] = 'E') Then
            Begin
              writeln('Ingresa otro movimiento, estrella interrumpe tu camino.');

            End
          Else
            Begin
              nave[1] := nave[1] + 1;
              nave[2] := nave[2] - 1;
              bucle := true;
            End;
        End;

      If ((tecla = X) And (nave[1] < fil) And (nave[2] < col)  And (
         listaMovimientos[i+1] = 'abjDerecha')) Then
        //  Abajo derecha

        Begin
          If (terreno[nave[1]+1, nave[2]+1] = 'E') Then
            Begin
              writeln('Ingresa otro movimiento, estrella interrumpe tu camino.');

            End
          Else
            Begin
              nave[1] := nave[1] + 1;
              nave[2] := nave[2] + 1;
              bucle := true;
            End;
        End;

      i := i + 1;
      // era 0. ahora es 1
    End;
  Until ((bucle = true) Or (i = contMovimientos));

  writeln;

End;

// ANIMACIONES

Procedure ImpresoraColor(caracter: char; color: integer);
Begin
  // Cambio los colores
  textColor(color);
  write(caracter, ' ');
  // RESET
  textBackground(FONDO);
  textColor(COLOR_NORMAL);
End;

// Animacion de los colores en los menus...
Procedure AnimacionMenu(activo, max: Integer; Var menuVector:
                        vectorString);

Var 
  i: Integer;
Begin
  Clrscr;
  Writeln('---Bienvenido a L nave---');
  Writeln;
  For i := 1 To max Do
    Begin
      textBackground(FONDO);
      textcolor(COLOR_NORMAL);
      If (i = activo) Then
        Begin
          textBackground(FONDO);
          textColor(BLANCO);
        End;
      Writeln(menuVector[i]);
    End;
End;


// Algoritmo nave Perdida

Procedure navePerdidaAlgor(Var errores: Integer; contMovimientos: integer; nave: vector; estrellas: ArrayDinamico; cantidadEstrellas: integer);

Var 
  i: integer;

Begin

  contMovimientos := contMovimientos - 1;

  For i:= 1 To cantidadEstrellas Do
    Begin
      If (contMovimientos = 1) And ((Abs(nave[1] - estrellas[i].posicionX) <= 1) And (Abs(nave[2] - estrellas[i].posicionY) <= 1)) Then
        Begin
          errores := errores + 4;
        End;

      If (contMovimientos = 2) And ((Abs(nave[1] - estrellas[i].posicionX) <= 1) And (Abs(nave[2] - estrellas[i].posicionY) <= 1)) Then
        Begin
          errores := errores + 2;
        End;

      If (contMovimientos >= 3) And ((Abs(nave[1] - estrellas[i].posicionX) <= 1) And (Abs(nave[2] - estrellas[i].posicionY) <= 1)) Then
        Begin
          errores := errores + 1;
        End;
    End;
End;

// LEER EL MAPA FINAL PROCEDIMIENTO
//
//
Procedure leerMapa(Var data: dataMapa; Var terreno: mapa; Var nave,
                   planeta:
                   vector; fil, col, tecla:Integer);

Var 
  i, j: Integer;
  estrellaDisponible: Boolean;
  listaMovimientos: ArrayMovimientos;
  contArray, contMov: integer;
  terrenoModificado: mapa;
Begin
  Clrscr;
  Writeln('!!Intenta encontrar el Planeta!!');
  Writeln;

  // Mostrar el score de la partida
  If (data.tipoMapa = tipoAleatorio) Or (data.tipoMapa = tipoPersonalizado) Then
    writeln('NIVEL: ', data.score);

  terrenoModificado := terreno;

  // Inicializar la 2da variable del array de Movimientos vacio

  // Procedo a mover el personaje
  If (tecla > 0) Then
    Begin

      // Este Condicional se encarga de mandar el objeto de Movimientos verdadero:
      condicionalEstrella(listaMovimientos, contArray,
                          data.estrellas.
                          coordenadas, data.
                          estrellas.
                          cantidad, nave, planeta);
      // Aqui procede a moverse el personaje:
      Personaje(listaMovimientos, data.contErrores, contArray, terreno, nave, planeta, fil,
                col,
                tecla);
      terrenoModificado[nave[1], nave[2]] := PERSONAJEPOS;

      // Este condicional se encarga de mostrar las interrogaciones en el mapa
      generacionInterrogaciones(terrenoModificado, contMov, data.estrellas.coordenadas,
                                data.estrellas.cantidad, nave, planeta);

      // Verifico si la nave ya se perdio
      navePerdidaAlgor(data.contErrores, contArray, nave, data.estrellas.coordenadas, data.estrellas.cantidad);
    End
  Else
    // Este condicional se encarga de mostrar las estrellas en el mapa
    generacionInterrogaciones(terrenoModificado, contMov, data.estrellas.coordenadas,
                              data.estrellas.cantidad, nave, planeta);


  // Coloco las celdas
  For i := 1 To fil Do
    Begin
      j := 0;
      For j := 1 To col Do
        Begin
          If ((j = 1) And (i < 10)) Then
            Write(i, '  ', PARED, ' ');
          If ((j = 1) And (i >= 10)) Then
            Write(i, ' ', PARED, ' ');

          // STAR, BOMBA, POSMOV, BANDERA Y PERSONAJEPOS

          If (terrenoModificado[i, j] = CELDA) Then
            ImpresoraColor(terrenoModificado[i, j], COLOR_NORMAL)
          Else
            Begin
              // Impresion del personaje
              If (terrenoModificado[i, j] = PERSONAJEPOS) Then
                ImpresoraColor(terrenoModificado[i, j], BLANCO);

              // Impresion del planeta
              If (terrenoModificado[i, j] = BANDERA) Then
                ImpresoraColor(terrenoModificado[i, j], AZUL);


              // Caso especial de la interrogacion encima de la estrella o del planeta
              If (terrenoModificado[i, j] = POSMOV) And ((terreno[i, j] =
                 BANDERA
                 ) Or (terreno[i, j] = STAR)) Then
                ImpresoraColor(terreno[i, j], VERDE)
              Else
                Begin

                  // Caso especial donde la interrogacion este encima del Destructor
                  If ((terrenoModificado[i, j] = POSMOV) And (terreno[i, j
                     ] = BOMBA)
                     ) Then


                    //  El color de la interrogacion es rojo, por el caso especial
                    ImpresoraColor(terrenoModificado[i, j], ROJO)
                  Else
                    Begin
                      // Impresion de la Interrogacion
                      If (terrenoModificado[i, j] = POSMOV) Then
                        ImpresoraColor(terrenoModificado[i, j], AZUL);
                      // Impresion del destructor, quiero que aparezca vacio
                      If (terrenoModificado[i, j] = BOMBA) Then
                        Begin
                          If (data.score = 1) Then
                            ImpresoraColor(terrenoModificado[i, j], ROJO)
                          Else
                            ImpresoraColor(CELDA, COLOR_NORMAL);
                        End;


                    End;
                End;

              // Impresion de la estrella
              If (terrenoModificado[i, j] = STAR) Then
                ImpresoraColor(terrenoModificado[i, j], TURQUESA);
            End;
        End;
      Writeln;
    End;

  Writeln;
  Writeln('Presiona la letra para moverte: ');
  Writeln;
  Writeln('    ^       ^         ^');
  Writeln('     \Q     W       E/');
  Writeln('   <- A             D ->');
  Writeln('       /Z         X\');
  Writeln('      v      S      v');
  Writeln('             v');
  Writeln;
  Writeln('No dejes presionado ninguna tecla...');
  Writeln;
  Writeln('Presiona ESC para salir');
End;
// ---------- Aqui se desarrolla el bucle principal del juego
//
//

Procedure Partida(Var terreno: mapa; Var data: dataMapa; Var desarrolloPartida: Victoria; Var destructores
                  : ArrayDinamico; Var cant: integer; nave, planeta
                  :vector;
                  fil, col:Integer);

Var 
  ch: Char;
  rastro: vector;
  i: integer;

Begin
  Clrscr;
  // Se declara la partida
  desarrolloPartida := sigue;
  // Relleno el Mapa
  relleno(terreno, data, nave, planeta, fil, col);

  // Contadores inicializados
  data.contadorMovimientos := 1;
  data.contErrores := 0;

  // Inicializo el rastro
  rastro[1] := nave[1];
  rastro[2] := nave[2];

  // Inicializar contador de movimientos en 1 (agregarAlHistorialDeMovimientos)

  // Se lee el mapa inicial
  leerMapa(data, terreno, nave,
           planeta, fil, col, 0);

  // Bucle donde se desarollan los movimientos
  Repeat
    Begin

      // Reinicio los errores
      If ((rastro[1] <> nave[1]) Or (rastro[2] <> nave[2])) Then
        Begin
          data.contErrores := 0;
          // Vuelvo a comenzar el rastro
          rastro[1] := nave[1];
          rastro[2] := nave[2];
        End;

      // Limpia la posicion anterior de la nave
      terreno[nave[1], nave[2]] := CELDA;

      // Esto sostiene el repeat (no corre el codigo de abajo hasta que se presione una tecla)
      //
      //
      //
      ch := Upcase(Readkey);

      // Guardar historial de movimientos de la nave para generar archivo de salida
      agregarAlHistorialDeMovimientos(nave, data.historialMovimientos, data.
                                      contadorMovimientos);

      leerMapa(data, terreno, nave, planeta, fil, col, Ord(ch));

      // Si gano la partida, el boolean es true
      If ((nave[1] = planeta[1]) And (nave[2] = planeta[2])) Then
        desarrolloPartida := gano;

      For i:= 1 To cant Do
        Begin
          If ((nave[1] = destructores[i].posicionX) And (nave[2] = destructores[i].
             posicionY))
            Then
            desarrolloPartida := perder;
        End;

      // En caso de nave Perdida
      If (data.contErrores >= 8) Then
        desarrolloPartida := navePerdida;
    End;
  Until (Ord(ch) = ESC) Or (desarrolloPartida = gano) Or (desarrolloPartida = perder) Or (desarrolloPartida = navePerdida);

  // Registrar el abandono
  If (ord(ch) = ESC) Then
    desarrolloPartida := abandono;


  // Guardar historial de movimientos de la nave para generar archivo de salida
  agregarAlHistorialDeMovimientos(nave, data.historialMovimientos, data.
                                  contadorMovimientos);

  // Imprimir data de los archivos
  procesarArchivoSalida(salida,data, rutaArchivoSalida);
End;

// Menu tutorial

Procedure menuTutorial(Var opc: Integer; Var volver, salir: menuBoolean);

Var 
  keyPad: Char;
  menuVector: vectorString;
  activo: Integer;
Begin
  Clrscr;
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
  textBackground(FONDO);
  Writeln('---L nave---');
  Writeln;
  Repeat
    If ((Ord(keyPad) = Q) Or (Ord(keyPad) = DERECHA) Or (Ord(keyPad) = D))
      Then
      Begin
        AnimacionMenu(activo, NUM_TUTORIAL, menuVector);
        keyPad := 'a';
      End
    Else
      keyPad := Upcase(Readkey);
    Case Ord(keyPad) Of 
      0:
         Begin
           keyPad := Readkey;
           Case Ord(keyPad) Of 
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
                            Clrscr;
                            Writeln('Gud Lock');
                            Readkey;
                          End;
                        If (activo = 2) Then
                          Begin
                            Clrscr;
                            Writeln('BUENA SUERTE');
                            Readkey;
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
                      Clrscr;
                      Writeln('Gud Lock');
                      Readkey;
                    End;
                  If (activo = 2) Then
                    Begin
                      Clrscr;
                      Writeln('BUENA SUERTE');
                      Readkey;
                    End;
                  If (activo = 3) Then
                    volver := marchar;
                End;
    End;
  Until (salir = marchar) Or (volver = marchar);
End;

// ANIMACIONES
//
//

// Animacion Ganar
Procedure AnimacionGanar(desarrollo: Victoria; score: integer);
Begin
  // Si el personaje llego a el planeta
  If (desarrollo = gano) Then
    Begin
      Clrscr;
      textcolor(red);
      If (score = 0) Then
        writeln('!Felicidades!, lograste descifrar el camino.')
      Else
        Writeln('Pasaste al siguiente nivel: ', score, ' ...');
      Writeln;
      Delay(1000);
    End;
End;

// Animacion Perder

Procedure AnimacionPerder(desarrollo: Victoria);
Begin
  // Si el personaje llego a perder

  If (desarrollo = perder) Then
    Begin
      Clrscr;
      textcolor(blue);
      writeln('!Perdiste!, pisaste un destructor');
      writeln;
    End;
End;

// Animacion navePerdida
Procedure perdidaAnimacion(desarrollo: Victoria);
Begin
  If (desarrollo = navePerdida) Then
    Begin
      Clrscr;
      textcolor(blue);
      writeln('!Perdiste!, Te quedaste sin movimientos posibles');
      writeln;
    End;
End;


// MENU JUGAR::
Procedure bloqueMenuJugar(Var data: dataMapa; Var plano: mapa; Var nave,
                          planeta:
                          vector;Var fil, col: Integer; tipo:
                          TipoGeneracionMapa)
;

Var 
  desarrollo: Victoria;

Begin

  // Inicializar el score:
  data.score := 1;

  Clrscr;
  Delay(300);
  Randomize;
  If (tipo = TipoArchivo) Then
    procesarArchivoEntrada(entrada, data, rutaArchivoEntrada);
  If (tipo = TipoAleatorio) Then
    Begin
      fil := Random(4)+9;
      col := Random(4)+9;
      data.estrellas.cantidad := 5;
      data.destructores.cantidad := 5;
    End;
  // Validar si es personalizado
  If (tipo = TipoPersonalizado) Then
    Begin
      // Filas y Columnas
      validarPersonalizado(fil, col, LIMITE_PERSONALIZADO);
      // Cantidad Estrellas y Destructores
      data.estrellas.cantidad := 5;
      data.destructores.cantidad := 5;
    End;

  If (tipo = tipoAleatorio) Or (tipo = tipoPersonalizado) Then
    Partida(plano, data, desarrollo, data.destructores.coordenadas, data.destructores.
            cantidad, nave, planeta, fil, col
    );

  If (data.archivoValidado) Then
    Partida(plano, data, desarrollo, data.destructores.coordenadas, data.destructores.
            cantidad, nave, planeta, fil, col
    )
  Else
    writeln('Regresa al menu...');

  If (tipo = tipoAleatorio) Or (tipo = tipoPersonalizado) Then
    Begin
      Repeat
        Begin
          Delay(200);
          // Victoria
          If (desarrollo = gano) Then
            Begin
              data.score := data.score + 1;
              AnimacionGanar(desarrollo, data.score);
              procesarArchivoSalida(salida,data, rutaArchivoSalida);
              Partida(plano, data, desarrollo, data.destructores.coordenadas, data.destructores.
                      cantidad, nave, planeta, fil, col
              );
            End;

          If (desarrollo = perder) Then
            Begin
              AnimacionPerder(desarrollo);
              writeln('Presiona para seguir...');
              readkey;
            End;

          If (desarrollo = navePerdida) Then
            Begin
              perdidaAnimacion(desarrollo);
              writeln('Presiona para seguir...');
              readkey;
            End;

        End;
      Until  (desarrollo = perder) Or (desarrollo = navePerdida) Or (desarrollo = abandono);
    End
    // En caso de que sea tipo = tipoArchivo
  Else
    Begin
      If (data.archivoValidado) Then
        Begin
          If (desarrollo = gano) Then
            Begin
              AnimacionGanar(desarrollo, 0);
              procesarArchivoSalida(salida, data, rutaArchivoSalida);
              Delay(300);
              writeln;
              writeln('Presiona cualquier tecla para salir al menu.');
              readkey;
            End;

          If (desarrollo = perder) Then
            Begin
              AnimacionPerder(desarrollo);
              Delay(300);
              writeln;
              writeln('Presiona para seguir...');
              readkey;
            End;

          If (desarrollo = navePerdida) Then
            Begin
              AnimacionPerder(desarrollo);
              Delay(300);
              writeln;
              writeln('Presiona para seguir...');
              readkey;
            End;
        End;
    End;

End;
// Menu opcion jugar

Procedure menuJugar(Var data: dataJuego; Var opc: Integer; Var volver,
                    salir
                    :
                    menuBoolean);

Var 
  keyPad: Char;
  menuVector: vectorString;
  activo: Integer;
Begin
  Clrscr;
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
  textBackground(FONDO);
  Writeln('---L nave---');
  Writeln;
  Repeat
    If ((Ord(keyPad) = Q) Or (Ord(keyPad) = ESC) Or (Ord(keyPad) = DERECHA
       )
       Or
       (
       Ord(keyPad) = ENTER) Or (Ord(keyPad) = D))
      Then
      Begin
        AnimacionMenu(activo, NUM_SUBMENU, menuVector);
        keyPad := '0';
      End
    Else
      keyPad := Upcase(Readkey);
    Case Ord(keyPad) Of 
      0:
         Begin
           keyPad := Readkey;
           Case Ord(keyPad) Of 
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
                          Begin
                            data.dataArchivo.tipoMapa := TipoArchivo;
                            bloqueMenuJugar(data.dataArchivo, data.
                                            dataArchivo
                                            .
                                            plano,
                                            data.dataArchivo.naveT, data.
                                            dataArchivo.
                                            planetaT, data.dataArchivo.
                                            dimensiones
                                            .
                                            fil,
                                            data.dataArchivo.dimensiones.
                                            col
                                            ,
                                            data.dataArchivo.tipoMapa);
                          End;
                        If (activo = 2) Then
                          Begin
                            data.dataPersonalizada.tipoMapa := 






                                                               TipoPersonalizado
                            ;
                            bloqueMenuJugar(data.dataPersonalizada, data.
                                            dataPersonalizada.plano,
                                            data.dataPersonalizada.naveT,
                                            data
                                            .
                                            dataPersonalizada.
                                            planetaT, data.
                                            dataPersonalizada
                                            .
                                            dimensiones.fil,
                                            data.dataPersonalizada.
                                            dimensiones
                                            .
                                            col, data.dataPersonalizada.
                                            tipoMapa
                            )
                            ;
                          End;
                        If (activo = 3) Then
                          Begin
                            data.dataRandom.tipoMapa := TipoAleatorio;
                            bloqueMenuJugar(data.dataRandom, data.
                                            dataRandom
                                            .
                                            plano
                                            ,
                                            data.dataRandom.naveT, data.
                                            dataRandom
                                            .
                                            planetaT, data.dataRandom.
                                            dimensiones.
                                            fil,
                                            data.dataRandom.dimensiones.
                                            col,
                                            data.dataRandom.tipoMapa);
                          End;
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
                    Begin
                      data.dataArchivo.tipoMapa := TipoArchivo;
                      bloqueMenuJugar(data.dataArchivo, data.dataArchivo.
                                      plano,
                                      data.dataArchivo.naveT, data.
                                      dataArchivo.
                                      planetaT, data.dataArchivo.
                                      dimensiones
                                      .
                                      fil,
                                      data.dataArchivo.dimensiones.col,
                                      data.dataArchivo.tipoMapa);
                    End;
                  If (activo = 2) Then
                    Begin
                      data.dataPersonalizada.tipoMapa := TipoPersonalizado
                      ;
                      bloqueMenuJugar(data.dataPersonalizada, data.
                                      dataPersonalizada.plano,
                                      data.dataPersonalizada.naveT, data.
                                      dataPersonalizada.
                                      planetaT, data.dataPersonalizada.
                                      dimensiones.fil,
                                      data.dataPersonalizada.dimensiones.
                                      col, data.dataPersonalizada.tipoMapa
                      )
                      ;
                    End;
                  If (activo = 3) Then
                    Begin
                      data.dataRandom.tipoMapa := TipoAleatorio;
                      bloqueMenuJugar(data.dataRandom, data.dataRandom.
                                      plano
                                      ,
                                      data.dataRandom.naveT, data.
                                      dataRandom
                                      .
                                      planetaT, data.dataRandom.
                                      dimensiones.
                                      fil,
                                      data.dataRandom.dimensiones.col,
                                      data.dataRandom.tipoMapa);
                    End;
                  If (activo = 4) Then
                    volver := marchar;
                End;
    End;
  Until (volver = marchar) Or (salir = marchar);
End;
// Menu

Procedure Menu(Var data: dataJuego; Var opc: Integer; Var volver, salir:
               menuBoolean);

Var 
  keyPad: Char;
  menuVector: vectorString;
  activo: Integer;
Begin
  Clrscr;
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
  textBackground(FONDO);
  Writeln('---Bienvenido a L nave---');
  Writeln;
  Writeln('Presiona cualquier tecla para comenzar...');
  Readkey;
  Repeat
    If ((Ord(keyPad) = IZQUIERDA) Or (Ord(keyPad) = DERECHA) Or (Ord(
       keyPad)
       =
       ENTER) Or (Ord(keyPad) = Q) Or (Ord(keyPad) = D)) Then
      Begin
        AnimacionMenu(activo, NUM_MENUPRINCIPAL, menuVector);
        keyPad := 'k';
      End
    Else
      keyPad := Upcase(Readkey);
    Case Ord(keyPad) Of 
      0:
         Begin
           keyPad := Readkey;
           Case Ord(keyPad) Of 
             ARRIBA:
                     Begin
                       If (activo > 1) Then
                         activo := activo -1;
                       AnimacionMenu(activo, NUM_MENUPRINCIPAL, menuVector
                       );
                     End;
             ABAJO:
                    Begin
                      If (activo < 3) Then
                        activo := activo + 1;
                      AnimacionMenu(activo, NUM_MENUPRINCIPAL, menuVector)
                      ;
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
  Clrscr;
  // Ruta archivo de entrada
  rutaArchivoEntrada := 'C:\project-ucab\est.dat';
  rutaArchivoSalida := 'C:\project-ucab\est.res';
  // Partida Completa
  Menu(dataPrincipal, opc, volver, salir);
End.
