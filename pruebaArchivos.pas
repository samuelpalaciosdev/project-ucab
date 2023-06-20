Program prueba_archivos;

Const
  limite = 30;
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
Var
  m: matriz; fil,col:Integer;
	archivo: text;
	datosMapa: dataMapa;

Procedure leerArchivo(var archivo: text);
Var
  i, j: Integer;
Begin

  reset(archivo);
	// Guardar fila y columna en el objeto
	Read(archivo, datosMapa.dimensiones.fil, datosMapa.dimensiones.col);
	// Guardar posicion nave     (X,Y)
	Read(archivo, datosMapa.nave.posicionX, datosMapa.nave.posicionY);
	// Guardar posicion planetaT (X,Y)
	Read(archivo, datosMapa.planetaT.posicionX, datosMapa.planetaT.posicionY);
	// Guardar cantidad de estrellas
	Read(archivo, datosMapa.estrellas.cantidad);

End;


Begin

  Assign(archivo, 'E:\Default Folders\Samuel\Desktop\UCAB 2do semestre\project-ucab\est.dat');
	leerArchivo(archivo);
	writeLn('El valor de filas es ', datosMapa.dimensiones.fil, ' y de columnas ', datosMapa.dimensiones.col);
	writeLn('Las coordenadas de la nave son: ', datosMapa.nave.posicionX, ' y ', datosMapa.nave.posicionY);
	writeLn('Las coordenadas de el planeta T son: ', datosMapa.planetaT.posicionX, ' y ', datosMapa.planetaT.posicionY);
Readln;
End.