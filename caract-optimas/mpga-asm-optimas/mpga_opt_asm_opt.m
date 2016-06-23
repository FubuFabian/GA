% mpga_opt_asm_opt.m
% este programa ajusta el PDM a una imagen binaria con un MPGA
% despues ajusta el ASM correspondiente utilizando caracteristicas optimas
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

% nombres=[
%       'g64-u3-16-01.tif';...
%       'g64-u3-16-02.tif';...
% 	    'g64-u3-19-01.tif';...
% 	    'g64-u3-19-02.tif';...
% 	    'g64-u3-19-03.tif';...
% 	    'g64-u3-19-04.tif';...
% 	    'g64-u3-19-05.tif';...
%       'g64-u3-20-05.tif';...
%       'g64-u3-20-06.tif';...
%       'g64-u3-20-07.tif';...
%       'g64-u3-20-08.tif';...
%       'g64-u3-20-09.tif';...
%       'g64-u3-20-10.tif';...
%       'g64-u3-22-01.tif';...
%       'g64-u3-22-02.tif';...
%       'g64-u3-22-03.tif';...
%        'g64-u3-22-04.tif';...
%        'g64-u3-22-05.tif';...
%        'g64-u3-22-06.tif';...
%        'g64-u3-22-07.tif'];

nombres=[
%       'u3-16-01.bmp';...
%       'u3-16-02.bmp';...
% 	  'u3-19-01.bmp';...
% 	  'u3-19-02.bmp';...
% 	  'u3-19-03.bmp';...
% 	  'u3-19-04.bmp';...
% 	  'u3-19-05.bmp';...
%       'u3-20-05.bmp';...
%       'u3-20-06.bmp';...
%       'u3-20-07.bmp';...
%       'u3-20-08.bmp';...
%       'u3-20-09.bmp';...
%       'u3-20-10.bmp';...
%       'u3-22-01.bmp';...
%       'u3-22-02.bmp';...
%       'u3-22-03.bmp';...
      'u3-22-04.bmp';...
%       'u3-22-05.bmp';...
%       'u3-22-06.bmp';...
%       'u3-22-07.bmp'
        ];

        
[ren_n col_n]=size(nombres);

%*************************************************************************
% MATRIZ CON LOS INDICES DE LAS CAR. OPTIMAS DE CADA PUNTO DEL PDM. CADA
% RENGLON DE CAROPT CORRESPONDE A UN PUNTO DEL PDM
CAROPT=load('car_opt_pros.txt');

%************************************************************************
% lectura de las muestras de entrenamiento para el clasificador KNN, K=5
%************************************************************************
NOMENTRE=[ %'an-u3-14-01-al.con';
%'an-u3-14-02-al.con';
%'an-u3-14-03-al.con';
%'an-u3-14-04-al.con';
%'an-u3-14-05-al.con';
%'an-u3-14-06-al.con';
%'an-u3-15-02-al.con';
%%'an-u3-15-03-al.con';
%'an-u3-15-04-al.con';
%'an-u3-15-05-al.con';
%'an-u3-15-06-al.con';
%'an-u3-16-03-al.con';
'an-u3-16-04-al.con';
%'an-u3-16-05-al.con';
%'an-u3-16-06-al.con';
%'an-u3-16-07-al.con';
%'an-u3-17-00-al.con';
%'an-u3-17-05-al.con';
%'an-u3-18-00-al.con';
%'an-u3-18-01-al.con';
%'an-u3-18-02-al.con';
%'an-u3-18-03-al.con';
%'an-u3-18-04-al.con';
%'an-u3-18-05-al.con';
];

