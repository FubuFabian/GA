%calcula_M1.m
% esta funcion calcula para el punto x0,y0 de A, el momento de orden 'ordenM' 
% entradas: 
%           X, Y: vectores con las coordenadas de cada pixel en un perfil de gris
%           A: imagen de la derivada de I filtrada con una cierta sigma
%           alfa: escala interna del histograma
function MOMENTO=calcula_M1(X0, Y0, A, alfa,  ordenM)
[puntosp colp]=size(X0);
beta=1;
dos_alfa_cuad=2*alfa^2;
dos_beta_cuad=2*beta^2;
inv_2pi_alfa_cuad=1/(2*pi*alfa^2);
X=round(X0-3*sqrt(alfa)): round(X0+3*sqrt(alfa))
Y=round(Y0-3*sqrt(alfa)): round(Y0+3*sqrt(alfa))
[renX0 colX0]=size(X0);
X0=repmat(X0, [1 colX0]);
Y0=repmat(Y0, [1 colX0]);
X_X0_2=(X-X0).^2;
Y_Y0_2=(Y-Y0).^2;
indexfin=1;

for indexX=1:colX0
   for indexY=indexX:colX0
       EXP1(:,indexfin)=exp(-(X_X0_2(indexX)+Y_Y0_2(indexY))/dos_alfa_cuad);
   		indexfin=indexfin+1;
	end
end
keyboard
%H=zeros(puntosp,256);
H=zeros(puntosp, 1);
for bin=0:255 % aqui es hasta 255, 1 es nomas pa'probar
   H(:,bin+1)=H(:, bin+1)+exp(-((X-X0).^2+(Y-Y0).^2)/dos_alfa_cuad).*repmat(exp(-((A(Y,X)-bin).^2)/dos_beta_cuad), [1 colX0]);
   
   %H(:,bin+1)=H(:, bin+1)*inv_2pi_alfa_cuad;   

end % for bin..   
H=H*inv_2pi_alfa_cuad;
%plot(H(no_histo,:));
m(1)=sum([0:255].*H); % momentos del histograma para beta=1, 256 niveles
m(2)=sum([0:255].^2.*H);
momento=m(ordenM); % vector con los momentos de cada pixel en el perfil


for bin=0:255 % aqui es hasta 255, 1 es nomas pa'probar
	for x=round(x0-3*sqrt(alfa)):round(x0+3*sqrt(alfa))
		for y=round(y0-3*sqrt(alfa)): round(y0+3*sqrt(alfa))
            H(bin+1)=H(bin+1)+exp(-((x-x0)^2+(y-y0)^2)/dos_alfa_cuad)*exp(-((A(y,x)-bin)^2)/dos_beta_cuad);
       end            
    end 
  	H(bin+1)=H(bin+1)*inv_2pi_alfa_cuad;   
end % for bin..   
