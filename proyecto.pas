Program proyectoProgram;

Uses crt;

Const
  // Prueba
  NUM_MENUPRINCIPAL = 3;
  NUM_SUBMENU = 4;
  NUM_TUTORIAL = 3;
  // MAIN
  LIMITE = 30;
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
  Victoria = (sigue, gano, perder);
  TipoGeneracionMapa = (TipoArchivo, TipoAleatorio, TipoPersonalizado);
	TipoElemento  = (Estrellas, Destructores);
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



// Procedimiento reutilizable para mostrar la cantidad y las coordenadas de las estrellas y destructores

Procedure MostrarCantidadYCoordenadas(cantidad: Integer; coordenadas:
                                      ArrayDinamico; mensaje: String);

Var
  i: Integer;
Begin
  Writeln('Cantidad de ', mensaje, ': ', cantidad);
  // Mostrar la cantidad de estrellas o destructores
  Writeln('Coordenadas de ', mensaje, ':');
  // Mostrar las coordenadas de estrellas o destructores
  For i := 1 To cantidad Do
    Begin
      Writeln(i, ': X=', coordenadas[i].posicionX, ', Y=', coordenadas[i].
              posicionY);
      // Mostrar las coordenadas de cada elemento
    End;
End;

procedure generarCoordenadasRandom(var param: ArrayDinamico; elemento: TipoElemento;
  var diagonalCont, diagonalDetrasCont: Integer; nave, planeta: vector;
  fil, col: Integer; cant: Integer);
var
  i, j: Integer;
  difX, difY: Integer;
  estrellasDetras: Integer;
  repetido: Boolean;
begin
  estrellasDetras := 0;

  for i := 1 to cant do
  begin
    repetido := False; // Variable para verificar si las coordenadas generadas ya están en la lista

    repeat
      param[i].posicionX := Random(fil) + 1;
      param[i].posicionY := Random(col) + 1;

      // Verificar si las coordenadas generadas ya están en la lista
      for j := 1 to i - 1 do
      begin
        if (param[i].posicionX = param[j].posicionX) and (param[i].posicionY = param[j].posicionY) then
        begin
          repetido := True;
          Break;
        end;
      end;

    until repetido or
      ((param[i].posicionX <> nave[1]) or (param[i].posicionY <> nave[2])) and
      ((param[i].posicionX <> planeta[1]) or (param[i].posicionY <> planeta[2]));

    // Verificar si es diagonal o está detrás del planeta
    if (elemento = Estrellas) then
    begin
      // Verificar si la estrella está detrás del planeta en el eje x o y
      if ((param[i].posicionX < planeta[1]) and (param[i].posicionY = planeta[2])) or
        ((param[i].posicionY > planeta[2]) and (param[i].posicionX = planeta[1])) then
        estrellasDetras := estrellasDetras + 1;

      difX := param[i].posicionX - planeta[1];
      difY := param[i].posicionY - planeta[2];

      // Verificar si la estrella está diagonal al planeta
      if Abs(difX) = Abs(difY) then
      begin
        diagonalCont := diagonalCont + 1;
        WriteLn('Estrella diagonal a planeta [', param[i].posicionX, ',', param[i].posicionY, ']');

        // Verificar si está detrás del planeta en posición diagonal
        if ((param[i].posicionX < planeta[1]) and (param[i].posicionY < planeta[2])) or
          ((param[i].posicionX > planeta[1]) and (param[i].posicionY > planeta[2])) then
          diagonalDetrasCont := diagonalDetrasCont + 1;
      end;
    end;
  end;
end;


// Genera coordenadas estrellas y destructores
Procedure bloqueGenerador(Var param: ArrayDinamico; tipo: TipoGeneracionMapa; elemento: TipoElemento;
                          nave, planeta: vector; fil
                          , col: Integer; Var cant: Integer);
Var
  i, diagonalCont, diagonalDetrasCont: Integer;
