% calcula_car_opt2.m
% esta funcion regresa el vector de caracteristicas optimas coorrespondientes a un punto en la imagen
% los parametros de entrada M* son matrices de [alto x ancho x escala] con la deriva N a una escala de la imagen
% las coordenadas del punto en la imagen son X+dx, Y+dy
% vectorop es el vector con P caractersiticas optimas
% CAROPTPUNTO: vector con los indices de las car optimas para cada punto del PDM
function VECTOROPT=calcula_car_opt3(MGI, MDxGI, MDyGI, MDxxGI, MDyyGI, MDxyGI, CAROPTPUNTO, DX, DY, x, y);
sigma0=0.5; %escala interna mas peque?a
vectoropt=0;
[renp, colp]=size(DX); %numero de pixeles en cada perfil
X=repmat(x, [renp, 1]);
Y=repmat(y, [renp, 1]);
% Precalculo de constantes
% constantes de calcula_M1
beta=5; % ancho del bin del histograma
dos_beta_cuad=2*beta^2;
%***********************************
% constantes para las 5 escalas diferentes
escala1=1;
alfa1=2*sigma0;
espaciamiento1=2^(escala1-1);
X01=X+DX*espaciamiento1;
Y01=Y+DY*espaciamiento1;
dos_alfa_cuad1=2*alfa1^2;
inv_2pi_alfa_cuad1=1/(2*pi*alfa1^2);

%******************
escala2=2;
alfa2=4*sigma0;
espaciamiento2=2^(escala2-1);
X02=X+DX*espaciamiento2;% (x0, y0) origen de la gaussiana de apertura
Y02=Y+DY*espaciamiento2;
dos_alfa_cuad2=2*alfa2^2;
inv_2pi_alfa_cuad2=1/(2*pi*alfa2^2);

%******************
escala3=3;
alfa3=8*sigma0;
espaciamiento3=2^(escala3-1);
X03=X+DX*espaciamiento3;% (x0, y0) origen de la gaussiana de apertura
Y03=Y+DY*espaciamiento3;
dos_alfa_cuad3=2*alfa3^2;
inv_2pi_alfa_cuad3=1/(2*pi*alfa3^2);


%******************
escala4=4;
alfa4=16*sigma0;
espaciamiento4=2^(escala4-1);
X04=X+DX*espaciamiento4;% (x0, y0) origen de la gaussiana de apertura
Y04=Y+DY*espaciamiento4;
dos_alfa_cuad4=2*alfa4^2;
inv_2pi_alfa_cuad4=1/(2*pi*alfa4^2);

%******************
escala5=5;
alfa5=32*sigma0;
espaciamiento5=2^(escala5-1);
X05=X+DX*espaciamiento5;% (x0, y0) origen de la gaussiana de apertura
Y05=Y+DY*espaciamiento5;
dos_alfa_cuad5=2*alfa5^2;
inv_2pi_alfa_cuad5=1/(2*pi*alfa5^2);


for pperfil=1:renp
% calculo de constantes para cada punto del perfil de pixeles y para cada escala  
%*******************************************
% escala 1
X1=round(X01(pperfil)-3*sqrt(alfa1)): round(X01(pperfil)+3*sqrt(alfa1));
Y1=round(Y01(pperfil)-3*sqrt(alfa1)): round(Y01(pperfil)+3*sqrt(alfa1));
[renX colX]=size(X1);
colY=colX;
X_X0_2_1=(X1-X01(pperfil)).^2;
Y_Y0_2_1=(Y1-Y01(pperfil)).^2;

for i=1:colX
   for j=1: colY
      EXP1_1(i,j)= exp(-(X_X0_2_1(i)+Y_Y0_2_1(j))/dos_alfa_cuad1); 
   end
end

%********************************************
% escala 2
X2=round(X02(pperfil)-3*sqrt(alfa2)): round(X02(pperfil)+3*sqrt(alfa2));
Y2=round(Y02(pperfil)-3*sqrt(alfa2)): round(Y02(pperfil)+3*sqrt(alfa2));
[renX colX]=size(X2);
[renY colY]=size(Y2);
X_X0_2_2=(X2-X02(pperfil)).^2;
Y_Y0_2_2=(Y2-Y02(pperfil)).^2;

for i=1:colX
   for j=1: colY
      EXP1_2(i,j)= exp(-(X_X0_2_2(i)+Y_Y0_2_2(j))/dos_alfa_cuad2); 
   end
