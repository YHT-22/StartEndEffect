function [signal_connect] = Connect_Tone(f1, f2, f3, Amp1, Amp2, Amp3, Dur1, Dur2, Dur3, fs)
% 设置参数
% fs = 97656; % 采样率
% 输入的segDur以s为单位
% 生成若干个相位连续的正弦信号
n1 = round(Dur1*fs); % 采样点数
t1 = (0:n1-1)/fs; % 时间向量
n2 = round(Dur2*fs); % 采样点数
t2 = (0:n2-1)/fs; % 时间向量
n3 = round(Dur3*fs); % 采样点数
t3 = (0:n3-1)/fs; % 时间向量
phi = 0; % 初始相位为0


%% S1S2S3
s1 = Amp1 * sin(2*pi*f1*(t1 + phi)); % 第一个信号
phi = mod(phi + 2*pi*f1*Dur1, 2*pi); % 更新相位，使得s1, s2两个信号之间相位连续
% phi = angle(s1(end-1));
s2 = Amp2 * sin(2*pi*f2*t2 + phi); % 第二个信号
phi = mod(phi + 2*pi*f2*Dur2, 2*pi); % 更新相位，使得s2, s3两个信号之间相位连续
s3 = Amp3 * sin(2*pi*f3*t3 + phi); % 第三个信号
% 将两个信号交替排列
signal_connect = [s1, s2, s3];