Begin

  Randomize;

	if (tipo = TipoAleatorio) Then
  Begin
	  Repeat
		  cant := Random(LIMITE_ELEMENTOS) + 1;
		Until (cant >=3);
	End;

	diagonalCont:= 0; // Contador para verificar estrellas diagonales a planeta
	diagonalDetrasCont:= 0;
	
	if (elemento = Estrellas) Then
	Begin                                           
	  Repeat
		  generarCoordenadasRandom(param, elemento,diagonalCont, diagonalDetrasCont, nave, planeta, fil, col, cant);
		Until (diagonalCont >= 5) and (diagonalDetrasCont >=2);
	End
	Else
	Begin
		 generarCoordenadasRandom(param, elemento,diagonalCont, diagonalDetrasCont,nave, planeta, fil, col, cant);
	End;
	
  // MostrarCantidadYCoordenadas(cant, param, 'holaaaaaaaaaaaa');
  Readkey;
  Writeln;
  Writeln('Cargando...');
  Delay(400);
End;
// Generador
Procedure Generador(Var data: dataMapa; Var tipo:TipoGeneracionMapa; Var nave,
                    planeta: vector;
                    Var cant, cant2: Integer; Var coordsEstrellas, coordsDestructores:ArrayDinamico;
                    fil, col: Integer);

Var
  i, j: Integer;
Begin
  Randomize;
  If ((tipo = TipoPersonalizado) Or (tipo = TipoAleatorio)) Then
    Begin
 {Randomizo la nave}
      nave[1] := Random(fil)+1;
      nave[2] := Random(col)+1;
      // Randomizar la posición X,Y del planeta
      Repeat
        planeta[1] := Random(fil)+1;
        // X
        planeta[2] := Random(col)+1;
        // Y
      Until ((planeta[1] <> nave[1]) Or (planeta[2] <> nave[2]));
      // Planeta y nave no pueden estar en la misma celda



{ Si es tipo aleatorio puedo hacer 2 llamadas a la funcion del bloque de una vez para que me genere
		 las coordenadas de destructores y estrellas sin problema }
      If ((tipo = tipoAleatorio) Or (tipo = tipoPersonalizado)) Then
        Begin
          bloqueGenerador(coordsEstrellas, tipo, Estrellas, nave, planeta, fil, col, cant);
          bloqueGenerador(coordsDestructores, tipo, Destructores, nave, planeta, fil, col, cant2);
        End;
      Writeln;
			writeLn('Posicion planeta [', planeta[1], ',',planeta[2], ']');
			writeLn('Cantidad de filas: ', fil);
			writeLn('Cantidad de columnas: ', col);
      Writeln('!Presiona para jugar!');
			
      Readkey;                           
    End;
End;
// ARCHIVOS
//



// Procedimiento reutilizable para leer la cantidad y las coordenadas de las estrellas y destructores desde un archivo
Procedure leerCantidadYCoordenadas(Var entrada: Text; Var cantidad: Integer; Var
                                   coordenadas: ArrayDinamico);

Var
  i, cant_1, cant_2: Integer;
Begin



// Leer el primer numero de la cantidad de estrellas o destructores del archivo de entrada y comprobar si es > o < que 10
  // Nro < que 10 (ej. 0 7) = 7
  Read(entrada, cant_1);
  If (cant_1 = 0) Then
    Begin
      Read(entrada, cantidad);
      // Guarda el siguiente numero como la cantidad
    End
    // Nro > que 10 (ej. 1 5) = 15
  Else
    Begin
      Read(entrada, cant_2);
      // Obtener el segundo nro de la line
      cantidad := cant_1 * 10 + cant_2;
      // Combinar el primer n£mero con el segundo
    End;



{Leer las coordenadas de las estrellas o destructores y guarda la posicion de cada elemento
 como un objeto de coordenadas dentro de un array}
  For i := 1 To cantidad Do
    Begin
      Read(entrada, coordenadas[i].posicionX, coordenadas[i].posicionY);
    End;
End;
// Leer archivo de entrada (guardar su data en el objeto de tipo dataMapa)

