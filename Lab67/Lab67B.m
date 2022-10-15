%Szymon Palmowski 235911
%Programowanie sieciowe
%Laboratorium 6 - Miniprojekt zadanie 2

clear all;
close all;
whitebg([0 .5 .6])

%% Wczytywanie baz danych

load x.mat  %wczytanie bazy uczacej
load y.mat  %wczytanie bazy testowej

N = 2;          %liczba wejsc sieci (dostosowana do struktury danych wejsciowych)
X = x;          %przypisanie zmiennych
Y = y;          %przypisanie zmiennych
x = [x;y];      %utworzenie wektora danych
P = size(x,2);  %liczba danych wejsciowych punktow pomiarowych

K = 19;         %liczba neuronow

%% Utworzenie struktury sieci - przypisanie wag/rozmieszczenie neuronow w przestrzeni

a = 1;
b = 2;

%% Inicjacja wektorow wag

for k = 1:K
    W(:,k) = (b-a)*rand(N,1)+a; 
end


%% Norma euklidesowa odleglosci dwoch punktow w przestrzeni

dist = @(v1,v2) sqrt(sum((v2-v1).^2));

%% Funkcja sasiedztwa dla dwoch punktow w przestrzeni

neighbor = @(d,lam) (d<lam).*1;

%% Liczba epok uczenia sie

Epoki = 10000;  %liczba epok
ep = 1/(Epoki); %czestotliwosc zmian w 1 epoce
alpha = 0.5;    %wspolczynnik uczenia sie
lambda = 0.8; 	%promien sasiedztwa

%% Uczenie sie

for i = 1:Epoki
   L = randi([1 P],1);  %losowanie wejscia
   for k = 1:K
       D(k) = dist(x(:,L),W(:,k));
   end
   [val,z] = min(D);
   for k = 1:K
      Dz(k) = dist(W(:,k),W(:,z)) ;
   end
   for k = 1:K
      W(:,k) = W(:,k)+alpha*neighbor(Dz(k),lambda)*(x(:,L)-W(:,z)); %strategia WTM
   end
   
  %% Redukcja parametrow
  
   alpha = (1-ep)*alpha;
   lambda = (1-ep)*lambda;
end

%% Testowanie sieci

f = figure(1);
plot(x(1,:),x(2,:),'m.','MarkerSize',18);
hold on; grid on; title('\fontsize{12}{\color{magenta}Sieæ Kohonena}');
for k = 1:K
    plot(W(1,k),W(2,k),'c.','MarkerSize',18);
end 
legend('\fontsize{9}{\color{magenta}Funkcja bazowa}', '\fontsize{9}{\color{cyan}Funkcja Kohonena}')
saveas(f,sprintf('Palmowski_235911_pslab67B.png'));

%% Dane

C = W; %przypisanie wektorow wag
c = W(1,:);   
k = K; %liczba neuronow
p = P; %liczba danych wejsciowych punktow pomiarowych
x = x(1,:);
d = y; %testowanie

%% Zdefiniowanie stalych elementow funkcji

t = max(c)-min(c);
sigma = 2*t/(k);

%% Radialna funkcja aktywacji Gaussa

phi = @(x,c) exp((-((x-c)'*(x-c)))/2/sigma^2);
Phi = zeros(p,k);

%% Wyznaczanie macierzy fi

for i = 1:p
    for j = 1:k
Phi(i,j) = phi(x(i),c(j));
    end
end

%% Wyznaczanie wektora wag

w = inv(Phi'*Phi)*Phi'*d';

%% Testowanie

d_ = Phi*w;
f = figure(2);
plot(X, Y,'m')
hold on; grid on; title('\fontsize{12}{\color{magenta}Porownanie dzialania funkcji Gaussa z funkcja Kohonena}');
plot(x, d_,'c')
plot(C(1,:),C(2,:),'k.','MarkerSize',18)
legend('\fontsize{9}{\color{magenta}Funkcja bazowa}', '\fontsize{9}{\color{cyan}Funkcja Gaussa}', '\fontsize{9}{\color{black}Funkcja Kohonena}')
saveas(f,sprintf('Palmowski_235911_pslab67C.png'));
MSE = sum((Y-d_').^2)/length(d_);

x = [0:0.05:12];
p = size(x,2);
for i = 1:p
    for j = 1:k
Phi(i,j) = phi(x(i),c(j));
    end
end

f = figure(3);
d_ = Phi*w;
plot(X,Y,'m')
hold on; grid on; title('\fontsize{12}{\color{magenta}Porownanie dzialania funkcji Gaussa z funkcja Kohonena dla innego X}');
plot([0:0.05:12],d_,'c')
plot(C(1,:),C(2,:),'k.','MarkerSize',18)
legend('\fontsize{9}{\color{magenta}Funkcja bazowa}', '\fontsize{9}{\color{cyan}Funkcja Gaussa}', '\fontsize{9}{\color{black}Funkcja Kohonena}')
saveas(f,sprintf('Palmowski_235911_pslab67D.png'));