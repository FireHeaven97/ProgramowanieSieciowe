%Szymon Palmowski 235911
%Programowanie sieciowe
%Laboratorium 6 - Miniprojekt zadanie 1

close all;
clear all;
c = ['m'];
whitebg([0 .5 .6])

%% Wczytywanie baz danych

load baza_ucz.mat   %wczytanie bazy uczacej
load baza_test.mat  %wczytanie bazy testowej

rozmiar_we = size(baza_ucz_we,2); 
ind = randperm(rozmiar_we);

%% Podzielenie baz na zestawy

baza_ucz_we1 = baza_ucz_we(ind(1:rozmiar_we*0.75),:)'; %ucz¹cy wejœciowy
baza_ucz_wy1 = baza_ucz_wy(ind(1:rozmiar_we*0.75),:)'; %ucz¹cy wyjsciowy 
baza_wal_we1 = baza_ucz_we(ind(1:rozmiar_we*0.25),:)'; %walidacyjny wejsciowy
baza_wal_wy1 = baza_ucz_wy(ind(1:rozmiar_we*0.25),:)'; %walidacyjny wyjsciowy
baza_test_we = baza_test_we';                          %transponowanie danych testowych wejsciowych
baza_test_wy = baza_test_wy';                          %transponowanie danych testowych wyjsciowych  

n = size(baza_ucz_we1,1);                              %rozmiar sieci

k1 = 30;                   %liczba neuronow 1. warstwy
k2 = size(baza_ucz_wy1,1); %liczba neuronow 2. warstwy

%% Wartosci stale

eta = 0.15;    %wspolczynnik uczenia sie
beta = 1.25;   %wspolczynnik funkcji aktywacji
Epoki = 10000; %maksymalna liczba epok uczenia sie

%% Inicjalizacja sieci

a = -0.01; %zakres dolny
b = 0.01;  %zakres gorny

W1 = (b-a)*rand(n+1,k1) +a;   %warstwa ukryta (n+1 z k1)
W2 = (b-a)*rand(k1+1,k2) +a;  %warstwa wyjsciowa (k1+1 z k2)

%% Uczenie sie

msew = []; %inicjalizacja tablicy na przechowywanie b³êdu œredniokwadtatowego 
test = 0 %flaga sprawdzaj¹ca 
walbreak = 2;
dopuszczalny_blad = 0.01;

while test ~= 1
for i = 1:Epoki
    if mod(i,100) == 0
       mse = 0;
       L   = randi([1 size(baza_wal_we1,2)],1); %losujemy przyklad
       x1  = [-1; baza_wal_we1(:,L)];           %wejscie progowe
       u1  = W1'*x1;                            %suma wazona 1. warstwy
       y1  = 1./(1+exp(-beta*u1));              %funkcja aktywacji 1. warstwy
       x2  = [-1; y1];                          %wejscie 2 warstwy to wyjscie 1. warstwy
       u2  = W2'*x2;                            %liczymy pobudzenie 2. warstwy sieci
       y2  = 1./(1+exp(-beta*u2));              %liczymy wartosc funkcji aktywacji 2. warstwy
       ty2 = baza_wal_wy1(:,L);                 %wyciagniecie kolumny sygnalu wyjsciowego
       
       mse = sum((y2-ty2).^2);
       msew = [msew;mse];
       if size(msew,1)>walbreak
           nowy_blad = (msew(end-walbreak)-msew(end));
           if nowy_blad > dopuszczalny_blad 
               test = 0;
           else
               test=1;
           end
       end
    else
       if i == Epoki
           nowy_blad=msew(1)-msew(end);
           if nowy_blad<0
               test=0;
           end
    end
       if size(msew,1)>walbreak && test==0
           msew=[];
           break
       end
   L   = randi([1 size(baza_ucz_we1,2)]);   %losujemy przyklad
   x1  = [-1; baza_ucz_we1(:,L)];           %wejscie progowe
   u1  = W1'*x1;                            %suma wazona 1. warstwy
   y1  = 1./(1+exp(-beta*u1));              %funkcja aktywacji 1. warstwy
   x2  = [-1; y1];                          %wejscie 2 warstwy to wyjscie 1. warstwy
   u2  = W2'*x2;                            %liczymy pobudzenie 2. warstwy sieci
   y2  = 1./(1+exp(-beta*u2));              %liczymy wartosc funkcji aktywacji 2. warstwy
   ty2 = baza_ucz_wy1(:,L);                 %wyciagniecie kolumny sygnalu wyjsciowego
   
   %% Pochodna funkcji unipolarnej
   
   pochodna1 = beta*y1.*(1-y1);
   pochodna2 = beta*y2.*(1-y2);
   
   %% Wsteczna propagacja bledu
   
   d2 = ty2 - y2;       %wektor wyjsc
   e2 = pochodna2.*d2;  %k2x1, blad 2 warstwy
  
   %% Warstwa wejsciowa
   
   d1 = W2(2:end,:)*d2; %suma roznic pomnozona przez wektor wag
   e1 = pochodna1.*d1;  %blad 1. warstwy
   
   %% Modyfikujemy wartosc macierzy wag
   
   deltaW1 = eta*x1*e1';
   deltaW2 = eta*x2*e2'; 
   W1 = W1+deltaW1;
   W2 = W2+deltaW2; 
   end
end
end

%% Testowanie sieci

for i = 1:size(baza_test_we,2)
   x1  = [-1; baza_test_we(:,i)];   %wyciagniecie wartosci wejsciowej
   u1  = W1'*x1;                    %suma wazona
   y1  = 1./(1+exp(-beta*u1));      %funkcja aktywacji
   x2  = [-1; y1];                  %wyciagniecie wartosci wejsciowej 2. warstwy
   u2  = W2'*x2;                    %suma wazona
   y2  = 1./(1+exp(-beta*u2));      %funkcja aktywacji
   disp([baza_test_wy(:,i)  y2]);   %porownanie bazy wyjsciowej z baza oczekiwana
end

%% Wykres bledu walidacyjnego

f = figure(1);
plot([1:1:size(msew,1)], msew, c)
hold on; grid on; legend('\fontsize{8}{\color{magenta}blad walidacyjny}'); title('\fontsize{12}{\color{magenta}Zmiana bledu zestawu walidacyjnego w zaleznosci od epok}'); xlabel('\fontsize{10}{\color{magenta}Epoki}'); ylabel('\fontsize{10}{\color{magenta}Blad zestawu walidacyjnego}');
saveas(f,sprintf('Palmowski_235911_pslab67A.png'));
        