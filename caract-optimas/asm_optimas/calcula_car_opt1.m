% calcula_car_opt1.m
% esta funcion regresa el vector de caracteristicas optimas coorrespondientes a un punto en la imagen
% los parametros de entrada M* son matrices de [alto x ancho x escala] con la deriva N a una escala de la imagen
% las coordenadas del punto en la imagen son X+dx, Y+dy
% vectorop es el vector con P caractersiticas optimas
% CAROPTPUNTO: vector con los indices de las car optimas para cada punto del PDM
function vectoropt=calcula_car_opt1(MGI, MDxGI, MDyGI, MDxxGI, MDyyGI, MDxyGI, dx, dy , X, Y, CAROPTPUNTO)
sigma0=0.5; %escala interna mas peque?a
vectoropt=0;
% Precalculo de constantes
escala1=1;
alfa1=2*sigma0;
espaciamiento1=2^(escala1-1);
x01=X+dx*espaciamiento1;
y01=Y+dy*espaciamiento1;
%******************
escala2=2;
alfa2=4*sigma0;
espaciamiento2=2^(escala2-1);
x02=X+dx*espaciamiento2;% (x0, y0) origen de la gaussiana de apertura
y02=Y+dy*espaciamiento2;
%******************
escala3=3;
alfa3=8*sigma0;
espaciamiento3=2^(escala3-1);
x03=X+dx*espaciamiento3;% (x0, y0) origen de la gaussiana de apertura
y03=Y+dy*espaciamiento3;
%******************
escala4=4;
alfa4=16*sigma0;
espaciamiento4=2^(escala4-1);
x04=X+dx*espaciamiento4;% (x0, y0) origen de la gaussiana de apertura
y04=Y+dy*espaciamiento4;
%******************
escala5=5;
alfa5=32*sigma0;
espaciamiento5=2^(escala5-1);
x05=X+dx*espaciamiento5;% (x0, y0) origen de la gaussiana de apertura
y05=Y+dy*espaciamiento5;


