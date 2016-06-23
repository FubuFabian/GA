function [Xint, Yint]=interpolar_a1(X, Y)
%Esta funcion interpola puntos continuos en un contorno muestreado
%La función cierra el contorno
%hold on
[ren col]=size(X);
X(ren+1, 1)=X(1,1);
Y(ren+1, 1)=Y(1,1);
no_puntos=ren;
apun=1;
for j=1:no_puntos
  d=floor(sqrt((X(j+1)-X(j))^2+(Y(j+1)-Y(j))^2));
  inc=(X(j+1)-X(j))/d;
  if inc==0
     inc=(Y(j+1)-Y(j))/d;
     if inc~=0
      YI=Y(j):inc:Y(j+1);
      size_YI=size(YI);
      for i=1:size_YI(1,2)
         Xint(apun,1)=X(j);
         Yint(apun,1)=YI(i);
         apun=apun+1;
         %plot(X(j),-1*YI(i), '.')
      end
     end
  else
  	XI=X(j):inc:X(j+1);
  	YI=interp1([X(j), X(j+1)], [Y(j), Y(j+1)], XI);
  	size_XI=size(XI);
  	for i=1:size_XI(1,2)
      Xint(apun,1)=XI(i);
      Yint(apun,1)=YI(i);
      apun=apun+1;  
      %plot(XI(i),-1*YI(i), '.')
	end
  end
end
%hold off