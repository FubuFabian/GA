% prom_d.m
% ENTRADAS
% XY es una matriz con el contorno
% YP es la imagen original

function f=prom_d(X, Y, YP)
global PUNTOS_MODELO
INFLMT=-10; %extremo exterior del perfil de gris
SUPLMT=10;	%extremo interior del mismo
%[ren col]=size(XY);
%XY(ren+1, :)=XY(1,:);
no_puntos=length(X);
f=0;
suma_ext=0;
for punto=1:no_puntos-1
	inc_X= X(punto+1)-X(punto);
	inc_Y= Y(punto+1)-Y(punto);
	if inc_Y==0
		if inc_X>0 normal_angle=3*pi/2; end %// 270 degrees
		if inc_X<0 normal_angle=pi/2; end%// 90 degrees
		if inc_X==0 normal_angle=-10.0; end%// error p1 and p0 are the same point!
		
	else
		if inc_Y>0 normal_angle= atan(-1*inc_X/inc_Y); end
		if inc_Y<0 normal_angle= atan(-1*inc_X/inc_Y)+pi;end
		
	end
	cos_normal_angle= cos(normal_angle);
	sin_normal_angle= sin(normal_angle);
   F=zeros(SUPLMT-INFLMT+1);
   for k=INFLMT:SUPLMT
       dx= (k*cos_normal_angle+0.5);
		dy= (k*sin_normal_angle+0.5);
       dxpg=round(dx+X(punto));
       dypg=round(dy+Y(punto));
       F(k-INFLMT+1)=YP(dypg, dxpg); 
       %YP(dypg, dxpg)=255;
   end %for k=INFLMT:SUPLMT
   F_EXTERIOR=mean(F(1:-INFLMT));
   F_INTERIOR=mean(F(-INFLMT+2:SUPLMT-INFLMT+1));
   d=255-F_EXTERIOR+F_INTERIOR;
   f=f+d; 
   suma_ext=suma_ext+F_EXTERIOR;
end % end for punto=1:
f=f/((no_puntos-1)*sqrt(suma_ext));
%figure
%imshow(uint8(YP))