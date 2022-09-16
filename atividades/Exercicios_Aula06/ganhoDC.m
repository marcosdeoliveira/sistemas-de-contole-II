##Reseta ambiente
clear all;
close all;
clc;

##Carrega pacote de controle
pkg load control;

##Operador
s = tf('s');

Cs = 1;

Gs = 10 /(s+20)

##Gmf = feedback((Gs*Cs),1)
##step(Gmf)
##
##hold on

##Cs = 2;
##Gmf = feedback((Gs*Cs),1)
##step(Gmf)

##Cs = 10;
##Gmf2 = feedback((Gs*Cs),1)
##step(Gmf2)

Gs = 1/s;
Gmf = feedback(Gs,1)
step(Gmf)
