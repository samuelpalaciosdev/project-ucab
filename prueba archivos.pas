Program prueba_archivos_matriz;

Const
  limite = 30;
	 
Type
  matriz = Array[1..limite,1..limite] of Integer;

Var
  m: matriz; fil,col:Integer;
	archivo: Text;

Procedure leerArchivo(var archivo: text);
Var
  i, j: Integer;
Begin
  Reset(archivo);
	Read(archivo, fil, col);
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

Procedure llenarMatriz(var m: matriz; fil,col:Integer);
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
	llenarMatriz(m, fil,col);
	imprimirMatriz(m,fil,col);

Readln;
End.