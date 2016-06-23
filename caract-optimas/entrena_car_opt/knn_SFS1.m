% knn_SFS1.m
% 22-sep-2004: solo calculamos las car optimas de la imagen a segmentar
% esta version utiliza solo las Xs (caract. optimas) de cada punto del PDM
% determinadas utilizando SFS
% clasificador KNN prostata/ fondo con caracteristcias optimas
% Este programa lee el conjunto alineado de ejemplos y muestrea N (35) puntos (landmarks) de cada uno
% Calcula las 30 imagenes correspondientes a 5 escalas, 6 derivadas
% Muestrea una ventana de 5 x 5 pixeles alrededor de cada uno de los N puntos de referencia (landmarks)
% salva NoPM matrices de 5x5 de vectores de 60 componentes en un archivo v5x5-60car-nombre.txt por cada contorno
% salva NoPM puntos en un archivo nombre.mue1 por cada contorno
% La transfomacion de escala es : X=(1/escala)*X para contornos alineados por dif de area
% Queee tal!
clear

% MATRIZ CON LOS INDICES DE LAS CAR. OPTIMAS DE CADA PUNTO DEL PDM. CADA
% RENGLON DE CAROPT CORRESPONDE A UN PUNTO DEL PDM
CAROPT=load('car_opt_pros.txt');

