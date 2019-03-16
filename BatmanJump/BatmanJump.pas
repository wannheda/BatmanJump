uses graphABC;

type
  point = record
    x, y: integer;
  end;

var
  batman, background, platform, startMenu, restartMenu, upper, how, achi, sett, pause : picture;
  left, right, x, y, i, h, score, sc, err, n, x1, y1, xx, yy: integer;
  vx, vy: real;
  platforms: array of point;
  game, active, howToPlay, achievement, gameover, restart, pau, menu, p: boolean;
  dataBase : array [1..5] of string;
  DB: text;

//КЛАВИАТУРА
procedure KeyDown(Key: integer);
begin
  if Key = VK_Left then 
    begin
      batman := picture.Create('image\batman1.png');
      left := 1;
    end;
  
  if Key = VK_Right then 
    begin
      batman := picture.Create('image\batman2.png');
      right := 1;
    end;
    
end;
//КЛАВИАТУРА

//МЫШЬ
procedure MouseUp(x, y, mb: integer);
begin
  if (mb = 1) and (x > 105) and (x < 430) and (y > 145) and (y < 258) then
    game := true;
  if (mb = 1) and (x > 136) and (x < 396) and (y > 325) and (y < 386) then
    howToPlay := true;
  if (mb = 1) and (x > 140) and (x < 398) and (y > 422) and (y < 480) then
    achievement := true;
  if (mb = 1) and (x > 354) and (x < 484) and (y > 664) and (y < 726) then
    active := false;
    
  if (mb = 1) and (x > 140) and (x < 398) and (y > 422) and (y < 480) and (pau = true) then
    begin
      achievement := false;
      active := false;
      pau := false;
    end;
  if (mb = 1) and (x > 105) and (x < 430) and (y > 145) and (y < 258) and (pau = true) then
    begin
      game := true;
      pau := false;
      p := true;
    end;
    
  if (mb = 1) and (x > 136) and (x < 400) and (y > 326) and (y < 386) and (gameover = true) then
    begin
      achievement := false;
      howtoplay := false;
      gameover := false;
      pau := false;
      p := false;
      game := true;
    end;
  if (mb = 1) and (x > 140) and (x < 394) and (y > 432) and (y < 480) and (gameover = true) then 
    begin
      achievement := false;
      howtoplay := false;
      gameover := false;
      active := false;
    end;
    
  if (mb = 1) and (x > 412) and (x < 470) and (y > 752) and (y < 814) and (howToPlay = true) then 
    begin
      active := true;
      howToPlay := false;
    end;
    
  if (mb = 1) and (x > 412) and (x < 470) and (y > 752) and (y < 814) and (achievement = true) then 
    begin
      active := true;
      achievement := false;
    end;

  if (mb = 1) and (x > 474) and (x < 496) and (y > 13) and (y < 34) and (game = true) then
    begin
      pau := true;
      game := false;
    end;

end;
//МЫШЬ