[renentre, colentre]=size(NOMENTRE);
%figure
%axis equal
%hold on
for imagen=1:renentre % repetimos el ciclo para todos los archivos
   name=NOMENTRE(imagen,:);
   name=name(4:11);
   name=strcat('v5x5_60car_', name, '.txt');
   fid=fopen(name, 'r');
	for j=1:35
		L=fscanf(fid, '%c',20);
		LN=fscanf(fid, '%d\n',1);
			for i=1:25
				P=fscanf(fid, '%c',6);
				PN=fscanf(fid, '%d\n',1);
				P=fscanf(fid, '%c\n',24);
				IO((j-1)*25+i, imagen)=fscanf(fid, '%d\n',1);
				CAR=fscanf(fid, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f \n', 60);
				MUE_ENTRE((j-1)*25+i,:, imagen)=CAR';
			end
	end
	fclose(fid);
end % for imagen=1:renentre



%*****************************************************************
% GENERACI?N DE INSTANCIAS DEL MODELO
%*****************************************************************
P16=EIG_VEC(:,55:70);
P10=EIG_VEC(:,61:70);
D=diag(EIG_VAL);
Limb16=3*sqrt(D(55:70));Limb10=3*sqrt(D(61:70));
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
%****************************************************************
MAXGEN0=10%52%51%151; % generaciones de la 1a etapa
MAXGEN =2%251%151; % generaciones de la 2a etapa
GGAP = 1.0; %0.8;  % Generation gap, how many new individuals are created
NINDG =10;  % Number of individuals per subpopulations NIVEL DE GRIS
NIND0=10; % N?mero de Individuos por subpoblaci?n EN BLANCO Y NEGRO
NPOB=5; % N?mero de supoblaciones
INSR=0.9; % taza de reinserci?n
MIGR=0.2; % taza de migraci?n
MIGGEN=10; % intervalo entre migraciones en BW
MIGGENGRIS=10; % intervalo entre migraciones en nivel de gris
NVAR = 14;   % n?mero de variables
PRECI = [2,2,3,3,3,3,3,4,4,4,6,6,5,7];  % Precision of binary representation 55 bits
%[bi, tx,ty,S,th]
Sinf=0.65; %valor inferior del rango de la escala
Ssup=1.25;%1.45 % valor superior
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
chiqui=nom_ima(1:length(nom_ima)-3);

%***************************************************************
% calculo de las 6 derivadas gaussianas de I: D0 (imagen filtrada),  Dx, Dy, Dxx, Dyy, Dxy  
% para los 5 valores de sigma: 0.5, 1.0, 2.0, 4.0, 8.0
%*****************************************************************
nom_ima=strcat(chiqui, 'bmp');
IMA=imread(nom_ima, 'bmp');
sigma0=0.5; %escala interna inicial
   sigma=sigma0;
   for escala_externa=1:5
   		n=4*sigma+1; %tama?o de la mascara
		H=fspecial('gaussian', n, sigma);
		% Dx(H)=-(x/sigma^2)*H
		dxj=1;
		for x=-2*sigma:2*sigma
   			for dxi=1:4*sigma+1
     			DxH(dxi,dxj)=-(x/sigma^2)*H(dxi, dxj);   
   			end
   		dxj=dxj+1;
		end
		


		GI=conv2(H,IMA);
       [renDI, colDI]=size(GI)
       GI=GI(2*sigma+1:renDI-2*sigma, 2*sigma+1:colDI-2*sigma);
       MGI(:,:,escala_externa)=GI; % matriz con la imagen filtrada para sigma=0.5, 1.0, 2.0, 4.0, 8.0
       						% una imagen por capa de la matriz 
              
		DxGI=conv2(DxH, IMA);
       DxGI=DxGI(2*sigma+1:renDI-2*sigma, 2*sigma+1:colDI-2*sigma);
       MDxGI(:,:,escala_externa)=DxGI;
       
       % Dy(H)=-(y/sigma^2)*H
		dyi=1;
		for y=-2*sigma:2*sigma
   			for dyj=1:4*sigma+1
     			DyH(dyi, dyj)=-(y/sigma^2)*H(dyi, dyj);   
   			end
   		dyi= dyi+1;
		end
		DyGI=conv2(DyH, IMA);
       DyGI=DyGI(2*sigma+1:renDI-2*sigma, 2*sigma+1:colDI-2*sigma);
       MDyGI(:,:,escala_externa)=DyGI;
       
       %Dxx=(x^2/sigma^4-1/sigma^2)*H
		dxj=1;
		for x=-2*sigma:2*sigma
   			for dxi=1:4*sigma+1
     			DxxH(dxi, dxj)=(x^2/sigma^4-1/sigma^2)*H(dxi, dxj);   
   			end
   		dxj= dxj+1;
		end

		DxxGI=conv2(DxxH, IMA);
       DxxGI=DxxGI(2*sigma+1:renDI-2*sigma, 2*sigma+1:colDI-2*sigma);
       MDxxGI(:,:,escala_externa)=DxxGI;
       
       %Dyy=(y^2/sigma^4-1/sigma^2)*H
		dyi=1;
		for y=-2*sigma:2*sigma
   			for dyj=1:4*sigma+1
     			DyyH(dyi, dyj)=(y^2/sigma^4-1/sigma^2)*H(dyi, dyj);   
   			end
   		dyi= dyi+1;
		end
		DyyGI=conv2(DyyH, IMA);
       DyyGI=DyyGI(2*sigma+1:renDI-2*sigma, 2*sigma+1:colDI-2*sigma);
       MDyyGI(:,:,escala_externa)=DyyGI;
       
		%(magnitud del gradiente) DxyH=sqrt(DxH^2+DyH^2)
	    %DxyH=sqrt(DxH.*DxH + DyH.*DyH);
      DxGI=double(DxGI);
      DyGI=double(DyGI);
      DxyGI=sqrt(DxGI.*DxGI+ DyGI.*DyGI);
      MDxyGI(:,:,escala_externa)=DxyGI;
      sigma=sigma*2;
   end % for escala_externa=1:5  

%*************************************************************
% inicializacion aleatoria y sembrado de la Poblacion binaria
%A0=zeros(1, sum(PRECI)); 
%forma promedio de tamano minimo localizada en el origen, th=0
A0=[1 0 1 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
A1=A0;
A1(1, sum(PRECI)-11:sum(PRECI)-7)=ones(1,5);%forma promedio de tamano maximo localizada en el origen, th=0
Pob=crtbp(NPOB*NIND0,sum(PRECI));
Pob(1,:)=A0;
[renpob0 colpob0]=size(Pob);
Pob(renpob0,:)=A1;
% ************************************************************
Pob_Real=bs2rv(Pob,FieldD);
%ObjV=fobj_mgm_ppbw(YP, Pob_Real, MEDIA2COL, P10, Limb10);
ObjV=fobj_optimas(Pob_Real, MEDIA2COL, P10, Limb10, MGI, MDxGI, MDyGI, MDxxGI, MDyyGI, MDxyGI, CAROPT, MUE_ENTRE, IO, renentre);
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
    %ObjSel=fobj_mgm_ppbw(YP, PobReal, MEDIA2COL, P10, Limb10);
    ObjSel=fobj_optimas(PobReal, MEDIA2COL, P10, Limb10, MGI, MDxGI, MDyGI, MDxxGI, MDyyGI, MDxyGI, CAROPT, MUE_ENTRE, IO, renentre);
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
nomfbw=strcat(int2str(exp), 'fbw-',chiqui,'tif')print( gcf, '-dtiffnocompression', nomfbw)
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
	IMA(round(Yint(i)), round(Xint(i)))=255;   
end
figure
imshow(uint8(IMA))
keyboard
%**************************************************************************
% Ajuste con un ASM caracteristicas optimas
%**************************************************************************
XYc=repmat([ORIX+tx ORIY+ty],[PUNTOS_MODELO,1]);
XY(:,2)=-1*XY(:,2); %inversion de Y porque invertimos en la etapa anterior
T=[s*cos(th) -s*sin(th); s*sin(th) s*cos(th)];
b=b';
Limb=Limb10;
for iteracion=1:25
   iteracion
   XYT=(T*XY')'+XYc;
   [ren col]=size(XY);
   XYTI=XYT;
   XYTI(:,2)=-1*(XYT(:,2)-XYc(:,2))+XYc(:,2); %invertir Ys pa' buscar en la imagen
   [dX, dY]=busqueda_optimas1(XYTI, MGI, MDxGI, MDyGI, MDxxGI, MDyyGI, MDxyGI, CAROPT, MUE_ENTRE, IO, renentre)
   %dX=zeros(35,1);
   %dY=zeros(35,1);
   dY=-1*dY; %invertimos dy para regresar al MDP al derecho
   dXY(:,1)=dX;
   dXY(:,2)=dY;
   X1=XYT+dXY;
%   figure
%   hold on
%   axis equal
%   plot(X1(:,1), X1(:,2), '-r')
%   plot(XYT(:,1), XYT(:,2), '-g')
%   hold off
   [ax ay tx1 ty1]=f_alin_e2((X1-XYc),(XYT-ORIXY));
   th1=atan(ay/ax);
   dth=th1-th;
   s1=ax/cos(th1);
   txy1=repmat([tx1 ty1],[ren,1]);
   T1=[ax -ay; ay ax];
   XYT=XYT-XYc;
   dx=X1-(T1*XYT')'-txy1-XYc;
   [ren col]=size(dx);
   renglon=1;
   for i=1:ren
      dx_col(renglon,1)=dx(i,1);
      dx_col(renglon+1,1)=dx(i,2);
      renglon=renglon+2;
   end
   db=P10'*dx_col;
   b=b+db;
   for i=1:10
      if b(i,1)> Limb(i,1)
         b(i,1)= Limb(i,1);
      end
      if b(i,1)< -1*Limb(i,1)
         b(i,1)= -1*Limb(i,1);
      end
   end
	x=P10*b;
	puntos=1;
	for i=1:2:length(x)-1
   	xy(puntos,1)=x(i);
	   xy(puntos,2)=x(i+1);
   	puntos=puntos+1;
	end
   XY=xy+MEDIA2COL; %NUEVA FORMA DEL CONTORNO
   th=th+th1;
   s=s*s1;
   tx=tx+tx1;
   ty=ty+ty1;
 %  XYc=repmat([tx ty],[ren,1]);
   XYc=repmat([ORIX+tx ORIY+ty],[PUNTOS_MODELO,1]);
   T=[s*cos(th) -s*sin(th); s*sin(th) s*cos(th)];
   DespliegaSalvaParcial(XYT, XYc, IMA);
end % for iteracion
end %fin del metaciclo


