%Szymon Palmowski 235911
%Programownie sieciowe
%Laboratorium 2 - Eksperymentalne symulacje zwi¹zane z doborem rozmiaru sieci neuronowej
%Cyfry

clear all;
close all;
c = ['m'];
whitebg([0 .5 .6])

load baza_cyfry1; %wczytani bazy cyfr

%% CIAG UCZACY

baza_we = baza_we_1;  %wczytanie bazy wejsciowej
baza_wy = baza_wy_1;  %wczytanie bazy wyjsciowej
rozmiar_BD = size(baza_we_1,2);
ind=randperm(rozmiar_BD);

baza_ucz_we = baza_we(:,ind(1:rozmiar_BD*0.7));     %baza uczaca wejscie
baza_wal_we = baza_we(:,ind(1:rozmiar_BD*0.15));    %baza walidacyjna wejscie
baza_test_we = baza_we(:,ind(1:rozmiar_BD*0.15));   %baza testowa wejscie
baza_ucz_wy = baza_wy(:,ind(1:rozmiar_BD*0.7));     %baza uczaca wyjscie
baza_wal_wy = baza_wy(:,ind(1:rozmiar_BD*0.15));    %baza walidacyjna wyjscie
baza_test_wy = baza_wy(:,ind(1:rozmiar_BD*0.15));   %baza testowa wyjscie

n = size(baza_ucz_we,1); %liczba wejsc x
k = size(baza_ucz_wy,1); %liczba neuronow w warstwie / liczba wyjsc y
L2 = size(baza_wal_wy,1);

%% WARTOSCI STALE

eta = 0.01;     %wspolczynnik uczenia sie sieci
beta = 1.25;    %wspolczynnik funkcji aktywacji
Epoki = 10000;   %maksymalna liczba epok uczenia sie

%% INICJALIZACJA SIECI

W = (0.1+0.1)*rand(n,k)-0.1;    %inicjalizacja wstepnej macierzy wag
w0 = 0.5*ones(1,k);

W = [w0;W];
stary_blad_wal = 999;       %mozliwie duzy blad walidacyjny na poczatek
dopuszczalny_blad = 0.005;  %dopuszczalny blad
blad_wal = 99;              %mozliwie duzy blad walidacyjny na poczatek

%% UCZENIE SIE

for ep = 1:Epoki
    L = randi([1 size(baza_ucz_we,2)],1); %algorytm losujacy
    x = baza_ucz_we(:,L);                 %wybor przykladu a)
    x = [-1;x];                           %zwiekszenie macierzy o -1 
    u = W'*x;                             %suma wazona
    y = 1./(1+exp(-beta*u));              %funkcja aktywacji
    ty = baza_ucz_wy(:,L);                %wyciagniecie kolumny sygnalu wyjsciowego
    d = ty-y;                             %wektor roznic w sieci
    blad_ucz = mse(d);                    %blad sredniokwadratowy
    blad_ucz_i(1) = 0;                    %inicjalizacja do plot
    blad_ucz_i = [blad_ucz_i, blad_ucz];  %zapis wartosci bledu uczacego
    f = figure(1);
    plot(blad_ucz_i(2:length(blad_ucz_i)), c)
    hold on; grid on; legend('\fontsize{8}{\color{magenta}blad uczacy}'); title('\fontsize{12}{\color{magenta}Zmiana bledu zestawu uczacego w zaleznosci od epok}'); xlabel('\fontsize{10}{\color{magenta}Epoki}'); ylabel('\fontsize{10}{\color{magenta}Blad zestawu uczacego}');
    saveas(f,sprintf('blad_ucz.png'));
    dW = eta*x*d';                        %modyfikacja wartosci w macierzy wag
    W = W+dW;                             %aktualna macierz wag
    
%% PROCES WALIDACYJNY

    if(mod(ep,100)==0)
        L2 = randi(size(baza_wal_we,2));    %algorytm losujacy
        x = [-1;baza_wal_we(:,L2)];
        u = W'*x;                           %suma wazona
        y = 1./(1+exp(-beta*u));            %funkcja aktywacji
        ty = baza_ucz_wy(:,L2);             %wyciagniecie kolumny sygnalu wyjsciowego
        d1 = ty-y;                           %wektor roznic w sieci
        blad_wal = mse(d1);                  %blad sredniokwadratowy
        blad_wal_i(1) = 0;                  %inicjalizacja do plot
        blad_wal_i = [blad_wal_i, mse(d1)];  %zapis wartosci bledu uczacego
        f = figure(2);
        plot(blad_wal_i(2:length(blad_wal_i)), c)
        hold on; grid on; legend('\fontsize{8}{\color{magenta}blad walidacyjny}'); title('\fontsize{12}{\color{magenta}Zmiana bledu zestawu walidacyjnego w zaleznosci od epok}'); xlabel('\fontsize{10}{\color{magenta}Epoki}'); ylabel('\fontsize{10}{\color{magenta}Blad zestawu walidacyjnego}');
        saveas(f,sprintf('blad_wal.png'));
        W = W+blad_wal;
    end
    
    if blad_wal>stary_blad_wal
        break;
    end
    
    if (blad_wal<dopuszczalny_blad)
        break;
    end
    stary_blad_wal = blad_wal;
end

%% TESTOWANIE

for i = 1:size(baza_test_we,2)
    x = baza_test_we(:,i);  %wyciagniecie wartosci wejsciowej
    x = [-1;x];
    u = W'*x;               %suma wazona
    y = 1./(1+exp(-beta*u));%funkcja aktywacji
    [baza_test_wy(:,i) y]   %porownanie bazy wyjsciowej z baza oczekiwana
end