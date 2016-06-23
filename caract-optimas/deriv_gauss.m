%deriv_gauss.m
clear
name=input('nombre de la imagen?');
A=imread(name, 'bmp');
sigma=input('desv. std. de la gaussiana?');
n=4*sigma+1;
H=fspecial('gaussian', n, sigma);
% Dx(H)=-(x/sigma^2)*H
j=1;
for x=-2*sigma:2*sigma
   for i=1:4*sigma+1
     DxH(i,j)=-(x/sigma^2)*H(i,j);   
   end
   j=j+1;
end

figure
imshow(A)

GA=conv2(H,A);
figure
imagesc(GA)

DxGA=conv2(DxH, A);
figure
imagesc(DxGA)

% Dy(H)=-(y/sigma^2)*H
i=1;
for y=-2*sigma:2*sigma
   for j=1:4*sigma+1
     DyH(i,j)=-(y/sigma^2)*H(i,j);   
   end
   i=i+1;
end
DyGA=conv2(DyH, A);
figure
imagesc(DyGA)

%Dxx=(x^2/sigma^4-1/sigma^2)*H
j=1;
for x=-2*sigma:2*sigma
   for i=1:4*sigma+1
     DxxH(i,j)=(x^2/sigma^4-1/sigma^2)*H(i,j);   
   end
   j=j+1;
end

DxxGA=conv2(DxxH, A);
figure
imagesc(DxxGA)


%Dyy=(y^2/sigma^4-1/sigma^2)*H
i=1;
for y=-2*sigma:2*sigma
   for j=1:4*sigma+1
     DyyH(i,j)=(y^2/sigma^4-1/sigma^2)*H(i,j);   
   end
   i=i+1;
end
DyyGA=conv2(DyyH, A);
figure
imagesc(DyyGA)

% (magnitud del gradiente) DxyH=sqrt(DxH^2+DyH^2)
DxyH=sqrt(DxH.*DxH + DyH.*DyH);
DxyGA=conv2(DxyH, A);
figure
imagesc(DxyGA)

