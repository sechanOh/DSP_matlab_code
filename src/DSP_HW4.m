%% clear datas
clear;
clc;

%% HW 4-1. 음성이나 음악 신호에 2000Hz 사인파를 더한다.
[soundfile, fs] = audioread('file_example_MP3_700KB.mp3');
soundfile = soundfile(:, 1); % 2채널 이상 음성파일 -> 1채널로 변경

f1 = 2000; % 2000Hz
om = f1 / fs * 2 * pi;
N = length(soundfile);
A = 0.2;
x = (1:N)';
soundfile_sin_added = soundfile + A * sin(om * x);
%sound(soundfile_sin_added, fs);

%% HW 4-2. spetrocgram을 본다
fig=figure(1);
plot1 = subplot(2,1,1,'Parent',fig);
specgram(soundfile);
title("Original sound",'FontWeight','bold');
plot2 = subplot(2,1,2,'Parent',fig);
specgram(soundfile_sin_added);
title("Sinewave added",'FontWeight','bold');

limits = clim;
clim(plot1, limits);

fig_axes = axes(fig,'visible','off');
colorbar(fig_axes,'Position',[0.93 0.168 0.022 0.7]);
clim(fig_axes, limits);

%% HW 4-3. 2차/2차 IIR notch filter 적용하여 sinewave 제거
figure(2);
a = -cos(om);
r = 0.99;
sine_stop_filter_numerator = [1 2*a 1];
sine_stop_filter_denominator = [1 (1+r)*a r];
[H, w] = freqz(sine_stop_filter_numerator, sine_stop_filter_denominator);
subplot(2,1,1);
plot(w, abs(H));
grid;
ylim([0 1.1]);
xlim([0 pi]);
title('Sinewave removing');

sinewave_extracted = zeros(N, 1);
for n = 3:N
    for i = 1:length(sine_stop_filter_numerator)
        sinewave_extracted(n) = sinewave_extracted(n) + sine_stop_filter_numerator(i) * soundfile_sin_added(n-i+1);
    end
    for i = 2:length(sine_stop_filter_denominator)
        sinewave_extracted(n) = sinewave_extracted(n) - sine_stop_filter_denominator(i) * sinewave_extracted(n-i+1);
    end
end

plot3 = subplot(2,1,2);
specgram(sinewave_extracted);
title("Sinewave removed",'FontWeight','bold');
clim(plot3, limits);
colorbar(plot3);

%% HW 4-4. 2차/2차 IIR notch filter 적용하여 sinewave 추출
figure(3);
a = -cos(om);
r = 0.99;
sine_pass_filter_numerator = [0 a*(r-1) (r-1)];
sine_pass_filter_denominator = [1 (1+r)*a r];
[H, w] = freqz(sine_pass_filter_numerator, sine_pass_filter_denominator);
subplot(2,1,1);
plot(w, abs(H));
grid;
ylim([0 1.1]);
xlim([0 pi]);
title('Sinewave extracting');

sinewave_extracted = zeros(N, 1);
for n = 3:N
    for i = 1:length(sine_pass_filter_numerator)
        sinewave_extracted(n) = sinewave_extracted(n) + sine_pass_filter_numerator(i) * soundfile_sin_added(n-i+1);
    end
    for i = 2:length(sine_pass_filter_denominator)
        sinewave_extracted(n) = sinewave_extracted(n) - sine_pass_filter_denominator(i) * sinewave_extracted(n-i+1);
    end
end

plot4 = subplot(2,1,2);
specgram(sinewave_extracted);
title("Sinewave removed",'FontWeight','bold');
clim(plot4, limits);
colorbar(plot4);

%% 질문
figure(4);
a = -cos(om);
r = 0.99;
sine_stop_filter_numerator = [1 2*a 1];
sine_stop_filter_denominator = [1 (1+r)*a r];
[H, w] = freqz(sine_stop_filter_numerator, sine_stop_filter_denominator);
subplot(2,2,1);
plot(w, abs(H));
grid;
ylim([0 1.1]);
xlim([0 pi]);
title(['omega: ' num2str(om/pi) ' pi']);

a = -cos(om);
r = 0.99;
sine_pass_filter_numerator = [0 a*(r-1) (r-1)];
sine_pass_filter_denominator = [1 (1+r)*a r];
[H, w] = freqz(sine_pass_filter_numerator, sine_pass_filter_denominator);
subplot(2,2,2);
plot(w, abs(H));
grid;
ylim([0 1.1]);
xlim([0 pi]);
title(['omega: ' num2str(om/pi) ' pi']);

new_om = pi/16;

a = -cos(new_om);
r = 0.99;
sine_stop_filter_numerator = [1 2*a 1];
sine_stop_filter_denominator = [1 (1+r)*a r];
[H, w] = freqz(sine_stop_filter_numerator, sine_stop_filter_denominator);
subplot(2,2,3);
plot(w, abs(H));
grid;
ylim([0 1.1]);
xlim([0 pi]);
title(['omega: ' num2str(new_om/pi) ' pi']);

a = -cos(new_om);
r = 0.99;
sine_pass_filter_numerator = [0 a*(r-1) (r-1)];
sine_pass_filter_denominator = [1 (1+r)*a r];
[H, w] = freqz(sine_pass_filter_numerator, sine_pass_filter_denominator);
subplot(2,2,4);
plot(w, abs(H));
grid;
ylim([0 1.1]);
xlim([0 pi]);
title(['omega: ' num2str(new_om/pi) ' pi']);

