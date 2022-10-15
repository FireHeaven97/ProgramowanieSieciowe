%Szymon Palmowski 235911
%Programowanie sieciowe
%Laboratorium 4 - Aproksymacja funkcji jednej zmiennej

clear all;
close all;

%% Dane

xp = 0:0.25:10;
xp = xp';
dp = 0.8*sin(xp/4)+0.4*sin(pi*xp/4)+0.1*cos(pi*xp);
p = length(xp);         %liczba wszystkich punktow p
k = 10;                 %liczba centrum k<=p
p = p-k;                %pomniejszenie liczby punktow o liczbe centrum, jezeli zbior xp jest duzy
ind = randperm(length(xp));
c = xp(ind(1:k),:);     %losowanie punktow, ktore stana sie centrum
s = sort(ind(k+1:end));
x = xp(s,:);            %pomniejszenie zbioru punktow o centrum
d = dp(s,:);            %pomniejszenie zbioru punktow o centrum

%% Zdefiniowanie stalych elementow funkcji

t = max(c) - min(c);
sigma = t/k;

%% Radialna funkcja aktywacji Gaussa

phi = @(x,c) exp(-((x-c)'*(x-c))/2/sigma^2);
Phi = zeros(p,k);

%% Wyznaczanie macierzy fi

for i = 1:p
    for j = 1:k
        Phi(i,j) = phi(x(i), c(j));
    end
end
Phi = [ones(p,1), Phi];

%% Wyznaczanie wektora wag

w = inv(Phi'*Phi)*Phi'*d;

%% Testowanie

d_ = Phi*w;
f = figure(1);
whitebg([0 .5 .6])
hold on; grid on; title('\fontsize{12}{\color{magenta}Wykres aproksymacji funkcji jednej zmiennej}');
plot(x,d,'m')
plot(x,d_,'r')
legend('\fontsize{9}{\color{magenta}Funkcja bazowa}', '\fontsize{9}{\color{red}Funkcja testowana}')
saveas(f,sprintf('Palmowski_235911_pslab4C.png'));
x = 0:0.05:10;
x = x';
blad = mse(d_)