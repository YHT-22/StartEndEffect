clear;
Fs = 195312;            % Sampling frequency 
T = 1/Fs;             % Sampling period
f0 = 1000;
DiffRatio = [0, 1e-4/8, 1e-4/4, 1e-4/2, 1e-4, 1e-4 * 2, 1e-4 * 4, 1e-4 * 8];
% DiffRatio = [1, 4, 9, 16, 25, 36];
soundf = f0 * (1 + DiffRatio);
sL = 0.3;             % Length of signal

for i = 1:numel(soundf)
    clearvars -except Fs T i soundf sL
    t = T:T:sL;
    y0 = 0.5 * sin(2 * pi * soundf(i) * t);
    
%     L = length(y0);
%     Y = fft(y0);
%     P2 = abs(Y/L);
%     P1 = P2(1:L/2+1);
%     P1(2:end-1) = 2*P1(2:end-1);
%     f = Fs*(0:(L/2))/L;
    
    subplot(2, 4, i);
    plot(y0);hold on;
    plot(t * Fs, y0, '.r');
    ylim([-0.8, 0.8]);
    xlim([0 length(y0)/5]);
    text(1000, 0.7, strcat("f = ", num2str(soundf(i)), "Hz"));
    title(strcat("采样率Fs = ",num2str(Fs)));
end
