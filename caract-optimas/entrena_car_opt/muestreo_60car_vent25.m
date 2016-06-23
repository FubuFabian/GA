% muestreo_60car_vent25.m
% Este programa lee el conjunto alineado de ejemplos y muestrea N (35) puntos (landmarks) de cada uno
% Calcula las 30 imagenes correspondientes a 5 escalas, 6 derivadas
% Muestrea una ventana de 5 x 5 pixeles alrededor de cada uno de los N puntos de referencia (landmarks)
% salva NoPM matrices de 5x5 de vectores de 60 componentes en un archivo v5x5-60car-nombre.txt por cada contorno
% salva NoPM puntos en un archivo nombre.mue1 por cada contorno
% La transfomacion de escala es : X=(1/escala)*X para contornos alineados por dif de area
% Queee tal!
clear
NoPM=35;
sigma0=0.5 % escala interna inicial
NOM=[ 'an-u3-14-01-al.con';
'an-u3-14-02-al.con';
%'an-u3-14-03-al.con';
%'an-u3-14-04-al.con';
'an-u3-14-05-al.con';
%'an-u3-14-06-al.con';
'an-u3-15-02-al.con';
%'an-u3-15-03-al.con';
'an-u3-15-04-al.con';
%'an-u3-15-05-al.con';
'an-u3-15-06-al.con';
%'an-u3-16-03-al.con';
'an-u3-16-04-al.con';
%'an-u3-16-05-al.con';
'an-u3-16-06-al.con';
%'an-u3-16-07-al.con';
'an-u3-17-00-al.con';
%'an-u3-17-05-al.con';
'an-u3-18-00-al.con';
%'an-u3-18-01-al.con';
'an-u3-18-02-al.con';
%'an-u3-18-03-al.con';
'an-u3-18-04-al.con';
'an-u3-18-05-al.con';
];

