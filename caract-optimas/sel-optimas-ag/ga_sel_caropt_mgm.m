% ga_sel_caropt_mgm.m
% ag para hacer la seleccion de caracteristicas optimas de las 60 originales
% de la prostata utilizando K-medias de entrenamiento
% sga
% This script implements the Simple Genetic Algorithm described
% in the examples section of the GA Toolbox manual.
% Author:     Andrew Chipperfield
% History:    23-Mar-94     file created


clear
NoPM=35;

%************************************************************************
% lectura de las K-MEDIAS de entrenamiento para el clasificador KNN, K=5
%************************************************************************
% ARCHIVOS USADOS PARA CALCULAR LAS 14-MEDIAS
% NOMENTRE=[ 
% 'an-u3-14-03-al.con';
% 'an-u3-18-05-al.con';
% 'an-u3-15-04-al.con';
% 'an-u3-16-04-al.con';
% 'an-u3-17-05-al.con';
% ];


MEDIAS_P=load('medias_optimas_pros.txt');
MEDIAS_F=load('medias_optimas_fondo.txt');
NOMVAL=[ 
% 'an-u3-14-02-al.con';
% 'an-u3-18-05-al.con';
% 'an-u3-15-03-al.con';
% 'an-u3-16-03-al.con';
% 'an-u3-15-05-al.con';
% 'an-u3-16-05-al.con';
% 'an-u3-14-04-al.con';
'an-u3-16-04-al.con';
];
[renval, colval]=size(NOMVAL);

for imagen=1:renval % repetimos el ciclo para todos los archivos
   name=NOMVAL(imagen,:);
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
				MUE_VAL((j-1)*25+i,:, imagen)=CAR';
			end
	end
	fclose(fid);
end % for imagen=1:renval

%keyboard
%****************************************************************************
%***********  ALGORITMO GENETICO PA' SELECCION OPTIMA *******************

NIND = 25;           % Number of individuals per subpopulations
MAXGEN =10;        % maximum Number of generations
GGAP = .9;           % Generation gap, how many new individuals are created
NVAR = 60;           % 60 bits on/off indican si la xi correspondiente sera evaluada


% Initialise population
   Chrom = crtbp(NIND, NVAR);

% Reset counters
   Best = NaN*ones(MAXGEN,1);	% best in current population
   gen = 0;			% generational counter

% Evaluate initial population
   ObjV = error_knn_optimas_mgm(MUE_VAL, MEDIAS_P, MEDIAS_F, Chrom, IO);

% Track best individual and display convergence
   Best(gen+1) = min(ObjV)
   plot(log10(Best),'ro');xlabel('generation'); ylabel('log10(f(x))');
   text(0.5,0.95,['Best = ', num2str(Best(gen+1))],'Units','normalized');   
   drawnow;        


% Generational loop
   while gen < MAXGEN

    % Assign fitness-value to entire population
       FitnV = ranking(ObjV);

    % Select individuals for breeding
       SelCh = select('sus', Chrom, FitnV, GGAP);

    % Recombine selected individuals (crossover)
       SelCh = recombin('xovsp',SelCh,0.7);

    % Perform mutation on offspring
       SelCh = mut(SelCh);

    % Evaluate offspring, call objective function
       ObjVSel = error_knn_optimas_mgm(MUE_VAL, MEDIAS_P, MEDIAS_F, SelCh, IO);

    % Reinsert offspring into current population
       [Chrom ObjV]=reins(Chrom,SelCh,1,1,ObjV,ObjVSel);

    % Increment generational counter
       gen = gen+1

    % Update display and record current best individual
       Best(gen+1) = min(ObjV)
       plot(log10(Best),'ro'); xlabel('generation'); ylabel('log10(f(x))');
       text(0.5,0.95,['Best = ', num2str(Best(gen+1))],'Units','normalized');
       drawnow;
   end 
% End of GA

% save 'mejor_pob_13_medias_1805.txt' Chrom -ASCII
% save 'mejores_fobj_13_medias_1805.txt' ObjV -ASCII