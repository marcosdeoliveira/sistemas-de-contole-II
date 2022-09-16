close all; %fecha todas as figuras
clear all; %limpa todas as variáveis
clc; %limpa o terminal

pkg load control

s = tf('s'); %operador de laplace

x_min = -1;
x_max = 0.05;

y_min = -3;
y_max = -y_min;

G_s = (1)/(s*(s+1))

% diagrama de Nyquist para freq positivas e negativas
figure(1)
nyquist (G_s);
hold on;
eixox_h = plot([x_min, x_max],[0 0], '--k','linewidth',1);
eixoy_h = plot([0 0],[y_min, y_max], '--k','linewidth',1);
##axis([x_min,x_max , y_min,y_max]);
hold off;
% diagrama de Nyquist SOMENTE para freq positivas [correto]


[re, im , w2] = nyquist (G_s)
figure(2)
hold on;
plot(re,im);
grid on;
eixox_h = plot([x_min, x_max],[0 0], '--k','linewidth',1);
eixoy_h = plot([0 0],[y_min, y_max], '--k','linewidth',1);
axis([x_min,x_max , y_min,y_max]);
hold off;
