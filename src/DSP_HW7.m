%% Practice
clear; clc;

x = [1, 3, 4, 2, 1, 2, 2, 1]';
h = [1, 2, 1]';
y1 = conv(h,x);

%% Lecture 6-1 page.13
N = pow2(ceil(log2(length(h))));
M = N / 2;
zero_padding_h = zeros(N, 1);
zero_padding_h(1:length(h)) = h;
H = fft(zero_padding_h);

data_block = zeros(N, 1);
y2 = zeros(N + M, 1);
iteration = floor(length(x)/M);
for n = 1:iteration
    data_block(1:M) = data_block(M+1:end);
    data_block(M+1:end) = x((n-1)*M+1:n*M);
    X = fft(data_block);
    Y = X.*H;
    tmp = ifft(Y);
    y2((n-1)*M+1:n*M) = tmp(M+1:end);
end

data_block(1:M) = data_block(M+1:end);
data_block(M+1:end) = zeros(M, 1);
%if length(x)/M - floor(length(x)/M) > 0
%    data_block(M+1:M + length(x)/M - floor(length(x)/M)) = x((iteration-1)*M+1:end);
%end
X = fft(data_block);
Y = X.*H;
tmp = ifft(Y);
y2((iteration-1)*M+1:end) = tmp(M+1:end);

%% HW 7-1. time domain filtering
%clear;

now_time = cputime;

[x, fs] = audioread('file_example_MP3_700KB.mp3');
x = x(:, 1); % 2채널 이상 음성파일 -> 1채널로 변경

P = length(x);
M = 8000;
h = 0.01*randn(M,1);

h(1) = 0.7;
h(5000) = 0.2;

y1 = conv(x, h);

disp(['time domain filtering: ' num2str(cputime - now_time)])

%% HW 7-2. frequency domain filtering
%clear;

now_time = cputime;

[x, fs] = audioread('file_example_MP3_700KB.mp3');
x = x(:, 1); % 2채널 이상 음성파일 -> 1채널로 변경

N = length(x);
M = 8000;
h = 0.01*randn(M,1);

h(1) = 0.7;
h(5000) = 0.2;

fftsize = 32768;
blocksize = 16384;
he = [h;zeros(fftsize-M,1)];
H = fft(he);

nblocks = floor(N/blocksize);
y2 = zeros(N,1);

inblock = zeros(fftsize,1);
W = zeros(fftsize,1);
Y = zeros(fftsize,1);
tmp = zeros(fftsize,1);

for k=1:nblocks
    blockbegin = (k-1)*blocksize;
    for m=1:blocksize
        inblock(m) = inblock(m+blocksize);
        inblock(m+blocksize) = x(blockbegin+m);
    end

    U = fft(inblock);
    Y = U.*H;
    tmp = ifft(Y);

    for m = 1:blocksize
        y2(blockbegin+m) = tmp(blocksize+m);
    end
end

disp(['frequency domain filtering: ' num2str(cputime - now_time)])
