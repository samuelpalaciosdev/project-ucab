Program probando_archivo;

Const
  LIMITE = 30;
  LIMITE_ESTRDEST = 15; // Limite estrellas y destructores

Type
  vector = Array[1..LIMITE] Of Integer;
  mapa = Array[1..LIMITE, 1..LIMITE] Of Char;
  matriz = Array[1..LIMITE_ESTRDEST, 1..LIMITE_ESTRDEST] Of Integer;
  TipoGeneracionMapa = (TipoArchivo, TipoAleatorio, TipoPersonalizado);
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
    tipoMapa: TipoGeneracionMapa;
  End;
  dataJuego = Record
    dataArchivo: dataMapa;
    dataRandom: dataMapa;
    dataPersonalizada: dataMapa;
  End;

Var
  // VARIABLES ARCHIVOS
  // Archivo
  archivo: Text;
  rutaArchivo: String;
	dataPrincipal: dataJuego;

// ARCHIVOS
//
// Procedimiento reutilizable para leer la cantidad y las coordenadas de las estrellas y destructores desde un archivo
Procedure leerCantidadYCoordenadas(Var archivo: Text; Var cantidad: Integer; Var coordenadas: Array Of coordenada);
Var
  i, cant_1, cant_2: Integer;
Begin
  // Leer el primer numero de la cantidad de estrellas o destructores del archivo y comprobar si es > o < que 10
  // Nro < que 10 (ej. 0 7) = 7
  Read(archivo, cant_1);
  If (cant_1 = 0) Then
    Begin
      Read(archivo, cantidad); // Guarda el siguiente numero como la cantidad
    End
  // Nro > que 10 (ej. 1 5) = 15
  Else
    Begin
      Read(archivo, cant_2); // Obtener el segundo nro de la linea
      cantidad := cant_1 * 10 + cant_2; // Combinar el primer número con el segundo
    End;
	{Leer las coordenadas de las estrellas o destructores y guarda la posicion de cada elemento
	como un objeto de coordenadas dentro de un array}
  For i := 1 To cantidad Do
    Begin
      Read(archivo, coordenadas[i].posicionX, coordenadas[i].posicionY);
    End;
End;


// Procedimiento reutilizable para mostrar la cantidad y las coordenadas de las estrellas y destructores
Procedure MostrarCantidadYCoordenadas(cantidad: Integer; coordenadas: Array Of coordenada; mensaje: String);
Var
  i: Integer;
Begin
  writeLn('Cantidad de ', mensaje, ': ', cantidad);  // Mostrar la cantidad de estrellas o destructores
  writeln('Coordenadas de ', mensaje, ':'); // Mostrar las coordenadas de estrellas o destructores
  For i := 1 To cantidad Do
    Begin
      writeln(i, ': X=', coordenadas[i].posicionX, ', Y=', coordenadas[i].posicionY); // Mostrar las coordenadas de cada elemento
    End;
End;

// Leer Archivo Principal (Guardar su data en el objeto de tipo dataMapa)
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
  leerCantidadYCoordenadas(archivo, datosMapa.estrellas.cantidad, datosMapa.estrellas.coordenadas);
  // Guardar cantidad y coordenadas de destructores
  leerCantidadYCoordenadas(archivo, datosMapa.destructores.cantidad, datosMapa.destructores.coordenadas);
  Close(archivo);
End;

// Procesar datos del Archivo
Procedure procesarArchivo(Var archivo: Text; Var datosMapa: dataMapa; rutaArchivo: String);
Begin
  // Asignar la variable archivo al archivo en la ruta (rutaArchivo)
  Assign(archivo, rutaArchivo);
	// Extraer los datos del archivo y almacenarlos en el objeto "datosMapa"
  leerArchivo(archivo, datosMapa);
	// Mostrar info del archivo
  writeLn('El valor de filas es ', datosMapa.dimensiones.fil,' y de columnas ',datosMapa.dimensiones.col);
  writeLn('Las coordenadas de la nave son: ', datosMapa.naveT[1], ' y ', datosMapa.naveT[2]);
  writeLn('Las coordenadas de el planeta T son: ', datosMapa.planetaT[1],' y ', datosMapa.planetaT[2]);
  MostrarCantidadYCoordenadas(datosMapa.estrellas.cantidad, datosMapa.estrellas.coordenadas, 'estrellas');
  MostrarCantidadYCoordenadas(datosMapa.destructores.cantidad, datosMapa.destructores.coordenadas, 'destructores');
End;

Begin

  rutaArchivo:= 'est.dat';
	procesarArchivo(archivo, dataPrincipal.dataArchivo, rutaArchivo);

Readln;
End.