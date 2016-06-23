% fobj_gris_lip.m
% esta version llama a una funcion de contraste LIP Pinoli (1997)
% F: vector de salida con el valor de fobj para cada renglon (cromosoma) de PoP
% XY vector de forma promedio 2 columnas
% IMA imagen 
% PoP_Real matriz de cromosomas decodificados uno por renglon
function F=fobj_gris_lip(YP, Pop_Real, MEDIA2COL, P10, Limb10)
global ORIX
global ORIY
%PPINTER=1;
dt=0.5;
[rencrom, colcrom]=size(Pop_Real);
[ren col]=size(MEDIA2COL);
for no_ind=1:rencrom
   ind=Pop_Real(no_ind,:);
   lind=length(ind);
   s=ind(lind-1);
	th=ind(lind);
	tx=ind(lind-3);
	ty=ind(lind-2);
	XYc=repmat([ORIX+tx ORIY+ty],[ren,1]);
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
   XY(:,2)=-1*XY(:,2); %inversion de Y pa'que salga al derecho en la imagen
   XYT=(T*XY')'+XYc;
    XYi=interpolar_t(XYT(:,1), XYT(:,2), dt);
	F(no_ind)=contraste_lip(XYi(:,1),XYi(:,2), YP);   % funcion obj original para imagenes de ngris
end
F=F';

