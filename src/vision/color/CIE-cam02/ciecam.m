R = 187.2483;
G = 1.9948;
B = 26.3469;

var_R = ( R / 255 );        %Where R = 0 ÷ 255
var_G = ( G / 255 );        %Where G = 0 ÷ 255
var_B = ( B / 255 );        %Where B = 0 ÷ 255

if ( var_R > 0.04045 ) var_R = ( ( var_R + 0.055 ) / 1.055 ) ^ 2.4;
else                   var_R = var_R / 12.92;
end
if ( var_G > 0.04045 ) var_G = ( ( var_G + 0.055 ) / 1.055 ) ^ 2.4;
else                   var_G = var_G / 12.92;
end
if ( var_B > 0.04045 ) var_B = ( ( var_B + 0.055 ) / 1.055 ) ^ 2.4;
else                   var_B = var_B / 12.92;
end

var_R = var_R * 100;
var_G = var_G * 100;
var_B = var_B * 100;

X = var_R * 0.4124 + var_G * 0.3576 + var_B * 0.1805
Y = var_R * 0.2126 + var_G * 0.7152 + var_B * 0.0722
Z = var_R * 0.0193 + var_G * 0.1192 + var_B * 0.9505

%X1=X/Y;
%Y1=Y/Y;
%Z1=Z/Y;

M1=[0.7328 0.4296 -0.1624
    -0.7306 1.6975 0.0061
    0.0030 0.0136 0.9834];

xyz_ratio=[X
    Y
    Z];

rgb1=M1*xyz_ratio

% Tristimulus values of white point
% Table A4 Page 294 Ohta Robinson
% Illuminant  X        Y       Z
%    A       109.85   100.00  35.58
%    D65      95.04   100.00 108.89
%    C        98.07   100.00 118.23
%    D50      96.42   100.00  82.49
%    D55      95.68   100.00  92.14
%    D75      94.96   100.00 122.61
%    B        99.09   100.00  85.31

Xw=95.04;
Yw=100.00;
Zw=108.89;

xyz_w_ratio=[Xw
    Yw
    Zw];

rgbw=M1*xyz_w_ratio;

D=0.7; % Degree of adaptation 0.6<D<1;

Rc=[(Yw*D/rgbw(1))+(1-D)]*rgb1(1);
Gc=[(Yw*D/rgbw(2))+(1-D)]*rgb1(2);
Bc=[(Yw*D/rgbw(3))+(1-D)]*rgb1(3);

Rcw=[(Yw*D/rgbw(1))+(1-D)]*rgbw(1);
Gcw=[(Yw*D/rgbw(2))+(1-D)]*rgbw(2);
Bcw=[(Yw*D/rgbw(3))+(1-D)]*rgbw(3);

rgbc=[Rc
    Gc
    Bc];

rgbcw=[Rcw
    Gcw
    Bcw];


M2=[0.38971 0.68898 -0.07868
    -0.22981 1.18340 0.04641
    0 0 1];

rgb2=M2*inv(M1)*rgbc;
rgbw2=M2*inv(M1)*rgbcw;

% Typical luminance values
% 1.6 * 109 cd/m2    Solar disk at noon (don't look!)
% 600'000 cd/m2    Solar disk at horizon
% 120'000 cd/m2    Frosted bulb 60 W
% 11'000 cd/m2    T8 cool white fluorescent
% 8'000 cd/m2    Average clear sky
% 2'500 cd/m2    Moon surface
% 2'000 cd/m2    Average cloudy sky
% 30 cd/m2   Green electroluminescent source
% 0.0004 cd/m2   Darkest sky

La= 11000;
k= 1/(5*La+1);

Fl=0.2*(k^4)*(5*La)+0.1*((1-k^4)^2)*((5*La)^(1/3));

Ra=400*((Fl*rgb2(1)/100)^0.42)/(27.13+((Fl*rgb2(1)/100)^0.42))+0.1;
Ga=400*((Fl*rgb2(2)/100)^0.42)/(27.13+((Fl*rgb2(2)/100)^0.42))+0.1;
Ba=400*((Fl*rgb2(3)/100)^0.42)/(27.13+((Fl*rgb2(3)/100)^0.42))+0.1;

Raw=400*((Fl*rgbw2(1)/100)^0.42)/(27.13+((Fl*rgbw2(1)/100)^0.42))+0.1;
Gaw=400*((Fl*rgbw2(2)/100)^0.42)/(27.13+((Fl*rgbw2(2)/100)^0.42))+0.1;
Baw=400*((Fl*rgbw2(3)/100)^0.42)/(27.13+((Fl*rgbw2(3)/100)^0.42))+0.1;

a=Ra-12*Ga/11+Ba/11;
b=1/9*(Ra+Ga-2*Ba);
if (a>0 & b>0)
    h=atan(b/a);
end
if (a<0 & b>0)
    h=3.1416+atan(b/a);
end
if (a<0 & b<0)
    h=3.1416+atan(b/a);
end
if (a>0 & b<0)
    h=2*3.1416+atan(b/a);
end

hdeg=h*180/3.1416
if (hdeg>=0 & hdeg<20.14) hdeg=360+hdeg;
end  
hr=20.14;
hy=90;
hg=164.25;
hb=237.53;

if (hdeg>=20.14 & hdeg<90)
    h1=20.14;
    h2=90;
    H1=0;
end

if (hdeg>=90 & hdeg<164.25)
    h1=90;
    h2=164.25;
    H1=100;
end 

if (hdeg>=164.25 & hdeg<237.53)
    h1=90;
    h2=164.25;
    H1=200;
end 

if (hdeg>=237.53)
    h1=237.53;
    h2=380.14;
    H1=300;
end 

e1=0.25*(cos(h1+360/3.1416)+3.8);
e2=0.25*(cos(h2+360/3.1416)+3.8);
H=H1+100*(hdeg-h1)/e1/((h-h1)/e1+(h2-h)/e2);

Yb=50;
Nbb=0.725*((Yw/Yb)^0.2);
A=(2*Ra+Ga+1/20*Ba-0.305)*Nbb;
Aw=(2*Raw+Gaw+1/20*Baw-0.305)*Nbb;

% c=0.525 (dark surround), c=0.59 (dim surround), c=0.69 (average surround)
c=0.69;
z=1.48+sqrt(Yb/Yw);
J=100*((A/Aw)^(c*z)) % lightness

Q=(4/c)*sqrt(J/100)*(Aw+4)*(Fl^0.25) % brightness

% Nc=0.8 (dark surround) Nc=0.9 (dim surround) Nc=1.0 (average surround)
Nc=1.0;
Ncb=Nbb;
e=0.25*(cos(hdeg+360/3.1416)+3.8);
t=(50000/13)*Nc*Ncb*e*(a^2+b^2)/(Ra+Ga+21/20*Ba);

C=(t^0.9)*sqrt(J/100)*((1.64-(0.29^(Yb/Yw)))^(0.73)) % chroma
M=C*(Fl^0.25) % colourfulness
s=100*sqrt(M/Q) % saturation