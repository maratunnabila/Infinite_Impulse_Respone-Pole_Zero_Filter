unit Unit1;

interface

uses
  Math, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus, Vcl.StdCtrls,
  VCLTee.Series, VCLTee.TeEngine, Vcl.ExtCtrls, VCLTee.TeeProcs, VCLTee.Chart;

type
  TForm1 = class(TForm)
    Chart1: TChart;
    Series1: TLineSeries;
    Series2: TLineSeries;
    Series3: TLineSeries;
    Series4: TLineSeries;
    Series5: TPointSeries;
    Series6: TPointSeries;
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    Chart2: TChart;
    Series7: TLineSeries;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Button1: TButton;
    Chart3: TChart;
    Series8: TLineSeries;
    Chart4: TChart;
    Series9: TLineSeries;
    Chart5: TChart;
    Series10: TLineSeries;
    Series11: TLineSeries;
    Series12: TLineSeries;
    StaticText5: TStaticText;
    procedure Lingkaran;
    procedure Pole;
    procedure Zero;
    procedure SinyalInput;
    procedure SinyalOutput;
    procedure RespMag;
    procedure RespFrek;
    procedure ScrollBar1Change(Sender: TObject);
    procedure ScrollBar2Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  x,y1,y2,y3,y4,real,imj,magnitude,noisehilang: array [-1000..1000] of extended;
  num1,num2,num3,num4,denum1,denum2,denum3,denum4,mag1,mag2,mag3,mag4: array [-1000..1000] of extended;
  r,teta,xp1,yp1,xp11,yp11,xx: extended;
  a1,a2,a3,f1,f2,f3,noise,p: extended;
  fs,t,i: integer;

const ndata=500;

implementation

{$R *.dfm}


procedure TForm1.Lingkaran;
begin
  series1.clear;
  series2.clear;

   for t:=-1000 to 1000 do
   begin
   series1.AddXY(t/1000, abs(sqrt(1- power(t/1000,2))));
   end;

   for t:=1000 downto -1000 do
   begin
   series2.AddXY(t/1000, -abs(sqrt(1- power(t/1000,2))));
   end;
end;

procedure TForm1.Pole;
begin
  series3.Clear;
  series4.Clear;
  p:=-1;
  r:=(ScrollBar1.Position)/1000;
  teta:=(ScrollBar2.Position)*(pi/180);

  xp1:=r*cos(teta);
  yp1:=r*sin(teta);
  xp11:=r*cos(-teta);
  yp11:=r*sin(-teta);
  series3.AddXY(xp1,yp1);
  series4.AddXY(xp11,yp11);

  while p<=1 do
  begin
  series11.AddXY(0,p);
  series12.AddXY(p,0);
  p:=p+0.001;
  end;

end;

procedure TForm1.Zero;
begin
  series5.Clear; series6.Clear;
  if radiobutton1.Checked = true then
   begin
   series5.AddXY(-1,0);
   series6.AddXY(-1,0);
   end
   else if radiobutton2.Checked= true then
   begin
   series5.AddXY(1,0);
   series6.AddXY(1,0);
   end
   else if radiobutton3.Checked = true then
   begin
   series5.AddXY(-1,0);
   series6.AddXY(1,0);
   end
   else if radiobutton4.Checked= true then
   begin
   series5.AddXY(1*cos(45*pi/180),-1*sin(45*pi/180));
   series6.AddXY(1*cos(45*pi/180),1*sin(45*pi/180));
   end;
end;

procedure TForm1.ScrollBar1Change(Sender: TObject);
begin
  Series1.clear; series2.Clear; series3.clear; series4.Clear;
  series8.Clear; series9.Clear;
  StaticText2.Caption:=(floattostr(r));
  StaticText4.Caption:=(floattostr(teta));
  Lingkaran;
  Pole;
  Zero;
  SinyalOutput;
  RespMag;
  RespFrek;
end;

procedure TForm1.ScrollBar2Change(Sender: TObject);
begin
  Series1.clear; series2.Clear; series3.clear; series4.Clear;
  series8.Clear; series9.Clear;
  StaticText2.Caption:=(floattostr(r));
  StaticText4.Caption:=(floattostr(teta));
  Lingkaran;
  Pole;
  Zero;
  SinyalOutput;
  RespMag;
  RespFrek;
end;

procedure TForm1.SinyalInput;
begin

  a1:=strtofloat(Edit1.Text);
  a2:=strtofloat(Edit2.Text);
  a3:=strtofloat(Edit3.Text);
  f1:=strtofloat(Edit4.Text);
  f2:=strtofloat(Edit5.Text);
  f3:=strtofloat(Edit6.Text);
  fs:=strtoint(Edit7.Text);

  noise:=randg(0.5,1);

  for t := 0 to fs div 2 do
  begin
   x[t]:=(a1*sin(2*pi*t*(f1/fs)))+(a2*sin(2*pi*t*(f2/fs)))+(a3*cos(2*pi*t*(f3/fs)))+noise;
   Series7.AddXY(t,x[t]);
  end;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  SinyalInput;
