function Pi=interpolar(X, Y, dt)
% interpolaci?n de puntos intermedios utilizando la ec. parametrica de una
% recta: pi=p0(1-t)+p1t; 0<=t<=1
%entrada: X, Y vectores de coordenadas x y
%				ppinter puntos por intervalo [pi pi+1]
%salida: Xint Yint vectores con los nuevos puntos
%figure
%hold on
[ren col]=size(X);
X(ren+1, 1)=X(1,1);
Y(ren+1, 1)=Y(1,1);
no_puntos=ren;
nopi=no_puntos/dt;
Pi=zeros(nopi,2);
apun=1;
Pi(apun,:)=[X(1) Y(1)];    
for j=1:no_puntos
    for t=dt:dt:1
        apun=apun+1;        
        Pi(apun,:)=[X(j) Y(j)]*(1-t)+ [X(j+1) Y(j+1)]*t;    
    end
end %end for j=1..
%hold off
