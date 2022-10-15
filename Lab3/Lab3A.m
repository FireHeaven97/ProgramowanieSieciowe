% Szymon Palmowski  235911
% Programowanie sieciowe
% Laboratorium 3 - MLP

clear all;
close all;

%% DANE

% Model funkcji XOR
baza_ucz_we = [1 1 0 0;  %wejscie 1
               1 0 1 0]; %wejscie 2
baza_ucz_wy = [0 1 1 0]; %wyjscie

% Zdefiniowanie rozmiaru sieci
n = size(baza_ucz_we,1);    %liczba wejsc sieci
k1 = 2;                     %liczba neuronow 1. warstwy
k2 = size(baza_ucz_wy,1);   %liczba neuronow 2. warstwy

% Ustawienie parametrow uczenia sieci
eta = 0.10;     %wspolczynnik uczenia sie sieci
beta = 1.25;    %wspolczynnik funkcji aktywacji
Epoki = 100000; %maksymalna liczba epok uczenia sie

%% INICJACJA SIECI

a = -0.1; %zakres dolny
b = 0.1;  %zakres gorny

% Inicjalizacja wstepnych macierzy wag
W1 = (b-a)*rand(n+1, k1)+a;  %warstwa ukryta (n+1 z k1)
W2 = (b-a)*rand(k1+1, k2)+a; %warstwa wyjsciowa (k1+1 z k2)

%% UCZENIE SIE

for ep=1:Epoki
L = randi([1 size(baza_ucz_we,2)],1); %losujemy przyklad
x = [-1; baza_ucz_we(:,L)];           %wejscie progowe

% Liczymy od 1. i 2. warstw sieci na sygnal wejsciowy
u = W1'*x;                  %suma wazona 1. warstwy
y1 = 1./(1+exp(-beta*u));   %funkcja aktywacji 1. warstwy
x2 = [-1; y1];              %wejscie 2 warstwy to wyjscie 1. warstwy
u2 = W2'*x2;                %liczymy pobudzenie 2. warstwy sieci
y2 = 1./(1+exp(-beta*u2));  %liczymy wartosc funkcji aktywacji 2. warstwy

% Wsteczna propagacja bledu
ty = baza_ucz_wy(:,L);       %wyciagniecie kolumny sygnalu wyjsciowego
d3 = ty-y2;                  %roznica 2. warstwy

% Obliczenie roznicy bledu odpowiedzi dla warstw sieci
d2 = baza_ucz_wy(:, L)- y2;  %wektor wyjsc
e2 = y2.*(1-y2).*d2;         %k2x1, blad 2 warstwy
d1 = W2(2:end,:)*d2;         %suma roznic pomnozona przez wektor wag
e1 = y1.*(1-y1).*d1;         %blad 1. warstwy

% Modyfikujemy wartosc macierzy wag
dW1 = eta*x*e1';    %modyfikacja wartosci w macierzy wag 1. warstwy
dW2 = eta*x2*e2';   %modyfikacja wartosci w macierzy wag 2. warstwy
W1 = W1+dW1;        %aktualna macierz wag 1. warstwy
W2 = W2+dW2;        %aktualna macierz wag 2. warstwy
end

%% TESTOWANIE SIECI

for i = 1 : size(baza_ucz_we,2)
x = [-1;baza_ucz_we(:,i)];  %wyciagniecie wartosci wejsciowej
u = W1'*x;                  %suma wazona
y1 = 1./(1+exp(-beta*u));   %funkcja aktywacji
x2 = [-1; y1];              %wyciagniecie wartosci wejsciowej 2 warstwy
u2 = W2'*x2;                %suma wazona
y2 = 1./(1+exp(-beta*u2));  %funkcja aktywacji
disp([baza_ucz_wy(:,i) y2]) %porownanie bazy wyjsciowej z baza oczekiwana
end