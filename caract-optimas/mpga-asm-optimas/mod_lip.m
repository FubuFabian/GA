% mod_lip.m
% Este guion calcula el módulo LIP del número real R  
% para imagenes de nivel de gris [0 255]
function M=mod_lip(R)
if R>=0
   M=R;
end
if R<0
   M=-256*R/(256-R);
end