procedure BatmanJump();
var i: integer;
begin

  //ИЗОБРАЖЕНИЯ
  batman := picture.Create('image\batman1.png');
  background := picture.Create('image\background.png');
  platform := picture.Create('image\platform.png');
  startMenu := picture.Create('image\startMenu.png');
  restartMenu := picture.Create('image\restartMenu.png');
  upper := picture.Create('image\upper.png');
  how := picture.Create('image\howToPlay.png');
  achi := picture.Create('image\achievement.png');
  pause := picture.Create('image\pause1.png');
  
  active := true; game := false; howToPlay := false; achievement := false; gameover := false; p := false;
  
  //МЕНЮ
  while active do 
    begin
      assign(DB, 'data/dataBase');
      reset(DB);
      for i := 1 to 5 do readln(DB, dataBase[i]);
      close(DB);
      val(dataBase[3], n, err);
      SetLength(platforms, n);
      
      //СТАРТОВОЕ МЕНЮ
      window.Top:=0;
      ClearWindow; 
      
      if (p = false) then
        begin
          x := 266; y := 425; h := 425;
          score := 0;
          for i := 0 to n-1 do 
            begin
              xx := random(532);
              yy := random(850);
              if (yy < 843) then begin
              platforms[i].x := xx;
              platforms[i].y := yy;
              end;
            end;
          p := true;
         end;
             
      
      startMenu.Draw(0,0);
      Redraw;
      
      //ПАУЗА
     while pau do
        begin
          pause.Draw(0,0);
          Redraw;
        end;
        
      //ИГРА
      while game do
        begin
          Window.Top:=0;
          background.Draw(0, 0);
          for i := 0 to n-1 do
            platform.Draw(platforms[i].x, platforms[i].y);
          batman.Draw(x, y);
          upper.Draw(0, 0);
          TextOut(20,10,score.ToString);
          val(dataBase[1], sc, err);
          
          if left = 1 then  x := x - 7; 
          if right = 1 then x := x + 7; 
          
          
          if x < 0 then 
            begin 
              x := 532; 
              x := x - 7; 
            end;
          if x > 532 then 
            begin  
              x := 0 ; 
              x := x + 7;
            end;
          
          vy := vy + 0.1;
          y := y + round(vy);
          
          for i := 0 to n-1 do 
            if (x + 36 > platforms[i].x) and (x + 5 < platforms[i].x + 56) and (y + 53 > platforms[i].y) and (y + 53 < platforms[i].y + 14) and (vy > 0) then 
              begin
                vy := -7;
              end;
          
          if y < h then 
            begin
              for i := 0 to n-1 do 
                begin
                  y := h;
                  platforms[i].y := platforms[i].y - round(vy);
                
                  if platforms[i].y > 850 then 
                    begin
                      platforms[i].y := 0;
                      platforms[i].x := random(532);
                    end;
                end;
              score+=1;
            end;
          
          if y > 850 then 
            begin
              game := false;
              gameover := true;
              break;
            end;
          Redraw;
       end;
     
     //РЕСТАРТ
     while gameover do 
      begin
        window.Top:=0;
        restartMenu.Draw(0,0);
        TextOut(270,186,score.ToString);
        vy := 0;
        
        if score > sc then dataBase[1] := score.ToString;
        
        assign (DB, 'data\dataBase');
        rewrite(DB);
        for i := 1 to 5 do writeln(DB, dataBase[i]);
        close(DB);
        Redraw;
      end;
     
     //ПРАВИЛА
     while howToPlay do
      begin
        window.Top:=0;
        how.Draw(0,0);
        Redraw;
      end;
      
      //ДОСТИЖЕНИЯ
      while achievement do
        begin
          window.Top:=0;
          achi.Draw(0,0);
          TextOut(60, 74, dataBase[2]);
          TextOut(346, 74, dataBase[1]);
          Redraw;
        end;
    end;

end;

//УДЕРЖИВАНИЕ КЛАВИШ
procedure KeyUp(Key: integer);
  begin
    if Key = VK_Left then left := 0;
    if Key = VK_Right then right := 0;
  end;

procedure windowSetting();
  begin
    Window.Caption := 'Batman Jump 1.1.0';
    SetWindowSize(532, 850);
    Window.IsFixedSize := True;
    LockDrawing;
  end;

procedure keyboardMouse();
  begin
    OnKeyDown := KeyDown;
    OnKeyUp := KeyUp;
    OnMouseUp := MouseUp;
  end;

procedure fontSetting();
  begin
    SetFontSize(20);
    SetFontColor(clBlack);
    SetBrushStyle(bsClear);
    SetFontName('Ravie');
  end;

begin
  
  windowSetting; //НАСТРОЙКИ ОКНА
  
  fontSetting; //НАСТРОЙКИ ШРИФТОВ
  
  keyboardMouse; //КЛАВИАТУРА И МЫШЬ
  
  BatmanJump; //ИГРА
  
  Halt;
end.
