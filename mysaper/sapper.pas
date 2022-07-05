program saper;

uses GraphABC, ABCObjects, ABCButtons;

type
  sbutton = record  //тип кнопки
    x, y, sx, sy, condition: integer;
    check, flag, bomb: boolean;
  end;

const
  field_size = 10;

var
  MassOfPicture: array[0..13] of Picture;   //массив картинок
  myB: array[1..field_size, 1..field_size] of sbutton;
  BtNewGame: ButtonABC;
  N_flag: RectangleABC;
  k_flag: SquareABC;
  calc_flag: integer;

procedure The_End();
begin
  font.Color := clred;
  font.Size := 40;
  textout(400, 200, 'Проигрыш!');  
end;

procedure win();
var
  i, j, k: integer;
begin
  k := 0;
  for i := 1 to field_size do
  begin
    for j := 1 to field_size do
    begin
      if (myb[i, j].check or myB[i, j].flag) and (calc_flag = 0) then inc(k);
      if k = 100 then begin
        font.Color := clred;
        font.Size := 40;
        textout(400, 200, 'Выигрыш!');
      end;
    end;
  end;  
end;

procedure DrawPoleSapera();  //draw
var
  i, j, rx, ry: integer;
begin
  for var x := 1 to 3 do 
  begin
    for i := 1 to field_size do
    begin
      for j := 1 to field_size do
      begin
        if myB[i, j].check = false then MassOfPicture[11].Draw(myB[i, j].x, myB[i, j].y);  //не нажата 
        if myB[i, j].flag = true then MassOfPicture[12].Draw(myB[i, j].x, myB[i, j].y);   //флаг    
        if myB[i, j].check = true then begin
          if (myb[i, j].condition = 0) then 
            MassOfPicture[1].Draw(myB[i, j].x, myB[i, j].y);
          if (myb[i, j].condition = 1) then MassOfPicture[2].Draw(myB[i, j].x, myB[i, j].y);   
          if (myb[i, j].condition = 2) then MassOfPicture[3].Draw(myB[i, j].x, myB[i, j].y);
          if (myb[i, j].condition = 3) then MassOfPicture[4].Draw(myB[i, j].x, myB[i, j].y);
          if (myb[i, j].condition = 4) then MassOfPicture[5].Draw(myB[i, j].x, myB[i, j].y);   
          if (myb[i, j].condition = 5) then MassOfPicture[6].Draw(myB[i, j].x, myB[i, j].y);
          if (myb[i, j].condition = 6) then MassOfPicture[7].Draw(myB[i, j].x, myB[i, j].y);
          if (myb[i, j].condition = 7) then MassOfPicture[8].Draw(myB[i, j].x, myB[i, j].y);          
          if (myb[i, j].condition = 8) then MassOfPicture[9].Draw(myB[i, j].x, myB[i, j].y);
          if (myb[i, j].bomb) and (myb[i, j].condition = 9) then begin
            MassOfPicture[10].Draw(myB[i, j].x, myB[i, j].y);
            The_end();
          end;       
        end;
      end;
    end;
    win();
  end;
end;

procedure RandomPole();   //random
var
  i, j, rx, ry: integer;
begin
  randomize;  
  for i := 1 to field_size do//изначальные характеристики
  begin
    for j := 1 to field_size do
    begin
      myB[i, j].bomb := false;
      myB[i, j].check := false;
      myB[i, j].flag := false;
      myB[i, j].condition := 0;
      myB[i, j].x := i * 35;
      myB[i, j].y := j * 35 + 35;
      myB[i, j].sx := 35;
      myB[i, j].sy := 35;
    end;
  end;
  
  for i := 1 to 10 do// бомбочки
  begin
    rx := Random(10) + 1;
    ry := Random(10) + 1;
    while myb[rx, ry].bomb = true do
    begin
      rx := Random(10) + 1;
      ry := Random(10) + 1;            
    end;
    myb[rx, ry].bomb := true;
    myB[rx, ry].condition := 9;
  end;
end;

procedure CalcBomb();
var
  i, j: integer;
