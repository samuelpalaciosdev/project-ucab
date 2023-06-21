Program matriz_archivos;

Const
  limite = 30;
	limiteEstrellas = 15;
	limiteDestructores = 10;

Type
  matriz = Array[1..limite, 1..limite] of Char;
	// Tipo de dato usado en varias keys del objeto
	coordenada = Record
	  posicionX: Integer;
		posicionY: Integer;
	end;
	// Objeto donde se almacena toda la info del archivo
  datamapa = record
    dimensiones: record
      fil: Integer;
      col: Integer;
    end;
    nave: coordenada;
    planetaT: coordenada;
		estrellas: Record
		  cantidad: Integer;
			coordenadas: Array[1..limiteEstrellas] of coordenada;
		end;
		destructores: Record
		  cantidad: Integer;
			coordenadas: Array[1..limiteEstrellas] of coordenada;
		end;
  end;

  // Variables principales
Var
  m: matriz; fil,col:Integer;
	archivo: text;
	datosMapa: dataMapa;

// Procedimiento reutilizable para leer info de las (ESTRELLAS Y DESTRUCTORES) del archivo
procedure leerCantidadYCoordenadas(var archivo: Text; var cantidad: Integer; var coordenadas: array of coordenada);
var
  i, cant_1, cant_2: Integer;
begin
  // Leer el primer numero de la cantidad de (estrellas o destructores) del archivo y comprobar si es > 10 o < 10
	// Nro < a 10 (0 n) (ej. 0 7) = 7
  Read(archivo, cant_1);
  if cant_1 = 0 then
  Begin
    Read(archivo, cantidad);
  End
	// Nro > a 10 (1 n ó 2 n) Agarra el primer nro de la linea y lo une con el sig (ej 1 5) = 15
  Else
  Begin
    Read(archivo, cant_2);
    cantidad := cant_1 * 10 + cant_2;
  End;
	{ ---- Leer coordenadas de (estrellas o destructores), guarda la posicion de cada elemento como un
	       obj de coordenadas dentro de un array}
  for i := 1 to cantidad do
  Begin
    Read(archivo, coordenadas[i].posicionX, coordenadas[i].posicionY);
  End;
end;


Procedure leerArchivo(var archivo: text; var datosMapa: dataMapa);
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
	leerCantidadYCoordenadas(archivo, datosMapa.estrellas.cantidad, datosMapa.estrellas.coordenadas);
	// Guardar cantidad y coordenadas de destructores
	leerCantidadYCoordenadas(archivo, datosMapa.destructores.cantidad, datosMapa.destructores.coordenadas);

  Close(archivo);
End;

// Mostrar cantidad y coordenadas Procedure reutilizable para (ESTRELLAS Y DESTRUCTORES)
procedure MostrarCantidadYCoordenadas(cantidad: Integer; coordenadas: array of coordenada; mensaje: String);
var
  i: Integer;
begin
  writeLn('Cantidad de ', mensaje, ': ', cantidad);
  writeln('Coordenadas de ', mensaje, ':');
  for i := 1 to cantidad do
  begin
    writeln(i, ': X=', coordenadas[i].posicionX, ', Y=', coordenadas[i].posicionY);
  end;
end;

procedure LlenarMatriz(var m: matriz; datosMapa: dataMapa);
var
  i,j: Integer;
begin
  // Inicializar la matriz con espacios en blanco
  for i := 1 to limite do
    for j := 1 to limite do
      m[i, j] := '#';

	// Asignar posicion de la nave en la matriz
	m[datosMapa.nave.posicionX, datosMapa.nave.posicionY] := 'H';

	// Asignar posicion del planetaT en la matriz
	m[datosMapa.planetaT.posicionX, datosMapa.planetaT.posicionY] := 'T';

  // Asignar las coordenadas de las estrellas en la matriz
  for i := 1 to datosMapa.estrellas.cantidad do
    m[datosMapa.estrellas.coordenadas[i].posicionX, datosMapa.estrellas.coordenadas[i].posicionY] := 'E';

  // Asignar las coordenadas de los destructores en la matriz
  for i := 1 to datosMapa.destructores.cantidad do
    m[datosMapa.destructores.coordenadas[i].posicionX, datosMapa.destructores.coordenadas[i].posicionY] := 'D';
end;


Procedure imprimirMatriz(m:matriz; datosMapa: dataMapa);
Var
  i,j:Integer;
Begin

  for i:=1 to datosMapa.dimensiones.fil Do
	Begin
	  for j:=1 to datosMapa.dimensiones.col Do
		Begin
		  write(m[i,j], ' ');
		End;
		writeLn;
	End;
End;


Begin

  Assign(archivo, 'E:\Default Folders\Samuel\Desktop\UCAB 2do semestre\project-ucab\est.dat');
	leerArchivo(archivo, datosMapa);
	writeLn('El valor de filas es ', datosMapa.dimensiones.fil, ' y de columnas ', datosMapa.dimensiones.col);
	writeLn('Las coordenadas de la nave son: ', datosMapa.nave.posicionX, ' y ', datosMapa.nave.posicionY);
	writeLn('Las coordenadas de el planeta T son: ', datosMapa.planetaT.posicionX, ' y ', datosMapa.planetaT.posicionY);
  MostrarCantidadYCoordenadas(datosMapa.estrellas.cantidad, datosMapa.estrellas.coordenadas, 'estrellas');
  MostrarCantidadYCoordenadas(datosMapa.destructores.cantidad, datosMapa.destructores.coordenadas, 'destructores');
	LlenarMatriz(m, datosMapa);
	imprimirMatriz(m, datosMapa);
Readln;
End.