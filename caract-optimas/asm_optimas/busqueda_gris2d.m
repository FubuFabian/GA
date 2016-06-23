%Función de ajuste de un MDP a una imagen utilizando estadisticas de un conjunto 
%de entrenamiento de perfiles de gris (g_prom,Sg)
% XY es una matriz con el contorno
% IMA es la imagen sobre la que se busca ajustar al MDP
% inv_SSS es un arreglo 3D de con las matrices de covarianza INVERSAS de cada punto del MDP, una por capa
% pgris_prom es una matriz con los prefiles de gris promedio de cada punto, uno por renglón
% [dX dY] matriz de 2 columnas con los desplazamientos normales a cada punto de XY

function [dX, dY]=busqueda_gris2d(XY, IMA, inv_SSS, pgris_prom)
INFLMT=-12; %extremo exterior del perfil de gris
SUPLMT=12;	%extremo interior del mismo
INFLMT_BUS=-30;	% extremo exterior de la linea de busqueda
SUPLMT_BUS=30;		% extremo interior de la misma

[ren col]=size(XY);
XY(ren+1, :)=XY(1,:);
X=XY(:,1);
Y=XY(:,2);
no_puntos=ren+1;
IMA2=IMA;
minprom=0;
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
   minfGs=1e20;
   jmin=0;
   for j=INFLMT_BUS:SUPLMT_BUS 
		dx= (j*cos_normal_angle+0.5);
		dy= (j*sin_normal_angle+0.5);
		dx=round(dx+X(punto,1));
      dy=round(dy+Y(punto,1));
      for k=INFLMT:SUPLMT
         dxpg= (k*cos_normal_angle+0.5);
			dypg= (k*sin_normal_angle+0.5);
         dxpg=round(dx+dxpg);
		   dypg=round(dy+dypg);
         Gs1(1, k-INFLMT+1)=double(IMA(dypg,dxpg));
         %Gs=Gs/sum(Gs); %normalización del perfil de gris. Debe usarse con perfiles de entrenamiento normalizados
      end
      for indice=1:SUPLMT-INFLMT
         Gs(1,indice)=Gs1(indice+1)-Gs1(indice);
      end
      Gs=Gs/sum(abs(Gs));
    %  dbstop in busqueda_gris2.m at 56
    %  size(Gs)
    %  size(inv_SSS)
    % size(pgris_prom(punto,:))
         
     fGs(j-INFLMT_BUS+1)=(Gs-pgris_prom(punto,:))*inv_SSS(:,:,punto)*(Gs-pgris_prom(punto,:))';
      if (fGs(j-INFLMT_BUS+1))<minfGs
         minfGs=(fGs(j-INFLMT_BUS+1));
         jmin=j;
      end
            
   end%end for(j=
   dX(punto,1)= (jmin*cos_normal_angle+0.5);% ajust X respecto al punto i (X,Y)
	dY(punto,1)= (jmin*sin_normal_angle+0.5);
	%dx=round(dX(punto,1)+X(punto,1));
   %dy=round(dY(punto,1)+Y(punto,1));
   %IMA2(dy,dx)=255;
   minprom=minprom+minfGs;   
   %figure
   %plot([INFLMT_BUS:SUPLMT_BUS],fGs,'-r')
end % end for punto=1:
minprom=minprom/35
%figure
%imshow(IMA2)