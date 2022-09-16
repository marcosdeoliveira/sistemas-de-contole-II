##Limpa todos os dados anteriores
clear -a
close all
clc
## Inicia pacote de controle
pkg load control

s = tf('s');

k=1;

#controlador
K_s = (k*(s+0.01)*(s+6))/(s*(s+20)*(s+100));

#planta
P_s = (10)/(s^2+10*s+29);

##funcao de transferencia
G_s = K_s*P_s

##diagrama de Bode
bode(G_s)

## margens de fase e ganho; frequencia de 0dB e -180
[Gm,Pm,Wcp,Wcg]= margin (Gs);
margins =[20*log10(Gm),Pm,Wcg,Wcp];  

##Diagrama de Nyquist
nyquist(G_s);

##carta de Nichols
nichols(G_s);

