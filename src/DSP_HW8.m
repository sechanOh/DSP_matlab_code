%% Practice: digital filter design
clear; clc;

fs = 2000;
fpfs = [500 600];
a = [1 0];
dev = [0.01 0.05];
[n,f,m,weight] = firpmord(fpfs,a,dev,fs);
h = firpm(n,f,m,weight);
[H,w] = freqz(h,1);
subplot(2,1,1);
plot(w, abs(H));
grid;

fs = 2000;
fpfs = [500 600];
a = [0 1];
dev = [0.005 0.001];
[n,f,m,weight] = firpmord(fpfs,a,dev,fs);
h = firpm(n,f,m,weight);
[H,w] = freqz(h,1);
subplot(2,1,2);
plot(w, abs(H));
grid;

%% HW 8. digital filter design
clear; clc;

w_p = 0.2*pi;
w_s = 0.3*pi;
N = 30;
m = N/2+1;
delta = 0.005;
wp = 0:delta:w_p;
ws = w_s:delta:pi;
nwp = length(wp);
nws = length(ws);
mlength = nwp+nws;
y = zeros(mlength,1);
for i=1:nwp
    y(i) = 1;
end
A = zeros(mlength,m);
for i=1:nwp
    A(i,1) = 1;
    for j = 2:m
        A(i,j) = 2*cos(wp(i)*(j-1));
    end
end
for i = nwp+1:mlength
    A(i,1) = 1;
    for j = 2:m
        A(i,j) = 2*cos(ws(i-nwp)*(j-1));
    end
end

B = zeros(2*mlength, m+1);
for i = 1:mlength
    for j = 1:m
        B(i,j) = A(i,j);
    end
    B(i,m+1) = -1;
end
for i = (mlength+1):(2*mlength)
    for j = 1:m
        B(i,j) = -A(i-mlength, j);
    end
    B(i, m+1) = -1;
end
f = zeros(m+1, 1);
f(m+1, 1) = 1;
b = [y;-y];
d = linprog(f,B,b); %linprog에는 Optimization Toolbox이(가) 필요합니다.
h = zeros(1, N+1);
for i = 1:m-1
    h(i) = d(m-i+1);
end
for i = m:N+1
    h(i) = d(i-m+1);
end
maxripple = d(m+1);
[H,w] = freqz(h, 1);
w = w/pi/2;
plot(w, abs(H));
grid
