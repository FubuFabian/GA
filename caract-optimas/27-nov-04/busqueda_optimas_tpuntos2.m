% busqueda_optimas1.m
% 15-10-2004: Funci?n de ajuste de un MDP a una imagen utilizando las caracteristicas optimas
% XY es una matriz con el contorno
% M** son la matrices con las derivadas de la imagen filtrada

% [dX dY] matriz de 2 columnas con los desplazamientos normales a cada punto de XY

function [dX, dY]=busqueda_optimas_tpuntos2(XY, MGI, MDxGI, MDyGI, MDxxGI, MDyyGI, MDxyGI, CAROPT, MUE_ENTRE, IO, renentre)
INFLMT=-5; %extremo exterior del perfil de gris
SUPLMT=5;	%extremo interior del mismo
INFLMT_BUS=-8;	% extremo exterior de la linea de busqueda
SUPLMT_BUS=8;		% extremo interior de la misma
[ren col]=size(XY);
XY(ren+1, :)=XY(1,:);
X=XY(:,1);
Y=XY(:,2);
no_puntos=ren+1;
minprom=0;
RESOL=2; %resolucion de la  busqueda
INDOP=find(CAROPT);
CAROPTPUNTO=CAROPT(INDOP);
for punto=1:no_puntos-1 % para todos los puntos del contorno
    %keyboard
    punto
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
    minfGs=100;
    % PRIMERO CLASIFICAMOS TODOS LOS PIXELES DEL PERFIL EXTENDIDO
    for k=INFLMT_BUS-INFLMT:SUPLMT_BUS+SUPLMT % para el perfil de longitud SUPLMT-INFLMT
            DX(k-INFLMT_BUS-INFLMT+1,1)= (k*cos_normal_angle+0.5)*RESOL;
		    DY(k-INFLMT_BUS-INFLMT+1,1)= (k*sin_normal_angle+0.5)*RESOL;
    end % para un perfil extendido  
    dx=X(punto,1);
    dy=Y(punto,1);
  	%'inicio de calcula_car_opt2' 
    VECTOROPT=calcula_car_opt3(MGI, MDxGI, MDyGI, MDxxGI, MDyyGI, MDxyGI, CAROPTPUNTO, DX, DY, dx, dy);
    %'inicio de knn_optimas1'
    IN_OUT=knn_optimas1(MUE_ENTRE, punto, VECTOROPT, CAROPTPUNTO, IO, renentre);
    %'fin de knn_optimas1'
     
    % AHORA BUSCAMOS EL MINIMO A LO LARGO DEL PERFIL EXTENDIDO CLASIFICADO MUESTRANDO
    % UN PERFIL PEQU&O
    for pixelperfil=INFLMT_BUS:SUPLMT_BUS
        j=pixelperfil-INFLMT_BUS+1;
        fGs(j)=sum(IN_OUT(j:-1*INFLMT+j-1))+sum((1-IN_OUT(-1*INFLMT+j+1:SUPLMT-INFLMT+j)));
        if (fGs(j))<minfGs
            minfGs=(fGs(j));
            jmin=j;
            posmin=pixelperfil;
        end
    end%end for pixelperfil
    dX(punto,1)= (posmin*cos_normal_angle+0.5);% ajust X respecto al punto i (X,Y)
	dY(punto,1)= (posmin*sin_normal_angle+0.5);
	minprom=minprom+minfGs;   
    %keyboard
end % end for punto=1.. procesamiento de los 35 puntos del modelo
minprom=minprom/35
