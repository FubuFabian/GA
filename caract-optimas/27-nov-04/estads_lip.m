% estads_lip.m como en Pinoli (1997) mas o menos!
% programa para captura de muestras de constraste C y nivel de gris promedio 
% ENTRADAS
% XY es una matriz con el contorno
% YP es la imagen original

function f=estads_lip(X, Y, YP, nombre_contorno)
global PUNTOS_MODELO

INFLMT=-10; %extremo exterior del perfil de gris para un muestreo de puntos en sentido ANTIHORARIO
SUPLMT=10;	%extremo interior del mismo para un muestreo de puntos en sentido ANTIHORARIO
%[ren col]=size(XY);
%XY(ren+1, :)=XY(1,:);
no_puntos=length(X);
%f=0;
suma_ext=0;
suma_C=0;
suma_DIF=0;
%suma_C=double(suma_C);
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
   G_EXTERIOR=(F(1:-INFLMT));
   f_ext=0;
   for index=1:-INFLMT
   	   f_ext=f_ext+G_EXTERIOR(index)-f_ext*G_EXTERIOR(index)/256;
   end
   f_ext=256-256*(1-f_ext/256)^(1/10);
   
   G_INTERIOR=(F(-INFLMT+2:SUPLMT-INFLMT+1));
   f_int=0;
   for index=1:SUPLMT
   	   f_int=f_int+G_INTERIOR(index)-f_int*G_INTERIOR(index)/256;
   end
   f_int=256-256*(1-f_int/256)^(1/10);
   
   
   DIF=256*(f_int-f_ext)/(256-f_ext);
   suma_DIF=suma_DIF+DIF-suma_DIF*DIF/256;
   
   C=256*mod_lip(f_int-f_ext)/(256-min(f_ext, f_int));	
   suma_C=suma_C+C-suma_C*C/256;
   %keyboard     
 %  f=f+d; 
 	if rem(punto, 2)==0
   	 	suma_ext=suma_ext+f_ext-suma_ext*f_ext/256;
	end
end % end for punto=1:
%f=f/((no_puntos-1)*sqrt(suma_ext/(no_puntos-1)));
%figure
%imshow(uint8(YP))
%keyboard
suma_DIF=256-256*(1-suma_DIF/256)^(1/(no_puntos-1))
suma_C=256-256*(1-suma_C/256)^(1/(no_puntos-1))
suma_ext=256-256*(1-suma_ext/256)^(1/(no_puntos/2))

%f1=100-suma_C+0.5*suma_ext
%f2=256*(suma_ext-suma_C)/(256-suma_C)
%f3=[[suma_C suma_ext]-media_m]*invSm*[[suma_C suma_ext]-media_m]'; % Dmalahanobis

fid=fopen('estadisticas_lip.rtf', 'a')
fprintf(fid, '%s: p_suma_C:%4.4f	p_sumaDIF:%4.4f  p_suma_ext_35p:%4.4f \n', nombre_contorno, suma_C, suma_DIF, suma_ext);
fclose(fid)
%f=-256*suma_C/(256-suma_C);
%keyboard
%f=-256*suma_C/(256-suma_C);
f=0;
