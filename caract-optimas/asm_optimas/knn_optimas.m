%knn_optimas.m
% 14-10-2004: funcion para clasificar un vector de car. optimas utilzando los 5 vecinos mas cercanos
% entrada:		MUE_ENTRE, matriz con los vallres de entrenamiento de los 35 puntos del pDM y del las N imagenes
%				punto (self explain)
%				vectoropt, vector a clasificar
%				CAROPTPUNTO, vector (lista) de caracteristicas optimas
%				IO matriz con las etiquetas in/out de los puntos de entrenamiento
%				renentre, No. de imagenes de entrenamiento
function in_out=knn_optimas(MUE_ENTRE, punto, vectoropt, CAROPTPUNTO, IO, renentre)
                  contadorD=1;
                  for muestraentre=1:25
              		for imagenentre=1:renentre
                   		v1=MUE_ENTRE((punto-1)*25+muestraentre,CAROPTPUNTO,imagenentre);
                   		%v=VECTOR((j-1)*5+i,CAROPTPUNTO);
                   		D(contadorD)=(sum((vectoropt-v1).^2));
                        %D(contadorD)=sqrt(sum(abs(v-v1)));
                   		IOPIXEL(contadorD)=IO((punto-1)*25+muestraentre,imagenentre);
                   		contadorD=contadorD+1;
                    end
                  end
                 
              	[KV, IKV]=sort(D); % ordena KV en forma descendente guarda el indice original en IKV
              	TOP5=KV(1:5)/1e7; % escalamiento de d^2
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
                 		in_out=255;
                 else
                 		in_out=0;
                 end
                