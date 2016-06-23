% error_knn_optimas_mgm.m
% funcion de error de clasificacion de un conjunto de pixeles utilizando N
% caracteristicas optimas
% parametros de entrada:
%   MUE_VAL: matriz con las 60 car optimas de la muestra de validacion
%   MEDIAS_P: 14 medias de entrenamiento de la prostata
%   MEDIAS_F: 14 medias de entrenamiento del fondo
%   chrom: matriz de cadenas binarias que indican las xi a evaluar por
%   renglon
%   IO: matriz de etiquetas pros/fondo (1/0)
function error=error_knn_optimas_mgm(MUE_VAL, MEDIAS_P, MEDIAS_F, chrom, IO)
[no_ind no_bits]=size(chrom);
[no_medias_pros no_car_opt]=size(MEDIAS_P);
[no_medias_fondo no_car_opt]=size(MEDIAS_F);
error=zeros(no_ind,1);
[ren_MUE_VAL col_MUE_VAL capas_MUE_VAL]=size(MUE_VAL);
for individuo=1:no_ind
    CAROPT=chrom(individuo,:).*[1:60];
    CAROPT=CAROPT(find(CAROPT));
    %keyboard
    for imagenval=1:capas_MUE_VAL %para todas las imagenes de validacion
         for pixelval=1:ren_MUE_VAL % para todos los pixeles de validacion
            contadorD=1;
            v1=MUE_VAL(pixelval,CAROPT,imagenval);
            %calcular las distancias de cada pixel de validacion a las MEDIAS de entrenamiento	              
            for media=1:no_medias_pros      
                v2=MEDIAS_P(media,CAROPT);
               	D(contadorD)=sum((v1-v2).^2);
               	IOPIXEL(contadorD)=1; %prostata
               	contadorD=contadorD+1;
            end
            for media=1:no_medias_fondo
                v2=MEDIAS_F(media,CAROPT);
               	D(contadorD)=sum((v1-v2).^2);
               	IOPIXEL(contadorD)=0; %fondo
               	contadorD=contadorD+1;
            end
            %******************
			% clasificador KNN5
			%******************
			[KV, IKV]=sort(D); % ordena KV en forma descendente guarda el indice original en IKV
        	TOP15=KV(1:15)/1e7;
          	ITOP15=IKV(1:15);
          	IOTOP15=IOPIXEL(ITOP15);
            suma_pros=0;
            suma_fondo=0;
            for toppixel=1:15
            	if (IOTOP15(toppixel)==1)
                    suma_pros= suma_pros + exp(-TOP15(toppixel));
            	else
             		suma_fondo= suma_fondo + exp(-TOP15(toppixel));
          		end
            end
            if suma_pros>suma_fondo
                IOKNN=1;
            else
                IOKNN=0;
            end
            error(individuo)=error(individuo)+(IO(pixelval,imagenval)-IOKNN)^2;
         end %for pixelval=1:..
     end %for imagenval=1:..
 end % for individuo=1:no_ind
     