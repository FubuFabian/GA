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
    CAROPT=chrom(individuo,:).*[1:no_bits];
    CAROPT=CAROPT(find(CAROPT));
    %keyboard
for imagenval=1:renval %1ra mitad de imagenes pa' validacion
         for pixelval=1:ren_MUE_ENTRE % para todos los pixeles de validacion
            %pixelval
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
            error(individuo)=error(individuo)+(IO(pixelval,imagenval)-IOKNN)^2;
         
        end %for pixelval=1:..
     end %for imagenval=1:..
     %keyboard
 end % for individuo=1:no_ind
     