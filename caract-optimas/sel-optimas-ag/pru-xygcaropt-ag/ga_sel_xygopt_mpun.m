% ga_sel_xygopt_mpunto.m
% version para encontrar las car opts incluidas x,y,g. Para cada punto del
% PDM. Ademas con los archivos de entrenamiento correctos sirva para cada
% resolucion
% ag para hacer la seleccion de caracteristicas optimas de la 60 originales
% de la prostata
% sga
% This script implements the Simple Genetic Algorithm described
% in the examples section of the GA Toolbox manual.
% Author:     Andrew Chipperfield
% History:    23-Mar-94     file created


clear
NoPM=35;

%************************************************************************
% lectura de las muestras de entrenamiento para el clasificador KNN, K=5
%************************************************************************
% NOMENTRE=[ %'an-u3-14-01-al.con';
% 'an-u3-14-02-al.con';
% %'an-u3-14-03-al.con';
% 'an-u3-14-04-al.con';
% %'an-u3-14-05-al.con';
% %'an-u3-14-06-al.con';
% %'an-u3-15-02-al.con';
% 'an-u3-15-03-al.con';
% %'an-u3-15-04-al.con';
% 'an-u3-15-05-al.con';
% %'an-u3-15-06-al.con';
% 'an-u3-16-03-al.con';
% %'an-u3-16-04-al.con';
% 'an-u3-16-05-al.con';
% %'an-u3-16-06-al.con';
% %'an-u3-16-07-al.con';
% %'an-u3-17-00-al.con';
% 'an-u3-17-05-al.con';
% %'an-u3-18-00-al.con';
% %'an-u3-18-01-al.con';
% 'an-u3-18-02-al.con';
% 'an-u3-18-03-al.con';
% 'an-u3-18-04-al.con';
% %'an-u3-18-05-al.con';
% ];

NOMENTRE=[ 
 'an-u3-15-02_r5.txt';
 'an-u3-15-03_r5.txt';
%'an-u3-18-04-al.con';
% 'an-u3-15-03-al.con';
% 'an-u3-16-03-al.con';
% 'an-u3-15-05-al.con';
% 'an-u3-16-05-al.con';
% 'an-u3-17-05-al.con';
% 'an-u3-14-04-al.con';
];
[renentre, colentre]=size(NOMENTRE);
renval=ceil(renentre/2); % separamos (renentre-renval) archivos para enterenamiento y (renval) archivos para validacion
rentotal=renentre;
%figure
%axis equal
%hold on
for imagen=1:renentre % repetimos el ciclo para todos los archivos
   name=NOMENTRE(imagen,:);
   imaname=name(4:14);
   name=strcat('v5x5_xyg_60car_binv', imaname, '.txt');
   fid=fopen(name, 'r');
	for j=1:35
		L=fscanf(fid, '%c',20);
		LN=fscanf(fid, '%d\n',1);
			for i=1:25
				P=fscanf(fid, '%c',6);
				PN=fscanf(fid, '%d\n',1);
				P=fscanf(fid, '%c\n',24);
				IO((j-1)*25+i, imagen)=fscanf(fid, '%d\n',1);
				CAR=fscanf(fid, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f \n', 63);
				MUE_ENTRE((j-1)*25+i,:, imagen)=CAR';
			end
	end
	fclose(fid);
end % for imagen=1:renentre
[muestrasporima,no_cars, no_imas]=size(MUE_ENTRE);
pixporventana=muestrasporima/NoPM;
%keyboard

%****************************************************************************
%***********  ALGORITMO GENETICO PA' SELECCION OPTIMA *******************

NIND = 50;           % Number of individuals per subpopulations
MAXGEN =15;        % maximum Number of generations
GGAP = .9;           % Generation gap, how many new individuals are created
NVAR = 63;           % 60 bits on/off indican si la xi correspondiente sera evaluada



% CALCULO DE CAR. OPTS PA'CADA UNO DE LOS 35 PUNTOS DEL PDM. SE SALVAN LAS
% CAROPTS Y LOS VALORES OPTIMOS DE FOBJ
indice_entre=1;
for punto=1:NoPM
    MUE_ENTRE_PUNTO=MUE_ENTRE(indice_entre:punto*pixporventana,:,:);
    indice_entre=indice_entre+pixporventana; % pa 25 pixeles por punto del PDM
% Initialise population
   Chrom = crtbp(NIND, NVAR);

% Reset counters
   Best = NaN*ones(MAXGEN,1);	% best in current population
   gen = 0;			% generational counter

% Evaluate initial population
   ObjV = error_knn_optimas(MUE_ENTRE_PUNTO, renval, rentotal, IO, Chrom);

% Track best individual and display convergence
   Best(gen+1) = min(ObjV)
   plot(log10(Best),'ro');xlabel('generation'); ylabel('log10(f(x))');
   text(0.5,0.95,['Best = ', num2str(Best(gen+1))],'Units','normalized');   
   drawnow;        


% Generational loop
   while gen < MAXGEN,

    % Assign fitness-value to entire population
       FitnV = ranking(ObjV);

    % Select individuals for breeding
       SelCh = select('sus', Chrom, FitnV, GGAP);

    % Recombine selected individuals (crossover)
       SelCh = recombin('xovsp',SelCh,0.7);

    % Perform mutation on offspring
       SelCh = mut(SelCh);

    % Evaluate offspring, call objective function
       ObjVSel = error_knn_optimas(MUE_ENTRE_PUNTO, renval, rentotal, IO, SelCh);

    % Reinsert offspring into current population
       [Chrom ObjV]=reins(Chrom,SelCh,1,1,ObjV,ObjVSel);

    % Increment generational counter
       gen = gen+1;

    % Update display and record current best individual
       Best(gen+1) = min(ObjV)
       plot(log10(Best),'ro'); xlabel('generation'); ylabel('log10(f(x))');
       text(0.5,0.95,['Best = ', num2str(Best(gen+1))],'Units','normalized');
       drawnow;
       %keyboard
   end 
% End of GA

%  save 'mejor_pob_1804.txt' Chrom -ASCII
%  save 'mejores_fobj_1804.txt' ObjV -ASCII

namepob=strcat('mejor_pob_p',int2str(punto),'_' ,imaname, '.txt');
fid=fopen(namepob, 'w');
fprintf(fid, '%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d \n', Chrom');
fclose(fid)

nameobj=strcat('mejor_fobj_p',int2str(punto),'_' ,imaname, '.txt');
fid=fopen(nameobj, 'w');
fprintf(fid, '%d\n', ObjV');
fclose(fid)
end % for punto