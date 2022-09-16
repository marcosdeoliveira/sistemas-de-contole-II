
##
#{
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  Sistemas de Controle II| Projeto Final
  
  Controlador por atraso-avanço

  Daniel Macedo Costa Fagundes          RA:11076809
  Gutemberg Cordeiro Borges             RA:11075013
  Marcos Vinícius Fabiano de Oliveira   RA:11067212
  
  Gtotal = Kc * GcAv * GcAt * Gs
  
  Onde:
  GcAv = ( T1*s +1 ) / ( (T1/alpha)*s +1 )
  GcAt = (T2*s + 1) / (alpha*T2*s + 1)
    
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

##Requisitos de projeto
ess = 1/1000;
Mp = 5/100;
tp = 0.1;

phase_tol = 5;

Kv = 1/ ess;
Kc = Kv * den2/num
K = Kc*1;

G1 = K*Gs
#{
  -Precisamos encontrar a margem de fase atual
  e levar o sistema para a desejada, ou próximo o suficiente
  
  A margem de fase atual é a margem para o sistema ajustado com Kc
  A margem desejada deve levar o sistema a 5% de sobressinal
  Para isso vamos encontrar um fator de amortecimento satisfatorio
  e entao determinar a margem de fase necessaria levando em conta
  a margem atual do sistema
#}

#margem de fase atual
[mag, phase,wcm, wcp] = margin(G1);
phaseAtual = phase;

##margem de fase desejada
qsi = -log(Mp) / ( sqrt( log(Mp)*log(Mp) + pi^2 ) );
Mf = 100*qsi
##descontando a margem presente
Mf = Mf - phaseAtual + phase_tol -180

#{
  -Encontra a frequecia na margem de fase desejada
  a partir do Bode do sistema ajustado
#}
[mag, phase, w] = bode(G1);
mag = 20*log10(mag);
delta = 0.5

for i=1 :length(phase)
  if phase(i)<= Mf && phase(i) >= Mf-delta
    w1 = w(i)
    p = i
    F = phase(p)
    M = mag(p)
  end
end

#{
  -Encontra os parametros alpha e T2 de acordo com
  a nova frequencia estimada acima
#}
alpha = (1-sind(Mf)) / (1+sind(Mf));
alphaB = -20*log10(1/sqrt(alpha));
T2 = 1 / (w1/10);

##construindo compensador em atraso
##beta = 1/alpha;
##GcAt = (s+(1/T2))/(s+(1/(beta*T2)))

GcAt = (T2*s + 1) / (alpha*T2*s + 1)
Gtotal = G1*GcAt;

#{
  - Compensador em avanço
  A parte que falta compensar somado ao que já temos (GcAt*G1)
  não deve aumentar o ganho em dB
  
  Isso significa que estamoos buscando na atual Gtotal
  uma frequencia que o ganho seja 20log10(1/sqrt(alpha)), ou seja,
  a frequencia onde o ganho seja 'alphaB'
  
  Nomeando a frequencia citada w2, encontraremos 
  T1 = 1/ (sqrt(alpha)*w2)
#}

##encontra a freq para o ganho alpha
[mag, phase, w] = bode(G1);
mag = 20*log10(mag);
bode(Gtotal)
for i=1 :length(mag)
  if mag(i)>= alphaB && mag(i) <= alphaB +0.3
    w2 = w(i);
  end
end
w2
T1 = 1 / (w2*sqrt(alpha));
GcAv = ( T1*s +1 ) / ( (T1/alpha)*s +1 )
##GcAv = (s+(1/T1))/(s+(1/(alpha*T1)))

Gtotal = Kc*Gs*GcAt*GcAv


#{
  - - Controlador somente por atraso
  de acordo com o calculado em invertedPendulum_atraso.m
#}

Kc = 14863.29654
Gc_Atraso = (3.961*s + 1 )/ (2707*s +1)
Gtotal_Atraso = Gs*2*Kc*Gc_Atraso

#{
  - - Controlador somente por avanço
  de acordo com o calculado em invertedPendulum_avanco.m
#}

Kc = 1486.3
Gc_Avanco= (0.03461*s + 1)/(0.004583*s + 1)
Gtotal_Avanco = Gs*Kc*Gc_Avanco


#{
  - - Repostas ao step e a rampa
#}


##Resposta a rampa
rampGs = ramp(feedback(Gs,1),t);
rampGtotal = ramp(feedback(Gtotal,1),t);
rampGtotal_Avanco = ramp(feedback(Gtotal_Avanco,1),t);
rampGtotal_Atraso = ramp(feedback(Gtotal_Atraso,1),t);

##Erro a rampa
essGs = ref - rampGs;
essGtotal = ref - rampGtotal;
essGtotal_Avanco = ref - rampGtotal_Avanco;
essGtotal_Atraso = ref - rampGtotal_Atraso;

##Resposta ao degrau
stepGs = step(feedback(Gs,1),t);
stepGtotal = step(feedback(Gtotal,1),t);
stepGtotal_Avanco = step(feedback(Gtotal_Avanco,1),t);
stepGtotal_Atraso = step(feedback(Gtotal_Atraso,1),t);


## - - Plots - -

##Resposta para entrada Degrau
figure;
hold on;
plot(t,stepGs, t, stepGtotal_Avanco, t, stepGtotal_Atraso, t, stepGtotal);
plot([min(t) max(t)], [1+Mp 1+Mp],'--r');
legend("Planta","Avanco","Atraso","Avanco-Atraso" ,"Sobresinal de 5%", 'location','northeast');
title("Resposta para entrada degrau ");
plot([min(t) max(t)], [1 1],'k');
axis([0 5 0 2]);
grid minor on;
hold off;

##Resposta para entrada rampa
figure;
hold on;
plot(t,ref,'--r', t, rampGtotal_Avanco, t, rampGtotal_Atraso, t, rampGtotal);
legend("Referencia","Planta","Avanco","Atraso","Avanco-Atraso",'location','southeast');
title("Resposta para entrada rampa");
axis([0 5 0 5]);
grid minor on;
hold off;

##Erro para entrada rampa
figure;
hold on;
plot(t,essGtotal_Avanco, t,essGtotal_Atraso, t,essGtotal);
plot([min(t) max(t)], [ess ess],'--r');
legend("Avanco","Atraso","Avanco-Atraso", "Maximo desejado", 'location','northeast')
title("Erro para entrada rampa");
##axis([0 3 -0.005 0.05 ]);
grid minor on;
hold off;