Procedure leerArchivo(Var entrada: Text; Var datosMapa: dataMapa);
Begin
  // Abrir archivo
  Reset(entrada);
  // Guardar fila y columna en el objeto
  Read(entrada, datosMapa.dimensiones.fil, datosMapa.dimensiones.col);
  // Guardar posicion nave     (X,Y)
  Read(entrada, datosMapa.naveT[1], datosMapa.naveT[2]);
  // Guardar posicion planetaT (X,Y)
  Read(entrada, datosMapa.planetaT[1], datosMapa.planetaT[2]);
  // Guarda cantidad y coordenadas de estrellas
  leerCantidadYCoordenadas(entrada, datosMapa.estrellas.cantidad, datosMapa.estrellas.coordenadas);
  // Guardar cantidad y coordenadas de destructores
  leerCantidadYCoordenadas(entrada, datosMapa.destructores.cantidad, datosMapa.destructores.coordenadas);
  Close(entrada);
End;

// Procesar datos del archivo de entrada
Procedure procesarArchivo(Var entrada: Text; Var datosMapa: dataMapa;
                          rutaArchivoEntrada: String);

Var
  i: Integer;
Begin
  // Asignar la variable archivo al archivo en la ruta (rutaArchivoEntrada)
  Assign(entrada, rutaArchivoEntrada);
  // Extraer los datos del archivo y almacenarlos en el objeto "datosMapa"
  leerArchivo(entrada, datosMapa);
  // Mostrar info del archivo de entrada
  Writeln('El valor de filas es ', datosMapa.dimensiones.fil,' y de columnas ', datosMapa.dimensiones.col);
  Writeln('Las coordenadas de la nave son: ', datosMapa.naveT[1], ' y ', datosMapa.naveT[2]);
  Writeln('Las coordenadas de el planeta T son: ', datosMapa.planetaT[1],' y ', datosMapa.planetaT[2]);
  MostrarCantidadYCoordenadas(datosMapa.estrellas.cantidad, datosMapa.estrellas.coordenadas, 'estrellas');
  MostrarCantidadYCoordenadas(datosMapa.destructores.cantidad, datosMapa.destructores.coordenadas, 'destructores');
  Delay(300);
  Writeln;
  Writeln('Presiona para jugar si estas listo...');
  Writeln;
  Readkey;
End;

// Historial de Movimientos del personaje

Procedure agregarAlHistorialDeMovimientos(nave: vector; Var historialMov:
ArrayHistorialMovimientos; Var contMov:Integer);
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
  If (nave[1] <> historialMov[contMov - 1].posicionX)Or (nave[2]<> historialMov[contMov - 1].posicionY) Then
    Begin
      historialMov[contMov].PosicionX := nave[1];
      historialMov[contMov].PosicionY := nave[2];
      contMov := contMov + 1;
    End;

  writeLn('Posicion historial [',historialMov[contMov-1].PosicionX, ' ', historialMov[contMov-1].PosicionY, ']');
  readkey;
End;

Procedure generarArchivoSalida(data: dataMapa);
Var
  i, contMovs: Integer;
	historialMovs: ArrayHistorialMovimientos;
Begin

  contMovs:= data.contadorMovimientos;
  historialMovs:= data.historialMovimientos;
	
  rewrite(salida);
	
	for i:=1 to (contMovs - 1) Do
	Begin
	  writeLn(salida, historialMovs[i].PosicionX, ' ' ,historialMovs[i].PosicionY);
	End;

	close(salida);
End;

Procedure procesarArchivoSalida(var salida: Text;  datosMapa: dataMapa; rutaArchivoSalida: String);
Begin
  Assign(salida, rutaArchivoSalida);
	generarArchivoSalida(datosMapa)  
End;

// ANIMACIONES
//
//

// Animacion Ganar
Procedure AnimacionGanar(desarrollo: Victoria);
Begin
  // Si el personaje llego a el planeta
  If (desarrollo = gano) Then
    Begin
      Clrscr;
      textcolor(red);
      Writeln('!Ganaste!, Felicitaciones');
      Writeln;
      Writeln;
      Readkey;
    End;
End;

Procedure imprimirHistorialMovimientos(data: dataMapa);
Var
  j: Integer;
Begin
	  Clrscr;
		textColor(blue);
		writeLn('El historial de movimientos fue: ');
		writeLn('Historial de movimientos: ');
		for j:=1 to (data.contadorMovimientos-1) Do
		  writeLn('[',data.historialMovimientos[j].PosicionX, ',',data.historialMovimientos[j].PosicionY,']');
		Writeln;
		Readkey;
End;

// Animacin Perder

