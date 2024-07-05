%% HW 7-1. time domain filtering
clear;

now_time = cputime;

[x, fs] = audioread('file_example_MP3_700KB.mp3');
x = x(:, 1); % 2채널 이상 음성파일 -> 1채널로 변경

P = length(x);
M = 8000;
h = 0.01*randn(M,1);

h(1) = 0.7;
h(5000) = 0.2;

y1 = conv(x, h);

disp(['time domain filtering' num2str(cputime - now_time)])

%% HW 7-2. frequency domain filtering
clear;

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

disp(['frequency domain filtering' num2str(cputime - now_time)])
