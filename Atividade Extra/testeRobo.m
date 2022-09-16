##Obejtos que se movem no grafico

##Reseta ambiente
clear all;
close all;
clc;
figure;
##hold on;
%cria triangulo
altura = 100
largura = 100
origem = [-200 -400]
theta = deg2rad (0);
tr0 = [(origem(1)-largura/2), origem(1), (origem(1)+largura/2); origem(2),(origem(2)+altura) , origem(2)]
%matriz de translação
moveX = [1 1 1; 0 0 0];
moveY = [0 0 0; 1 1 1];
r = [cos(theta) -sin(theta) 0; sin(theta) cos(theta) 0; 0 0 1]
##function moveY(valor)
##  %aplica translação
##  tr = tr+moveY*valor;
##endfunction


for i=0:20:800
  %aplica translação
  tr = tr0+moveY*i;
  %plota
  fill(tr(1,:),tr(2,:),'b');
  axis([-500 500 -500 500])
  drawnow ;
  
end 
