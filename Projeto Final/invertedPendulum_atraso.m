
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
t = 0:0.001:20;
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

#{
  -Primeiro passo: determinar Kc
  
  Desejamos um erro para rampa de 0.001
  ess = 1/ Kv => Kv = 1000
  Gs =  a / (bs^2 + cs) = a/(s(bs+c)) , onde:
  a = num
  b = den1
  c = den2

  Kv = lim s*Kc*Gc*Gs, para baixas freq Gc = 1
  Kv = lim Kc*sGs
  Kv = Kc lim a/(bs+c) = Kc * a/c
  Kc = Kv * c/a
  Kc = Kv * den2/num
  
#}

ess = 1/1000;
Mp = 5/100;
phase_tol = 8.5;

Kv = 1/ ess;
Kc = Kv * den2/num
K = 2*Kc;

G1 = K*Gs

## - - - - - - Resposta só com ajuste de K - - - - - - 

##Degrau
stepK = step(feedback(G1,1),t);

##Rampa
rampK=ramp(feedback(G1,1),t);

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
mag = 20*log10(mag);

qsi = -log(Mp) / ( sqrt( log(Mp)*log(Mp) + pi^2 ) );
Mf = 100*qsi;
Mf = Mf + phaseAtual+phase_tol - 180;
delta = 0.3
w1 = 0;
##encontra a frequecia na margem de fase desejada
for i=1 :length(phase)
  if phase(i)<= Mf && phase(i) >= Mf-delta
    w1 = w(i)
    p = i
    F = phase(p)
    M = mag(p)
  end
end

##Construindo compensador
T = 1 / (w1/10);
beta = 10^(M/20);
Gc = 1*(T*s +1) / (beta*T*s +1)
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

