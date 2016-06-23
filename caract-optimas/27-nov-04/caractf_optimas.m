
%caractf_optimas.m
%programa para caracterizar a mano diferentes fobj de reconocimeinto del contorno de la prostata.
% este programa utiliza las car. optimas y el clasificador de KVecinosCercanos

%************************** OJO: LOS CONTORNOS DEBEN ANOTARSE EN SENTIDO ANTIHORARIO **********************************************

clear
N=35; %No. de puntos del modelo
resp='si';

INFLMT=-10; %extremo exterior del perfil de gris
SUPLMT=10;	%extremo interior del mismo

% MATRIZ CON LOS INDICES DE LAS CAR. OPTIMAS DE CADA PUNTO DEL PDM. CADA
% RENGLON DE CAROPT CORRESPONDE A UN PUNTO DEL PDM
CAROPT=load('car_opt_todos_puntos_sX1.txt');
[rencaropt colcaropt]=size(CAROPT);
% este ciclo elimina las cars de escala mas grande pa'que no se acabe la imagen
for i=1:rencaropt
   for j=1:colcaropt
      if CAROPT(i,j)==50
         CAROPT(i,j)=0;
      end
   end
end

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
%'an-u3-15-03-al.con';
'an-u3-15-04-al.con';
%'an-u3-15-05-al.con';
%'an-u3-15-06-al.con';
%'an-u3-16-03-al.con';
%'an-u3-16-04-al.con';
%'an-u3-16-05-al.con';
%'an-u3-16-06-al.con';
%'an-u3-16-07-al.con';
%'an-u3-17-00-al.con';
%'an-u3-17-05-al.con';
%'an-u3-18-00-al.con';
%'an-u3-18-01-al.con';%'an-u3-18-02-al.con';
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
%****************************************************************************

NoPM=35;
sigma0=0.5 % escala interna inicial
NOM=[ %'an-u3-14-01-al.con';
%'an-u3-14-02-al.con';
%'an-u3-14-03-al.con';
%'an-u3-14-04-al.con';
%'an-u3-14-05-al.con';
%'an-u3-14-06-al.con';
%'an-u3-15-02-al.con';
%'an-u3-15-03-al.con';
'an-u3-15-04-al.con';
%'an-u3-15-05-al.con';
%'an-u3-15-06-al.con';
%'an-u3-16-03-al.con';
%'an-u3-16-04-al.con';
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

[ren, col]=size(NOM);
%figure
%axis equal
%hold on
for i=1:ren % repetimos el ciclo para todas las imagenes
   ncontorno=NOM(i,:);
   nomima=ncontorno(4:length(ncontorno)-7)
   nomima=strcat(nomima,'.bmp')
   I=imread(nomima,'bmp');
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
		

		GI=conv2(H,I);
       [renDI, colDI]=size(GI)
       GI=GI(2*sigma+1:renDI-2*sigma, 2*sigma+1:colDI-2*sigma);
       MGI(:,:,escala_externa)=GI; % matriz con la imagen filtrada para sigma=0.5, 1.0, 2.0, 4.0, 8.0
       						% una imagen por capa de la matriz 
              
		DxGI=conv2(DxH, I);
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
		DyGI=conv2(DyH, I);
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

		DxxGI=conv2(DxxH, I);
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
		DyyGI=conv2(DyyH, I);
       DyyGI=DyyGI(2*sigma+1:renDI-2*sigma, 2*sigma+1:colDI-2*sigma);
       MDyyGI(:,:,escala_externa)=DyyGI;
       %DyyGI=(255*(DyyGI-min(min(DyyGI)))/max(max(DyyGI)));
       %figure
		%imshow(uint8(DyyGI))

		%(magnitud del gradiente) DxyH=sqrt(DxH^2+DyH^2)
		%DxyH=sqrt(DxH.*DxH + DyH.*DyH);
      DxGI=double(DxGI);
      DyGI=double(DyGI);
      DxyGI=sqrt(DxGI.*DxGI+ DyGI.*DyGI);
      MDxyGI(:,:,escala_externa)=DxyGI;
      %DxyGI=(255*(DxyGI-min(min(DxyGI)))/max(max(DxyGI)));
      %figure
      %imshow(uint8(DxyGI)) 
      sigma=sigma*2;
   end % for escala_externa=1:5  
expe=input('numero del primer contorno?');
while resp=='si'
% anotacion manual del contorno sobre la imagen original
[X Y p]=impixel(I);

confirma=input('anotacion correcta? si/no');
if confirma=='si'
	[Xint, Yint]=interpolar_a1(X, Y);
	Xint=round(Xint);
	Yint=round(Yint);
	I2=I;
	for i=1:length(Xint)
   		I2(Yint(i), Xint(i))=255;
	end
	figure
	imshow(I2)

	%guardamos imagen anotada
	nomima2=nomima(1:length(nomima)-4);
	nomano=strcat('entre1504_contorno',int2str(expe),'-', nomima2, '.tif');
	imwrite(I2,nomano, 'tif');

	%muestreo de N puntos del contorno a intervalos iguales
	intervalo=round(length(Xint)/N);
	puntosN=1;
	for i=1:length(Xint)
   		if mod(i, intervalo)==0
      		XN(puntosN)=Xint(i);
      		YN(puntosN)=Yint(i);
      		puntosN=puntosN+1;
   		end
	end
	XN(puntosN)=XN(1);
	YN(puntosN)=YN(1);
  	X=XN;
 	Y=YN;
   	no_puntos=puntosN;
   INDOP=find(CAROPT);
   CAROPTPUNTO=CAROPT(INDOP);
   fopt=0;
   for punto=1:no_puntos-1 % para todos los puntos del contorno
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
           for  k=INFLMT:SUPLMT % para el perfil de longitud SUPLMT-INFLMT
                DX(k-INFLMT+1,1)= (k*cos_normal_angle+0.5);
		        DY(k-INFLMT+1,1)= (k*sin_normal_angle+0.5);
           end % para un perfil   
           %XYperfil=DXY+repmat([X(punto) Y(punto)], [SUPLMT-INFLMT+1,1]);
           
           VECTOROP=calcula_car_opt3(MGI, MDxGI, MDyGI, MDxxGI, MDyyGI, MDxyGI, CAROPTPUNTO, DX, DY, X(punto), Y(punto));
           IN_OUT=knn_optimas1(MUE_ENTRE, punto, VECTOROP, CAROPTPUNTO, IO, renentre);
           fopt=fopt+[sum(IN_OUT(1:-1*INFLMT-1))+sum((1-IN_OUT(-1*INFLMT+1:SUPLMT-INFLMT+1)))];
           
    end % end for punto=1.. procesamiento de los 35 puntos del modelo
   fopt=fopt/N
   
   	nomfs=strcat('entre1504_fs-', nomima2, '-contorno-', int2str(expe),'.txt')
	fid=fopen(nomfs, 'w');
	fprintf(fid,'fopt:%4.4f  \n', fopt);
	fclose(fid)
	expe=expe+1;

end %if confirma=='si'

resp=input('desea continuar si/no?')

end % while resp  
end % for todas las imagenes

