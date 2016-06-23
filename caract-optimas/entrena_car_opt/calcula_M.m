% calcula_M.m
% esta version realiza operaciones vectorizadas solo procesa un punto a la vez
% esta funcion calcula para el punto x0,y0 de A, el momento de orden 'ordenM' 
% entradas: 
%           x0,y0: renglon y columna del pixel
%           A: imagen de la derivada de I filtrada con una cierta sigma
%           alfa: escala interna del histograma
function momento=calcula_M(x0,y0, A, alfa,  ordenM)
beta=5; % ancho del bin del histograma
dos_alfa_cuad=2*alfa^2;
dos_beta_cuad=2*beta^2;
inv_2pi_alfa_cuad=1/(2*pi*alfa^2);
X=round(x0-3*sqrt(alfa)): round(x0+3*sqrt(alfa));
Y=round(y0-3*sqrt(alfa)): round(y0+3*sqrt(alfa));
[renX colX]=size(X);
[renY colY]=size(Y);
X_X0_2=(X-x0).^2;
Y_Y0_2=(Y-y0).^2;

for i=1:colX
   for j=1: colY
      EXP1(i,j)= exp(-(X_X0_2(i)+Y_Y0_2(j))/dos_alfa_cuad); 
   end
end

for bin=0:beta:255
for i=1:colX
   for j=1: colY
       EXP2(i,j,bin+1)= exp(-((A(Y(j),X(i))-bin)^2)/dos_beta_cuad);
   end
end
end

H=zeros(1,256);
for bin=0:beta:255 % aqui es hasta 255, 1 es nomas pa'probar
   for i=1:colX
   		for j=1: colY
            %H(bin+1)=H(bin+1)+EXP1(i,j).*exp(-((A(Y(j),X(i))-bin)^2)/dos_beta_cuad);
            H(bin+1)=H(bin+1)+EXP1(i,j).*EXP2(i,j,bin+1);
       end
	end
end % for bin..   
%H(bin+1)=H(bin+1)*inv_2pi_alfa_cuad;     
H=H*inv_2pi_alfa_cuad;
%plot(H(no_histo,:));
m(1)=sum([0:255].*H); % momentos del histograma para beta=1, 256 niveles
m(2)=sum([0:255].^2.*H);
momento=m(ordenM);





