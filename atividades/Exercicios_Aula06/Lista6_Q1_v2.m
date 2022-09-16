##Sistemas de controle II | Lista Aula 6 Questão 1

##Reseta ambiente
clear all;
close all;
clc;

##Carrega pacote de controle
pkg load control;

##Operador
s = tf('s');

##referencia para entrada ao degrau
ref =1;
##vetor de frequencias
w = logspace(-2,2,100);

##ganho de malha aberta
k = 28.224;

################################################################################
##                      Diagrama de Bode em malha aberta                       #
################################################################################

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
%                   Funcao de transferencia encontrada na mão
%

Gtotal = ( k*(s+1) )/ ( s*(s+4)*(s^2+2.24*s + 7.84))


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
%                       ajustando a FT encontrada
%
##O diagrama fornecido passa em zero db qnd wn = 1, por isso
##vamos determinar o ganho atual em wn =1 e achar 
##o ajuste que garante nosso diagrama de Bode pra 0db em wn=1

[mag, phase, w] = bode(Gtotal, w);
n=1;

while ( w(n)<=1) %% itera até encontrar wn=1
  n=n+1;
end
##Ganho atual em wn=1 [em dB]
ganho_omega1 = 20*log10(mag(n));

##fator que corrigem o ganho para 0dB
ajuste = 10^(ganho_omega1/-20);
%remove o ganho atual
Gtotal=Gtotal/k;
%calibra o ganho para o fator encontrado
k=k*ajuste
%atualiza a FT
Gtotal=Gtotal*k;

%plota diagrama de bode corrigido
figure;
bode(Gtotal)


################################################################################
##                      Diagrama de Bode em malha fechada                      #
################################################################################

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
%                       diagrama com o ganho k inicial
%
k_atual = k;
Gtotal_mf = feedback(Gtotal, 1);
##figure;
##bode(Gtotal_mf);
##title(["K=" num2str(k)]);

[mag, phase, w] = bode(Gtotal_mf, w);
[Mp,i] = max(mag);
pico_ress = 20*log10(Mp);
freq_ress = w(i);
n=1;
while(20*log10(mag(n))>=-3)
n=n+1;
end
banda_pass = w(n);

##Resposta ao degrau
##máximo sobressinal Mss
[y,x] = step(Gtotal_mf);
yp = max(y);
Mss = 100*(yp-ref)/ref;

## Verbose
printf("\nGanho k:\t %0.3f\n", k)
printf("Pico ress:\t %0.3f \n", pico_ress)
printf("Freq ress:\t %0.3f \n", freq_ress)
printf("Banda pass:\t %0.3f \n", banda_pass)
printf("Sobressinal:\t %0.2f%%\n", Mss)
printf("- - - - - - - - - - \n")

##Graficos de saída
figure;
%resposta ao degrau
step(Gtotal_mf);
hold on;
%referência do degrau
plot([0 20],[ref ref], '--r', 'linewidth',0.5);
%pico sobressinal
plot([0 20],[yp yp], '--b', 'linewidth',0.5);
%titulo de acordo com K
title(["K=" num2str(k_atual)]);

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
%                       diagrama com ganho k de 22
%
k_atual=22;

Gtotal_mf = feedback(Gtotal*(k_atual/k), 1);
##figure;
##bode(Gtotal_mf);
##title(["K=" num2str(k_atual)]);

[mag, phase, w] = bode(Gtotal_mf, w);
[Mp,i] = max(mag);
pico_ress = 20*log10(Mp);
freq_ress = w(i);
n=1;
while(20*log10(mag(n))>=-3)
n=n+1;
end
banda_pass = w(n);

##Resposta ao degrau
##máximo sobressinal Mss
[y,x] = step(Gtotal_mf);
yp = max(y);
Mss = 100*(yp-ref)/ref;

## Verbose
printf("\nGanho k:\t %0.3f\n", k_atual)
printf("Pico ress:\t %0.3f \n", pico_ress)
printf("Freq ress:\t %0.3f \n", freq_ress)
printf("Banda pass:\t %0.3f \n", banda_pass)
printf("Sobressinal:\t %0.2f%%\n", Mss)
printf("- - - - - - - - - - \n")

##Graficos de saída
figure;
%resposta ao degrau
step(Gtotal_mf);
hold on;
%referência do degrau
plot([0 20],[ref ref], '--r', 'linewidth',0.5);
%pico sobressinal
plot([0 20],[yp yp], '--b', 'linewidth',0.5);
%titulo de acordo com K
title(["K=" num2str(k_atual)]);


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
%                       diagrama com ganho k de 25
%
k_atual=25;

Gtotal_mf = feedback(Gtotal*(k_atual/k), 1);
##figure;
##bode(Gtotal_mf);
##title(["K=" num2str(k_atual)]);

[mag, phase, w] = bode(Gtotal_mf, w);
[Mp,i] = max(mag);
pico_ress = 20*log10(Mp);
freq_ress = w(i);
n=1;
while(20*log10(mag(n))>=-3)
n=n+1;
end
banda_pass = w(n);

##Resposta ao degrau
##máximo sobressinal Mss
[y,x] = step(Gtotal_mf);
yp = max(y);
Mss = 100*(yp-ref)/ref;

## Verbose
printf("\nGanho k:\t %0.3f\n", k_atual)
printf("Pico ress:\t %0.3f \n", pico_ress)
printf("Freq ress:\t %0.3f \n", freq_ress)
printf("Banda pass:\t %0.3f \n", banda_pass)
printf("Sobressinal:\t %0.2f%%\n", Mss)
printf("- - - - - - - - - - \n")

##Graficos de saída
figure;
%resposta ao degrau
step(Gtotal_mf);
hold on;
%referência do degrau
plot([0 20],[ref ref], '--r', 'linewidth',0.5);
%pico sobressinal
plot([0 20],[yp yp], '--b', 'linewidth',0.5);
%titulo de acordo com K
title(["K=" num2str(k_atual)]);







