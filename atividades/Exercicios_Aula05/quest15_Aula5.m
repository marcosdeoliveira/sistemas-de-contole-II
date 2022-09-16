##Limpa todos os dados anteriores
clear -a
close all
clc
## Inicia pacote de controle
pkg load control

s = tf('s');

k=1;

#controlador
K_s = (s+0.1) / (s+0.5);

#planta
P_s = (10)/(s*(s+1));

##funcao de transferencia
G_s = K_s*P_s
figure
##diagrama de Bode
bode(G_s)

## margens de fase e ganho; frequencia de 0dB e -180
[Gm,Pm,Wcp,Wcg]= margin (G_s);
margins =[20*log10(Gm),Pm,Wcg,Wcp] 
figure
##Diagrama de Nyquist
nyquist(G_s);
figure
##carta de Nichols
nichols(G_s);

