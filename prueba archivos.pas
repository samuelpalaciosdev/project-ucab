Program prueba_archivos_matriz;

Const
  limite = 30;

Type
  matriz = Array[1..limite,1..limite] of Integer;
  datosMapa = record
    Dimensiones: record
      Fil: Integer;
      Col: Integer;
    end;
    Nave: record
      PosicionX: Integer;
      PosicionY: Integer;
    end;
    PlanetaT: record
      PosicionX: Integer;
      PosicionY: Integer;
    end;
    {Estrellas: record
      Cantidad: Integer;
      Coordenadas: array of record
        PosicionX: Integer;
        PosicionY: Integer;
      end;
    end;
    Destructores: record
      Cantidad: Integer;
      Coordenadas: array of record
        PosicionX: Integer;
        PosicionY: Integer;
      end;
    end;  }
  end;
		
Var
  m: matriz; fil,col:Integer;
	archivo: Text;

Procedure leerArchivo(var archivo: text);
Var
  i, j, fil, col: Integer;
Begin
  Reset(archivo);
	Read(archivo, fil, col);
	datosMapa.Dimensiones.Fil := fil;
  datosMapa.Dimensiones.Col := col;
End;

Function validarDim(n: Integer; mensaje: String):Integer;
Begin
  Repeat
	  write('Indica la cantidad a ingresar de ', mensaje);
		readLn(n);
		if (n < 0) or (n > limite) Then
		  writeLn('Error, el numero de ', mensaje, ' debe estar comprendido entre 1 y ', limite);
	Until (n>=1) and (n<=limite);

	validarDim:= n;
End;

{Procedure llenarMatrizManual(var m: matriz; fil,col:Integer);
Var
  i,j: Integer;
Begin

  for i:=1 to fil Do
	Begin
	  for j:=1 to Col Do
		Begin
		  write('Indique valor a ingresar en la posicion [',i,',',j,']');
			readLn(m[i,j]);
		End;
	End;
End;
}

Procedure llenarMatrizRandom(var m: matriz; fil,col:Integer);
Var
  i,j:Integer;
Begin

  randomize;
  for i:=1 to fil Do
	Begin
	  for j:=1 to col Do
		Begin
		  m[i,j]:= Random(9) + 1;
		End;
	End;
End;  

Procedure imprimirMatriz(m: matriz; fil,col: Integer);
Var
  i,j: Integer;
Begin
  for i:=1 to fil Do
	Begin
	  for j:=1 to col Do
		Begin
		  write(m[i,j], ' ');
		End;
		writeLn;
	End;
End;

Begin

  Assign(archivo, 'E:\Default Folders\Samuel\Desktop\UCAB 2do semestre\project-ucab\est.dat');
	leerArchivo(archivo);
	// llenarMatrizManual(m, fil,col);
	llenarMatrizRandom(m, datosMapa.Dimensiones.fil, datosMapa.Dimensiones.col);
	imprimirMatriz(m,datosMapa.Dimensiones.fil,datosMapa.Dimensiones.col);

Readln;
End.