end
%********************************************
 
 
% escala 3
X3=round(X03(pperfil)-3*sqrt(alfa3)): round(X03(pperfil)+3*sqrt(alfa3));
Y3=round(Y03(pperfil)-3*sqrt(alfa3)): round(Y03(pperfil)+3*sqrt(alfa3));
[renX colX]=size(X3);
[renY colY]=size(Y3);
X_X0_2_3=(X3-X03(pperfil)).^2;
Y_Y0_2_3=(Y3-Y03(pperfil)).^2;

for i=1:colX
   for j=1: colY
      EXP1_3(i,j)= exp(-(X_X0_2_3(i)+Y_Y0_2_3(j))/dos_alfa_cuad3); 
   end
end
%********************************************
% escala 4
X4=round(X04(pperfil)-3*sqrt(alfa4)): round(X04(pperfil)+3*sqrt(alfa4));
Y4=round(Y04(pperfil)-3*sqrt(alfa4)): round(Y04(pperfil)+3*sqrt(alfa4));
[renX colX]=size(X4);
[renY colY]=size(Y4);
X_X0_2_4=(X4-X04(pperfil)).^2;
Y_Y0_2_4=(Y4-Y04(pperfil)).^2;

for i=1:colX
   for j=1: colY
      EXP1_4(i,j)= exp(-(X_X0_2_4(i)+Y_Y0_2_4(j))/dos_alfa_cuad4); 
   end
end
%********************************************
% escala 5
X5=round(X05(pperfil)-3*sqrt(alfa5)): round(X05(pperfil)+3*sqrt(alfa5));
Y5=round(Y05(pperfil)-3*sqrt(alfa5)): round(Y05(pperfil)+3*sqrt(alfa5));
[renX colX]=size(X5);
[renY colY]=size(Y5);
X_X0_2_5=(X5-X05(pperfil)).^2;
Y_Y0_2_5=(Y5-Y05(pperfil)).^2;

for i=1:colX
   for j=1: colY
      EXP1_5(i,j)= exp(-(X_X0_2_5(i)+Y_Y0_2_5(j))/dos_alfa_cuad5); 
   end
