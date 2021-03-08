close all; %fecha todas as figuras
clear all; %limpa todas as variáveis
clc; %limpa o terminal

pkg load control

s = tf('s'); %operador de laplace

x_min = -1.1;
x_max = 1.1;

y_min = -1.5;
y_max = 1.5;

G_s = (1)/(s^2 + 0.8*s + 1)

hold on;
grid on;
nyquist (G_s);

eixox_h = plot([x_min, x_max],[0 0], '-k','linewidth',1);
eixoy_h = plot([0 0],[y_min, y_max], '-k','linewidth',1);
axis([x_min,x_max , y_min,y_max]);
