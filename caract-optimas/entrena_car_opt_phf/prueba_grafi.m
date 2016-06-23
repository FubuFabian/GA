

x0=550;
y0=550;
raiz_tres_alfa=500;
for x=round(x0-raiz_tres_alfa):round(x0+raiz_tres_alfa)
    for y=round(y0-raiz_tres_alfa): round(y0+raiz_tres_alfa)
        Z(y,x)=exp(-((x-x0)^2+(y-y0)^2)/150); %esta linea tabula la exp para
       %graficacion
    end            
end 