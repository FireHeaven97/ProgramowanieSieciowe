%Szymon Palmowski 235911
%Programownie sieciowe
%Laboratorium 1 - Model sieci neuronowej
%Zwierzeta

clear all; close all;
baza_ucz_we = [4, 2, 0, 2, 4;       %ile ma nog
               -1, 1, 1, -1, 1;     %czy jest jajorodne
               -1, 2, -1, 2, -1;    %czy potrafi latac
               0, -1, 2, -1, 1;     %czy potrafi plywac 
               2, -1, -1, 2, 2;     %czy ma siersc
               -1, 2, -1, -1, -1;   %czy ma piora
               -1, 2, -1, -1, -1];  %czy ma puste kosci
      %pies, golab, okon, nietoperz, dziobak
           
baza_ucz_wy = [1, 0, 0, 1, 1;   %ssak
               0, 1, 0, 0, 0;   %ptak
               0, 0, 1, 0, 0];  %ryba
         
n = size(baza_ucz_we,1);  %ilosc wejsc x
k = size(baza_ucz_wy,1);  %ilosc wyjsc / neuronow

eta = 0.15;   %wspolczynnik uczenia sie sieci
beta = 1.25;  %wspolczynnik funkcji aktywacji
Epoki = 5000; %maksymalna liczba epok uczenia sie

a = 0; b = 0.1;         %zakres przedzialu
W = (b-a)*rand(n,k)+a;  %inicjalizacja wstepnej macierzy wag

for ep = 1:Epoki
   L = randperm(k,1);       %algorytm losujacy
   x = baza_ucz_we(:,L);    %wyciagniecie kolumny sygnalu wejsciowego
   u = W'*x;                %suma wazona
   y = tanh(beta*u);        %funkcja aktywacji
   ty = baza_ucz_wy(:,L);   %wyciagniecie kolumny sygnalu wyjsciowego
   d = ty-y;                %wektor roznicy wartosci oczekiwana, a wyjscia
   dW = eta*x*d';           %modyfikacja wartosci w macierzy wag
   W = W+dW;                %aktualna macierz wag
end

for i = 1:size(baza_ucz_we,2)
   x = baza_ucz_we(:,i);    %wyciagniecie wartosci wejsciowej
   u = W'*x;                %suma wazona
   y = tanh(beta*u);        %funkcja aktywacji
   [baza_ucz_wy(:,i) y]     %porownanie bazy wyjsciowej z baza oczekiwana
end