Procedure AnimacionPerder(desarrollo: Victoria);
Begin
  // Si el personaje llego a perder

  If (desarrollo = perder) Then
    Begin
      Clrscr;
      textcolor(blue);
      writeln('!Perdiste!, pisaste un destructor');
      writeln;
      readkey;
    End;
End;

// Funcion que valida tanto filas como columnas
Function validarDim(n: Integer; mensaje: String; lim: Integer): Integer;
Begin
  Repeat
    Write('Indique la cantidad de ', mensaje, ' a ingresar: ');
    Readln(n);
    If (n < 0) Or (n > lim) Then
      Writeln('Error, la cantidad de ', mensaje,
              ' debe estar comprendido entre 1 y ', lim);
  Until (n>=1) And (n<=lim);
  validarDim := n;
End;
// POR HACER RELLENO ESTATICO
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
  MostrarCantidadYCoordenadas(data.estrellas.cantidad, data.estrellas.
                              coordenadas, 'Estrellas');
  Readkey;
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


// Condicional de la estrella:

Procedure condicionalEstrella(Var listaMovimientos: ArrayMovimientos; Var
                              contMovimientos: Integer; Var
                              terrenoModificado: mapa;
                              param:
                              ArrayDinamico
                              ; cant: integer; Var nave: vector; planeta:
                              vector);

Var
  i, j, cantidadEstrellas: Integer;
  estrellaDisponible: Boolean;
  difX, difY: Integer;
  difFila, difCol: Integer;
Begin
  // Inicializar en False
  estrellaDisponible := False;
  cantidadEstrellas := cant;

  // Inicializo contador movimientos
  contMovimientos := 1;


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
          If (nave[2] < param[i].posicionY) Then
            Begin

              // Voy a meter el movimiento dentro del array
              contMovimientos := contMovimientos + 1;
              // Posibles movimientos que puede hacer el usuario
              listaMovimientos[contMovimientos] := 'Derecha';


              // Condicional para no sobreescribir la estrella
              // Poner interrogacion si la dist entre nave y estrella es > 1
              If (Abs(nave[2] - param[i].PosicionY) > 1) Then
                // Animacion de la interrogacion
                terrenoModificado[nave[1], nave[2]+1] := POSMOV;
              // Poner interrogacion a la derecha de la nave
              // POSMOV = '?'
            End;

          // Estrella en misma columna hacia la izquierda

          If (nave[2] > param[i].posicionY) Then
            Begin

              // Voy a meter el movimiento dentro de la variable
              contMovimientos := contMovimientos + 1;
              listaMovimientos[contMovimientos] := 'Izquierda';

              // Condicional para no sobreescribir la estrella
              If (Abs(nave[2] - param[i].posicionY) > 1) Then
                // Animacion de la interrogacion
                terrenoModificado[nave[1], nave[2]-1] := POSMOV;


            End;

        End
        // Misma fila, distinta columna
      Else If (nave[2] = param[i].posicionY) And (nave[1]
              <> param[i].posicionX) Then
             Begin

               //  Estrella en misma fila hacia abajo

               If (nave[1] < param[i].posicionX) Then
                 Begin

                   // Voy a meter el movimiento dentro de la variable
                   contMovimientos := contMovimientos + 1;
                   listaMovimientos[contMovimientos] := 'Abajo';


                   //  Condicional para no sobreescribir la estrella
                   If (Abs(nave[1] - param[i].posicionX) > 1) Then
                     //  Animacion de la interrogacion
                     terrenoModificado[nave[1]+1, nave[2]] := POSMOV;
                   // Fila hacia abajo (se pone interrogacion abajo)


                 End;

               // Estrella en misma fila hacia arriba

               If (nave[1] > param[i].posicionX) Then
                 Begin


                   // Voy a meter el movimiento dentro de la variable
                   contMovimientos := contMovimientos + 1;
                   listaMovimientos[contMovimientos] := 'Arriba';


                   //  Condicional para no sobreescribir la estrella
                   If (Abs(nave[1] - param[i].posicionX) > 1) Then
                     //  Animacion de la interrogacion
                     terrenoModificado[nave[1]-1, nave[2]] := POSMOV;
                   // Poner estrella arriba de la nave


                 End;
             End;



