%gauss_ima_fft.m
% ESTO SOLO FUNCIONA BIEN CON IMAGENES.TIF. POR ALGUNA RAZON BMP NO JALA!
%clear
name=input('nombre de la imagen?');
A=imread(name, 'bmp');
s=size(A);

H=fspecial('gaussian', s, 2);
TFA=fft2(A);
TFH=fft2(H);
LoGS= TFA.*TFH;
LOGI=fftshift(ifft2(LoGS));
LOGIn=abs(LOGI);
LOGIn=LOGIn-min(min(LOGIn));
LOGIn=255*LOGIn/max(max(LOGIn));
figure
imshow(LOGIn)

