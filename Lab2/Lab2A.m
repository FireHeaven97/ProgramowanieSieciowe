%Szymon Palmowski 235911
%Programownie sieciowe
%Laboratorium 2 - Eksperymenty symulacyjne zwiazane zdoborem rozmiaru sieci neuronowej
%Litery

%% DANE
clear all; close all;

run litery;             %wczytanie liter
A = reshape(litA,[],1); %zmiana rozmiaru litery A
B = reshape(litB,[],1); %zmiana rozmiaru litery B
C = reshape(litC,[],1); %zmiana rozmiaru litery C
D = reshape(litD,[],1); %zmiana rozmiaru litery D
E = reshape(litE,[],1); %zmiana rozmiaru litery E
baza_ucz_we = [A,B,C,D,E];%wczytanie bazy wejsciowej
baza_ucz_wy = eye(5);   %macierz jednostkowa

eta = 0.15;   %wspolczynnik uczenia sie sieci
beta = 1.25;  %wspolczynnik funkcji aktywacji
Epoki = 5000; %maksymalna liczba epok uczenia sie

n = size(baza_ucz_we,1); %liczba wejsc x
k = size(baza_ucz_wy,1); %liczba neuronow w warstwie/ liczba wyjsc y

a = 0; b = 0.1;         %zakres przedzialu
W = (b-a)*rand(n,k)+a;  %inicjalizacja wstepnej macierzy wag
w0 = 0.5*ones(1,k);

%% UCZENIE SIE
for ep = 1:Epoki
   L = randperm(k,1);       %algorytm losujacy
   x = baza_ucz_we(:,L);    %wyciagniecie kolumny sygnalu wejsciowego
   x0 = [-1; x];
   W0 = [w0; W];
   u = W0'*x0;              %suma wazona
   y = 1./(1+exp(-beta*u)); %funkcja aktywacji
   ty = baza_ucz_wy(:,L);   %wyciagniecie kolumny sygnalu wyjsciowego
   d = ty-y;                %wektor roznicy wartosci oczekiwana, a wyjscia
   dW = eta*x*d';           %modyfikacja wartosci w macierzy wag
   W = W+dW;                %aktualna macierz wag
end

%% TESTOWANIE
for i = 1:size(baza_ucz_we,2)
   x = baza_ucz_we(:,i);    %wyciagniecie wartosci wejsciowej
   u = W'*x;                %suma wazona
   y = 1./(1+exp(-beta*u)); %funkcja aktywacji
   [baza_ucz_wy(:,i) y]     %porownanie bazy wyjsciowej z baza oczekiwana
end