begin
  for i := 1 to field_size do
  begin
    for j := 1 to field_size do
    begin
      if (i = 1) and (j = 1) then begin//верхний левый угол
        if myb[1, 2].bomb then myb[1, 1].condition += 1;
        if myb[2, 1].bomb then myb[1, 1].condition += 1;
        if myb[2, 2].bomb then myb[1, 1].condition += 1;
      end;
      if (i = 1) and (j = field_size) then begin//верхний правый угол
        if myb[1, 9].bomb then myb[1, field_size].condition += 1;
        if myb[2, field_size].bomb then myb[1, field_size].condition += 1;
        if myb[9, field_size].bomb then myb[field_size, field_size].condition += 1;
        if myb[9, 9].bomb then myb[field_size, field_size].condition += 1;
        if myb[2, 9].bomb then myb[1, field_size].condition += 1;
      end;
      if (i = field_size) and (j = 1) then begin//нижний левый угол
        if myb[9, 1].bomb then myb[field_size, 1].condition += 1;
        if myb[field_size, 2].bomb then myb[field_size, 1].condition += 1;
        if myb[9, 2].bomb then myb[field_size, 1].condition += 1;
      end;
      if (i = field_size) and (j = field_size) then begin//нижний правый угол
        if myb[field_size, 9].bomb then myb[field_size, field_size].condition += 1;
      end;
      if (i = 1) and (j <> 1) and (j <> field_size) then begin
        if myb[1, j - 1].bomb then myb[1, j].condition += 1;//для верхнего ряда без углов
        if myb[1, j + 1].bomb then myb[1, j].condition += 1;
        if myb[2, j].bomb then myb[1, j].condition += 1;
        if myb[2, j - 1].bomb then myb[1, j].condition += 1;
        if myb[2, j + 1].bomb then myb[1, j].condition += 1;
      end;
      if (i = field_size) and (j <> 1) and (j <> field_size) then begin
        if myb[field_size, j - 1].bomb then myb[field_size, j].condition += 1;//для нижнего ряда без углов
        if myb[field_size, j + 1].bomb then myb[field_size, j].condition += 1;
        if myb[9, j].bomb then myb[field_size, j].condition += 1;
        if myb[9, j - 1].bomb then myb[field_size, j].condition += 1;
        if myb[9, j + 1].bomb then myb[field_size, j].condition += 1;
      end;
      if (j = 1) and (i <> 1) and (i <> field_size) then begin
        if myb[i - 1, j].bomb then myb[i, 1].condition += 1;//для левого ряда без углов
        if myb[i + 1, j].bomb then myb[i, 1].condition += 1;
        if myb[i, j + 1].bomb then myb[i, 1].condition += 1;
        if myb[i - 1, j + 1].bomb then myb[i, 1].condition += 1;
        if myb[i + 1, j + 1].bomb then myb[i, 1].condition += 1;
      end;
      if (j = field_size) and (i <> 1) and (i <> field_size) then begin
        if myb[i - 1, j].bomb then myb[i, field_size].condition += 1;//для правого ряда без углов
        if myb[i + 1, j].bomb then myb[i, field_size].condition += 1;
        if myb[i, j - 1].bomb then myb[i, field_size].condition += 1;
        if myb[i - 1, j - 1].bomb then myb[i, field_size].condition += 1;
        if myb[i + 1, j - 1].bomb then myb[i, field_size].condition += 1;
      end;
      if (i <> 1) and (j <> 1) and (i <> field_size) and (j <> field_size) then begin
        if myb[i + 1, j].bomb then myb[i, j].condition += 1;//для центральных клеток
        if myb[i - 1, j].bomb then myb[i, j].condition += 1;
        if myb[i, j + 1].bomb then myb[i, j].condition += 1;
        if myb[i, j - 1].bomb then myb[i, j].condition += 1;
        if myb[i + 1, j + 1].bomb then myb[i, j].condition += 1;
        if myb[i - 1, j - 1].bomb then myb[i, j].condition += 1;
        if myb[i + 1, j - 1].bomb then myb[i, j].condition += 1;
        if myb[i - 1, j + 1].bomb then myb[i, j].condition += 1;
      end;
    end;
  end;  