for car=1:length(CAROPTPUNTO)
   					switch CAROPTPUNTO(car)
   						case 1
       					%escala=1;  
       					%alfa=2*sigma0;
       					%espaciamiento=2^(escala-1);
    						A=MGI(:,:,escala1);
      						%x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
       					vectoropt(car)=calcula_M(x01,y01, A, alfa1,  1);
                  	    
   						case 2
       					%escala=1;  
       					%alfa=2*sigma0;
       					%espaciamiento=2^(escala-1);
   	    					A=MGI(:,:,escala1);
       					%x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
       					vectoropt(car)=calcula_M(x01,y01, A, alfa1, 2);
                       
   						case 3
       					%escala=1;
       					%alfa=2*sigma0;
       					%espaciamiento=2^(escala-1);
       					%x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
       					%*******************        
       					% momentos de Dx 
       					%*******************
       					A=MDxGI(:,:,escala1);
       					vectoropt(car)=calcula_M(x01,y01, A, alfa1,  1);
                  	    
   						case 4
       					%escala=1;
       					%alfa=2*sigma0;
       					%espaciamiento=2^(escala-1);
       					%x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
       					%*******************        
       					% momentos de Dx 
       					%*******************
       					A=MDxGI(:,:,escala1);
       					vectoropt(car)=calcula_M(x01,y01, A, alfa1, 2);
                        
   						case 5                                                                  
       					%escala=1;
       					%alfa=2*sigma0;
       					%espaciamiento=2^(escala-1);
       					%x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
      						%*******************        
      						% momentos de Dy 
      						%*******************
      						A=MDyGI(:,:,escala1);
      						vectoropt(car)=calcula_M(x01,y01, A, alfa1,  1);
                  	 
   						case 6
      						%escala=1;
      						%alfa=2*sigma0;
      						%espaciamiento=2^(escala-1);
      						%x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
       					A=MDyGI(:,:,escala1);
       					vectoropt(car)=calcula_M(x01,y01, A, alfa1, 2);
                     
                    
  						case 7
      						%escala=1;
      						%alfa=2*sigma0;
      						%espaciamiento=2^(escala-1);
      						%x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
      						%*******************        
       					% momentos de Dxx 
                        %*******************
                        A=MDxxGI(:,:,escala1);
                        vectoropt(car)=calcula_M(x01,y01, A, alfa1,  1);
                  	    
                        
                    case 8
                        %escala=1;
                        %alfa=2*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de Dxx 
                        %*******************
                        A=MDxxGI(:,:,escala1);
                        vectoropt(car)=calcula_M(x01,y01, A, alfa1, 2);
                        
                    case 9
                        %escala=1;
                        %alfa=2*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de Dyy 
                        %*******************
                        A=MDyyGI(:,:,escala1);
                        vectoropt(car)=calcula_M(x01,y01, A, alfa1,  1);
                  	   
                        
                        
                    case 10
                        %escala=1;
                        %alfa=2*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de Dyy 
                        %*******************
                        A=MDyyGI(:,:,escala1);
                        vectoropt(car)=calcula_M(x01,y01, A, alfa1, 2);
                        
                        
                    case 11
                        %escala=1;
                        %alfa=2*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de Dxy 
                        %*******************
                        A=MDxyGI(:,:,escala1);
                        vectoropt(car)=calcula_M(x01,y01, A, alfa1,  1);
                  	     
                    case 12
                        %escala=1;
                        %alfa=2*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de Dxy 
                        %*******************
                        A=MDxyGI(:,:,escala1);
                        vectoropt(car)=calcula_M(x01,y01, A, alfa1, 2);
                       
                        
                    case 13
                        %escala=2;
                        %alfa=4*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MGI(:,:,escala2);
                        vectoropt(car)=calcula_M(x02,y02, A, alfa2,  1);
                        
                        
                        
                    case 14
                        %escala=2;
                        %alfa=4*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MGI(:,:,escala2);
                        vectoropt(car)=calcula_M(x02,y02, A, alfa2,  2);
                        
                        
                        
                        
                    case 15
                        %escala=2;
                        %alfa=4*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxGI(:,:,escala2);
                        vectoropt(car)=calcula_M(x02,y02, A, alfa2,  1);
                        
                                                                                                
                    case 16
                        %escala=2;
                        %alfa=4*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxGI(:,:,escala2);
                        vectoropt(car)=calcula_M(x02,y02, A, alfa2,  2);
                        
                        
                    case 17
                        %escala=2;
                        %alfa=4*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDyGI(:,:,escala2);
                        vectoropt(car)=calcula_M(x02,y02, A, alfa2,  1);
                        
                        
                        
                        
                    case 18
                        %escala=2;
                        %alfa=4*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDyGI(:,:,escala2);
                        vectoropt(car)=calcula_M(x02,y02, A, alfa2,  2);
                        
                        
                    case 19
                        %escala=2;
                        %alfa=4*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxxGI(:,:,escala2);
                        vectoropt(car)=calcula_M(x02,y02, A, alfa2, 1);
                        
                        
                        
                        
                    case 22
                        %escala=2;
                        %alfa=4*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxxGI(:,:,escala2);
                        vectoropt(car)=calcula_M(x02,y02, A, alfa2,  2);
                        
                        
                        
                    case 23
                        %escala=2;
                        %alfa=4*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxyGI(:,:,escala2);
                        vectoropt(car)=calcula_M(x02,y02, A, alfa2, 1);
                        
                        
                    case 24
                        %escala=2;
                        %alfa=4*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxyGI(:,:,escala2);
                        vectoropt(car)=calcula_M(x02,y02, A, alfa2,  2);
                        
                        
                    case 25
                        %escala=3;
                        %alfa=8*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MGI(:,:,escala3);
                        vectoropt(car)=calcula_M(x03,y03, A, alfa3,  1);
                        
                        
                        
                    case 26
                        %escala=3;
                        %alfa=8*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MGI(:,:,escala3);
                        vectoropt(car)=calcula_M(x03,y03, A, alfa3,  2);
                        
                    case 27
                        %escala=3;
                        %alfa=8*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxGI(:,:,escala3);
                        vectoropt(car)=calcula_M(x03,y03, A, alfa3,  1);
                        
                    case 28
                        %escala=3;
                        %alfa=8*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxGI(:,:,escala3);
                        vectoropt(car)=calcula_M(x03,y03, A, alfa3,  2);
                        
                    case 29
                        %escala=3;
                        %alfa=8*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDyGI(:,:,escala3);
                        vectoropt(car)=calcula_M(x03,y03, A, alfa3, 1);
                        
                        
                        
                    case 30
                        %escala=3;
                        %alfa=8*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDyGI(:,:,escala3);
                        vectoropt(car)=calcula_M(x03,y03, A, alfa3,  2);
                        
                    case 36
                        %escala=3;
                        %alfa=8*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxyGI(:,:,escala3);
                        vectoropt(car)=calcula_M(x03,y03, A, alfa3,  2);
                        
                    case 37
                        %escala=4;
                        %alfa=16*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MGI(:,:,escala4);
                        vectoropt(car)=calcula_M(x04,y04, A, alfa4, 1);
                        
                    case 38
                        %escala=4;
                        %alfa=16*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MGI(:,:,escala4);
                        vectoropt(car)=calcula_M(x04,y04, A, alfa4, 2);
                        
                        
                    case 40
                        %escala=4;
                        %alfa=16*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxGI(:,:,escala4);
                        vectoropt(car)=calcula_M(x04,y04, A, alfa4, 2);
                        
                    case 48
                        %escala=4;
                        %alfa=16*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxyGI(:,:,escala4);
                        vectoropt(car)=calcula_M(x04,y04, A, alfa4, 2);
                        
                    case 49
                        %escala=5;
                        %alfa=32*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MGI(:,:,escala5);
                        vectoropt(car)=calcula_M(x05,y05, A, alfa5, 1);
                        
                    case 50
                        %escala=5;
                        %alfa=32*sigma0;
                        %espaciamiento=2^(escala-1);
                        %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							%y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MGI(:,:,escala5);
                        vectoropt(car)=calcula_M(x05,y05, A, alfa5, 2);
                    otherwise
                        'caracteristica no implementada'
                        break
                    end %switch
end %for car=1:legth(CAROPTPUNTO)