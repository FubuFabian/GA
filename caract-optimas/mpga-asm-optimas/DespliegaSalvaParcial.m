% DespliegaSalvaParcial(XYT, XYc, IMA)
% funcion pa desplegar resultados parciales del ajuste del ASM

function ok=DespliegaSalvaParcial(XYT, XYc, IMA)
XYTI=XYT+XYc;

%figure
%axis equal
%plot(XYTI(:,1), XYTI(:,2), '-b')

XYTI(:,2)=-1*(XYTI(:,2)-XYc(:,2))+XYc(:,2);
[Xint, Yint]=interpolar_a1(XYTI(:,1), XYTI(:,2));
[ren col]=size(Xint);
Xint=round(Xint);
Yint=round(Yint);
for i=1:ren
  IMA(Yint(i),Xint(i))=255;
%  IMA(XYori(i,2),XYori(i,1))=255;
end
imwrite(IMA, '1604-mpga35-asm25', 'tif')
figure
imshow(IMA)
ok=0;
