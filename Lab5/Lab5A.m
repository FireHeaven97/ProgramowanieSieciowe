%Szymon Palmowski 235911
%Programowanie sieciowe
%Laboratorium 5 - Zaimplementowanie sieci Kohonena do grupowania danych pomiarowych

clear all;
close all;

%% Dane

P = 25; %liczba danych wejsciowych punktow pomiarowych
N = 2;   %liczba wejsc sieci (dostosowana do struktury danych wejsciowych)

%% Wygenerowanie przykladowego klastra danych punktowych w przestrzeni dwuwymiarowej (2D)

a = 0.2;
b = 0.5;

%% Losowy klaster danych

x = (b-a)*rand(N,P)+a;

K = 100; %liczba neuronow

%% Utworzenie struktury sieci - przypisanie wag/rozmieszczenie neuronow w przestrzeni

a = 0;
b = 1;

%% Inicjacja wektorow wag

for k = 1:K
    W(:,k) = (b-a)*rand(N,1)+a;
end

%% Norma euklidesowa odleglosci dwoch punktow w przestrzeni

dist = @(v1,v2) sqrt(sum((v2-v1).^2));

%% Funkcja sasiedztwa dla dwoch punktow w przestrzeni

neighbor = @(d, lam) (d<lam).*1;

%% Liczba epok uczenia sie

Epoki = 100;    %liczba epok
ep = 1/Epoki;   %czestotliwosc zmian w 1 epoce
alpha = 0.5;    %wspolczynnik uczenia sie
lambda = 0.3;   %promien sasiedztwa

%% Uczenie sie

for i = 1:Epoki
    L = randi([1 P],1);                %losowanie wejscia
    for k = 1:K
        D(k) = dist(x(:,L),W(k));
    end
    [val,z] = min(D);
    for k = 1:K
        Dz(k) = dist(W(k),W(z));
    end
    W(:,z) = W(z)+alpha*(x(:,L)-W(z)); %strategia WTA
    
    %% Redukcja parametrow
    
    alpha = (1-ep)*alpha;
    lambda = (1-ep)*lambda;
end

%% Testowanie sieci

whitebg([0 .5 .6])
f = figure(1); hold on; grid on; title('\fontsize{12}{\color{magenta}Siec Kohonena}');
plot(x(1,:), x(2,:), 'm.', 'MarkerSize', 18);
axis([ 0 1 0 1]);
for k = 1:K
    plot(W(1,k),W(2,k), 'c.', 'MarkerSize',18);
end
axis([0 1 0 1]);
saveas(f,sprintf('Palmowski_235911_pslab5A.png'));
