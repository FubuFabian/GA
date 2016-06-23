% fobj_mgm_ppbw.m
% F: vector de salida con el valor de fobj para cada renglon (cromosoma) de PoP
% XY vector de forma promedio 2 columnas
% IMA imagen 
% PoP_Real matriz de cromosomas decodificados uno por renglon
function F=fobj_mgm_ppbw(YP, Pop_Real, MEDIA2COL, P10, Limb10)
global ORIX
global ORIY
dt=0.25; %incremento de t durante interpolacion parametrica 0<=t<=1
[rencrom, colcrom]=size(Pop_Real);
[ren col]=size(MEDIA2COL);
for no_ind=1:rencrom
   ind=Pop_Real(no_ind,:);
   lind=length(ind);
   s=ind(lind-1);
	th=ind(lind);
	tx=ind(lind-3);
	ty=ind(lind-2);
	T=[s*cos(th) -s*sin(th); s*sin(th) s*cos(th)];
	b=ind(1:10);
    x=P10*b';
	puntos=1;
	for i=1:2:length(x)-1
   	xy(puntos,1)=x(i);
	   xy(puntos,2)=x(i+1);
   	puntos=puntos+1;
   end
   XY=xy+MEDIA2COL; %NUEVA FORMA DEL CONTORNO
   XYi=interpolar_t(XY(:,1), XY(:,2), dt);
   XYi(:,2)=-1*XYi(:,2); %inversion de Y pa'que salga al derecho en la imagen
   [reni coli]=size(XYi);
   XYc=repmat([ORIX+tx ORIY+ty],[reni,1]);
   XYT=(T*XYi')'+XYc;
   F(no_ind)=prom_255_menosIn_masOut(XYT(:,1), XYT(:,2), YP);   % notas del 17/feb/2004
end
F=F';

