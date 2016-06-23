% calcula_car_opt.m
% esta funcion regresa el vector de caracteristicas optimas coorrespondientes a un punto en la imagen
% los parametros de entrada M* son matrices de [alto x ancho x escala] con la deriva N a una escala de la imagen
% las coordenadas del punto en la imagen son X+dx, Y+dy
% vectorop es el vector con P caractersiticas optimas
% CAROPTPUNTO: vector con los indices de las car optimas para cada punto del PDM
function vectoropt=calcula_car_opt(MGI, MDxGI, MDyGI, MDxxGI, MDyyGI, MDxyGI, dx, dy , X, Y, CAROPTPUNTO)
sigma0=0.5; %escala interna mas pequeña
vectoropt=0;
for car=1:length(CAROPTPUNTO)
   					switch CAROPTPUNTO(car)
   						case 1
       					escala=1;  
       					alfa=2*sigma0;
       					espaciamiento=2^(escala-1);
    						A=MGI(:,:,escala);
      						x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
       					vectoropt(car)=calcula_M(x0,y0, A, alfa,  1);
                  	    
   						case 2
       					escala=1;  
       					alfa=2*sigma0;
       					espaciamiento=2^(escala-1);
   	    					A=MGI(:,:,escala);
       					x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
       					vectoropt(car)=calcula_M(x0,y0, A, alfa, 2);
                       
   						case 3
       					escala=1;
       					alfa=2*sigma0;
       					espaciamiento=2^(escala-1);
       					x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
       					%*******************        
       					% momentos de Dx 
       					%*******************
       					A=MDxGI(:,:,escala);
       					vectoropt(car)=calcula_M(x0,y0, A, alfa,  1);
                  	    
   						case 4
       					escala=1;
       					alfa=2*sigma0;
       					espaciamiento=2^(escala-1);
       					x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
       					%*******************        
       					% momentos de Dx 
       					%*******************
       					A=MDxGI(:,:,escala);
       					vectoropt(car)=calcula_M(x0,y0, A, alfa, 2);
                        
   						case 5                                                                  
       					escala=1;
       					alfa=2*sigma0;
       					espaciamiento=2^(escala-1);
       					x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
      						%*******************        
      						% momentos de Dy 
      						%*******************
      						A=MDyGI(:,:,escala);
      						vectoropt(car)=calcula_M(x0,y0, A, alfa,  1);
                  	 
   						case 6
      						escala=1;
      						alfa=2*sigma0;
      						espaciamiento=2^(escala-1);
      						x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
       					A=MDyGI(:,:,escala);
       					vectoropt(car)=calcula_M(x0,y0, A, alfa, 2);
                     
                    
  						case 7
      						escala=1;
      						alfa=2*sigma0;
      						espaciamiento=2^(escala-1);
      						x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
      						%*******************        
       					% momentos de Dxx 
                        %*******************
                        A=MDxxGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  1);
                  	    
                        
                    case 8
                        escala=1;
                        alfa=2*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de Dxx 
                        %*******************
                        A=MDxxGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa, 2);
                        
                    case 9
                        escala=1;
                        alfa=2*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de Dyy 
                        %*******************
                        A=MDyyGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  1);
                  	   
                        
                        
                    case 10
                        escala=1;
                        alfa=2*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de Dyy 
                        %*******************
                        A=MDyyGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa, 2);
                        
                        
                    case 11
                        escala=1;
                        alfa=2*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de Dxy 
                        %*******************
                        A=MDxyGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  1);
                  	     
                    case 12
                        escala=1;
                        alfa=2*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de Dxy 
                        %*******************
                        A=MDxyGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa, 2);
                       
                        
                    case 13
                        escala=2;
                        alfa=4*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  1);
                        
                        
                        
                    case 14
                        escala=2;
                        alfa=4*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  2);
                        
                        
                        
                        
                    case 15
                        escala=2;
                        alfa=4*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  1);
                        
                                                                                                
                    case 16
                        escala=2;
                        alfa=4*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  2);
                        
                        
                    case 17
                        escala=2;
                        alfa=4*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDyGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  1);
                        
                        
                        
                        
                    case 18
                        escala=2;
                        alfa=4*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDyGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  2);
                        
                        
                    case 19
                        escala=2;
                        alfa=4*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxxGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa, 1);
                        
                        
                        
                        
                    case 22
                        escala=2;
                        alfa=4*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxxGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  2);
                        
                        
                        
                    case 23
                        escala=2;
                        alfa=4*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxyGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa, 1);
                        
                        
                    case 24
                        escala=2;
                        alfa=4*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxyGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  2);
                        
                        
                    case 25
                        escala=3;
                        alfa=8*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  1);
                        
                        
                        
                    case 26
                        escala=3;
                        alfa=8*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  2);
                        
                    case 27
                        escala=3;
                        alfa=8*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  1);
                        
                    case 28
                        escala=3;
                        alfa=8*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  2);
                        
                    case 29
                        escala=3;
                        alfa=8*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDyGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa, 1);
                        
                        
                        
                    case 30
                        escala=3;
                        alfa=8*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDyGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  2);
                        
                    case 36
                        escala=3;
                        alfa=8*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxyGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa,  2);
                        
                    case 37
                        escala=4;
                        alfa=16*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa, 1);
                        
                    case 38
                        escala=4;
                        alfa=16*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa, 2);
                        
                        
                    case 40
                        escala=4;
                        alfa=16*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa, 2);
                        
                    case 48
                        escala=4;
                        alfa=16*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MDxyGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa, 2);
                        
                    case 49
                        escala=5;
                        alfa=32*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa, 1);
                        
                    case 50
                        escala=5;
                        alfa=32*sigma0;
                        espaciamiento=2^(escala-1);
                        x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
							y0=Y+dy*espaciamiento;
                        %*******************        
                        % momentos de GI 
                        %*******************
                        A=MGI(:,:,escala);
                        vectoropt(car)=calcula_M(x0,y0, A, alfa, 2);
                    otherwise
                        'caracteristica no implementada'
                        break
                    end %switch
end %for car=1:legth(CAROPTPUNTO)