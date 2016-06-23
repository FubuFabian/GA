%calcula_M.m
% esta funcion calcula para el punto x0,y0 de A, el momento de orden 'ordenM' 
% entradas: 
%           x0,y0: renglon y columna del pixel
%           A: imagen de la derivada de I filtrada con una cierta sigma
%           alfa: escala interna del histograma
function momento=calcula_M(x0,y0, A, alfa,  ordenM)
beta=1;
dos_alfa_cuad=2*alfa^2;
dos_beta_cuad=2*beta^2;
inv_2pi_alfa_cuad=1/(2*pi*alfa^2);
H=zeros(1,256);
for bin=0:255 % aqui es hasta 255, 1 es nomas pa'probar
	for x=round(x0-3*sqrt(alfa)):round(x0+3*sqrt(alfa))
		for y=round(y0-3*sqrt(alfa)): round(y0+3*sqrt(alfa))
            H(bin+1)=H(bin+1)+exp(-((x-x0)^2+(y-y0)^2)/dos_alfa_cuad)*exp(-((A(y,x)-bin)^2)/dos_beta_cuad);
       end            
    end 
  	H(bin+1)=H(bin+1)*inv_2pi_alfa_cuad;   
end % for bin..   
%plot(H(no_histo,:));
m(1)=sum([0:255].*H); % momentos del histograma para beta=1, 256 niveles
m(2)=sum([0:255].^2.*H);
momento=m(ordenM);
