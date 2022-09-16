##Sistemas de controle II | LAB03: ex 2

##Reseta ambiente
clear all;
close all;
clc;

##Carrega pacote de controle
pkg load control;

##Operador
s = tf('s');

##Funcao do controlador
Ds = (78.5758*(s+436)^2)/((s+132)*(s+8030))

##Funcao da planta
Ps = (1.163*10^8)/(s^3 + 962.5*s^2 + 5.986*10^5*s + 1.16*10^8)

##Funca em malha aberta
Gs = Ds*Ps

##Diagrama de Nyquist para o sistema
nyquist(Gs);

##Analise de marges de fase e ganho
[Gm, Pm, wg, wm] = margin (Gs);
Gm_db = 20*log10(Gm);
printf("margem de Ganho:\t\t\t %f \nmargem de fase:\t\t\t\t %f \n", Gm_db, Pm);

##Fator de amortecimento
qsi = Pm / 100;

##Maximo sobressinal estimado
Mp = e^(-((qsi)/(sqrt(1-qsi^2)))*pi);

##Funcao de transferencia em malha fechada
Gs_mf = feedback(Gs,1)

##Verificadndo resposta ao degrau
figure;
step(Gs_mf);

##Maximo sobressinal experimental
[amp, t] = step(Gs_mf);
Mp_exp = abs(max(amp)-1);

##Transforma em porcentagem
Mp = Mp*100;
Mp_exp = Mp_exp*100;

##Imprime os valores de sobressinal
printf("maximo sobressinal teórico:\t\t %.2f%% \n", Mp);
printf("maximo sobressinal experimental:\t %.2f%%  \n", Mp_exp);

##Calculo do erro de aproximacao
erro = (abs(Mp - Mp_exp) / Mp)*100;
printf("erro de aprox:\t\t\t\t %.2f%%  \n", erro);