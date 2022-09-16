##Sistemas de controle II | Lista Aula 6

##Reseta ambiente
clear all;
close all;
clc;

##Carrega pacote de controle
pkg load control;

##Operador
s = tf('s');

gain = 0.9;
wn_pole = 2.8;
qsi = 0.4;

Gs = gain*(1/s)*(1/ (1+2*qsi*(s/wn_pole)+(s/wn_pole)^2) )

##Bode de malha aberta
k = 1;
Gc = (k*(s+1))/(s+4)
Gtotal = Gc*Gs

figure;
bode(Gtotal)


##Encontrando K de malha aberta

##O diagrama fornecido passa em zero db qnd wn = 1, por isso
##vamos determinar o ganho atual em wn =1 e achar 
##o k que corrige isso pra 0db

w = logspace(-2,2,100);
[mag, phase, w] = bode(Gtotal, w);
n=1;

while ( w(n)<=1) %% itera até encontrar wn=1
  n=n+1;
end
##Ganho atual em wn=1 [em dB]
ganho_omega1 = 20*log10(mag(n));

##K que corrigem o ganho para 0dB
k = 10^(ganho_omega1/-20);

##Novo bode corrigido
Gtotal=Gtotal*k
figure;
bode(Gtotal)

##Encontrando freq de cruzamento de ganho e freq quando phase = -180
figure;
margin(Gtotal)

##Diagrama de Bode em malha fechada

%diagrama com o ganho k atual
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

printf("\nGanho k:\t %0.3f\n", k)
printf("Pico ress:\t %0.3f \n", pico_ress)
printf("Freq ress:\t %0.3f \n", freq_ress)
printf("Banda pass:\t %0.3f \n", banda_pass)
printf("- - - - - - - - - - \n")

##Resposta ao degrau
figure;
step(Gtotal_mf);

%diagrama com ganho k de 22

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

printf("\nGanho k:\t %0.3f\n", k_atual)
printf("Pico ress:\t %0.3f \n", pico_ress)
printf("Freq ress:\t %0.3f \n", freq_ress)
printf("Banda pass:\t %0.3f \n", banda_pass)
printf("- - - - - - - - - - \n")

##Resposta ao degrau
figure;
step(Gtotal_mf);


%diagrama com ganho k de 25
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

printf("\nGanho k:\t %0.3f\n", k_atual)
printf("Pico ress:\t %0.3f \n", pico_ress)
printf("Freq ress:\t %0.3f \n", freq_ress)
printf("Banda pass:\t %0.3f \n", banda_pass)
printf("- - - - - - - - - - \n")

##Resposta ao degrau
figure;
step(Gtotal_mf);








