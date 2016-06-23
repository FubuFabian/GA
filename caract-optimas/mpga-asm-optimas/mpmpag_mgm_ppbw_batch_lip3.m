% mpmpag_mgm_ppbw_lip3.m
% esta version usa el modelo logaritmico de procesamiento de imagenes LIP
% Actualizaci?n de un PDM utilizando un AG MULTIPOBLACION EN IMAGEN BW Y EN GRIS (notas 1/marzo/2004)
% sobre Ppros=pp>pf&pp>ph Y SOBRE ln(IMA)
% la imagen original se filtra por promedio con una ventana de 7x7
clear
global	ORIX 
global	ORIY
ORIX=316%285-20%+50-15%320%307%316%CENTRO DE LA PROSTATA EN IMAGENES TU DE 704*512
ORIY=265%225+30%+50+15+7%265%225% 
global PUNTOS_MODELO
PUNTOS_MODELO=35;
NO_EJEM=29;
NoComp=16; %No. de componentes principales del MDP determinadas all? abajo
EIG_VAL=load('eig_val_entrena_tu2_p25.txt');
%nom_eigvec=input('nombre del archivo de eigen vectores?\n')
EIG_VEC=load('eig_vec_entrena_tu2_p25.txt');
%nom_media=input('archivo con la media?\')
MEDIA=load('media_entrena_tu2_p25.txt');
%nom_X1=input('archivo con el contorno de ejemplo?');
%X1=load(nom_X1);

nombres=[%'g64-u3-15-03.tif';... 
    %'g64-u3-16-01.tif';...
%     'g64-u3-16-02.tif';...
%     %'g64-u3-19-00.tif';...
% 	%'g64-u3-19-01.tif';...
% 	%'g64-u3-19-02.tif';...
% 	'g64-u3-19-03.tif';...
% 	'g64-u3-19-04.tif';...
% 	'g64-u3-19-05.tif';...
%       'g64-u3-19-06.tif';...
%       'g64-u3-20-05.tif';...
%       'g64-u3-20-06.tif';...
%       'g64-u3-20-07.tif';...
%       'g64-u3-20-08.tif';...
%       'g64-u3-20-09.tif';...
%       'g64-u3-20-10.tif';...
%       'g64-u3-22-01.tif';...
%       'g64-u3-22-02.tif';...
%       'g64-u3-22-03.tif';...
       'g64-u3-22-04.tif';...
%       'g64-u3-22-05.tif';...
%       'g64-u3-22-06.tif';...
       'g64-u3-22-07.tif'];

%nombres=['g64-u3-15-03.tif';...
%        'g64-u3-15-03.tif';...
%        'g64-u3-15-03.tif';...
%        'g64-u3-15-03.tif';...
%        'g64-u3-15-03.tif';...
%        'g64-u3-15-03.tif';...
%        'g64-u3-15-03.tif';...
%        'g64-u3-15-03.tif';...
%        'g64-u3-15-03.tif';...
%        'g64-u3-15-03.tif'];
        
[ren_n col_n]=size(nombres);

% GENERACI?N DE INSTANCIAS DEL MODELO
P16=EIG_VEC(:,55:70);
P10=EIG_VEC(:,61:70);
D=diag(EIG_VAL);
Limb16=3*sqrt(D(55:70));
Limb10=3*sqrt(D(61:70));

puntos=1;
for i=1:2:length(MEDIA)-1
   XY(puntos,1)=MEDIA(i);
   XY(puntos,2)=MEDIA(i+1); 
   puntos=puntos+1;
end
[ren col]=size(XY);
MEDIA2COL=XY;
ORIXY=repmat([ORIX ORIY],[ren 1]);


%****************************************************************
%	PARAMETROS DEL AG
MAXGEN0=25%52%51%151; % generaciones de la 1a etapa
MAXGEN =2%251%151; % generaciones de la 2a etapa
GGAP = 1.0; %0.8;  % Generation gap, how many new individuals are created
NINDG =10;  % Number of individuals per subpopulations NIVEL DE GRIS
NIND0=10; % N?mero de Individuos por subpoblaci?n EN BLANCO Y NEGRO
NPOB=10; % N?mero de supoblaciones
INSR=0.9; % taza de reinserci?n
MIGR=0.2; % taza de migraci?n
MIGGEN=10; % intervalo entre migraciones en BW
MIGGENGRIS=10; % intervalo entre migraciones en nivel de gris
NVAR = 14;   % n?mero de variables
PRECI = [2,2,3,3,3,3,3,4,4,4,6,6,5,7];  % Precision of binary representation 55 bits
%[bi, tx,ty,S,th]
Sinf=0.65; %valor inferior del rango de la escala
Ssup=1.45; % valor superior
%FieldD=[PRECI;[[-22.9752;22.9752],[-26.604;26.604],[-28.167;28.167],[-34.69;34.69],...
%      [-41.81;41.81],[-47.9447;47.9447],[-54.959476;54.959476],...
%      [-72.1951;72.1951],[-102.96;102.96],[-121.4414;121.4414],[-39.68;39.68],...
%   	[-39.68;39.68],[0.33;1.28],[0;6.283185308]];rep([0; 0; 1 ;1], [1, NVAR])];

FieldD=[PRECI;[[-Limb10(1);Limb10(1)],[-Limb10(2);Limb10(2)],[-Limb10(3);Limb10(3)],[-Limb10(4);Limb10(4)],...
      [-Limb10(5);Limb10(5)],[-Limb10(6);Limb10(6)],[-Limb10(7);Limb10(7)],...
      [-Limb10(8);Limb10(8)],[-Limb10(9);Limb10(9)],[-Limb10(10);Limb10(10)],[-40;40],...
   	[-38;38],[Sinf;Ssup],[-3.1416; 3.1416]];repmat([0; 0; 1 ;1], [1, NVAR])];

%*****************************************************************
for exp=1:ren_n %inicio del metaciclo
nom_ima=nombres(exp,:);
IMA=imread(nom_ima, 'tif');
IMA=double(IMA);
%IMA=log(IMA+1);
%IMA=255*IMA/max(max(IMA));
IMA=255*(1-IMA/255);% modelo visual humano de IMA ?
IMAdisplay=IMA;
chiqui=nom_ima(5:length(nom_ima)-3);
nom_yp=strcat('ppbw705-', chiqui, 'tif');
YP=imread(nom_yp,'tif');
if max(max(YP))==1
   YP=double(YP)*255;
end
YP=imresize(YP,2);
YPdisplay=YP;
%keyboard
 
    
    % inicializacion aleatoria y sembrado de la Poblacion binaria
%A0=zeros(1, sum(PRECI)); 
%forma promedio de tamano minimo localizada en el origen, th=0
A0=[1 0 1 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
A1=A0;
A1(1, sum(PRECI)-11:sum(PRECI)-7)=ones(1,5);%forma promedio de tamano maximo localizada en el origen, th=0
Pob=crtbp(NPOB*NIND0,sum(PRECI));
Pob(1,:)=A0;
Pob(31,:)=A1;
% *******************************************
Pob_Real=bs2rv(Pob,FieldD);
ObjV=fobj_mgm_ppbw(YP, Pob_Real, MEDIA2COL, P10, Limb10);
%input('Pob inicial\n')
%keyboard
ind_minimo=1;
minimo=1e12;
%************  AJUSTE DEL PDM SOBRE IMAGEN BINARIA: FOBJ1
figure
hold on
gen=1;
while gen<MAXGEN0
	   FitnV = ranking(ObjV, [2 0], NPOB);
   % Select individuals for breeding
   SelCh = select('sus', Pob, FitnV, GGAP, NPOB);
   %input('Copias almacenadas en SelCh\n')
   %keyboard
   % Recombine selected individuals (crossover)
   SelCh = recombin('xovsp',SelCh,0.6, NPOB);
   % Perform mutation on offspring
   SelCh = mutate('mut',SelCh ,NaN, 0.01, NPOB);  
   %input('Ya mutamos y cruzamos SelCh\n')   %keyboard
   % Evaluate offspring, call objective function
	 PobReal=bs2rv(SelCh,FieldD);
    ObjSel=fobj_mgm_ppbw(YP, PobReal, MEDIA2COL, P10, Limb10);
    % Reinsert offspring into current population
    [Pob ObjV]=reins(Pob,SelCh,NPOB,[1, 0.9],ObjV,ObjSel); % [1,0.75] 1 representa el m?todo de reinserci?n en este caso inserci?n basada en el fitness, y 0.75 el porciento de los hijos que ser?n reinsertados
    gen
    [menor,indice]=min(ObjV)
 	  plot(gen,menor, '+b')
    gen=gen+1;
    %input('Ya se lleno Pob con la descendencia\n')
    %keyboard
    %MIGRACI?N
    if(rem(gen,MIGGEN)==0)
        [Pob, ObjV]=migrate(Pob, NPOB, [MIGR, 1, 0], ObjV);
    end
end
hold off
nomfbw=strcat(int2str(exp), 'fbw-',chiqui,'tif')
print( gcf, '-dtiffnocompression', nomfbw)
mejor_ind=Pob(indice,:);
ind=bs2rv(Pob(indice,:), FieldD);
lind=length(ind);
s=ind(lind-1);
th=ind(lind);
tx=ind(lind-3);
ty=ind(lind-2);
XYc=repmat([ORIX+tx ORIY+ty],[PUNTOS_MODELO,1]);
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
%Xint=XYT(:,1);
%Yint=XYT(:,2);
[Xint Yint]=interpolar_a1(XYT(:,1), XYT(:,2));
puntosa1=length(Xint);
for i=1:puntosa1
	YPdisplay(round(Yint(i)), round(Xint(i)))=128;   
end
figure
imshow(uint8(YPdisplay))
nomimabw=strcat(int2str(exp), 'resbw', chiqui, 'tif')
imwrite(uint8(YPdisplay), nomimabw, 'tif', 'compression', 'none')
%keyboard
%**************** AJUSTE DEL PDM SOBRE FUNCION DE TONOS DE GRIS  Pinoli (1997)
W=0.4;
medb1=ind(1);
medb2=ind(2);
medb3=ind(3);
medb4=ind(4);
medb5=ind(5);
medb6=ind(6);
medb7=ind(7);
medb8=ind(8);
medb9=ind(9);
medb10=ind(10);
medtx=ind(11);
medty=ind(12);
medS=ind(13);
medSsup=(medS+W*medS);
if (medSsup>Ssup)
   medSsup=Ssup;     
end
medSinf=(medS-W*medS);
if (medSinf<Sinf )
   medSinf=Sinf;
end

medth=ind(14);
FieldD1=FieldD;
FieldD1(1:7, 11:14)=[[6 6 5 7]; [[medtx-20;medtx+20],[medty-20;medty+20],...
   [medSinf ;medSsup],[medth-pi/4;medth+pi/4]];...
	repmat([0; 0; 1 ;1], [1, 4])];


%FieldD1(1:7, 11:14)=[[6 6 5 7]; [[medtx-W*abs(medtx);medtx+W*abs(medtx)],[medty-W*abs(medty);medty+W*abs(medty)],...
%   [medS-W*abs(medS);medS+W*abs(medS)],[medth-W*abs(medth);medth+W*abs(medth)]];...
%	repmat([0; 0; 1 ;1], [1, 4])];

%FieldD1=[PRECI;[[medb1-W*abs(medb1);medb1+W*abs(medb1)],[medb2-W*abs(medb2);medb2+W*abs(medb2)],[medb3-W*abs(medb3);medb3+W*abs(medb3)],[medb4-W*abs(medb4);medb4+W*abs(medb4)],...
%      [medb5-W*abs(medb5);medb5+W*abs(medb5)],[medb6-W*abs(medb6);medb6+W*abs(medb6)],[medb7-W*abs(medb7);medb7+W*abs(medb7)],...
%      [medb8-W*abs(medb8);medb8+W*abs(medb8)],[medb9-W*abs(medb9);medb9+W*abs(medb9)],[medb10-W*abs(medb10);medb10+W*abs(medb10)],[medtx-W*abs(medtx);medtx+W*abs(medtx)],...
%      [medty-W*abs(medty);medty+W*abs(medty)],[medS-W*abs(medS);medS+W*abs(medS)],[medth-W*abs(medth);medth+W*abs(medth)]];repmat([0; 0; 1 ;1], [1, NVAR])];
%[bi, tx,ty,S,th]
%Pob0=Pob;
%Pob_th=crtbp(NIND,PRECI(14));
%Pob(:, sum(PRECI)-(PRECI(14)-1):sum(PRECI))=Pob_th;
Pob=crtbp(NPOB*NINDG,sum(PRECI));
%Pob(1,:)=mejor_ind;
%Pob(2:NIND/2,:)=Pob0(2:NIND/2,:);
Pob_Real=bs2rv(Pob,FieldD1);
ObjV=fobj_gris_lip(IMA, Pob_Real, MEDIA2COL, P10, Limb10)
figure
hold on
gen=1;
while gen<MAXGEN
	   FitnV = ranking(ObjV, [2 0], NPOB);
   % Select individuals for breeding
      SelCh = select('sus', Pob, FitnV, GGAP, NPOB);
   % Recombine selected individuals (crossover)
      SelCh = recombin('xovsp',SelCh,0.6, NPOB);
   % Perform mutation on offspring
      SelCh = mutate('mut',SelCh ,NaN, 0.01, NPOB); 
   % Evaluate offspring, call objective function
	   PobReal=bs2rv(SelCh,FieldD1);
     ObjSel=fobj_gris_lip(IMA, PobReal, MEDIA2COL, P10, Limb10);
      % Reinsert offspring into current population
     % [Pob ObjV]=reins(Pob,SelCh,1,[1, 0.8],ObjV,ObjSel); % [1,0.75] 1 representa el m?todo de reinserci?n en este caso inserci?n basada en el fitness, y 0.75 el porciento de los hijos que ser?n reinsertados
      [Pob ObjV]=reins(Pob,SelCh,NPOB,[1, 0.9],ObjV,ObjSel);
      gen
      [menor,indice]=min(ObjV)
 	   plot(gen,menor, '+k')
   	  gen=gen+1;
      %MIGRACI?N
      if(rem(gen,MIGGENGRIS)==0)
        [Pob, ObjV]=migrate(Pob, NPOB, [MIGR, 1, 0], ObjV);
      end
  end
hold off

nomfgris=strcat(int2str(exp), 'fgris-',chiqui,'tif')
print( gcf, '-dtiffnocompression', nomfgris )
ind=bs2rv(Pob(indice,:), FieldD1);
lind=length(ind);
s=ind(lind-1);
th=ind(lind);
tx=ind(lind-3);
ty=ind(lind-2);
XYc=repmat([ORIX+tx ORIY+ty],[PUNTOS_MODELO,1]);
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
[Xint Yint]=interpolar_a1(XYT(:,1), XYT(:,2));
puntosa1=length(Xint);
for i=1:puntosa1
	IMAdisplay(round(Yint(i)), round(Xint(i)))=255;   
end
figure
imshow(uint8(IMAdisplay))
nomimagris=strcat(int2str(exp), 'resg', chiqui, 'tif')
imwrite(uint8(IMAdisplay), nomimagris, 'tif', 'compression', 'none')
%keyboard
end %fin del metaciclo


