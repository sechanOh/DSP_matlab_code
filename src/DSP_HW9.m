%% angle vs phase
clear;clc;

h = [0 0 0 0 0 0 1];
[H,w] = freqz(h, 1);
subplot(2,1,1);
plot(w, angle(H));
grid;

[P,w] = phasez(h, 1);
subplot(2,1,2);
plot(w, P);
grid;

%% HW 9. Noise cancellation
[ref,fs] = audioread("etest4r.wav");
[pri,fs] = audioread("etest4p.wav");
N = length(ref);
t = 1:N;
energy = 0;
flength = 256;
x = zeros(1,flength);
h = zeros(1,flength);
e = zeros(1,N);
for n = 1:N
    energy = energy - x(flength) * x(flength);
    for m = flength:-1:2
        x(m) = x(m-1);
    end
    x(1) = ref(n);
    energy = energy + x(1) * x(1);

    y = dot(x, h);
    e(n) = pri(n) - y;

    for m = 1:flength
        h(m) = h(m) + e(n) * x(m) / (energy + 0.1);
    end
end
audiowrite("lms4.wav", e, fs);