// Dif celdas => nave[1] - nave[2] = estrellaX - estrellaY, [Abajo Derecha y Arriba Izquierda], IMPORTANTE USAR ABS()
      If (Abs(nave[1] - param[i].posicionX) = Abs(nave[2] -
         param[i].posicionY)) Then
        Begin
          // Diagonal Abajo Derecha
          If (difFila > 0) And (difCol > 0) And (nave[1] < param[i].posicionX)
            Then
            Begin


              // Voy a meter el movimiento dentro de la variable
              contMovimientos := contMovimientos + 1;
              listaMovimientos[contMovimientos] := 'abjDerecha';


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


              // Voy a meter el movimiento dentro de la variable
              contMovimientos := contMovimientos + 1;
              listaMovimientos[contMovimientos] := 'arrIzquierda';

              // Animacion para no sobreescrbir la estrella
              If (Abs(nave[1] - param[i].posicionX) > 1) Then
                // Animacion para la interrrogacion
                terrenoModificado[(nave[1])-1, nave[2]-1] := POSMOV;
              // Poner interrogacion arriba izquierda de la nave
            End;
        End;


// Dif Igual => nave[1] - estrellaX = nave[2] - estrellaY, [Arriba Derecha y Abajo Izquierda], IMPORTANTE USAR ABS()
      If (Abs(nave[1] - param[i].posicionX) = Abs(nave[2] -
         param[i].posicionY)) Then
        Begin
          // Diagonal Abajo Izquierda
          If (difFila > 0) And (difCol < 0) And (nave[1] < param[i].posicionX)
            Then
            Begin

              // Voy a meter el movimiento dentro de la variable
              contMovimientos := contMovimientos + 1;
              listaMovimientos[contMovimientos] := 'abjIzquierda';

              // Condicional para no sobreescrbir la estrella
              If (Abs(nave[1] - param[i].posicionX) > 1) Then
                // Animacion para la interrogacion
                terrenoModificado[nave[1]+1, nave[2]-1] := POSMOV;
              // Poner interrogacion abajo izquierda de la nave

            End;

          // Diagonal Arriba Derecha
          If (difFila < 0) And (difCol > 0) And (nave[1] > param[i].posicionX)
            Then
            Begin
              // Voy a meter el movimiento dentro de la variable
              contMovimientos := contMovimientos + 1;
              listaMovimientos[contMovimientos] := 'arrDerecha';


              // Condicional para no sobreescribir la estrella
              If (Abs(nave[1] - param[i].posicionX) > 1) Then
                // Animacion para la interrogacion
                terrenoModificado[nave[1]-1, nave[2]+1] := POSMOV;
              // Poner interrogacion arriba derecha de la nave
            End;
        End;
    End;
End;

