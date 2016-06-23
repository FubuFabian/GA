%f_alin_e2.m
%Funci?n para alineaci?n por minimizaci?n del error cuad. de dos objetos 
%con puntos correspondientes
%Devuelve los valores [ax ay tx ty] de la transformaci?n r?gida  que alinea X2 con X1

function [ax, ay, tx, ty]=f_alin_e2(X1,X2)
[ren col]=size(X1);

XX1=sum(X1(:,1));
XX2=sum(X2(:,1));

YX1=sum(X1(:,2));
YX2=sum(X2(:,2));

Z=X2(:,1)'*X2(:,1)+X2(:,2)'*X2(:,2);
W=ren;

C1=sum(X1(:,1).*X2(:,1)+X1(:,2).*X2(:,2));
C2=sum(X1(:,2).*X2(:,1)-X1(:,1).*X2(:,2));

PARAM=[ XX2 -YX2 W 0; YX2 XX2 0 W; Z 0 XX2 YX2; 0 Z -YX2 XX2];
RES=inv(PARAM)*[XX1; YX1; C1; C2];

ax=RES(1);
ay=RES(2);
tx=RES(3);
ty=RES(4);

