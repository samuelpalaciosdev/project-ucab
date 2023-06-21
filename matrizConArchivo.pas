
Program matriz_archivos;

Const 
  limite = 30;
  limiteEstrellas = 15;
  limiteDestructores = 10;

Type 
  matriz = Array[1..limite, 1..limite] Of Char;
  // Tipo de dato usado en varias keys del objeto
  coordenada = Record
    posicionX: Integer;
    posicionY: Integer;
  End;
  // Objeto donde se almacena toda la info del archivo
  datamapa = Record
    // datamapa.estrellas.coordenadas
    dimensiones: Record
      fil: Integer;
      col: Integer;
    End;
    nave: coordenada;
    planetaT: coordenada;
    estrellas: Record
      cantidad: Integer;
      coordenadas: Array[1..limiteEstrellas] Of coordenada;
    End;
    destructores: Record
      cantidad: Integer;
      coordenadas: Array[1..limiteEstrellas] Of coordenada;
    End;
  End;

  // Variables principales

Var 
  m: matriz;
  fil,col: Integer;
  archivo: text;
  datosMapa: dataMapa;




// Procedimiento reutilizable para leer info de las (ESTRELLAS Y DESTRUCTORES) del archivo
Procedure leerCantidadYCoordenadas(Var archivo: Text; Var cantidad: Integer; Var
                                   coordenadas: Array Of coordenada);

Var 
  i, cant_1, cant_2: Integer;
Begin



// Leer el primer numero de la cantidad de (estrellas o destructores) del archivo y comprobar si es > 10 o < 10
  // Nro < a 10 (0 n) (ej. 0 7) = 7
  Read(archivo, cant_1);
  If cant_1 = 0 Then
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


Procedure leerArchivo(Var archivo: text; Var datosMapa: dataMapa);

Var 
  i, j: Integer;
Begin
  // Abrir archivo
  reset(archivo);
  // Guardar fila y columna en el objeto
  Read(archivo, datosMapa.dimensiones.fil, datosMapa.dimensiones.col);
  // Guardar posicion nave     (X,Y)
  Read(archivo, datosMapa.nave.posicionX, datosMapa.nave.posicionY);
  // Guardar posicion planetaT (X,Y)
  Read(archivo, datosMapa.planetaT.posicionX, datosMapa.planetaT.posicionY);

  // Guarda cantidad y coordenadas de estrellas
  leerCantidadYCoordenadas(archivo, datosMapa.estrellas.cantidad, datosMapa.
                           estrellas.coordenadas);
  // Guardar cantidad y coordenadas de destructores
  leerCantidadYCoordenadas(archivo, datosMapa.destructores.cantidad, datosMapa.
                           destructores.coordenadas);

  Close(archivo);
End;




// Mostrar cantidad y coordenadas Procedure reutilizable para (ESTRELLAS Y DESTRUCTORES)
Procedure MostrarCantidadYCoordenadas(cantidad: Integer; coordenadas: Array Of
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

Procedure LlenarMatriz(Var m: matriz; datosMapa: dataMapa);

Var 
  i,j: Integer;
Begin
  // Inicializar la matriz con espacios en blanco
  For i := 1 To limite Do
    For j := 1 To limite Do
      m[i, j] := '#';

  // Asignar posicion de la nave en la matriz
  m[datosMapa.nave.posicionX, datosMapa.nave.posicionY] := 'H';

  // Asignar posicion del planetaT en la matriz
  m[datosMapa.planetaT.posicionX, datosMapa.planetaT.posicionY] := 'T';

  // Asignar las coordenadas de las estrellas en la matriz
  For i := 1 To datosMapa.estrellas.cantidad Do
    m[datosMapa.estrellas.coordenadas[i].posicionX, datosMapa.estrellas.
    coordenadas[i].posicionY] := 'E';

  // Asignar las coordenadas de los destructores en la matriz
  For i := 1 To datosMapa.destructores.cantidad Do
    m[datosMapa.destructores.coordenadas[i].posicionX, datosMapa.destructores.
    coordenadas[i].posicionY] := 'D';
End;


Procedure imprimirMatriz(m:matriz; datosMapa: dataMapa);

Var 
  i,j: Integer;
Begin

  For i:=1 To datosMapa.dimensiones.fil Do
    Begin
      For j:=1 To datosMapa.dimensiones.col Do
        Begin
          write(m[i,j], ' ');
        End;
      writeLn;
    End;
End;


Begin

  Assign(archivo, 'est.dat');
  leerArchivo(archivo, datosMapa);
  writeLn('El valor de filas es ', datosMapa.dimensiones.fil, ' y de columnas ',
          datosMapa.dimensiones.col);
  writeLn('Las coordenadas de la nave son: ', datosMapa.nave.posicionX, ' y ',
          datosMapa.nave.posicionY);
  writeLn('Las coordenadas de el planeta T son: ', datosMapa.planetaT.posicionX,
          ' y ', datosMapa.planetaT.posicionY);
  MostrarCantidadYCoordenadas(datosMapa.estrellas.cantidad, datosMapa.estrellas.
                              coordenadas, 'estrellas');
  MostrarCantidadYCoordenadas(datosMapa.destructores.cantidad, datosMapa.
                              destructores.coordenadas, 'destructores');
  LlenarMatriz(m, datosMapa);
  imprimirMatriz(m, datosMapa);
  Readln;
End.
