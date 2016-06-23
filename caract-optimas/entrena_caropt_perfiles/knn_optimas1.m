%knn_optimas1.m
% 20-oct-2004: hace las cuentas con matrices
% 14-10-2004: funcion para clasificar un vector de car. optimas utilzando los 5 vecinos mas cercanos
% entrada:		MUE_ENTRE, matriz con los vallres de entrenamiento de los 35 puntos del pDM y del las N imagenes
%				punto (self explain)
%				vectoropt, vector a clasificar
%				CAROPTPUNTO, vector (lista) de caracteristicas optimas
%				IO matriz con las etiquetas in/out de los puntos de entrenamiento
%				renentre, No. de imagenes de entrenamiento
function IN_OUT=knn_optimas1(MUE_ENTRE, punto, VECTOROPT, CAROPTPUNTO, IO, renentre)
PIXELESPORPERFIL=21;
PIXELESPORVENTANA=21; % tenemos ahora 21 pixeles por perfil de entrenamiento
				  primerpix=(punto-1)*PIXELESPORVENTANA+1;
               inicio=1;
               for imagenentre=1:renentre
              		ENTRE_TEMP=MUE_ENTRE(primerpix:primerpix+20, CAROPTPUNTO,imagenentre);	
                    	ENTRE_PUNTO_TODOS(inicio:imagenentre*PIXELESPORVENTANA,:)=ENTRE_TEMP;
                    	IO_TEMP=IO(primerpix:primerpix+20, imagenentre);
                    	IO_TODOS(inicio:imagenentre*PIXELESPORVENTANA,1)=IO_TEMP;
                    	inicio=inicio+PIXELESPORVENTANA;
               end
               	% D_2: vector con la D euclid al cuad. de cada pixel del perfil a 
					%todos los pixeles de entrenamiento
               [renpuntos colpuntos]=size(ENTRE_PUNTO_TODOS);
               for pixel=1:PIXELESPORPERFIL
                  DIF=repmat(VECTOROPT(pixel,:),[renpuntos 1])-ENTRE_PUNTO_TODOS;
                  D_2(pixel, :)=diag(DIF*DIF')';
               end
                               
              IO_TODOS_M=repmat(IO_TODOS, [1 PIXELESPORPERFIL]); 
              [KV, IKV]=sort(D_2'); % ordena KV en forma descendente guarda el indice original en IKV
              TOP5=KV(1:5,:)/1e7; % escalamiento de d^2
              ITOP5=IKV(1:5,:);
              IOTOP5=IO_TODOS(ITOP5);
              
              for pixel_perfil=1:PIXELESPORPERFIL
              suma_pros=0;
              suma_fondo=0;  
                 for toppixel=1:5
                  	if (IOTOP5(toppixel, pixel_perfil)==1)
                        suma_pros= suma_pros + exp(-TOP5(toppixel, pixel_perfil));
                 		else
                   	    suma_fondo= suma_fondo + exp(-TOP5(toppixel, pixel_perfil));
                		end
                 end
                 if suma_pros>suma_fondo
                 		IN_OUT(pixel_perfil)=1;
                 else
                 		IN_OUT(pixel_perfil)=0;
                 end
              end
                                       
             
             
             
             
             