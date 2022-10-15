% do 11.05 oddac z tego sprawko
% 6-7 obowiazkowe do 8.06

clear all;
close all;

P = 500; %l. danych we/p. pomiarowych
N = 2; %l. we. sieci dostosowana do struktury danych we

a=0.2;
b=0.5;
% c=0.6;
% d=0.9;

x=(b-a)*rand(N,P)+a; %losowy klaster danych
r=4;
t=linspace(0,4*pi,P);
x=r*cos(t);
y=r*sin(t);
x=[x;y];
K=12; %l. neuronow

a=0;
b=1;

for k=1:K
    %inicjacja wektorow wag
    W(k).w=(b-a)*rand(N,1)+a;
%     W1(k).w=(d-c)*rand(N,1)+c;
end

%norma euklidesowa
dist = @(v1,v2) sqrt(sum((v2-v1).^2));

%f. sasiedztwa
neighbor = @(d, lam) (d<lam).*1; %w skrypcie bez 10*

epoki = 10000; %100
ep=1/epoki; %czestotliwosc zmian w 1 epoce

alpha = 0.5; %wsp. uczenia sie
lambda = 0.8; %promien sasiedztwa 0.3

%uczenie
for i = 1:epoki
    L=randi([1 P],1);
    for k=1:K
        D(k)=dist(x(:,L),W(k).w);
%         D1(k)=dist(y(:,L),W1(k).w);
    end
    [val,z]=min(D);
%     [val1,z1]=min(D1);
    for k=1:K
        Dz(k)=dist(W(k).w,W(z).w);
%         Dz1(k)=dist(W1(k).w,W1(z).w);
    end
    
    %WTA
    %W(:,z)=W(z).w+alpha*(x(:,L)-W(z).w); 
    %WTM
    for k=1:K
        W(k).w=W(k).w+alpha*neighbor(Dz(k),lambda)*(x(:,L)-W(z).w);
%         W1(k).w=W1(k).w+alpha*neighbor(Dz1(k),lambda)*(y(:,L)-W1(z).w);
    end
    
    
    %redukcja parametrow
    alpha=(1-ep)*alpha;
    lambda=(1-ep)*lambda;
    
end

%wyniki
figure(1), hold on;
plot(x(1,:),x(2,:),'g.','MarkerSize', 18);
% axis([0 1 0 1]);
for k=1:K
    plot(W(k).w(1),W(k).w(2), 'k.', 'MarkerSize',18);
end
% axis([0 1 0 1]);

% 
% plot(y(1,:),y(2,:),'g.','MarkerSize', 18);
% axis([0 1 0 1]);
% for k=1:K
%     plot(W1(k).w(1),W1(k).w(2), 'k.', 'MarkerSize',18);
% end
% axis([0 1 0 1]);