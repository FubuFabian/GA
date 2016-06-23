function [Xint, Yint]=interpolar(X, Y, ppinter)
% interpolaci?n de puntos intermedios
%entrada: X, Y vectores de coordenadas x y
%				ppinter puntos por intervalo [pi pi+1]
%salida: Xint Yint vectores con los nuevos puntos
%figure
%hold on
[ren col]=size(X);
X(ren+1, 1)=X(1,1);
Y(ren+1, 1)=Y(1,1);
no_puntos=ren;
apun=1;
for j=1:no_puntos
  inc=(X(j+1)-X(j))/ppinter;
  if inc==0
     inc=(Y(j+1)-Y(j))/ppinter;
     if inc~=0
      YI=Y(j):inc:Y(j+1);
      size_YI=size(YI);
      for i=1:size_YI(1,2)
         Xint(apun,1)=X(j);
         Yint(apun,1)=YI(i);
         apun=apun+1;
         %plot(X(j),-1*YI(i), '.')
      end %end for
     end % end if
  else
  	XI=X(j):inc:X(j+1);
  	YI=interp1([X(j), X(j+1)], [Y(j), Y(j+1)], XI);
  	size_XI=size(XI);
  	for i=1:size_XI(1,2)
      Xint(apun,1)=XI(i);
      Yint(apun,1)=YI(i);
      apun=apun+1;  
%      plot(XI(i),-1*YI(i), '.')
	end %end for
  end %end else
end %end for j=1..
%hold off
