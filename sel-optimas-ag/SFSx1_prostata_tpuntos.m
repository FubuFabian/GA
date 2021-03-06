% 
% SFSx1_prostata_tpuntos.m
% 29-oct-2004: esta version calcula un solo conjunto de car optimas pa' todos los puntos del PDM de la prostata
% ver notas del 29 de oct. 2004
% despues de hacer la seleccion hacia adelante prueba y descarta x1 si el error disminuye
%  7/sept./2004: Algoritmo de seleccion de caracteristicas optimas hacia adelante (Sequential Forward Selection)
clear
NoPM=35;

%************************************************************************
% lectura de las muestras de entrenamiento para el clasificador KNN, K=5
%************************************************************************
% NOMENTRE=[ 'an-u3-14-01-al.con';
% %'an-u3-14-02-al.con';
% %'an-u3-14-03-al.con';
% %'an-u3-14-04-al.con';
% %'an-u3-14-05-al.con';
% %'an-u3-14-06-al.con';
% %'an-u3-15-02-al.con';
% %'an-u3-15-03-al.con';
% %'an-u3-15-04-al.con';
% %'an-u3-15-05-al.con';
% %'an-u3-15-06-al.con';
% 'an-u3-16-03-al.con';
% %'an-u3-16-04-al.con';
% %'an-u3-16-05-al.con';
% %'an-u3-16-06-al.con';
% %'an-u3-16-07-al.con';
% %'an-u3-17-00-al.con';
% %'an-u3-17-05-al.con';
% %'an-u3-18-00-al.con';
% %'an-u3-18-01-al.con';
% %'an-u3-18-02-al.con';
% %'an-u3-18-03-al.con';
% %'an-u3-18-04-al.con';
% %'an-u3-18-05-al.con';
% ];

NOMENTRE=[ 
%'an-u3-14-02-al.con';
'an-u3-18-04-al.con';
'an-u3-18-04-al.con';
% 'an-u3-15-03-al.con';
% 'an-u3-16-03-al.con';
% 'an-u3-15-05-al.con';
% 'an-u3-16-05-al.con';
% 'an-u3-17-05-al.con';
% 'an-u3-14-04-al.con';
];

[renentre, colentre]=size(NOMENTRE);
%figure
%axis equal
%hold on
for imagen=1:renentre % repetimos el ciclo para todos los archivos
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
				IO((j-1)*25+i, imagen)=fscanf(fid, '%d\n',1);
				CAR=fscanf(fid, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f \n', 60);
				MUE_ENTRE((j-1)*25+i,:, imagen)=CAR';
			end
	end
	fclose(fid);
end % for imagen=1:renentre

%****************************************************************************
[ren_MUE_ENTRE col_MUE_ENTRE capas_MUE_ENTRE]=size(MUE_ENTRE);


renval=ceil(renentre/2); % separamos (renentre-renval) archivos para enterenamiento y (renval) archivos para validacion
rentotal=renentre;
renentre=renentre-renval;


CAROPT_TODAS=zeros(1,60);
ERRORES=zeros(1,60);
   L=0; %longitud inicial del vector de caracteristicas optimas
   e_min=10000;
   clear CAROPT;
   for x=1:60
      x
      %keyboard
      L=L+1;
      CAROPT(L)=x;
      error=0;
      for imagenval=1:renval %1ra mitad de imagenes pa' validacion
         for pixelval=1:ren_MUE_ENTRE % para todos los pixeles de validacion
            pixelval
            contadorD=1;
            v1=MUE_ENTRE(pixelval,CAROPT,imagenval);
            %calcular las distancias de cada pixel de validacion a la muestra de entrenamiento	              
            for pixelentre=1:ren_MUE_ENTRE      
                for imagenentre=renval+1:rentotal %2da mitad de imagenes pa' entrenamiento KNN
                    v2=MUE_ENTRE(pixelentre,CAROPT,imagenentre);
                 	D(contadorD)=sum((v1-v2).^2);
                 	IOPIXEL(contadorD)=IO(pixelentre,imagenentre);
                 	contadorD=contadorD+1;
                end    
            end
            %******************
			% clasificador KNN5
			%******************
			[KV, IKV]=sort(D); % ordena KV en forma descendente guarda el indice original en IKV
        	TOP5=KV(1:5)/1e7;
          	ITOP5=IKV(1:5);
          	IOTOP5=IOPIXEL(ITOP5);
            suma_pros=0;
            suma_fondo=0;
            for toppixel=1:5
            	if (IOTOP5(toppixel)==1)
                 suma_pros= suma_pros + exp(-TOP5(toppixel));
            	else
             		suma_fondo= suma_fondo + exp(-TOP5(toppixel));
          		end
            end
            if suma_pros>suma_fondo
                IOKNN=1;
            else
                IOKNN=0;
            end
            error=error+(IO(pixelval,imagenval)-IOKNN)^2;
         end %for pixelval=1:..
     end %for imagenval=1:..
     if error<e_min
         e_min=error;
     else
         L=L-1;   
     end
     ERRORES(x)=error;   
     end % for x=1:..
     CAROPT=CAROPT(1:L);
     %*****************
     %evaluacion de x1
     %*****************
     %keyboard
     error=0;
      for imagenval=1:renval %1ra mitad de imagenes pa' validacion
         for pixelval=1:ren_MUE_ENTRE % para la ventana de validacion
            pixelval
            contadorD=1;
            v1=MUE_ENTRE(pixelval,CAROPT(2:L),imagenval);
            %calcular las distancias de cada pixel de validacion a la muestra de entrenamiento	              
            for pixelentre=1:ren_MUE_ENTRE      
                for imagenentre=renval+1:rentotal %2da mitad de imagenes pa' entrenamiento KNN
                    v2=MUE_ENTRE(pixelentre,CAROPT(2:L),imagenentre);
                 		D(contadorD)=sum((v1-v2).^2);
                 		IOPIXEL(contadorD)=IO(pixelentre,imagenentre);
                 		contadorD=contadorD+1;
                end    
            end
            %******************
			% clasificador KNN5
			%******************
			[KV, IKV]=sort(D); % ordena KV en forma descendente guarda el indice original en IKV
        	TOP5=KV(1:5)/1e7;
          	ITOP5=IKV(1:5);
          	IOTOP5=IOPIXEL(ITOP5);
          suma_pros=0;
          suma_fondo=0;
          for toppixel=1:5
            	if (IOTOP5(toppixel)==1)
                 suma_pros= suma_pros + exp(-TOP5(toppixel));
            	else
             		suma_fondo= suma_fondo + exp(-TOP5(toppixel));
          		end
          end
          if suma_pros>suma_fondo
             IOKNN=1;
          else
             IOKNN=0;
          end
          error=error+(IO(pixelval,imagenval)-IOKNN)^2;
        end %for pixelval=1:..
     end %for imagenval
     
     if error<= e_min
        CAROPT_TODAS(1:length(CAROPT-1))=CAROPT(2:L);
     else
        CAROPT_TODAS(1:length(CAROPT))=CAROPT;
     end
     ERRORESx1=error;

% save 'car_opt_todos_puntos.txt' CAROPT -ASCII
% 
% save 'car_opt_todos_puntos_sX1.txt' CAROPT_TODAS -ASCII
% 
% save 'errores_60car.txt' ERRORES -ASCII
% 
% save 'errores_60car_sX1.txt' ERRORESx1 -ASCII

			



