%Szymon Palmowski 235911
%Programowanie sieciowe
%Laboratorium 4 - Model operacji logicznej XOR

clear all;
close all;

%% Dane

xp = [1 1 0 0; 
      1 0 1 0;];
xp = xp';
dp = [ 0 1 1 0];
dp = dp';
p = length(xp);     %liczba wszystkich punktow p
k = 4;              %liczba centrum k<=p
%p = p-k;           %pomniejszenie liczby punktow o liczbe centrum, jezeli zbior xp jest duzy
ind = randperm(length(xp));
c = xp(ind(1:k),:); %losowanie punktow, ktore stana sie centrum
x = xp;             %pomniejszenie zbioru punktow o centrum
d = dp;             %pomniejszenie zbioru punktow o centrum

%% Zdefiniowanie stalych elementow funkcji

t = 0.5;
sigma = t^2/k;

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

w = pinv(Phi'*Phi)*Phi'*d;

%% Testowanie

d_ = Phi*w
f = figure(1);
whitebg([0 .5 .6])
hold on; grid on; title('\fontsize{12}{\color{magenta}Model operacji logicznej XOR}');
plot(x,d,'mo')
plot(x,d_,'ro')
legend('\fontsize{9}{\color{magenta}Funkcja bazowa}', '\fontsize{9}{\color{red}Funkcja testowana}')
saveas(f,sprintf('Palmowski_235911_pslab4B.png'));
x = 0:0.05:10;
x = x';