end;

procedure TForm1.SinyalOutput;
begin
  series8.Clear;
  r:=(ScrollBar1.Position)/1000;
  teta:=(ScrollBar2.Position)*0.36;

   //low pass
  if radiobutton1.Checked = true then
   begin
     for t:= 0 to (ndata-1) do
      begin
        y1[t] := y1[0];
        y1[-t] := y1[0];
      end;

    for t:= 0 to ndata-1 do
    begin
    y1[t]:= x[t] + (2*x[t-1]) + x[t-2] + (2*cos(teta)*r*y1[t-1]) - (sqr(r)*y1[t-2]);
    series8.AddXY(t, y1[t]);
    end;
   end;

  //high pass
  if radiobutton2.Checked = true then
   begin
    for t:= 0 to (ndata-1) do
      begin
        y2[t] := y2[0];
        y2[-t] := y2[0];
      end;

    for t:= 0 to ndata-1 do
    begin
    y2[t]:= x[t] - (2*x[t-1]) + x[t-2] + (2*cos(teta)*r*y2[t-1]) - sqr(r)*y2[t-2];
    Series8.AddXY(t, y2[t]);
    end;
   end;

  //band pass
  if radiobutton3.Checked = true then
  begin
    for t:= 0 to (ndata-1) do
      begin
        y3[t] := y3[0];
        y3[-t] := y3[0];
      end;

  for t:= 0 to ndata-1 do
   begin
    y3[t]:= x[t] + x[t-2] + (2*cos(teta)*r*y3[t-1]) - sqr(r)*y3[t-2];
    Series8.AddXY(t, y3[t]);
   end;
  end;

  //band stop
  if radiobutton4.Checked = true then
  begin
    for t:= 0 to (ndata-1) do
      begin
        y4[t] := y4[0];
        y4[-t] := y4[0];
      end;

  for t:= 0 to ndata-1 do
   begin
    y4[t]:= x[t] - (2*r*cos(teta)*x[t-1]) + x[t-2] + (2*r*cos(teta)*y4[t-1]) - sqr(r)*y4[t-2];
    Series8.AddXY(t, y4[t]);
   end;
  end;

end;

procedure TForm1.RespMag;
begin
  series9.Clear;
  r:=(ScrollBar1.Position)/1000;
  teta:=(ScrollBar2.Position)*0.36;

   //low pass
  if radiobutton1.Checked = true then
   begin
    for i:= 0 to fs div 2 do
    begin
    num1[i]:= sqr(cos(2*2*pi*i/fs) + (2*cos(2*pi*i/fs)) + 1) + sqr(sin(2*2*pi*i/fs) + (2*sin(2*pi*i/fs)));
    denum1[i]:= sqr(cos(2*2*pi*i/fs) - (2*r*cos(teta)*cos(2*pi*i/fs)) + sqr(r)) + sqr(sin(2*2*pi*i/fs) - (2*r*cos(teta)*sin(2*pi*i/fs)));
    mag1[i]:= (sqrt(num1[i] / denum1[i]));
    series9.AddXY((i*2*pi/fs), mag1[i]);
    end;
   end;

  //high pass
  if radiobutton2.Checked = true then
   begin
    for i:= 0 to fs div 2 do
    begin
    num2[i]:= sqr(cos(4*pi*i/fs) - (2*cos(2*pi*i/fs)) + 1) + sqr(sin(4*pi*i/fs) - (2*sin(2*pi*i/fs)));
    denum2[i]:= sqr(cos(4*pi*i/fs) - (2*r*cos(teta)*cos(2*pi*i/fs)) + sqr(r)) + sqr(sin(4*pi*i/fs) - (2*r*cos(teta)*sin(2*pi*i/fs)));
    mag2[i]:= (sqrt(num2[i]/ denum2[i]));
    Series9.AddXY(i, mag2[i]);
    end;
   end;

  //band pass
  if radiobutton3.Checked = true then
  begin
  for i:= 0 to fs div 2 do
   begin
    num3[i]:= sqr(cos(4*pi*i/fs)-1) + sqr(sin(4*pi*i/fs));
    denum3[i]:= sqr(cos(4*pi*i/fs) - (2*r*cos(teta)*cos(2*pi*i/fs)) + sqr(r)) + sqr(sin(4*pi*i/fs) - (2*r*cos(teta)*sin(2*pi*i/fs)));
    mag3[i]:= (sqrt(num3[i]/ denum3[i]));
    Series9.AddXY(i, mag3[i]);
   end;
  end;

  //band stop
  if radiobutton4.Checked = true then
  begin
  for i:= 0 to fs div 2 do
   begin
    num4[i]:= sqr(cos(4*pi*i/fs) - (2*cos(teta)*cos(2*pi*i/fs)) + 1) + sqr(2*sin(2*pi*i/fs)*cos(teta) - (sin(2*pi*i/fs)));
    denum4[i]:= sqr(cos(4*pi*i/fs) - (2*r*cos(teta)*cos(2*pi*i/fs)) + sqr(r)) + sqr(sin(4*pi*i/fs) - (2*r*cos(teta)*sin(2*pi*i/fs)));
    mag4[i]:= (sqrt(num4[i]/ denum4[i]));
    Series9.AddXY(i, mag4[i]);
   end;
  end;