[ren, col]=size(NOM);
%figure
%axis equal
%hold on
for i=1:ren % repetimos el ciclo para todas las imagenes
   ns_A=[];
   ncontorno=NOM(i,:);
   M=dlmread(ncontorno, ' ');
	NoP=M(1,2);
	ang_ejem=M(2,1);
	escala=M(2,2); % valor de escala del contrno alineado por dif de areas: X=X*escala 
	centro_x=M(2,3);
	centro_y=M(2,4);
	ns_A(:,1)=M(3:NoP+2,1);
   ns_A(:,2)=M(3:NoP+2,2);
   
   %**************************************************************
   % construccion de la imagen binaria para etiquetado de muestras
   %**************************************************************
   Tinv=[cos(ang_ejem) sin(ang_ejem); -1*sin(ang_ejem) cos(ang_ejem)];
	Cori=(1/escala)*ns_A*Tinv;% multiplicando por 1/escala regresamos al original
	Cori(:,2)=-Cori(:,2);%invertimos Y para escribir en la imagen
	centro_xy=repmat([centro_x, centro_y],NoP, 1);
	Cori=round(Cori+centro_xy);
   nomima=ncontorno(4:length(ncontorno)-7)
   nomima=strcat(nomima,'.bmp')
   I=imread(nomima,'bmp');
	[J, IBW]=roifill(I,Cori(:,1), Cori(:,2));
   
   figure
	imshow(I)
   %***************************************************************
   % calculo de las 6 derivadas gaussianas de I: D0 (imagen filtrada),  Dx, Dy, Dxx, Dyy, Dxy  
   % para los 5 valores de sigma: 0.5, 1.0, 2.0, 4.0, 8.0
   %*****************************************************************
   sigma=sigma0;
   for escala_externa=1:5
   		n=4*sigma+1; %tamaño de la mascara
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
       GI=uint8(255*(GI-min(min(GI)))/max(max(GI)));
       [renDI, colDI]=size(GI)
       GI=GI(2*sigma+1:renDI-2*sigma, 2*sigma+1:colDI-2*sigma);
       MGI(:,:,escala_externa)=GI; % matriz con la imagen filtrada para sigma=0.5, 1.0, 2.0, 4.0, 8.0
       						% una imagen por capa de la matriz 
       %figure
       %imshow(GI)
              
		DxGI=conv2(DxH, I);
      	DxGI=uint8(255*(DxGI-min(min(DxGI)))/max(max(DxGI)));
       DxGI=DxGI(2*sigma+1:renDI-2*sigma, 2*sigma+1:colDI-2*sigma);
       MDxGI(:,:,escala_externa)=DxGI;
       %figure
		%imshow(DxGI)
      
      % Dy(H)=-(y/sigma^2)*H
		dyi=1;
		for y=-2*sigma:2*sigma
   			for dyj=1:4*sigma+1
     			DyH(dyi, dyj)=-(y/sigma^2)*H(dyi, dyj);   
   			end
   		dyi= dyi+1;
		end
		DyGI=conv2(DyH, I);
       DyGI=uint8(255*(DyGI-min(min(DyGI)))/max(max(DyGI)));
       DyGI=DyGI(2*sigma+1:renDI-2*sigma, 2*sigma+1:colDI-2*sigma);
       MDyGI(:,:,escala_externa)=DyGI;
       %figure
		%imshow(DyGI)

		%Dxx=(x^2/sigma^4-1/sigma^2)*H
		dxj=1;
		for x=-2*sigma:2*sigma
   			for dxi=1:4*sigma+1
     			DxxH(dxi, dxj)=(x^2/sigma^4-1/sigma^2)*H(dxi, dxj);   
   			end
   		dxj= dxj+1;
		end

		DxxGI=conv2(DxxH, I);
      	DxxGI=uint8(255*(DxxGI-min(min(DxxGI)))/max(max(DxxGI)));
       DxxGI=DxxGI(2*sigma+1:renDI-2*sigma, 2*sigma+1:colDI-2*sigma);
       MDxxGI(:,:,escala_externa)=DxxGI;
       %figure
		%imshow(DxxGI)

		%Dyy=(y^2/sigma^4-1/sigma^2)*H
		dyi=1;
		for y=-2*sigma:2*sigma
   			for dyj=1:4*sigma+1
     			DyyH(dyi, dyj)=(y^2/sigma^4-1/sigma^2)*H(dyi, dyj);   
   			end
   		dyi= dyi+1;
		end
		DyyGI=conv2(DyyH, I);
       DyyGI=uint8(255*(DyyGI-min(min(DyyGI)))/max(max(DyyGI)));
       DyyGI=DyyGI(2*sigma+1:renDI-2*sigma, 2*sigma+1:colDI-2*sigma);
       MDyyGI(:,:,escala_externa)=DyyGI;
       %figure
		%imshow(DyyGI)

		%(magnitud del gradiente) DxyH=sqrt(DxH^2+DyH^2)
		%DxyH=sqrt(DxH.*DxH + DyH.*DyH);
      DxGI=double(DxGI);
      DyGI=double(DyGI);
      DxyGI=sqrt(DxGI.*DxGI+ DyGI.*DyGI);
      DxyGI=uint8(255*(DxyGI-min(min(DxyGI)))/max(max(DxyGI)));
      MDxyGI(:,:,escala_externa)=DxyGI;
      %figure
      %imshow(DxyGI) 
      sigma=sigma*2;
   end % for escala_externa=1:5  
   
    %**********************************************************************
   % muestreo de 35 puntos de referencia (landmarks) del contorno ALINEADO
   % sobre las imagenes de derivadas gaussianas
   %**********************************************************************
   indice=1;
   inter=(NoP/NoPM);
   apun=inter;
   for j=1:NoP
	   %if rem(j,inter)==0
      if j==round(apun)
      	EJEMPLO_M(indice,:)=ns_A(j,:);
         indice=indice+1;
         apun=apun+inter;
   	end
   end
   if indice~=NoPM+1
      'NO SE MUESTREARON 35 PUNTOS!'
      indice
      break
   end
   %figure
   %plot(EJEMPLO_M(:,1), EJEMPLO_M(:,2), '.b');

	Tinv=[cos(ang_ejem) sin(ang_ejem); -1*sin(ang_ejem) cos(ang_ejem)];
	Cori=(1/escala)*EJEMPLO_M*Tinv;% multiplicando por 1/escala regresamos al original
	Cori(:,2)=-Cori(:,2);%invertimos Y para escribir en la imagen
	centro_xy=repmat([centro_x, centro_y],NoPM, 1);
	Cori=round(Cori+centro_xy);
   
   %figure
   %plot(Cori(:,1), Cori(:,2), '.r');
      
   %Función para muestreo de 60 caracteristicas: 2 momentos de 6 derivadas a 5 escalas 
	%parametros: 	IBW imagen binaria para anotar pixeles como dentro o fuera de la P
	%				Cori contorno muestreado y trasformado para ajustar a la imagen correspondiente
	%				MGI matriz de imagenes gaussiano-filtradas 5 imagenes
	%				MDxGI, MDyGI, MDxxGI, MDyyGI, MDxyGI matrices de derivadas una imagen por capa como arriba
	%				sigma0 escala exterior inicial
   m1m2_histo_apertura(IBW, Cori, double(MGI), double(MDxGI), double(MDyGI), double(MDxxGI), double(MDyyGI), double(MDxyGI), sigma0);
   keyboard
   
   
   %nompgris=ncontorno(4:length(ncontorno)-3);
   %nompgris=strcat('perfg25-',nompgris,'txt');
   %fid=fopen(nompgris,'w');
   %%fprintf(fid,'%3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d\n', double(MG'));
   %fclose(fid);
   
   %ncontorno=ncontorno(1:length(ncontorno)-3);
   %nfile=strcat(ncontorno,'mue25');
   %fid=fopen(nfile,'w');
   %fprintf(fid,'%4.4f %4.4f\n', EJEMPLO_M');
   %fclose(fid);
end % for i=1:ren
%hold off

