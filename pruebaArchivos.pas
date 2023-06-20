Program prueba_archivos;

Const
  limite = 30;

Type
  matriz = Array[1..limite, 1..limite] of Integer;
  datosMapa = record
    dimensiones: record
      fil: Integer;
      col: Integer;
    end;
  end;


Var
  m: matriz; fil,col:Integer;
	archivo: text;

Procedure leerArchivo(var archivo: text);
Var
  i, j: Integer;
Begin

  reset(archivo);
	Read(archivo, fil, col);

End;


Begin

  Assign(archivo, 'E:\Default Folders\Samuel\Desktop\UCAB 2do semestre\project-ucab\est.dat');
	leerArchivo(archivo);
	writeLn('El valor de filas es: ', fil, ' el valor de columnas es: ', col);

Readln;
End.