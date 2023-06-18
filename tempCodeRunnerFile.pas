
  // Procedure Personaje(Var nave: vector; fila, colum, tecla: integer);

  // Var 
  //   i: integer;

  // Begin

  //   // Normales

  //   If ((tecla = W) And (nave[1] > 1)) Then
  //     nave[1] := nave[1] - 1;

  //   If ((tecla = S) And (nave[1] < fila)) Then
  //     nave[1] := nave[1] + 1;

  //   If ((tecla = A) And (nave[2] > 1)) Then
  //     nave[2] := nave[2] - 1;

  //   If ((tecla = D) And (nave[2] < colum)) Then
  //     nave[2] := nave[2] + 1;


  //   // Diagonales

  //   If ((tecla = Q) And (nave[1] > 1) And (nave[2] > 1)) Then
  //     Begin
  //       nave[1] := nave[1] - 1;
  //       nave[2] := nave[2] - 1;
  //     End;

  //   If ((tecla = E) And (nave[1] > 1) And (nave[2] < colum)) Then
  //     Begin
  //       nave[1] := nave[1] - 1;
  //       nave[2] := nave[2] + 1;
  //     End;

  //   If ((tecla = Z) And (nave[1] < fila) And (nave[2] > 1)) Then
  //     Begin
  //       nave[1] := nave[1] + 1;
  //       nave[2] := nave[2] - 1;
  //     End;

  //   If ((tecla = X) And (nave[1] < fila) And (nave[2] < colum)) Then
  //     Begin
  //       nave[1] := nave[1] + 1;
  //       nave[2] := nave[2] + 1;
  //     End;


  // End;