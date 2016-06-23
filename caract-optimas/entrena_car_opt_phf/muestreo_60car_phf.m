% muestreo_60car_phf.m
%version modificada de :muestreo_60car_vent25_ver3_binv.m
% para calcular las car. opts de puntos seleccionados por el usuario
% en esta version se puede ajustar el ancho del bin de los histogramas, tambien se ajusta la discretizacion (niveles de gris) de la imagen
% rev 1-sept-2004: corregi el muestreo a diferentes sigmas, y renombre el indice para cada imagen
% rev. 18-ago-2004: ya se puede escribir el archivo de vectores de 61 componentes ver notas 18/ago/2004
% muestreo_60car_vent25_ver2.m
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
NOM=[%'an-u3-14-01-al.con';
%'an-u3-14-02-al.con';
%'an-u3-14-03-al.con';
%'an-u3-14-04-al.con';
'an-u3-14-05-al.con';
%'an-u3-14-06-al.con';
%'an-u3-15-02-al.con';
%'an-u3-15-03-al.con';
%'an-u3-15-04-al.con';
'an-u3-15-05-al.con';
%'an-u3-15-06-al.con';
%'an-u3-16-03-al.con';
%'an-u3-16-04-al.con'; ya esta!
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
for imagen=1:ren % repetimos el ciclo para todas las imagenes
%    ns_A=[];
    ncontorno=NOM(imagen,:);
%    M=dlmread(ncontorno, ' ');
% 	NoP=M(1,1);
% 	ang_ejem=M(2,1);
% 	escala=M(2,2); % valor de escala del contrno alineado por dif de areas: X=X*escala 
% 	centro_x=M(2,3);
% 	centro_y=M(2,4);
% 	ns_A(:,1)=M(3:NoP+2,1);
%    ns_A(:,2)=M(3:NoP+2,2);
%    
%    %**************************************************************
%    % construccion de la imagen binaria para etiquetado de muestras
%    %**************************************************************
%    Tinv=[cos(ang_ejem) sin(ang_ejem); -1*sin(ang_ejem) cos(ang_ejem)];
% 	Cori=(1/escala)*ns_A*Tinv;% multiplicando por 1/escala regresamos al original
% 	Cori(:,2)=-Cori(:,2);%invertimos Y para escribir en la imagen
% 	centro_xy=repmat([centro_x, centro_y],NoP, 1);
% 	Cori=round(Cori+centro_xy);
    nomima=ncontorno(4:length(ncontorno)-7)
    nomima=strcat(nomima,'.bmp')
    I=imread(nomima,'bmp');
% 	[J, IBW]=roifill(I,Cori(:,1), Cori(:,2));
%    figure
% 	imshow(I)
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
%    indice=1;
%    inter=(NoP/NoPM);
%    apun=inter;
%    for j=1:NoP
% 	   %if rem(j,inter)==0
%       if j==round(apun)
%       	EJEMPLO_M(indice,:)=ns_A(j,:);
%          indice=indice+1;
%          apun=apun+inter;
%    	end
%    end
%    if indice~=NoPM+1
%       'NO SE MUESTREARON 35 PUNTOS!'
%       indice
%       break
%    end
%    %figure
%    %plot(EJEMPLO_M(:,1), EJEMPLO_M(:,2), '.b');
% 
% 	Tinv=[cos(ang_ejem) sin(ang_ejem); -1*sin(ang_ejem) cos(ang_ejem)];
% 	Cori=(1/escala)*EJEMPLO_M*Tinv;% multiplicando por 1/escala regresamos al original
% 	Cori(:,2)=-Cori(:,2);%invertimos Y para escribir en la imagen
% 	centro_xy=repmat([centro_x, centro_y],NoPM, 1);
% 	Cori=round(Cori+centro_xy);
%    
%    %figure
%    %plot(Cori(:,1), Cori(:,2), '.r');
   
   %*********************************************************************
   % calculo de los momentos del histograma ponderado (escala alfa) para 
   % una ventana de 5x5 y para cada punto de referencia (35 en total)
   % Aqui tambien se guarda el archivo.
   %*********************************************************************
%     ancho_v=5;
% 	alto_v=5;
% 	offset_v= ceil(ancho_v/2); % para ventanas cuadradas
	beta=5; % ancho del bote (bin) del histograma este programa Si acepta un bin variable
% 	[renC colC]=size(Cori);
% 	Cori(renC+1, :)=Cori(1,:); %cerramos el contorno
    [X,Y,G]=impixel(I); %adquisicion a mouse de pixeles en la imagen I
    [no_puntos colpuntos]=size(Y);
%     X=Cori(:,1);
% 	Y=Cori(:,2);
  % no_puntos=renC+1;
   nomarchi=ncontorno(4:length(ncontorno)-7);
   nomarchi=strcat('xyg_60car_pros',nomarchi,'.txt');
   		for punto=1:no_puntos% para todos los puntos seleccionados
                 alfa=2*sigma0; % escala inicial de la gaussiana de apertura - outer scale   
                   MOMENTOS=zeros(5,12); %matriz de momemntos del pixel i,j de la ventana 
                   for escala=1:5  
                   	    %espaciamiento=2^(escala-1);
                 		A=MGI(:,:,escala);
   		                x0=X(punto);% (x0, y0) origen de la gaussiana de apertura
						y0=Y(punto);
                        %*******************        
                        % momentos de la imagen filtrada sin derivar 
                        %*******************
                        H=zeros(1,256);
						for bin=0:beta:255 % aqui es hasta 255, 1 es nomas pa'probar
			   				for x=round(x0-3*sqrt(alfa)):round(x0+3*sqrt(alfa))
			      				for y=round(y0-3*sqrt(alfa)): round(y0+3*sqrt(alfa))
                              H(bin+1)=H(bin+1)+exp(-((x-x0)^2+(y-y0)^2)/(2*alfa^2))*exp(-((A(y,x)-bin)^2)/(2*beta^2));
                         	end            
                        end 
                     	H(bin+1)=H(bin+1)*(1/(2*pi*alfa^2));   
             			end % for bin..   
             			% plot(H(no_histo,:));
             			m1=sum([0:255].*H); % momentos del histograma para beta=1, 256 niveles
						m2=sum([0:255].^2.*H);
                  	    MOMENTOS(escala, 1)=m1;
                  	    MOMENTOS(escala, 2)=m2;
                     
                        %*******************        
                        % momentos de Dx 
                        %*******************
                        A=MDxGI(:,:,escala);
                        H=zeros(1,256);
						for bin=0:beta:255 % aqui es hasta 255, 1 es nomas pa'probar
			   				for x=round(x0-3*sqrt(alfa)):round(x0+3*sqrt(alfa))
			      				for y=round(y0-3*sqrt(alfa)): round(y0+3*sqrt(alfa))
                              H(bin+1)=H(bin+1)+exp(-((x-x0)^2+(y-y0)^2)/(2*alfa^2))*exp(-((A(y,x)-bin)^2)/(2*beta^2));
                         	end            
                        end 
                     	H(bin+1)=H(bin+1)*(1/(2*pi*alfa^2));   
             			end % for bin..   
             			% plot(H(no_histo,:));
             			m1=sum([0:255].*H); % momentos del histograma para beta=1, 256 niveles
						m2=sum([0:255].^2.*H);
                  	    MOMENTOS(escala, 3)=m1;
                  	    MOMENTOS(escala, 4)=m2;

                        %*******************        
                        % momentos de Dy 
                        %*******************
                        A=MDyGI(:,:,escala);
                        H=zeros(1,256);
						for bin=0:beta:255 % aqui es hasta 255, 1 es nomas pa'probar
			   				for x=round(x0-3*sqrt(alfa)):round(x0+3*sqrt(alfa))
			      				for y=round(y0-3*sqrt(alfa)): round(y0+3*sqrt(alfa))
                              H(bin+1)=H(bin+1)+exp(-((x-x0)^2+(y-y0)^2)/(2*alfa^2))*exp(-((A(y,x)-bin)^2)/(2*beta^2));
                         	end            
                        end 
                     	H(bin+1)=H(bin+1)*(1/(2*pi*alfa^2));   
             			end % for bin..   
             			% plot(H(no_histo,:));
             			m1=sum([0:255].*H); % momentos del histograma para beta=1, 256 niveles
						m2=sum([0:255].^2.*H);
                  	    MOMENTOS(escala, 5)=m1;
                  	    MOMENTOS(escala, 6)=m2;
                     
                        %*******************        
                        % momentos de Dxx 
                        %*******************
                        A=MDxxGI(:,:,escala);
                        H=zeros(1,256);
						for bin=0:beta:255 % aqui es hasta 255, 1 es nomas pa'probar
			   				for x=round(x0-3*sqrt(alfa)):round(x0+3*sqrt(alfa))
			      				for y=round(y0-3*sqrt(alfa)): round(y0+3*sqrt(alfa))
                              H(bin+1)=H(bin+1)+exp(-((x-x0)^2+(y-y0)^2)/(2*alfa^2))*exp(-((A(y,x)-bin)^2)/(2*beta^2));
                         	end            
                        end 
                     	H(bin+1)=H(bin+1)*(1/(2*pi*alfa^2));   
             			end % for bin..   
             			% plot(H(no_histo,:));
             			m1=sum([0:255].*H); % momentos del histograma para beta=1, 256 niveles
						m2=sum([0:255].^2.*H);
                  	    MOMENTOS(escala, 7)=m1;
                  	    MOMENTOS(escala, 8)=m2;

                        %*******************        
                        % momentos de Dyy 
                        %*******************
                        A=MDyyGI(:,:,escala);
                        H=zeros(1,256);
						for bin=0:beta:255 % aqui es hasta 255, 1 es nomas pa'probar
			   				for x=round(x0-3*sqrt(alfa)):round(x0+3*sqrt(alfa))
			      				for y=round(y0-3*sqrt(alfa)): round(y0+3*sqrt(alfa))
                              H(bin+1)=H(bin+1)+exp(-((x-x0)^2+(y-y0)^2)/(2*alfa^2))*exp(-((A(y,x)-bin)^2)/(2*beta^2));
                         	end            
                        end 
                     	H(bin+1)=H(bin+1)*(1/(2*pi*alfa^2));   
             			end % for bin..   
             			% plot(H(no_histo,:));
             			m1=sum([0:255].*H); % momentos del histograma para beta=1, 256 niveles
						m2=sum([0:255].^2.*H);
                  	    MOMENTOS(escala, 9)=m1;
                  	    MOMENTOS(escala, 10)=m2;

                        %*******************        
                        % momentos de Dxy 
                        %*******************
                        A=MDxyGI(:,:,escala);
                        H=zeros(1,256);
						for bin=0:beta:255 % aqui es hasta 255, 1 es nomas pa'probar
			   				for x=round(x0-3*sqrt(alfa)):round(x0+3*sqrt(alfa))
			      				for y=round(y0-3*sqrt(alfa)): round(y0+3*sqrt(alfa))
                              H(bin+1)=H(bin+1)+exp(-((x-x0)^2+(y-y0)^2)/(2*alfa^2))*exp(-((A(y,x)-bin)^2)/(2*beta^2));
                         	end            
                        end 
                     	H(bin+1)=H(bin+1)*(1/(2*pi*alfa^2));   
             			end % for bin..   
             			% plot(H(no_histo,:));
             			m1=sum([0:255].*H); % momentos del histograma para beta=1, 256 niveles
						m2=sum([0:255].^2.*H);
                  	    MOMENTOS(escala, 11)=m1;
                  	    MOMENTOS(escala, 12)=m2;
                        %keyboard
                        alfa=2*alfa;   
                    end % for escala=1.. 
                  
                 fid=fopen(nomarchi,'a');
                 fprintf(fid,'punto %d:\n', punto);
                 fprintf(fid, '%d %d %d ', x0, y0, G(punto,1));
                 fprintf(fid, '%4.4f %4.4f %4.4f %4.4f %4.4f %4.4f %4.4f %4.4f %4.4f %4.4f %4.4f %4.4f \n', MOMENTOS');
                 fclose(fid);
         %keyboard     
         end % end for punto=1..
        
      %figure
      %imshow(I)
       
end % for imagen=1:ren
%hold off
