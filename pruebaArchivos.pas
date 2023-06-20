Program prueba_archivos;

Const
  limite = 30;

Type
  matriz = Array[1..limite, 1..limite] of Integer;
  datamapa = record
    dimensiones: record
      fil: Integer;
      col: Integer;
    end;
    nave: record
      posicionX: Integer;
      posicionY: Integer;
    end;
    planetaT: record
      posicionX: Integer;
      posicionY: Integer;
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

End;


Begin

  Assign(archivo, 'E:\Default Folders\Samuel\Desktop\UCAB 2do semestre\project-ucab\est.dat');
	leerArchivo(archivo);
	writeLn('El valor de filas es: ', datosMapa.dimensiones.fil, ' el valor de columnas es: ', datosMapa.dimensiones.col);

Readln;
End.