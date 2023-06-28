
procedure generarCoordenadasRandom(var param: ArrayDinamico; elemento: TipoElemento;
  var diagonalCont, diagonalDetrasCont, estrellaAtrasVerHor: Integer; nave, planeta: vector;
  fil, col: Integer; cant: Integer);
var
  i, j: Integer;
  difX, difY: Integer;
  estrellasDetras: Integer;
begin

  for i := 1 to cant do
  begin

    Repeat
      param[i].posicionX := Random(fil) + 1;
      param[i].posicionY := Random(col) + 1;
    Until
      ((param[i].posicionX <> nave[1]) or (param[i].posicionY <> nave[2])) and
      ((param[i].posicionX <> planeta[1]) or (param[i].posicionY <> planeta[2]));

    // Verificar si es diagonal o está detrás del planeta
    if (elemento = Estrellas) then
    begin
      // Verificar si la estrella está detrás del planeta en el eje x o y
      if ((param[i].posicionX < planeta[1]) and (param[i].posicionY = planeta[2])) or
        ((param[i].posicionY > planeta[2]) and (param[i].posicionX = planeta[1])) then
        estrellaAtrasVerHor := estrellaAtrasVerHor + 1;

      difX := param[i].posicionX - nave[1];
      difY := param[i].posicionY - nave[2];

      // Verificar si la estrella está diagonal a la nave
      if Abs(difX) = Abs(difY) then
      begin
        diagonalCont := diagonalCont + 1;
        WriteLn('Estrella diagonal a planeta [', param[i].posicionX, ',', param[i].posicionY, ']');

        // Verificar si está detrás del planeta en posición diagonal (justo detras de él)
        if ((param[i].posicionX = planeta[1] - 1) and (param[i].posicionY = planeta[2] - 1)) or
          ((param[i].posicionX = planeta[1] + 1) and (param[i].posicionY = planeta[2] + 1)) then
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
  i, diagonalCont, diagonalDetrasCont, estrellaAtrasVerHor: Integer;
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
	estrellaAtrasVerHor:= 0;

	if (elemento = Estrellas) Then
	Begin
	  Repeat
		  generarCoordenadasRandom(param, elemento,diagonalCont, diagonalDetrasCont, nave, planeta, fil, col, cant);
		Until (diagonalCont >= 2) and (diagonalDetrasCont >=1) and (estrellaAtrasVerHor >= 1);
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



Procedure generarCoordenadasRandom(var param: ArrayDinamico; elemento: TipoElemento; Var diagonalCont,
diagonalDetrasCont: Integer; nave, planeta: vector; fil, col, cant:Integer);
Var
  i,j: Integer;
	difX,difY: Integer;
Begin

  for i:=1 to cant Do
	Begin

		// Generar coordenadas sin que choquen con el planeta o la nave
	  Repeat
		  param[i].posicionX := Random(fil) + 1;
      param[i].posicionY := Random(col) + 1;
	  Until ((param[i].posicionX <> nave[1]) or (param[i].posicionY <> nave[2])) and
      ((param[i].posicionX <> planeta[1]) or (param[i].posicionY <> planeta[2]));

		if (elemento = Estrellas) Then
		Begin

		  // Verificar si hay estrellas en diagonal al planeta
			difX := param[i].posicionX - planeta[1];
      difY := param[i].posicionY - planeta[2];

			// (Abs(nave[1] - param[i].posicionX) = Abs(nave[2] - param[i].posicionY))    [Abajo Derecha y Arriba Izquierda]

			// (Abs(nave[1] - param[i].posicionX) = Abs(nave[2] - param[i].posicionY))    [Arriba Derecha y Abajo Izquierda]


		End;





	End;