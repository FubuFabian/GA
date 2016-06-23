% asmfd.m
% Actualización del ASM segun ARTICULO "ASMs-Their training and app." de COOTES 
% el algoritmo NO ES IGUAL
% Utiliza derivadas y perfiles de gris de una imagen filtrada: gaussiano VAR=64
clear
ORIX=285-20%+50-15%320%307%316%CENTRO DE LA PROSTATA EN IMAGENES TU DE 704*512
ORIY=225+30%+50+15+7%265%225% 
NoComp=16; %No. de componentes principales del MDP determinadas allá abajo
EIG_VAL=load('eig_val_entrena_tu2_g64.txt');
%nom_eigvec=input('nombre del archivo de eigen vectores?\n')
EIG_VEC=load('eig_vec_entrena_tu2_g64.txt');
%nom_media=input('archivo con la media?\')
MEDIA=load('media_entrena_tu2_g64.txt');
%nom_X1=input('archivo con el contorno de ejemplo?');
%X1=load(nom_X1);
nom_ima=input('nombre del archivo de imagen.tif (512x704)?');
IMA=imread(nom_ima, 'tif');


LISTA_PGRIS=[ 'perfg-g64-u3-14-01-al.txt';
   'perfg-g64-u3-14-02-al.txt';
   'perfg-g64-u3-14-03-al.txt';
   'perfg-g64-u3-14-04-al.txt';
   'perfg-g64-u3-14-05-al.txt';
   'perfg-g64-u3-14-06-al.txt';
   'perfg-g64-u3-14-07-al.txt';
   'perfg-g64-u3-14-08-al.txt';
   'perfg-g64-u3-15-02-al.txt';
	'perfg-g64-u3-15-03-al.txt';
	'perfg-g64-u3-15-04-al.txt';
	'perfg-g64-u3-15-05-al.txt';
   'perfg-g64-u3-15-06-al.txt';
   'perfg-g64-u3-16-03-al.txt';
	'perfg-g64-u3-16-04-al.txt';
   'perfg-g64-u3-16-05-al.txt';
   'perfg-g64-u3-16-06-al.txt';
   'perfg-g64-u3-16-07-al.txt';
   'perfg-g64-u3-17-00-al.txt';
   'perfg-g64-u3-17-05-al.txt';
   'perfg-g64-u3-18-00-al.txt';
	'perfg-g64-u3-18-01-al.txt';
	'perfg-g64-u3-18-02-al.txt';
	'perfg-g64-u3-18-03-al.txt';
	'perfg-g64-u3-18-04-al.txt';
   'perfg-g64-u3-18-05-al.txt';
   'perfg-g64-u3-21-02-al.txt';
   'perfg-g64-u3-21-03-al.txt';
   'perfg-g64-u3-21-04-al.txt';
];





%MATRICES DE COVARIANZA DE NIVEL DE GRIS DE CADA UNO DE LOS 35 PUNTOS DEL MODELO
[NoArPg col]=size(LISTA_PGRIS);
for i=1:NoArPg
   nombre=LISTA_PGRIS(i,:);
   fid=fopen(nombre, 'r');
   MGt=fscanf(fid,'%3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d\n', [25 35]);
	fclose(fid);
   MG1(:,:,i)=MGt';   
end

%Matriz de derivadas (gradientes) de los perfiles de gris de entrenamiento
[ren col capas]=size(MG1);
for k=1:capas
   for j=1:ren
   	for i=1:col-1
         MG(j,i,k)=MG1(j,i+1,k)- MG1(j,i,k);          
      end
      MG(j,:,k)=MG(j,:,k)/sum(abs(MG(j,:,k)));
	end
end

% CALCULO DE LAS MATs DE COV PARA CADA CONJUNTO DE PERFILES DE GRIS
%arreglo 3D con las matrices de cov. una por capa
[ren col capas]=size(MG);
for i=1:ren
   for j=1:capas
      capa(j,:)=MG(i,:,j);	  
   end 
  	g_prom(i,:)=mean(capa);    
	inv_SSS(:,:,i)=inv(cov(capa)); %arreglo 3D de matrices de cov. una por capa/punto del MDP
end

% GENERACIÓN DE INSTANCIAS DEL MODELO
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

% VALORES DE TRANSFORMACIÓN DEL MODELO: VALORES PROMEDIO DEL CONJ. DE ENTRENAMIENTO
%dbstop in prueba_alin_deformf.m at 38
s=1.3%1/0.9184;
th=-pi/4;
tx=ORIX;
ty=ORIY;
XYc=repmat([tx ty],[ren,1]);
T=[s*cos(th) -s*sin(th); s*sin(th) s*cos(th)];
b=zeros(16,1);
for iteracion=1:100
   iteracion
   XYT=(T*XY')'+XYc;
   [ren col]=size(XY);
   XYTI=XYT;
   XYTI(:,2)=-1*(XYT(:,2)-XYc(:,2))+XYc(:,2); %invertir Ys pa' buscar en la imagen
   [dX, dY]=busqueda_gris2d(XYTI, IMA,inv_SSS, g_prom);
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
end % for iteracion

XYTI=XYT+XYc;

%figure
%axis equal
%plot(XYTI(:,1), XYTI(:,2), '-b')

XYTI(:,2)=-1*(XYTI(:,2)-XYc(:,2))+XYc(:,2);
[Xint, Yint]=interpolar_a1(XYTI(:,1), XYTI(:,2));
[ren col]=size(Xint);
Xint=round(Xint);
Yint=round(Yint);
for i=1:ren
  	IMA(Yint(i),Xint(i))=255;
%  IMA(XYori(i,2),XYori(i,1))=255;
end
figure
imshow(IMA)