end;

procedure Res_Load();  //Загрузка текстур
begin
  window.Height := 500; 
  window.Width := 700;    
  window.Caption := 'Сапер'; 
  window.IsFixedSize := true;  
  clearwindow(clcyan);
  calc_flag := 10;
  k_flag := new SquareABC(430, 80, 60, clSkyBlue);
  k_flag.Text := IntToStr(calc_flag);
  MassOfPicture[1] := Picture.Create('resurce\bclear.png');
  MassOfPicture[1].Load('resurce\bclear.png');  
  MassOfPicture[2] := Picture.Create('resurce\b1.png');
  MassOfPicture[2].Load('resurce\b1.png');       
  MassOfPicture[3] := Picture.Create('resurce\b2.png');
  MassOfPicture[3].Load('resurce\b2.png');  
  MassOfPicture[4] := Picture.Create('resurce\b3.png');
  MassOfPicture[4].Load('resurce\b3.png');          
  MassOfPicture[5] := Picture.Create('resurce\b4.png');
  MassOfPicture[5].Load('resurce\b4.png');       
  MassOfPicture[6] := Picture.Create('resurce\b5.png');
  MassOfPicture[6].Load('resurce\b5.png');   
  MassOfPicture[7] := Picture.Create('resurce\b6.png');
  MassOfPicture[7].Load('resurce\b6.png');      
  MassOfPicture[8] := Picture.Create('resurce\b7.png');
  MassOfPicture[8].Load('resurce\b7.png');  
  MassOfPicture[9] := Picture.Create('resurce\b8.png');
  MassOfPicture[9].Load('resurce\b8.png');          
  MassOfPicture[10] := Picture.Create('resurce\bb.jpg');
  MassOfPicture[10].Load('resurce\bb.jpg');  
  MassOfPicture[11] := Picture.Create('resurce\bnoch.png');
  MassOfPicture[11].Load('resurce\bnoch.png');   
  MassOfPicture[12] := Picture.Create('resurce\flag.png');
  MassOfPicture[12].Load('resurce\flag.png');      
end;

function MyButtonClick(x, y, sx, sy, mx, my, mb: integer): boolean;//klick or not
begin
  if(mx >= x) and (mx <= x + sx) and (my >= y) and (my <= y + sy) then
    result := true
  else result := false;      
end;

procedure MouseDown(x, y, mb: integer); //where klick
var
  b: boolean;
  i, j: integer;
begin
  for i := 1 to field_size do
  begin
    for j := 1 to field_size do
    begin
      if mb = 1 then begin  //если кликнули на рисунке левой кнопкой
        b := MyButtonClick(myB[i, j].x, myB[i, j].y, 35, 35, x, y, mb);
        if b = true then  
          myB[i, j].check := true;                  
      end;      
      if mb = 2 then begin //если кликнули на рисунке правой кнопкой
        b := MyButtonClick(myB[i, j].X, myB[i, j].Y, 32, 32, x, y, mb);
        if b = true then  
        begin
          if myB[i, j].check <> true then begin
            if myB[i, j].flag = true then begin
              myB[i, j].flag := false;
              calc_flag += 1;
            end else
            begin
              myB[i, j].flag := true;
              calc_flag -= 1;
            end;
            k_flag.Text := IntToStr(calc_flag);
          end;          
        end;         
      end;      
    end;
  end;
  DrawPoleSapera();
end;

procedure NewGame; //new game
begin
  window.clear;
  Res_Load();
  RandomPole();
  CalcBomb();
  DrawPoleSapera();
  N_flag := new RectangleABC(420, 40, 80, 30, clSkyBlue);
  N_flag.Text:='флажки';
end;

begin		//main part
  btNewGame := ButtonABC.Create(575, 40, 100, 'Новая игра', clSkyBlue);
  btNewGame.OnClick := NewGame;
  NewGame;
  OnMouseDown := MouseDown;
end.