%% HW 7. 
clear; clc;

%x = [1 3 4 2 1 2 2 1]';
x = [1 3 4 3 5 7 6 3 4 6 7 7 4 2 4 6 4]';
h = [1 2 1]';

tmp=cputime; y1=conv(h,x);         time_spent1=cputime-tmp;
tmp=cputime; y2=overlabSave(x, h); time_spent2=cputime-tmp;

if isequal(y1, y2)
    disp('y1과 y2는 같습니다.');
else
    disp('y1과 y2는 다릅니다.');
end

disp(['convolution 실행시간:  ' num2str(time_spent1)]);
disp(['overlap save 실행시간: ' num2str(time_spent2)]);

function output = overlabSave(x, h)
    N = pow2(ceil(log2(length(h))));
    M = N / 2;
    
    zero_padding_h = zeros(N, 1);
    zero_padding_h(1:length(h)) = h;

    remain = mod(length(x),M);
    zero_padding_x = cat(1,x(:),zeros(M - remain,1));
    
    H = fft(zero_padding_h);
    
    iteration = floor(length(zero_padding_x)/M);
    output = zeros(iteration*M+remain, 1);
    
    data_block = zeros(N, 1);
    for n = 1:iteration
        data_block(1:M) = data_block(M+1:end);
        data_block(M+1:end) = zero_padding_x((n-1)*M+1:n*M);
        X = fft(data_block);
        Y = X.*H;
        tmp = ifft(Y);
        output((n-1)*M+1:n*M) = tmp(M+1:end);
    end
    
    if remain > 0
        data_block(1:M) = data_block(M+1:end);
        data_block(M+1:end) = zeros(M, 1);
        X = fft(data_block);
        Y = X.*H;
        tmp = ifft(Y);
        output(iteration*M+1:end) = tmp(M+1:M+remain);
    end
end

%% Lecture 6-1 page.14 : time domain filtering
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

disp(['time domain filtering: ' num2str(cputime - now_time)])

%% Lecture 6-1 page.14 : frequency domain filtering
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

disp(['frequency domain filtering: ' num2str(cputime - now_time)])
