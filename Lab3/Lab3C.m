% Szymon Palmowski  235911
% Programowanie sieciowe
% Laboratorium 3 - MLP

clear all;
close all;

%% Dane

baza_ucz_we = 0:10;
baza_ucz_wy = [1 1.32 1.6 1.54 1.41 1.01 0.6 0.42 0.2 0.51 0.8]/2;
baza_test_we = 0:0.1:10;

%% Zdefiniowanie rozmiaru sieci

n = size(baza_ucz_we,1);
k1 = 11;
k2 = size(baza_ucz_wy,1);

%% Ustawienie parametrow uczenia sie

beta = 1.25;                %wspolczynnik uczenia sie sieci
eta = 0.15;                 %wspolczynnik funkcji aktywacji
epoki = 500000;             %maksymalna liczba epok uczenia sie

%% Inicjalizacja wstepnych macierzy wag

a = -0.1;                   %zakres dolny
b = 0.1;                    %zakres gorny
W1 = (b-a)*rand(n+1,k1)+a;  %warstwa skryta (n+1 z k1)
W2 = (b-a)*rand(k1+1,k2)+a; %warstwa wyjsciowa (k1+1 z k2)

%% Algorytm uczenia sie

  for ep = 1 : epoki
      L = randi([1 size(baza_ucz_we, 2)],1); %losujemy przyklad
      x1 = [-1; baza_ucz_we(:,L)];           %wejscie progowe
      u1 = W1'*x1;                           %suma wazona 1. warstwy
      y1 = 1./(1+exp(-beta*u1));             %funkcja aktywacji 1. warstwy
      x2 = [-1; y1];                         %wejscie 2 warstwy to wyjscie 1. warstwy
      u2 = W2'*x2;                           %liczymy pobudzenie 2. warstwy sieci
      y2 = 1./(1+exp(-beta*u2));             %liczymy wartosc funkcji aktywacji
      ty = baza_ucz_wy(:,L);                 %wyciagniecie kolumny sygnalu wyjsciowego
      d2 = ty - y2;                          %roznica 2. warstwy
      d1 = d2.*W2(2:end,:);                  %suma roznic pomnozona przez wektor wag
      e2 = y2.*(1-y2).*d2;                   %k2x1, blad 2. warstwy
      e1 = y1.*(1-y1).*d1;                   %k1x1, blad 1. warstwy
      dW1 = eta*x1*e1';                      %modyfikacja wartosci w macierzy wag 1. warstwy
      W1 = W1 + dW1;                         %aktualna macierz wag 1. warstwy
      dW2 = eta*x2*e2';                      %modyfikacja wartosci w macierzy wag 2. warstwy
      W2 = W2 + dW2;                         %aktualna macierz wag 2. warstwy
  end
  
  %% Testowanie
  
  for i = 1 : size(baza_test_we,2)
      x1 = baza_test_we(:,i);       %wyciagniecie wartosci wejsciowej
      x1 = [-1;x1];
      u1 = W1'*x1;                  %suma wazona 1. warstwy
      y1 = 1./(1+exp(-beta*u1));    %funkcja aktywacji 1. warstwy
      x2 = [-1;y1];
      u2 = W2'*x2;                  %suma wazona 2. warstwy
      y2 = 1./(1+exp(-beta*u2));    %funkcja aktywacji 2. warstwy
      f = figure(1);
      scatter(x1(2),y2*2)
      whitebg([0 .5 .6])
      hold on; grid on; title('\fontsize{12}{\color{magenta}Wykres aproksymacji funkcji jednej zmiennej II}');
  end
   plot([0:10],[1 1.32 1.6 1.54 1.41 1.01 0.6 0.42 0.2 0.51 0.8], 'm')
   saveas(f,sprintf('Palmowski_235911_pslab3C.png'));
   
    %% Blad sredniokwadratowy
  
  for i = 1:length(y2)
      blad = mse(y2)
  end