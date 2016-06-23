% error_knn_optimas.m
% funcion de error de clasificacion de un conjunto de pixeles utilizando N
% caracteristicas optimas
% parametros de entrada:
%   MUE_ENTRE: matriz con las 60 car optimas de la muestra de entrenamiento
%   y validacion
%   IO: matriz de etiquetas 1/0 (prostata/fondo)
%   chrom: matriz de cadenas binarias que indican las xi a evaluar por
%   renglon
function error=error_knn_optimas(MUE_ENTRE, renval, rentotal, IO, chrom)
[no_ind no_bits]=size(chrom);
error=zeros(no_ind,1);
[ren_MUE_ENTRE col_MUE_ENTRE capas_MUE_ENTRE]=size(MUE_ENTRE);
for individuo=1:no_ind
    CAROPT=chrom(individuo,:).*[1:60];
    CAROPT=CAROPT(find(CAROPT));
    %keyboard
for imagenval=1:renval %1ra mitad de imagenes pa' validacion
         for pixelval=1:ren_MUE_ENTRE % para todos los pixeles de validacion
            pixelval;
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
			% clasificador KNN11
			%******************
			[KV, IKV]=sort(D); % ordena KV en forma descendente guarda el indice original en IKV
        	TOP11=KV(1:11)/1e7;
          	ITOP11=IKV(1:11);
          	IOTOP11=IOPIXEL(ITOP11);
            suma_pros=0;
            suma_fondo=0;
            for toppixel=1:11
            	if (IOTOP11(toppixel)==1)
                    suma_pros= suma_pros + exp(-TOP11(toppixel));
            	else
             		suma_fondo= suma_fondo + exp(-TOP11(toppixel));
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
     