%************************************************************************
% lectura de las muestras de entrenamiento para el clasificador KNN, K=5
%************************************************************************
NOMENTRE=[ %'an-u3-14-01-al.con';
%'an-u3-14-02-al.con';
'an-u3-14-03-al.con';
%'an-u3-14-04-al.con';
%'an-u3-14-05-al.con';
%'an-u3-14-06-al.con';
'an-u3-15-02-al.con';
%'an-u3-15-03-al.con';
%'an-u3-15-04-al.con';
'an-u3-15-05-al.con';
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

[ren, col]=size(NOM);
%figure
%axis equal
%hold on
for i=1:ren % repetimos el ciclo para todas las imagenes
   ns_A=[];
   ncontorno=NOM(i,:);
   M=dlmread(ncontorno, ' ');
	NoP=M(1,2); % en UNIX es M(1,)
	ang_ejem=M(2,1);
	escala=M(2,2); % valor de escala del contrno alineado por dif de areas: X=X*escala 
	centro_x=M(2,3);
	centro_y=M(2,4);
	ns_A(:,1)=M(3:NoP+2,1);
   ns_A(:,2)=M(3:NoP+2,2);
   
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
       %GI=(255*(GI-min(min(GI)))/max(max(GI)));                  
       %figure
       %imshow(uint8(GI))
              
		DxGI=conv2(DxH, I);
       DxGI=DxGI(2*sigma+1:renDI-2*sigma, 2*sigma+1:colDI-2*sigma);
       MDxGI(:,:,escala_externa)=DxGI;
       %DxGI=(255*(DxGI-min(min(DxGI)))/max(max(DxGI)));
       %figure
		%imshow(uint8(DxGI))
      
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
		%DyGI=(255*(DyGI-min(min(DyGI)))/max(max(DyGI)));
       %figure
		%imshow(uint8(DyGI))

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
       %DxxGI=(255*(DxxGI-min(min(DxxGI)))/max(max(DxxGI)));
       %figure
		%imshow(uint8(DxxGI))

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
   
   %*********************************************************************
   % calculo de los momentos del histograma ponderado (escala alfa) para 
   % una ventana de 5x5 y para cada punto de referencia (35 en total)
   % y clasificacion de los pixeles de cada ventana utilizando 5NN    
   %*********************************************************************
    ancho_v=5;
	alto_v=5;
	offset_v= ceil(ancho_v/2); % para ventanas cuadradas
	beta=1; % ancho del bote (bin) del histograma ESTE PROGRAMA SOLO JALA PARA beta=1
	[renC colC]=size(Cori);
	Cori(renC+1, :)=Cori(1,:); %cerramos el contorno
	X=Cori(:,1);
	Y=Cori(:,2);
   no_puntos=renC+1;
      		for punto=1:2:no_puntos-1 % para todos los puntos del contorno
            INDOP=find(CAROPT(punto,:));
            CAROPTPUNTO=CAROPT(punto, INDOP);
            for j=1:ancho_v % para la ventana de ancho_v x alto_v
          		for i=1:alto_v
                   vectoropt=0;
                   for car=1:length(CAROPTPUNTO)
                   switch CAROPTPUNTO(car)
                   case 1
                        escala=1;  
                        alfa=2*sigma0;
                        espaciamiento=2^(escala-1);
                 	    A=MGI(:,:,escala);
   		                x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  1);
                  	    
                    case 2
                        escala=1;  
                        alfa=2*sigma0;
                        espaciamiento=2^(escala-1);
                 	    A=MGI(:,:,escala);
   		                x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        vectoropt(car)=calcula_M(x0,y0, A, alfa, 2);
                       
                    case 3
                        escala=1;
                        alfa=2*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de Dx 
                        %*******************
                        A=MDxGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  1);
                  	    
                    case 4
                        escala=1;
                        alfa=2*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de Dx 
                        %*******************
                        A=MDxGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa, 2);
                        
                    case 5                                                                  
                  	    escala=1;
                        alfa=2*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de Dy 
                        %*******************
                        A=MDyGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  1);
                  	 
                    case 6
                        escala=1;
                        alfa=2*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        A=MDyGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa, 2);
                     
                    
                    case 7
                        escala=1;
                        alfa=2*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de Dxx 
                        %*******************
                        A=MDxxGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  1);
                  	    
                        
                        
                    case 8
                        escala=1;
                        alfa=2*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de Dxx 
                        %*******************
                        A=MDxxGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa, 2);
                        
                    case 9
                        escala=1;
                        alfa=2*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de Dyy 
                        %*******************
                        A=MDyyGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  1);
                  	    
                        
                        
                        
                        
                    case 10
                        escala=1;
                        alfa=2*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de Dyy 
                        %*******************
                        A=MDyyGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa, 2);
                        
                        
                    case 11
                        escala=1;
                        alfa=2*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de Dxy 
                        %*******************
                        A=MDxyGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  1);
                  	     
                    case 12
                        escala=1;
                        alfa=2*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de Dxy 
                        %*******************
                        A=MDxyGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa, 2);
                       
                        
                    case 13
                        escala=2;
                        alfa=4*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  1);
                        
                        
                        
                    case 14
                        escala=2;
                        alfa=4*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  2);
                        
                        
                        
                        
                    case 15
                        escala=2;
                        alfa=4*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  1);
                        
                                                                                                
                    case 16
                        escala=2;
                        alfa=4*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  2);
                        
                        
                    case 17
                        escala=2;
                        alfa=4*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDyGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  1);
                        
                        
                        
                        
                    case 18
                        escala=2;
                        alfa=4*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDyGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  2);
                        
                        
                    case 19
                        escala=2;
                        alfa=4*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxxGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa, 1);
                        
                        
                        
                        
                    case 22
                        escala=2;
                        alfa=4*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxxGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  2);
                        
                        
                        
                    case 23
                        escala=2;
                        alfa=4*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxyGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa, 1);
                        
                        
                    case 24
                        escala=2;
                        alfa=4*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxyGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  2);
                        
                        
                    case 25
                        escala=3;
                        alfa=8*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  1);
                        
                        
                        
                    case 26
                        escala=3;
                        alfa=8*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  2);
                        
                    case 27
                        escala=3;
                        alfa=8*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  1);
                        
                    case 28
                        escala=3;
                        alfa=8*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  2);
                        
                    case 29
                        escala=3;
                        alfa=8*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDyGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa, 1);
                        
                        
                        
                    case 30
                        escala=3;
                        alfa=8*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDyGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  2);
                        
                    case 36
                        escala=3;
                        alfa=8*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxyGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  2);
                        
                    case 37
                        escala=4;
                        alfa=16*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa, 1);
                        
                    case 38
                        escala=4;
                        alfa=16*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa, 2);
                        
                        
                    case 40
                        escala=4;
                        alfa=16*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa, 2);
                        
                    case 48
                        escala=4;
                        alfa=16*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxyGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa, 2);
                        
                    case 49
                        escala=5;
                        alfa=32*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa, 1);
                        
                    case 50
                        escala=5;
                        alfa=32*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X(punto)+(j-offset_v)*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto)+(i-offset_v)*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa, 2);
                    otherwise
                        'caracteristica no implementada'
                        break
                    end %switch
                end %for car=1:legth(CAROPTPUNTO)
                  %*********************************
                  % CLASIFICADOR KNN K=5
                  contadorD=1;
                  for muestraentre=1:25
              		for imagenentre=1:renentre
                   		v1=MUE_ENTRE((punto-1)*25+muestraentre,CAROPTPUNTO,imagenentre);
                   		%v=VECTOR((j-1)*5+i,CAROPTPUNTO);
                   		D(contadorD)=(sum((vectoropt-v1).^2));
                        %D(contadorD)=sqrt(sum(abs(v-v1)));
                   		IOPIXEL(contadorD)=IO((punto-1)*25+muestraentre,imagenentre);
                   		contadorD=contadorD+1;
                    end
                  end
                 
              	[KV, IKV]=sort(D); % ordena KV en forma descendente guarda el indice original en IKV
              	TOP5=KV(1:5)/1e7; % escalamiento de d^2
              	ITOP5=IKV(1:5);
              	IOTOP5=IOPIXEL(ITOP5);
                suma_pros=0;
                suma_fondo=0;
                for toppixel=1:5
                  	if (IOTOP5(toppixel)==1)
                        suma_pros= suma_pros + exp(-TOP5(toppixel));
                 	else
                   	    suma_fondo= suma_fondo + exp(-TOP5(toppixel));
                	end
                end
                x0=X(punto)+j-offset_v;% (x0, y0) coord. del pixel
 				  y0=Y(punto)+i-offset_v;
                if suma_pros>suma_fondo
                  I(y0,x0)=255;
                else
                  I(y0,x0)=0;
                end
                
              end % for i..;  (coord. y) procesamiento de la ventana de  alto_v X ancho_v pixeles
           end % for j.. (coord. x)
           % keyboard
           %imshow(I)
        imwrite(I, 'resultadoparcial16-04_optimo_2.tif', 'tif');  
        end % end for punto=1.. procesamiento de los 35 puntos del modelo
end % for i=1:ren ; proceso de todas imagenes
%hold off

