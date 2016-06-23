%histograma_region.m
% Este programa calcula el histograma de una region ponderada por una funcion de apertura gaussiana
clear
%name=input('nombre de la imagen?');
%A=imread(name, 'bmp');

%A=repmat([1:20],20,1);
A=ones(40,40)*128;

[ren col]=size(A);
A=double(A);
x0=round(col/2); % origen de la gaussiana de apertura
y0=round(ren/2);
alfa=3; % escala de la apertura-outer scale
beta=1; % ancho del bote (bin) del histograma ESTE PROGRAMA SOLO JALA PARA beta=1
sigma=1; % escala de la imagen-inner scale
H=zeros(1,256);
for i=0:255
   for x=round(x0-3*sqrt(alfa)):round(x0+3*sqrt(alfa))
      for y=round(y0-3*sqrt(alfa)): round(y0+3*sqrt(alfa))
         H(i+1)=H(i+1)+(1/(2*pi*alfa^2))*exp(-((x-x0)^2+(y-y0)^2)/(2*alfa^2))*exp(-((A(y,x)-i)^2)/(2*beta^2));
      end            
   end   
end

% 1° y 2° momentos del histograma para beta=1
m1=sum([0:255].*H);
m2=sum([0:255].^2.*H);
