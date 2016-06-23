
%leer_archivo_optimas.m
% este programa lee los archivos de vectores de 60car para 25 puntos alrededor de cada landmark
clear

NOMENTRE=[ %'an-u3-14-01-al.con';
%'an-u3-14-02-al.con';
%'an-u3-14-03-al.con';
%'an-u3-14-04-al.con';
%'an-u3-14-05-al.con';
%'an-u3-14-06-al.con';
'an-u3-15-02-al.con';
%'an-u3-15-03-al.con';
'an-u3-15-04-al.con';
%'an-u3-15-05-al.con';
'an-u3-15-06-al.con';
%'an-u3-16-03-al.con';
'an-u3-16-04-al.con';
%'an-u3-16-05-al.con';
'an-u3-16-06-al.con';
%'an-u3-16-07-al.con';
%'an-u3-17-00-al.con';
%'an-u3-17-05-al.con';
%'an-u3-18-00-al.con';
%'an-u3-18-01-al.con';
%'an-u3-18-02-al.con';
%'an-u3-18-03-al.con';
%'an-u3-18-04-al.con';
%'an-u3-18-05-al.con';
];

[renentre, colentre]=size(NOMENTRE);
%figure
%axis equal
%hold on
for imagen=1:renentre % repetimos el ciclo para todas las imagenes
   name=NOMENTRE(imagen,:);
   name=name(4:11);
   name=strcat('v5x5_60car_', name, '.txt');
   fid=fopen(name, 'r');
	for j=1:35
		L=fscanf(fid, '%c',20);
		LN=fscanf(fid, '%d\n',1);
			for i=1:25
				P=fscanf(fid, '%c',6);
				PN=fscanf(fid, '%d\n',1);
				P=fscanf(fid, '%c\n',24);
				IO(j,i, imagen)=fscanf(fid, '%d\n',1);
				CAR=fscanf(fid, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f \n', 60);
				VENT((j-1)*25+i,:, imagen)=CAR';
			end
	end
	fclose(fid);
end % for imagen=1:renentre


%clasificador KNN
% Para un nuevo vector correspondiente a un punto de ref (landmark):
% 	calcular la d del vector a todas la muestras de entrenamiento del % mismo punto de ref.
%	seleccionar las K distancias mas pequeñas
% 	ponderar distancias con e^-d^2
% 	sumar las ds de los vecinos de la misma clase prostata/fondo
% 	clasificar el vector con la clase de distacia menor. 

D=ones(35*25,renentre)*NaN;
v=[1:60];
for imagen=1:renentre
  for land=1:35   
     for muestra=1:25
        v1=VENT((land-1)*25+muestra,:,imagen);
        D((land-1)*25+muestra, imagen)=sqrt(sum((v-v1).^2));
     end  
  end
end



