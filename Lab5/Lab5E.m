%Szymon Palmowski 235911
%Programowanie sieciowe
%Laboratorium 5 - Zaimplementowanie sieci Kohonena do grupowania danych pomiarowych

clear all;
close all;

%% Dane

P = 500; %liczba danych wejsciowych punktow pomiarowych
N = 2;   %liczba wejsc sieci (dostosowana do struktury danych wejsciowych)
P0 = 100;

%% Wygenerowanie przykladowego klastra danych punktowych w przestrzeni dwuwymiarowej (2D)

a = 0.2;
b = 0.5;

%% Losowy klaster danych

x = (b-a)*rand(N,P)+a;
r0 = 4;
t = linspace(0,2*pi,P0);
x0 = r0*cos(t);
y0 = r0*sin(t);
r1 = 0:0.5:1.5;
t = linspace(0.2*pi,P);
x1 = r1'*cos(t);
y1 = r1'*sin(t);
x1 = [x0 reshape(x1,1,[])];
y1 = [y0 reshape(y1,1,[])];
x=[x1;y1];
K=30; %liczba neuronow

%% Utworzenie struktury sieci - przypisanie wag/rozmieszczenie neuronów w przestrzeni

a = 0;
b = 1;

%% Inicjacja wektorow wag

for k = 1:K
    W(k).w = (b-a)*rand(N,1)+a;
end

%% Norma euklidesowa odleglosci dwoch punktow w przestrzeni

dist = @(v1,v2) sqrt(sum((v2-v1).^2));

%% Funkcja sasiedztwa dla dwoch punktow w przestrzeni

neighbor = @(d, lam) (d<lam).*1;

%% Liczba epok uczenia sie

Epoki = 10000;  %liczba epok
ep = 1/Epoki;   %czestotliwosc zmian w 1 epoce
alpha = 0.5;    %wspolczynnik uczenia sie
lambda = 0.8;   %promien sasiedztwa

%% Uczenie sie

for i = 1:Epoki
    L = randi([1 P],1);
    for k = 1:K
        D(k) = dist(x(:,L),W(k).w);
    end
    [val,z] = min(D);
    for k = 1:K
        Dz(k) = dist(W(k).w,W(z).w);
    end
    
    %% Strategia WTM
    
    for k = 1:K
        W(k).w = W(k).w+alpha*neighbor(Dz(k),lambda)*(x(:,L)-W(z).w);
    end
    
    %% Redukcja parametrow
    
    alpha = (1-ep)*alpha;
    lambda = (1-ep)*lambda;
end

%% Testowanie sieci

whitebg([0 .5 .6])
f = figure(1), hold on; grid on; title('\fontsize{12}{\color{magenta}Siec Kohonena}');
plot(x(1,:),x(2,:),'m.','MarkerSize', 18);
for k = 1:K
    plot(W(k).w(1),W(k).w(2), 'c.', 'MarkerSize',18);
end
saveas(f,sprintf('Palmowski_235911_pslab5E.png'));