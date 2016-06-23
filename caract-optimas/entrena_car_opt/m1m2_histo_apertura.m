%Función para muestreo de 60 caracteristicas: 2 momentos de 6 derivadas a 5 escalas 
% XY es una matriz con las coordenadas de un contorno muestreado
%parametros: 	IBW imagen binaria para anotar pixeles como dentro o fuera de la P
%				XY contorno muestreado
%				MGI matriz de imagenes gaussiano-filtradas 5 imagenes
%				MDxGI, MDyGI, MDxxGI, MDyyGI, MDxyGI matrices de derivadas una imagen por capa como arriba
%				sigma0 escala exterior inicial
function OK=m1m2_histo_apertura(IBW, XY, MGI, MDxGI, MDyGI, MDxxGI, MDyyGI, MDxyGI, sigma0);
IBWE=edge(IBW, 'sobel');
ancho_v=5;
alto_v=5;
offset_v= floor(ancho_v/2); % para ventanas cuadradas
beta=1; % ancho del bote (bin) del histograma ESTE PROGRAMA SOLO JALA PARA beta=1
[ren col]=size(XY);
XY(ren+1, :)=XY(1,:); %cerramos el contorno
X=XY(:,1);
Y=XY(:,2);
no_puntos=ren+1;

%for i=1:no_puntos
%   IBWE(Y(i),X(i))=128;
%end
%figure
%imshow(IBWE)
%keyboard


alfa=2*sigma0; % escala inicial de la guassiana de apertura - outer scale   
for escala=1:5
   espaciamiento=2^(escala-1);
   A=MGI(:,:,escala);
   for punto=1:no_puntos-1 % para todos los puntos del contorno
      no_histo=1; % contador de histogramas 1:25
      for j=1:espaciamiento:ancho_v*espaciamiento
          for i=1:espaciamiento:alto_v*espaciamiento
             x0=X(punto)+j-offset_v*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
			   y0=Y(punto)+i-offset_v*espaciamiento;
				H(no_histo,:)=zeros(1,256);
				for bin=0:1
				   for x=round(x0-3*sqrt(alfa)):round(x0+3*sqrt(alfa))
				      for y=round(y0-3*sqrt(alfa)): round(y0+3*sqrt(alfa))
				         H(no_histo, bin+1)=H(no_histo, bin+1)+(1/(2*pi*alfa^2))*exp(-((x-x0)^2+(y-y0)^2)/(2*alfa^2))*exp(-((A(y,x)-bin)^2)/(2*beta^2));
				      end            
               	end 
              
              end % for bin..   
              in_out=IBW(y0, x0); % etiqueta dentro (1) fuera (0) del pixel (y0, x0)
              if (in_out==1)
                 A(y0,x0)=255;
              else
                 A(y0,x0)=0;
              end
              
%             plot(H(no_histo,:));
              m1=sum([0:255].*H(no_histo,:)); % momentos del histograma para beta=1, 256 niveles
				m2=sum([0:255].^2.*H(no_histo,:));
              %keyboard
              no_histo=no_histo+1;
          end % for i..
       end % for j..
    end % end for punto=1..
figure
imshow(uint8(A+double(IBWE)*255))
keyboard
alfa=2*alfa;   
end %end for escala=1..
OK=0;
