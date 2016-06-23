% asmfd_optimas1.m
% 20-oct-2004: utiliza versiones optimizadas de calcula_car_opt y de
% knn_optimas
% 15-oct-2004: este programa ajusta un ASM utilizando clasificacion de caracteristicas optimas
% Actualizaci?n del ASM segun ARTICULO "ASMs-Their training and app." de COOTES 
% el algoritmo NO ES IGUAL
% Utiliza derivadas y perfiles de gris de una imagen filtrada: gaussiano VAR=64
clear
ORIX=285+25%-15%320%307%316%CENTRO DE LA PROSTATA EN IMAGENES TU DE 704*512
ORIY=225+50%+15+7%265%225% 
NoComp=16; %No. de componentes principales del MDP determinadas all? abajo
EIG_VAL=load('eig_val_entrena_tu2_g64.txt');
%nom_eigvec=input('nombre del archivo de eigen vectores?\n')
EIG_VEC=load('eig_vec_entrena_tu2_g64.txt');
%nom_media=input('archivo con la media?\')
MEDIA=load('media_entrena_tu2_g64.txt');
%nom_X1=input('archivo con el contorno de ejemplo?');
%X1=load(nom_X1);
nom_ima=input('nombre del archivo de imagen.bmp (512x704)?');
IMA=imread(nom_ima, 'bmp');
sigma0=0.5; %escala interna inicial
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

%***************************************************************
   % calculo de las 6 derivadas gaussianas de I: D0 (imagen filtrada),  Dx, Dy, Dxx, Dyy, Dxy  
   % para los 5 valores de sigma: 0.5, 1.0, 2.0, 4.0, 8.0
   %*****************************************************************
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
   
% GENERACI?N DE INSTANCIAS DEL MODELO
% Empezamos con la forma promedio
P16=EIG_VEC(:,55:70);
D=diag(EIG_VAL);
Limb=3*sqrt(D(55:70));
puntos=1;
for i=1:2:length(MEDIA)-1
   XY(puntos,1)=MEDIA(i);
   XY(puntos,2)=MEDIA(i+1); 
   puntos=puntos+1;
end
[ren col]=size(XY);
MEDIA2COL=XY;
ORIXY=repmat([ORIX ORIY],[ren 1]);

% VALORES DE TRANSFORMACI?N DEL MODELO: VALORES PROMEDIO DEL CONJ. DE ENTRENAMIENTO
%dbstop in prueba_alin_deformf.m at 38
s=1.1;%1.3%1/0.9184;
th=0; %-pi/4;
tx=ORIX;
ty=ORIY;
XYc=repmat([tx ty],[ren,1]);
T=[s*cos(th) -s*sin(th); s*sin(th) s*cos(th)];
b=zeros(16,1);
for iteracion=1:50
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
   db=P16'*dx_col;
   b=b+db;
   for i=1:16
      if b(i,1)> Limb(i,1)
         b(i,1)= Limb(i,1);
      end
      if b(i,1)< -1*Limb(i,1)
         b(i,1)= -1*Limb(i,1);
      end
   end
	x=P16*b;
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
   XYc=repmat([tx ty],[ren,1]);
   T=[s*cos(th) -s*sin(th); s*sin(th) s*cos(th)];
   DespliegaSalvaParcial(XYT, XYc, IMA);
end % for iteracion