// Personaje
// Funciones del Personaje
Procedure Personaje(listaMovimientos: ArrayMovimientos; Var contMovimientos:
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
            writeln('Ingresa otro movimiento, estrella interrumpe tu camino.')
          Else
            Begin
              // Arriba
              nave[1] := nave[1] - 1;
              bucle := true;
            End;
        End;
      If ((tecla = S) And (nave[1] < fil)  And (listaMovimientos[i+1] = 'Abajo')
         ) Then
        //  Abajo
        If (terreno[nave[1]+1, nave[2]] = 'E') Then
          writeln('Ingresa otro movimiento, estrella interrumpe tu camino.')
      Else
        Begin
          nave[1] := nave[1] + 1;
          bucle := true;
        End;
      If ((tecla = A) And (nave[2] > 1)  And (listaMovimientos[i+1] =
         'Izquierda'))
        Then
        // Izquierda
        If (terreno[nave[1], nave[2]-1] = 'E') Then
          writeln('Ingresa otro movimiento, estrella interrumpe tu camino.')
      Else
        Begin
          nave[2] := nave[2] - 1;
          bucle := true;
        End;
      If ((tecla = D) And (nave[2] < col) And (listaMovimientos[i+1] = 'Derecha'
         ))
        Then
        // Derecha
        If (terreno[nave[1], nave[2]+1] = 'E') Then
          writeln('Ingresa otro movimiento, estrella interrumpe tu camino.')
      Else
        Begin
          nave[2] := nave[2] + 1;
          bucle := true;
        End;
      // Diagonales
      If ((tecla = Q) And (nave[1] > 1) And (nave[2] > 1)  And (listaMovimientos
         [i+1] = 'arrIzquierda')) Then
        //  Arriba Izquierda
        If (terreno[nave[1]-1, nave[2]-1] = 'E') Then
          writeln('Ingresa otro movimiento, estrella interrumpe tu camino.')
      Else
        Begin
          nave[1] := nave[1] - 1;
          nave[2] := nave[2] - 1;
          bucle := true;
        End;
      If ((tecla = E) And (nave[1] > 1) And (nave[2] < col)  And (
         listaMovimientos[i+1] = 'arrDerecha')) Then
        //  Arriba Derecha
        If (terreno[nave[1]-1, nave[2]+1] = 'E') Then
          writeln('Ingresa otro movimiento, estrella interrumpe tu camino.')
      Else
        Begin
          nave[1] := nave[1] - 1;
          nave[2] := nave[2] + 1;
          bucle := true;
        End;
      If ((tecla = Z) And (nave[1] < fil) And (nave[2] > 1)  And (
         listaMovimientos[i+1] = 'abjIzquierda')) Then
        //  Abajo Izquierda
        If (terreno[nave[1]+1, nave[2]-1] = 'E') Then
          writeln('Ingresa otro movimiento, estrella interrumpe tu camino.')
      Else
        Begin
          nave[1] := nave[1] + 1;
          nave[2] := nave[2] - 1;
          bucle := true;
        End;
      If ((tecla = X) And (nave[1] < fil) And (nave[2] < col)  And (
         listaMovimientos[i+1] = 'abjDerecha')) Then
        //  Abajo derecha
        If (terreno[nave[1]+1, nave[2]+1] = 'E') Then
          writeln('Ingresa otro movimiento, estrella interrumpe tu camino.')
      Else
        Begin
          nave[1] := nave[1] + 1;
          nave[2] := nave[2] + 1;
          bucle := true;
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




// LEER EL MAPA FINAL PROCEDIMIENTO
//
//
Procedure leerMapa(Var data: dataMapa; Var terreno: mapa; Var nave,
                   planeta:
                   vector; fil, col, tecla:Integer);

Var
  i, j: Integer;
  estrellaDisponible: Boolean;
  listaMovimientos, basuraMovimientos: ArrayMovimientos;
  contMovimientos, basuraContador: integer;
  terrenoModificado, basuraMapa: mapa;
Begin
  Clrscr;
  Writeln('!!Intenta encontrar el Planeta!!');
  Writeln;

  terrenoModificado := terreno;

  // Procedo a mover el personaje
  If (tecla > 0) Then
    Begin







    // Este Condicional se encarga de mandar el objeto de Movimientos verdadero:
      condicionalEstrella(listaMovimientos, contMovimientos, basuraMapa,
                          data.estrellas.
                          coordenadas, data.
                          estrellas.
                          cantidad, nave, planeta);
      // Aqui procede a moverse el personaje:
      Personaje(listaMovimientos, contMovimientos, terreno, nave, planeta, fil,
                col,
                tecla);
      terrenoModificado[nave[1], nave[2]] := PERSONAJEPOS;

      // Este condicional se encarga de mostrar las interrogaciones en el mapa
      condicionalEstrella(basuraMovimientos, basuraContador, terrenoModificado,
                          data
                          .estrellas.coordenadas, data.estrellas.cantidad, nave,
                          planeta);
    End
  Else
    // Mostrar interrogaciones cuando el mapa apenas se genera
    // Este condicional se encarga de mostrar las estrellas en el mapa
    condicionalEstrella(basuraMovimientos, basuraContador, terrenoModificado,
                        data
                        .estrellas.coordenadas, data.estrellas.cantidad, nave,
                        planeta);

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
              If (terrenoModificado[i, j] = STAR) Then
                ImpresoraColor(terrenoModificado[i, j], TURQUESA);

              If (terrenoModificado[i, j] = BOMBA) Then
                ImpresoraColor(terrenoModificado[i, j], ROJO);

              If (terrenoModificado[i, j] = POSMOV) Then
                ImpresoraColor(terrenoModificado[i, j], AZUL);

              If (terrenoModificado[i, j] = BANDERA) Then
                ImpresoraColor(terrenoModificado[i, j], AZUL);

              If (terrenoModificado[i, j] = PERSONAJEPOS) Then
                ImpresoraColor(terrenoModificado[i, j], BLANCO);
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

Procedure Partida(Var terreno: mapa; Var data: dataMapa; param
                  : ArrayDinamico; cant: integer; nave, planeta
                  :vector;
                  fil, col, tecla:Integer);

Var
  ch: Char;
  desarrollo: Victoria;
  i: integer;

Begin
  Clrscr;
  // Se declara la partida
  desarrollo := sigue;
  // Relleno el Mapa
  relleno(terreno, data, nave, planeta, fil, col);

  // Cont Movimientos

  data.contadorMovimientos := 1; // Inicializar contador de movimientos en 1 (agregarAlHistorialDeMovimientos)

  // Se lee el mapa inicial
  leerMapa(data, terreno, nave,
           planeta, fil, col, 0);

  // Bucle donde se desarollan los movimientos
  Repeat
    Begin
      // Limpia la posicion anterior de la nave
      terreno[nave[1], nave[2]] := CELDA;

// Esto sostiene el repeat (no corre el codigo de abajo hasta que se presione una tecla)
      //
      //
      //
      ch := Upcase(Readkey);
			
			// Guardar historial de movimientos de la nave para generar archivo de salida
	    agregarAlHistorialDeMovimientos(nave, data.historialMovimientos, data.contadorMovimientos);
			
      leerMapa(data, terreno, nave, planeta, fil, col, Ord(ch));



    // Si gano la partida, el boolean es true
      If ((nave[1] = planeta[1]) And (nave[2] = planeta[2])) Then
        desarrollo := gano;

      For i:= 1 To cant Do
        Begin
          If ((nave[1] = param[i].posicionX) And (nave[2] = param[i].
             posicionY))
            Then
            desarrollo := perder;
        End;
    End;
  Until ((Ord(ch) = ESC) Or (desarrollo = gano) Or (desarrollo = perder));


	// Guardar historial de movimientos de la nave para generar archivo de salida
	agregarAlHistorialDeMovimientos(nave, data.historialMovimientos, data.contadorMovimientos);
  // Victoria
  If (desarrollo = gano) Then
	Begin
    AnimacionGanar(desarrollo);
    imprimirHistorialMovimientos(data);
		procesarArchivoSalida(salida,data, rutaArchivoSalida);
	End;

  If (desarrollo = perder) Then
    AnimacionPerder(desarrollo);
		imprimirHistorialMovimientos(data);
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
// MENU JUGAR::
Procedure bloqueMenuJugar(Var data: dataMapa; Var plano: mapa; Var nave,
                          planeta:
                          vector;Var fil, col: Integer; tipo:
                          TipoGeneracionMapa)
;
Begin
  Clrscr;
  Delay(300);
  Randomize;
  If (tipo = TipoArchivo) Then
    procesarArchivo(entrada, data, rutaArchivoEntrada);
  If (tipo = TipoAleatorio) Then
    Begin
      Repeat
			  fil := Random(LIMITE-15)+1;
        col := Random(LIMITE-15)+1;
			Until (fil >=3) and (fil + col >=12);
    End;
  // Validar si es personalizado
  If (tipo = TipoPersonalizado) Then
    Begin
      // Filas y Columnas
      fil := validarDim(fil, 'filas', LIMITE);
      col := validarDim(col, 'columnas', LIMITE);
      // Cantidad Estrellas y Destructores
      data.estrellas.cantidad := validarDim(data.estrellas.cantidad,
                                 'estrellas'
                                 , LIMITE_ELEMENTOS);
      data.destructores.cantidad := validarDim(data.destructores.cantidad,
                                    'destructores', LIMITE_ELEMENTOS);
    End;
  Partida(plano, data, data.destructores.coordenadas, data.destructores.
          cantidad, nave, planeta, fil, col, 0
  );
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
  rutaArchivoEntrada := 'est.dat';
	rutaArchivoSalida:= 'est.res';
  // Partida Completa
  Menu(dataPrincipal, opc, volver, salir);
End.