Program prueba_archivos;

Const
  limite = 30;
	// Debería ser una variable que cambia segun el max de estrellas expresado en el archivo
	limiteEstrellas = 10;

Type
  matriz = Array[1..limite, 1..limite] of Integer;
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
  end;
	
// Variables principales	
Var
  m: matriz; fil,col:Integer;
	archivo: text;
	datosMapa: dataMapa;
	estrellas: Integer;
	estrellasMod: Integer;

Procedure leerArchivo(var archivo: text);
Var
  i, j: Integer;
	cantEstrellas,cantEstrellas_1, cantEstrellas_2: Integer;
Begin

  reset(archivo);
	// Guardar fila y columna en el objeto
	Read(archivo, datosMapa.dimensiones.fil, datosMapa.dimensiones.col);
	// Guardar posicion nave     (X,Y)
	Read(archivo, datosMapa.nave.posicionX, datosMapa.nave.posicionY);
	// Guardar posicion planetaT (X,Y)
	Read(archivo, datosMapa.planetaT.posicionX, datosMapa.planetaT.posicionY);
	// Leer el primer numero de la cantidad de estrellas del archivo y comprobar
	Read(archivo, cantEstrellas_1);
	// Nro de estrellas < a 10 (0 n) (ej 0 7) = 7 estrellas
	if (cantEstrellas_1 = 0) Then
	   Read(archivo, datosMapa.estrellas.cantidad) // Guardar cantidad de estrellas en el objeto
	Else
	// Nro de estrellas > a 10 (1 n ó 2 n)
	// Agarra el primer numero de la linea y lo une con el segundo (ej 1 5) = 15 estrellas
	Begin
	   Read(archivo, cantEstrellas_2);
		 writeLn('Estrellas 2: ', cantEstrellas_2);
		 cantEstrellas:= cantEstrellas_1 * 10 + cantEstrellas_2;
		 datosMapa.estrellas.cantidad:= cantEstrellas;
	End;
	   	   

	
	

End;


Begin

  Assign(archivo, 'E:\Default Folders\Samuel\Desktop\UCAB 2do semestre\project-ucab\est.dat');
	leerArchivo(archivo);
	writeLn('El valor de filas es ', datosMapa.dimensiones.fil, ' y de columnas ', datosMapa.dimensiones.col);
	writeLn('Las coordenadas de la nave son: ', datosMapa.nave.posicionX, ' y ', datosMapa.nave.posicionY);
	writeLn('Las coordenadas de el planeta T son: ', datosMapa.planetaT.posicionX, ' y ', datosMapa.planetaT.posicionY);
	writeLn('La cantidad de estrellas es: ', datosMapa.estrellas.cantidad);
	estrellas:= datosMapa.estrellas.cantidad;
	estrellasMod:= estrellas + 2;
  writeLn(estrellasMod);


Readln;
End.