end;

procedure TForm1.RespFrek;
var
j: integer;
realnum1,imajnum1,realdenum1,imajdenum1,phase1: array [-1000..1000] of extended;
realnum2,imajnum2,realdenum2,imajdenum2,phase2: array [-1000..1000] of extended;
realnum3,imajnum3,realdenum3,imajdenum3,phase3: array [-1000..1000] of extended;
realnum4,imajnum4,realdenum4,imajdenum4,phase4: array [-1000..1000] of extended;
begin
  series10.Clear;
  r:=(ScrollBar1.Position)/1000;
  teta:=(ScrollBar2.Position)*0.36;

   //low pass
  if radiobutton1.Checked = true then
   begin
    for j:= 0 to fs div 2 do
    begin
    realnum1[j]:= cos(2*2*pi*j/fs) + (2*cos(2*pi*j/fs) + 1);
    imajnum1[j]:= sin(2*2*pi*j/fs) + (2*sin(2*pi*j/fs));
    realdenum1[j]:= cos(2*2*pi*j/fs) - (2*r*cos(teta)*cos(2*pi*j/fs) + sqr(r));
    imajdenum1[j]:= sin(2*2*pi*j/fs) - (2*r*cos(teta)*sin(2*pi*j/fs));
    phase1[j]:= (180/pi)*(arctan2(imajnum1[j], realnum1[j]) - arctan2(imajdenum1[j], realdenum1[j]));
    series10.AddXY((j*2*pi/fs), phase1[j]);
    end;
   end;

  //high pass
  if radiobutton2.Checked = true then
   begin
    for j:= 0 to fs div 2 do
    begin
    realnum2[j]:= cos(4*pi*j/fs) - (2*cos(2*pi*j/fs)) + 1;
    imajnum2[j]:= sin(4*pi*j/fs) - (2*sin(2*pi*j/fs));
    realdenum2[j]:= cos(4*pi*j/fs) - (2*r*cos(teta)*cos(2*pi*j/fs)) + sqr(r);
    imajdenum2[j]:= sin(4*pi*j/fs) - (2*r*cos(teta)*sin(2*pi*j/fs));
    phase2[j]:= (180/pi)*(arctan2(imajnum2[j], realnum2[j]) - arctan2(imajdenum2[j], realdenum2[j]));
    series10.AddXY((j*2*pi/fs), phase2[j])
    end;
   end;

  //band pass
  if radiobutton3.Checked = true then
  begin
  for j:= 0 to fs div 2 do
    begin
    realnum3[j]:=(cos(2*2*pi*j/fs) - 1);
    realdenum3[j]:=(cos(2*2*pi*j/fs) - (2*r*cos(teta)*sin(2*pi*j/fs)) + sqr(r));
    imajnum3[j]:= (sin(2*2*pi*j/fs));
    imajdenum3[j]:= (sin(2*2*pi*j/fs) - (2*r*cos(teta)*sin(2*pi*j/fs)));
    phase3[j]:= (180/pi)*(arctan2(imajnum3[j],realnum3[j])- arctan2(imajdenum3[j],realdenum3[j]));
    series10.AddXY((j*2*pi/fs), phase3[j]);
    end;

   end;

  //band stop
  if radiobutton4.Checked = true then
  begin
  for j:= 0 to fs div 2 do
   begin
    realnum4[j]:=(cos(2*2*pi*j/fs) - (2*cos(teta)*cos(2*pi*j/fs)) + 1);
    realdenum4[j]:=(cos(2*2*pi*j/fs))-(2*r*cos(teta)*cos(2*pi*j/fs)) + sqr(r);
    imajnum4[j]:=(sin(2*2*pi*j/fs) - (sin(2*pi*j/fs))*(cos(2*pi*j/fs)));
    imajdenum4[j]:=(sin(2*2*pi*j/fs) - (2*r*cos(teta)*sin(2*pi*j/fs)));
    phase4[j]:= (180/pi)*(arctan2(imajnum4[j],realnum4[j])- arctan2(imajdenum4[j],realdenum4[j]));
    series10.AddXY((j*2*pi/fs), phase4[j]);
   end;
  end;

end;

end.
