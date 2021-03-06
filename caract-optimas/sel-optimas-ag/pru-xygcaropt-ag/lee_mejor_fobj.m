% lee_mejor_pob_fobj.m
% este chiqui programa abre y grafica lso archivos con las fobjs de la
% mejor pob del AG pa'seleccion de CAR. OPTIMAS

imaname1='u3-15-03_r1'
imaname3='u3-15-03_r3'
imaname5='u3-15-03_r5'
Mind1=zeros(35,63);
Mind3=zeros(35, 63);
Mind5=zeros(35, 63);
figure
hold on
for punto=1:35
%resolucion 1
clear ObjV
nameobj=strcat('mejor_fobj_p',int2str(punto),'_' ,imaname1, '.txt');
fid=fopen(nameobj, 'r');
ObjV= fscanf(fid, '%d\n');
fclose(fid)
[minObjV Imin]=min(ObjV);
plot(punto,minObjV,'og')
set(gca, 'xtick', [1:35])

namepob=strcat('mejor_pob_p',int2str(punto),'_' ,imaname1, '.txt');
fid=fopen(namepob, 'r');
Mpob=fscanf(fid, '%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d \n', [50 63]);
fclose(fid)
Mind1(punto,:)=Mpob(Imin,:).*[1:63];

% resolucion 3
clear ObjV
nameobj=strcat('mejor_fobj_p',int2str(punto),'_' ,imaname3, '.txt');
fid=fopen(nameobj, 'r');
ObjV= fscanf(fid, '%d\n');
fclose(fid)
[minObjV Imin]=min(ObjV);
plot(punto,minObjV,'ok')
namepob=strcat('mejor_pob_p',int2str(punto),'_' ,imaname3, '.txt');
fid=fopen(namepob, 'r');
Mpob=fscanf(fid, '%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d \n', [50 63]);
fclose(fid)
Mind3(punto,:)=Mpob(Imin,:).*[1:63];

%resolucion 5
clear ObjV
nameobj=strcat('mejor_fobj_p',int2str(punto),'_' ,imaname5, '.txt');
fid=fopen(nameobj, 'r');
ObjV= fscanf(fid, '%d\n');
fclose(fid)
[minObjV Imin]=min(ObjV);
plot(punto,minObjV,'or')
namepob=strcat('mejor_pob_p',int2str(punto),'_' ,imaname5, '.txt');
fid=fopen(namepob, 'r');
Mpob=fscanf(fid, '%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d \n', [50 63]);
fclose(fid)
Mind5(punto,:)=Mpob(Imin,:).*[1:63];

end
