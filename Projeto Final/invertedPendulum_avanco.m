
##
#{
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  Sistemas de Controle II| Projeto Final
  
  Controlador por avanço

  Daniel Macedo Costa Fagundes          RA:11076809
  Gutemberg Cordeiro Borges             RA:11075013
  Marcos Vinícius Fabiano de Oliveira   RA:11067212
    
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#}
##

##Reseta ambiente
clear all;
close all;
clc;

##Carrega pacote de controle
pkg load control;

##Operador Laplace
s = tf('s');
##Vetor de tempo
t = 0:0.001:0.5;
##vetor de frequencias
w = logspace(-2,2,100);
##referencia de rampa
ref = step(1/s,t);

##Constantes do projeto
Ng = 1;
Nm = 1;
Kg = 3.71;
Kt = 7.68e-3;
Km = 7.68e-3;
Rm = 2.6;
Rmp = 0.0063;
Mc = 0.94;
Jm = 3.9e-7;
Beq = 5.4;


##Funcao de transferencia
num = Ng*Nm*Kg*Kt;
den1 = (Rm*Rmp*Mc + (Rm*Ng*Kg*Jm*Kg/Rmp));
den2 = (Rm*Rmp*Beq + (Rm*Ng*Kg^2*Kt*Km/Rmp));
den = s*(den1*s + den2);

Gs = num/den

figure;
margin(Gs);

## Calculo de K
#{
ess = 1% = 0,01 => 1/Kv = 0,01 => Kv = 100

G_c = K_c*alpha*( (1+sT)/(1+alpha*sT) )

K = K_c*alpha

G_c*G_s = ( (1+sT)/(1+alpha*sT) ) * K * G_s

## para o erro estacionário
Kv = lim s->0  s * G_c*G_s = 
= lim s->0 s*K* (num/ s*(den1*s + den2))
= lim s->0 K*((num/ (den1*s + den2))
= K*(num/ den2) =>
100 = K*(num/ den2) 
K = 100 / (num/ den2) = 1486.3 % no min
#}

ess = 1/100;
Mp = 5/100;
phase_tol = 8.5;

Kv = 1/ess;
 
K = 100 / (num/den2); %% pelo menos isso
K = K*1

G1 = K*Gs

## - - - - - - Resposta só com ajuste de K - - - - - - 

##Degrau
figure;
step(feedback(G1,1),t);
stepK = step(feedback(G1,1),t);

##Rampa
figure;
ramp(feedback(G1,1),t);
rampK = ramp(feedback(G1,1),t);

##Bode
figure;
margin(G1);
[mag, phase,wcm, wcp] = margin(G1);
phaseAtual = phase;
grid on;

##Erro estacionario
essK = ref - rampK;


## - - - - - - Resposta com compensador - - - - - - 

[mag, phase, w] = bode(G1);
qsi = -log(Mp) / ( sqrt( log(Mp)*log(Mp) + pi^2 ) );
Mf = 100*qsi;
Mf = Mf - phaseAtual + phase_tol;

alpha = (1-sind(Mf)) / (1+sind(Mf));
alphaB = -20*log10(1/sqrt(alpha));

mag = 20*log10(mag);

##encontra a freq para o ganho alpha
for i=1 :length(mag)
  if mag(i)>= alphaB
    wm = w(i);
  end
end

##Construindo compensador
T = 1 / (wm*sqrt(alpha));
nc = 1*[T 1]
dc = [alpha*T 1]
Gc = tf(nc,dc)
GcG = Gc*G1
figure;
margin(GcG);

##Degrau
stepGcG = step(feedback(GcG,1),t);

##Rampa
rampGcG=ramp(feedback(GcG,1),t);

##Erro estacionario
essGcG = ref - rampGcG;


## - - Plots - -

##Resposta para entrada Degrau
figure;
hold on;
plot(t,stepK,'b', t, stepGcG, 'g');
plot([min(t) max(t)], [1+Mp 1+Mp],'--r');
legend("Sistema ajustado com K","Sistema Compensado", "Sobresinal de 5%", 'location','northeast');
title("Resposta para entrada degrau ");
plot([min(t) max(t)], [1 1],'k');
grid minor on;
hold off;

##Resposta para entrada rampa
figure;
hold on;
plot(t,ref,'--r', t, rampK, 'b', t,rampGcG,'g');
legend("Referencia","Sistema ajustado com K","Sistema Compensado" ,'location','southeast');
title("Resposta para entrada rampa");
grid minor on;
hold off;

##Erro para entrada rampa
figure;
hold on;
plot(t,essK,'b',t,essGcG,'g');
plot([min(t) max(t)], [ess ess],'--r');
legend("Sistema Ajustado","Sistema Compensado", "Maximo desejado", 'location','northeast')
title("Erro para entrada rampa");
grid minor on;
hold off;

