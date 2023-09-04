
n_FreqSeq = 0;
for f0Index = 1:length(f0)
    n = 0;
    SoundSavePath_son = strcat(SoundSavePath, "\Oddball_FreqLoc\fs", num2str(f0(f0Index)), "\");
    mkdir(fullfile(SoundSavePath_son));

    y0 = Amp * sin(2 * pi * f0(f0Index) * t);
    y0_addrisefall = genRiseFallEdge(y0, fs, rfTime, "both");
    if OddballBlankChoice == 0
        y0_std = repmat([y0_addrisefall, zeros(1, length(y0_addrisefall))], 1, StdNum);
    elseif OddballBlankChoice == 1
        y0_std = repmat([y0_addrisefall, zeros(1, round(OddballBlankDuration * fs, 0))], 1, StdNum);           
    end

    f1 = roundn(f0(f0Index) * (1 + FreqDiffRatio), -1);
    n_FreqSeq = n_FreqSeq + 1;
    n = n + 1;
    % control
    soundinfo(n).name = [ord(n_FreqSeq, :), ...
                        '_Std_f0-', num2str(f0(f0Index)), ...
                        '_DiffRatio-NaN', ...
                        '_ChangeDuration-NaN', ...
                        '_pos-NaN', ...
                        '_dur-', num2str(TotalDuration), 's', ...
                        '_stdNum_', num2str(StdNum), '.wav'];
    if OddballBlankChoice == 0
        soundinfo(n).wave = [y0_std, y0_addrisefall, zeros(1, length(y0_addrisefall))]; 
        soundinfo(n).preOddOnset = (length(repmat([y0_addrisefall, zeros(1, length(y0_addrisefall))], 1, StdNum - 1)) / fs) * 1000;
    elseif OddballBlankChoice == 1
        soundinfo(n).wave = [y0_std, y0_addrisefall, zeros(1, round(OddballBlankDuration * fs, 0))]; 
        soundinfo(n).preOddOnset = (length(repmat([y0_addrisefall, zeros(1, round(OddballBlankDuration * fs, 0))], 1, StdNum - 1)) / fs) * 1000;
    end
    soundinfo(n).DevOnset = (length(y0_std) / fs) * 1000;
    soundinfo(n).changestage = [0, 0];
    soundinfo(n).fs = fs;
    audiowrite(fullfile(SoundSavePath_son, soundinfo(n).name), soundinfo(n).wave, fs);

    for f1Index = 1:length(f1)
        y1 = rowFcn(@(x) Connect_Tone(f0(f0Index), f1(f1Index), f0(f0Index), Amp, Amp, Amp, ...
            x, ChangeDuration, (TotalDuration - x - ChangeDuration), fs),...
            ChangePosition', "UniformOutput", false);
        y1_addrisefall = cellfun(@(x) genRiseFallEdge(x, fs, rfTime, "both"), y1, "UniformOutput", false);
        if OddballBlankChoice == 0
            wave = cellfun(@(x) [y0_std, x, zeros(1, length(x))], y1_addrisefall, "UniformOutput", false);                      
        elseif OddballBlankChoice == 1
            wave = cellfun(@(x) [y0_std, x, zeros(1, round(OddballBlankDuration * fs, 0))], y1_addrisefall, "UniformOutput", false);           
        end

        %% Plot
        plotSize = autoPlotSize(length(ChangePosition) + 1);
        figure;
        maximizeFig;
        mSubplot(plotSize(1), plotSize(2), 1);
        if OddballBlankChoice == 0
            plot([y0_std, y0_addrisefall, zeros(1, length(y0_addrisefall))]);                      
        elseif OddballBlankChoice == 1
            plot([y0_std, y0_addrisefall, zeros(1, round(OddballBlankDuration * fs, 0))]);             
        end

        for pIndex = 1:length(ChangePosition)
            mSubplot(plotSize(1), plotSize(2), pIndex + 1);
            plot(wave{pIndex});
            hold on;
            plot([ChangePosition(pIndex) * fs:(ChangePosition(pIndex) + ChangeDuration) * fs] + length(y0_std), ...
                y1_addrisefall{pIndex}(1, ChangePosition(pIndex) * fs:(ChangePosition(pIndex) + ChangeDuration) * fs), 'r.');
            title(['f0=', num2str(f0(f0Index)), ' | f1=', num2str(f1(f1Index)), ' | pos=', num2str(ChangePosition(pIndex)), 's']);
        end
        scaleAxes("y", [-0.6, 0.6]);
        print(gcf, fullfile(strcat(SoundSavePath_son, "f0", strrep(num2str(f0(f0Index)), '.', 'o'), "f1", strrep(num2str(f1(f1Index)), '.', 'o'))), "-djpeg", "-r200");
        %% Export
        Change_Start = ((length(y0_std) / fs) + ChangePosition) * 1000;%in ms
        Change_End = ((length(y0_std) / fs) + ChangePosition + ChangeDuration) * 1000;%in ms
        filenames = rowFcn(@(x, y) [ord(n_FreqSeq + y, :), ...
                                    '_Dev_f0-', num2str(f0(f0Index)), ...
                                    '_DiffRatio-', num2str(f1(f1Index) / f0(f0Index)), ...
                                    '_ChangeDuration-', num2str(ChangeDuration * 1000), 'ms', ...
                                    '_pos-', num2str(ChangePosition(y) * 1000), 'ms', ...
                                    '_dur-', num2str(TotalDuration * 1000), 'ms', ...
                                    '_stdNum_', num2str(StdNum), '.wav'], ...
                           ChangePosition', (1:length(ChangePosition))', "UniformOutput", false);

        cellfun(@(x, y) audiowrite(fullfile(SoundSavePath_son, x), y, fs), filenames, wave, "UniformOutput", false);
        n_FreqSeq = n_FreqSeq + length(y1);
        for soundType = 1:numel(wave)
            soundinfo(n + soundType).name = filenames{soundType};
            soundinfo(n + soundType).wave = wave{soundType};
            soundinfo(n + soundType).changestage = [Change_Start(soundType), Change_End(soundType)];
            if OddballBlankChoice == 0
                soundinfo(n + soundType).preOddOnset = (length(repmat([y0_addrisefall, zeros(1, length(y0_addrisefall))], 1, StdNum - 1)) / fs) * 1000;                          
            elseif OddballBlankChoice == 1
                soundinfo(n + soundType).preOddOnset = (length(repmat([y0_addrisefall, zeros(1, round(OddballBlankDuration * fs, 0))], 1, StdNum - 1)) / fs) * 1000;                                                     
            end
            soundinfo(n + soundType).DevOnset = (length(y0_std) / fs) * 1000;            
            soundinfo(n + soundType).fs = fs;
        end
        n = n + length(y1);
    end
    save(strcat(SoundSavePath_son, 'SoundSequence.mat'), "soundinfo", "-mat");   
end
close all;