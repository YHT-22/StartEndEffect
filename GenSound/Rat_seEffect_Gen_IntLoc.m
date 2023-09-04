SoundSavePath_son = strcat(SoundSavePath, "\IntLoc\");
mkdir(fullfile(SoundSavePath_son));
n_Int = 0;
for f0Index = 1:length(f0)
    y0 = Amp * sin(2 * pi * f0(f0Index) * t);
    y0 = genRiseFallEdge(y0, fs, rfTime, "both");

    Int1 = Amp + AmpDiff;
    n_Int = n_Int + 1;
    % control
    audiowrite(fullfile(SoundSavePath_son, [ord(n_Int, :), ...
                        '_f0-', num2str(f0(f0Index)), ...
                        '_Int1-NaN', ...
                        '_ChangeDuration-NaN', ...
                        '_Midpos-NaN', ...
                        '_dur-', num2str(TotalDuration), '.wav']), ...
                        y0, fs);

    for Int1Index = 1:length(Int1)
        if Int1(Int1Index) > 1
            error("Invalid Intensity Input!(Amplitude must less than 1)");
        end
        y1 = rowFcn(@(x) [y0(1:(x - 1)), ...
                          Int1(Int1Index) * sin(2 * pi * f0(f0Index) * (1 / fs:1 / fs:ChangeDuration)), ...
                          y0((x + numel(1 / fs:1 / fs:ChangeDuration)):end)], ...
                          AllChange_Point, "UniformOutput", false);

        % Plot
        plotSize = autoPlotSize(length(AllChange_Point) + 1);
        figure;
        maximizeFig;
        mSubplot(plotSize(1), plotSize(2), 1);
        plot(y0);
        for pIndex = 1:length(AllChange_Point)
            mSubplot(plotSize(1), plotSize(2), pIndex + 1);
            plot(y1{pIndex});
            hold on;
            plot(AllChange_Point(pIndex):(AllChange_Point(pIndex) + floor(ChangeDuration * fs) - 1), ...
                Amp * sin(2 * pi * Int1(Int1Index) * (1 / fs:1 / fs:ChangeDuration)), 'r.');
            title(['f0=', num2str(f0(f0Index)), ' | Int1=', num2str(Int1(Int1Index)), ' | pos=', num2str(AllChange_Point(pIndex) / fs), 's']);
        end
        scaleAxes("y", [-0.6, 0.6]);
        print(gcf, fullfile(strcat(SoundSavePath_son, "fs", strrep(num2str(f0(f0Index)), ".", "o"), "Int", strrep(num2str(Int1(Int1Index)), ".", "o"))), "-djpeg", "-r200");

        % Export
        wave = y1;
        filenames = rowFcn(@(x, y) [ord(n_Int + y, :), ...
                                    '_f0-', num2str(f0(f0Index)), ...
                                    '_Int1-', num2str(Int1(Int1Index)), ...
                                    '_ChangeDuration-', num2str(ChangeDuration), ...
                                    '_pos-', num2str(round(AllChange_Point(y) / fs, 2)), ...
                                    '_dur-', num2str(TotalDuration), '.wav'], ...
                           AllChange_Point, (1:length(AllChange_Point))', "UniformOutput", false);

        cellfun(@(x, y) audiowrite(fullfile(SoundSavePath_son, x), y, fs), filenames, wave, "UniformOutput", false);
        n_Int = n_Int + length(y1);
    end
end
close all;