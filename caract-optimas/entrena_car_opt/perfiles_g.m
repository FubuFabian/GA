%Función para muestreo de perfiles de nivel de gris
% XY es una matriz con el contorno
% MG es una matriz con un perfil de gris por renglón, correspondiente a cada punto del contorno XY
% IMA es la imagen correspondiente a cada contorno XY
function MG=perfiles_g(XY, IMA)
INFLMT=-12;
SUPLMT=12;
[ren col]=size(XY);
XY(ren+1, :)=XY(1,:);
X=XY(:,1);
Y=XY(:,2);
no_puntos=ren+1;

for punto=1:no_puntos-1
	inc_X= X(punto+1)-X(punto);
	inc_Y= Y(punto+1)-Y(punto);
	if inc_Y==0
		if inc_X>0 normal_angle=3*pi/2; end %// 270 degrees
		if inc_X<0 normal_angle=pi/2; end%// 90 degrees
		if inc_X==0 normal_angle=-10.0; end%// error p1 and p0 are the same point!
		
	else
		if inc_Y>0 normal_angle= atan(-1*inc_X/inc_Y); end
		if inc_Y<0 normal_angle= atan(-1*inc_X/inc_Y)+pi;end
		
	end
	cos_normal_angle= cos(normal_angle);
	sin_normal_angle= sin(normal_angle);
	for j=INFLMT:SUPLMT 
		dx= (j*cos_normal_angle+0.5);
		dy= (j*sin_normal_angle+0.5);
		dx=round(dx+X(punto,1));
		dy=round(dy+Y(punto,1));
      MG(punto, j-INFLMT+1)=IMA(dy,dx);
      %IMA(dy,dx)=255;
	
	end%end for(j=
end % end for punto=1:
%figure
%imshow(IMA)