end
%********************************************
 
 
for car=1:length(CAROPTPUNTO)
   		switch CAROPTPUNTO(car)
   			case 1
       		%escala=1;  
       		%alfa=2*sigma0;
       		%espaciamiento=2^(escala-1);
    			A=MGI(:,:,escala1);
      			%x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
				%y0=Y+dy*espaciamiento;
            	%'antes de llamar calcula_M1'
            	%keyboard	            
            	VECTOROPT(pperfil, car)=calcula_M1(X1, Y1, A, 1, inv_2pi_alfa_cuad1, EXP1_1);
				%'fuera de calcula_M1'             
              %keyboard    	    
   			case 2
       		%escala=1;  
       		%alfa=2*sigma0;
       		%espaciamiento=2^(escala-1);
   	    		A=MGI(:,:,escala1);
       		%x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
				%y0=Y+dy*espaciamiento;
       		VECTOROPT(pperfil, car)=calcula_M1(X1, Y1, A, 2, inv_2pi_alfa_cuad1, EXP1_1);

                       
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
       		VECTOROPT(pperfil, car)=calcula_M1(X1, Y1, A, 1, inv_2pi_alfa_cuad1, EXP1_1);

                  	    
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
       		VECTOROPT(pperfil, car)=calcula_M1(X1, Y1, A, 2, inv_2pi_alfa_cuad1, EXP1_1);

                        
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
      			VECTOROPT(pperfil, car)=calcula_M1(X1, Y1, A, 1, inv_2pi_alfa_cuad1, EXP1_1);

                  	 
   			case 6
      			%escala=1;
      			%alfa=2*sigma0;
      			%espaciamiento=2^(escala-1);
      			%x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
				%y0=Y+dy*espaciamiento;
       		A=MDyGI(:,:,escala1);
       		VECTOROPT(pperfil, car)=calcula_M1(X1, Y1, A, 2, inv_2pi_alfa_cuad1, EXP1_1);

                     
                    
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
              VECTOROPT(pperfil, car)=calcula_M1(X1, Y1, A, 1, inv_2pi_alfa_cuad1, EXP1_1);

                  	    
                        
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
              VECTOROPT(pperfil, car)=calcula_M1(X1, Y1, A, 2, inv_2pi_alfa_cuad1, EXP1_1);

                        
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
              VECTOROPT(pperfil, car)=calcula_M1(X1, Y1, A, 1, inv_2pi_alfa_cuad1, EXP1_1);

                  	   
                        
                        
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
              VECTOROPT(pperfil, car)=calcula_M1(X1, Y1, A, 2, inv_2pi_alfa_cuad1, EXP1_1);

                        
                        
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
              VECTOROPT(pperfil, car)=calcula_M1(X1, Y1, A, 1, inv_2pi_alfa_cuad1, EXP1_1);

                  	     
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
               VECTOROPT(pperfil, car)=calcula_M1(X1, Y1, A, 2, inv_2pi_alfa_cuad1, EXP1_1);

                       
                        
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
              VECTOROPT(pperfil, car)=calcula_M1(X2, Y2, A, 1, inv_2pi_alfa_cuad2, EXP1_2);
                        
                        
                        
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
              %'caso 14'
              %keyboard
              VECTOROPT(pperfil, car)=calcula_M1(X2, Y2, A, 2, inv_2pi_alfa_cuad2, EXP1_2);

                        
                        
                        
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
              VECTOROPT(pperfil, car)=calcula_M1(X2, Y2, A, 1, inv_2pi_alfa_cuad2, EXP1_2);

                        
                                                                                                
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
              VECTOROPT(pperfil, car)=calcula_M1(X2, Y2, A, 2, inv_2pi_alfa_cuad2, EXP1_2);

                        
                        
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
              VECTOROPT(pperfil, car)=calcula_M1(X2, Y2, A, 1, inv_2pi_alfa_cuad2, EXP1_2);

                        
                        
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
             VECTOROPT(pperfil, car)=calcula_M1(X2, Y2, A, 2, inv_2pi_alfa_cuad2, EXP1_2);

                        
                        
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
            VECTOROPT(pperfil, car)=calcula_M1(X2, Y2, A, 1, inv_2pi_alfa_cuad2, EXP1_2);

                        
                        
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
          VECTOROPT(pperfil, car)=calcula_M1(X2, Y2, A, 2, inv_2pi_alfa_cuad2, EXP1_2);

                        
                        
                        
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
          VECTOROPT(pperfil, car)=calcula_M1(X2, Y2, A, 1, inv_2pi_alfa_cuad2, EXP1_2);

                        
                        
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
          VECTOROPT(pperfil, car)=calcula_M1(X2, Y2, A, 2, inv_2pi_alfa_cuad2, EXP1_2);

                        
                        
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
          VECTOROPT(pperfil, car)=calcula_M1(X3, Y3, A, 1, inv_2pi_alfa_cuad3, EXP1_3);
                        
                        
                        
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
          VECTOROPT(pperfil, car)=calcula_M1(X3, Y3, A, 2, inv_2pi_alfa_cuad3, EXP1_3);

                        
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
          VECTOROPT(pperfil, car)=calcula_M1(X3, Y3, A, 1, inv_2pi_alfa_cuad3, EXP1_3);
                        
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
        VECTOROPT(pperfil, car)=calcula_M1(X3, Y3, A, 2, inv_2pi_alfa_cuad3, EXP1_3);

                        
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
       VECTOROPT(pperfil, car)=calcula_M1(X3, Y3, A, 1, inv_2pi_alfa_cuad3, EXP1_3);

                        
                        
                        
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
      VECTOROPT(pperfil, car)=calcula_M1(X3, Y3, A, 2, inv_2pi_alfa_cuad3, EXP1_3);

                        
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
     VECTOROPT(pperfil, car)=calcula_M1(X3, Y3, A, 2, inv_2pi_alfa_cuad3, EXP1_3);

                        
 case 37
     %escala=4;
     %alfa=16*sigma0;
     %espaciamiento=2^(escala-1);
     %x0=X+dx*espaciamiento;% (x0, y0) origen de la gaussiana de apertura
	  %y0=Y+dy*espaciamiento;
     %*******************        
     %momentos de GI 
     %*******************
     A=MGI(:,:,escala4);
     VECTOROPT(pperfil, car)=calcula_M1(X4, Y4, A, 1, inv_2pi_alfa_cuad4, EXP1_4);
                        
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
   VECTOROPT(pperfil, car)=calcula_M1(X4, Y4, A, 2, inv_2pi_alfa_cuad4, EXP1_4);

                        
   
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
   VECTOROPT(pperfil, car)=calcula_M1(X4, Y4, A, 2, inv_2pi_alfa_cuad4, EXP1_4);

   
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
   VECTOROPT(pperfil, car)=calcula_M1(X4, Y4, A, 2, inv_2pi_alfa_cuad4, EXP1_4);

                        
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
   VECTOROPT(pperfil, car)=calcula_M1(X5, Y5, A, 1, inv_2pi_alfa_cuad5, EXP1_5);
   
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
   %'caso 50'
   %keyboard
  
   VECTOROPT(pperfil, car)=calcula_M1(X5, Y5, A, 2, inv_2pi_alfa_cuad5, EXP1_5);

   
otherwise
   
   'caracteristica no implementada'
   
   break
   
end %switch

end %for car=1:legth(CAROPTPUNTO)

end
              