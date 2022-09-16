##Limpa todos os dados anteriores
clear -a
close all
clc
## Inicia pacote de controle
pkg load control

s = tf('s');

##constantes
Ke = 0.117;
Ka = 5;
J = 1.88e-6;
b = 2.13e-4;
Ra = 1.8;
La = 4.1e-3;

##funcao de transferencia
G_s = (Ka*Ke)/(s*((Ra+La*s)*(J*s+b)+Ke^2))

##numero de graficos para gerar
graphs = 5;

##vetor de freq em hertz
omega_f = linspace(0.15,160,graphs);
##vetor auxiliar para guardar os valores em rad/s
omega_n = zeros(length(omega_f),1);

##vetor de tempo
t = linspace(0,0.1,1000);

for i=1:length (omega_f)
  
##  converte de hertz pra rad/s
    omega_n(i) = omega_f(i)*2*pi;
##  sinal senoidal
    u = sin(omega_n(i)*t);

##  gera grafico pra cada \omega
    figure
    lsim(G_s,u,t)
    title(strcat("freq: ",num2str(omega_f(i)), " rad/s"))
    
end

figure
bode(G_s)
title('Diagrama de Bode')

figure
nyquist(G_s)
title('Diagrama de Nyquist')