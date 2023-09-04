
n_Freq = 0;
for f0Index = 1:length(f0)
    n = 0;
    SoundSavePath_son = strcat(SoundSavePath, "\Single_FreqLoc\fs", num2str(f0(f0Index)), "\");
    mkdir(fullfile(SoundSavePath_son));

    y0 = Amp * sin(2 * pi * f0(f0Index) * t);
    y0_addrisefall = genRiseFallEdge(y0, fs, rfTime, "both");

    f1 = roundn(f0(f0Index) * (1 + FreqDiffRatio), -1);
    n_Freq = n_Freq + 1;
    n = n + 1;
    % control
    soundinfo(n).name = [ord(n_Freq, :), ...
                        '_f0-', num2str(f0(f0Index)), ...
                        '_DiffRatio-NaN', ...
                        '_ChangeDuration-NaN', ...
                        '_pos-NaN', ...
                        '_dur-', num2str(TotalDuration), 's.wav'];
    soundinfo(n).wave = y0_addrisefall;
    soundinfo(n).changestage = [0, 0];
    soundinfo(n).fs = fs;
    audiowrite(fullfile(SoundSavePath_son, soundinfo(1).name), y0_addrisefall, fs);
    
    for f1Index = 1:length(f1)
        y1 = rowFcn(@(x) Connect_Tone(f0(f0Index), f1(f1Index), f0(f0Index), Amp, Amp, Amp, ...
            x, ChangeDuration, (TotalDuration - x - ChangeDuration), fs),...
            ChangePosition', "UniformOutput", false);
        y1_addrisefall = cellfun(@(x) genRiseFallEdge(x, fs, rfTime, "both"), y1, "UniformOutput", false);

        %% Plot
        plotSize = autoPlotSize(length(ChangePosition) + 1);
        figure;
        maximizeFig;
        mSubplot(plotSize(1), plotSize(2), 1);
        plot(y0);
        for pIndex = 1:length(ChangePosition)
            mSubplot(plotSize(1), plotSize(2), pIndex + 1);
            plot(y1_addrisefall{pIndex});
            hold on;
            plot(ChangePosition(pIndex) * fs:(ChangePosition(pIndex) + ChangeDuration) * fs, ...
                y1_addrisefall{pIndex}(1, ChangePosition(pIndex) * fs:(ChangePosition(pIndex) + ChangeDuration) * fs), 'r.');
            title(['f0=', num2str(f0(f0Index)), ' | f1=', num2str(f1(f1Index)), ' | pos=', num2str(ChangePosition(pIndex)), 's']);
        end
        scaleAxes("y", [-0.6, 0.6]);
        print(gcf, fullfile(strcat(SoundSavePath_son, "f0", strrep(num2str(f0(f0Index)), '.', 'o'), "f1", strrep(num2str(f1(f1Index)), '.', 'o'))), "-djpeg", "-r200");
        %% Export
        Change_Start = ChangePosition * 1000;%in ms
        Change_End = (ChangePosition + ChangeDuration) * 1000;%in ms
        wave = y1_addrisefall;
        filenames = rowFcn(@(x, y) [ord(n_Freq + y, :), ...
                                    '_f0-', num2str(f0(f0Index)), ...
                                    '_DiffRatio-', num2str(f1(f1Index) / f0(f0Index)), ...
                                    '_ChangeDuration-', num2str(ChangeDuration * 1000), 'ms' ...
                                    '_pos-', num2str(ChangePosition(y) * 1000), 'ms', ...
                                    '_dur-', num2str(TotalDuration * 1000), 'ms.wav'], ...
                                    ChangePosition', (1:length(ChangePosition))', "UniformOutput", false);
        cellfun(@(x, y) audiowrite(fullfile(SoundSavePath_son, x), y, fs), filenames, wave, "UniformOutput", false);
        n_Freq = n_Freq + length(y1);
        for soundType = 1:numel(wave)
            soundinfo(n + soundType).name = filenames{soundType};
            soundinfo(n + soundType).wave = wave{soundType};
            soundinfo(n + soundType).changestage = [Change_Start(soundType), Change_End(soundType)];
            soundinfo(n + soundType).fs = fs;
        end
        n = n + length(y1);
    end
    save(strcat(SoundSavePath_son, 'SoundSequence.mat'), "soundinfo", "-mat");
end
close all;