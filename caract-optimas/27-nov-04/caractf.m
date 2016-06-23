
%caractf.m
%programa para caracterizar a mano diferentes fobj de reconocimeinto del contorno de la prostata.


%************************** OJO: LOS CONTORNOS DEBEN ANOTARSE EN SENTIDO ANTIHORARIO **********************************************

clear
N=70; %No. de puntos del modelo
resp='si';

%estadisticas del conjunto de entrenamiento nivel de gris
%muestras de (outp-inp) y el promedio de outp de imagenes de gris filtradas con filtro gaussiano
muestras_gris=[ 	18.8818 103.6795; 
					22.2260 122.1220; 
					17.7913 79.5391; 
					8.1190 82.3429; 
					15.8209 105.5395;
					17.7533 96.4300; 
					14.5162 111.6324; 
					16.1857 110.7914;
					12.4098 111.6488; 
					17.6654 126.1269; 
					21.8364 110.8568]; 
            
            
invSg=inv(cov(muestras_gris));
mediag=mean(muestras_gris);

%muestras de contraste LIP como en Pinolli y del promedio exterior calculada con el modelo LIP para 35 puntos sobre el contorno

muestrasClip=[	49.0409	150.6834; 
					50.5027	131.8480; 
					53.4260	175.2804; 
					27.9184	166.9624; 
					38.0768	146.8033; 
					47.1793	158.0024; 
					35.4340	139.9345; 
					37.0495	140.6728; 
					37.1711	139.6384; 
					39.9126	128.1401; 
					50.6306	143.4630]; 


invSClip=inv(cov(muestrasClip));
mediaClip=mean(muestrasClip);


%muestras de contraste direccional LIP por Fer y del promedio LIP de out promedio para 35 puntos igual que arriba


muestrasDifLip=[	46.2585  150.6834; 
					48.1674  131.8480; 
					53.3231  175.2804; 
					26.1459  166.9624; 
					38.0768  146.8033; 
					47.0827  158.0024; 
					32.5869  139.9345; 
					37.0495  140.6728; 
					29.3181  139.6384; 
					38.6271  128.1401; 
               50.6306  143.4630];
            
invSDifLip=inv(cov(muestrasDifLip));
mediaDifLip=mean(muestrasDifLip);

nomori=input('imagen original.bmp?');
nomgaus=input('imagen filtrada.tif?');

expe=input('numero del primer contorno?');
while resp=='si'
% anotacion manual del contorno sobre la imagen original
I=imread(nomori, 'bmp');
IG=imread(nomgaus, 'tif');
[X Y p]=impixel(I);

confirma=input('anotacion correcta? si/no');
if confirma=='si'
	[Xint, Yint]=interpolar_a1(X, Y);
	Xint=round(Xint);
	Yint=round(Yint);

	for i=1:length(Xint)
   		I(Yint(i), Xint(i))=255;
	end
	figure
	imshow(I)

	%guardamos imagen anotada
	nomori1=nomori(1:length(nomori)-4);
	nomano=strcat('contorno',int2str(expe),'-', nomori1, '.tif');
	imwrite(I,nomano, 'tif');

	%muestreo de N puntos del contorno a intervalos iguales
	intervalo=round(length(Xint)/N);
	puntosN=1;
	for i=1:length(Xint)
   		if mod(i, intervalo)==0
      		XN(puntosN)=Xint(i);
      		YN(puntosN)=Yint(i);
      		puntosN=puntosN+1;
   		end
	end
	XN(puntosN)=XN(1);
	YN(puntosN)=YN(1);
   
   %muestreo de 2N puntos del contorno a intervalos iguales
	intervalo=round(length(Xint)/(2*N));
	puntosN=1;
	for i=1:length(Xint)
   		if mod(i, intervalo)==0
      		X2N(puntosN)=Xint(i);
      		Y2N(puntosN)=Yint(i);
      		puntosN=puntosN+1;
   		end
	end
	X2N(puntosN)=X2N(1);
	Y2N(puntosN)=Y2N(1);
     
   
   
	% evaluacion de 5 funciones de energia diferentes
	fG=contraste_gris(XN, YN, IG, invSg, mediag)
	LIG=log(double(IG)+1);% ln de IG
	fLG=contraste_gris(XN, YN, LIG, invSg, mediag)
   
   
   fG2N=contraste_gris(X2N, Y2N, IG, invSg, mediag)

   fLG2N=contraste_gris(X2N, Y2N, LIG, invSg, mediag)

   
   
	LIPIG=255*(1-double(IG)/255);% modelo visual humano de IG
	fLIP=contraste_lip_M(XN, YN, LIPIG, invSClip, mediaClip)
	fLIP2=contraste_lip_M_fer(XN, YN, LIPIG, invSDifLip, mediaDifLip)

	nomfs=strcat('fs-', nomori1, '-contorno-', int2str(expe),'.txt')
	fid=fopen(nomfs, 'w');
	fprintf(fid,'fG:%4.4f  fLG:%4.4f  fG2N:%4.4f  fLG2N:%4.4f fLIP:%4.4f fLIP_fer:%4.4f \n', fG, fLG, fG2N, fLG2N, fLIP, fLIP2);
	fclose(fid)

	expe=expe+1;

end %if confirma=='si'

resp=input('desea continuar si/no?')

end % while resp  


