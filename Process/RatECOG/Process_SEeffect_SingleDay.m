close all; clc; clear;
addpath(genpath("K:\Programe\ECOGProcess"), "-begin");
rmpath(genpath("K:\Programe\Tool_box"));

[~, ~, RawMessage] = xlsread('K:\DATA_202307_RatECOG_StartEndEffect\RatECOG_SEeffect_DataRecording.xlsx', 'Sheet1', 'A90:E90');
SaveROOTPATH = 'K:\ANALYSIS_202307_RatECOG_StartEndEffect\';
MATPATH = 'K:\DATA_202307_RatECOG_StartEndEffect\Data\Mat\';
SoundRootPATH = 'K:\Program\RatLA_StartEndEffect\sound\';
SubjName = RawMessage(:, 1);
DateStrs = RawMessage(:, 2);
ProtocolStrs = RawMessage(:, 5);
params.posIndex = 3; % 1-AC, 2-PFC, 3-Llfp
params.processFcn = @PassiveProcess_clickTrainContinuous;
AREANAME = {['NaN'], ['NaN'], ['AC']};
AREANAME = AREANAME{params.posIndex};
MATPATHs = cellfun(@(x, y, z) [MATPATH, x, '\', y, '\', z, '_', AREANAME], SubjName, ProtocolStrs, DateStrs, "UniformOutput", false);
%others
icaOpt = "on";
fhp_filte2 = 0.1;
flp_filte2 = 20;
fsD = 500;%for cwt

%%
for mIndex = 1 : length(MATPATHs)
    clear cdrPlot pairTypes chMean chMean_filte chStd chStd_filte TFR coi ChangeTime lines
    %% make dir
    temp = string(split(MATPATHs{mIndex}, '\'));
    DateStr_temp = regexpi(temp(end), '_', 'split');
    DateStr = DateStr_temp(end - 1);
    ProtocolStr = temp(end - 1);
    FIGPATH = strcat(SaveROOTPATH, ProtocolStr, "\", DateStr, "\");
    mkdir(fullfile(FIGPATH));

    %% load data .mat
    run("SEeffectParamsSetting_ECOG.m");
    run("SEeffectLoadData_ECOG.m");
    run("RatECOG_ICA.m");
    % badCH
    trialsECOG = interpolateBadChs_RatECOG(trialsECOG, badCHs);

    %% process
    % trial
    ordertemp = cell2mat({trialAll.ordrSeq}');
    devtype = unique(ordertemp);
    t = linspace(trialonset_Window(1), trialonset_Window(2), diff(trialonset_Window) / 1000 * fs + 1);
    trialsECOG_Filtered = ECOGFilter(trialsECOG, fhp_filte2, flp_filte2, fs);
    ChangeTimeLines = unique(ChangeTime);

    for dIndex = 1:length(devtype)
        trial_idx = find(ordertemp == devtype(dIndex));
        trialsECOG_temp = trialsECOG(trial_idx);
        trialsECOG_Filtered_temp = trialsECOG_Filtered(trial_idx);
        
        chMean{dIndex} = cell2mat(cellfun(@mean, changeCellRowNum(trialsECOG_temp), "UniformOutput", false));
        chStd{dIndex} = cell2mat(cellfun(@(x) std(x)/sqrt(length(trial_idx)), changeCellRowNum(trialsECOG_temp), "UniformOutput", false));
        chMean_filte{dIndex} = cell2mat(cellfun(@mean, changeCellRowNum(trialsECOG_Filtered_temp), "UniformOutput", false));
        chStd_filte{dIndex} = cell2mat(cellfun(@(x) std(x)/sqrt(length(trial_idx)), changeCellRowNum(trialsECOG_Filtered_temp), "UniformOutput", false));

        % Plot cwt
        [TFR{dIndex}, t_fsD, f, coi{dIndex}] = computeTFR(chMean{dIndex}, fs, fsD, trialonset_Window);
        t_idx = find(t_fsD > CWTplotWindow(1) & t_fsD < CWTplotWindow(2));
        t_fsD_win = t_fsD(t_idx);
        FigCWT(dIndex) = plotCWT_RatECOG(cellfun(@(x) x(:, t_idx), TFR{dIndex}, "UniformOutput", false), t_fsD_win/1000, f, coi{dIndex}(t_idx));
        h_anno = annotation(FigCWT(dIndex), "textbox", [0.03, 0.9, 0.1, 0.05], "LineStyle", 'none', "FontSize", 10, "String", strrep(TrialTypes(dIndex), "_", "-"), 'FitBoxToText', 'on');
        for changeLinesNum = 1 : numel(ChangeTimeLines)
            lines(changeLinesNum).X = ChangeTimeLines(changeLinesNum); lines(changeLinesNum).color = "k";
        end
        scaleAxes(FigCWT(dIndex), "x", CWTplotWindow);
        scaleAxes(FigCWT(dIndex), "y", "on");
        pause(1);
        addLines2Axes(FigCWT(dIndex), lines);
        print(FigCWT(dIndex), strcat(FIGPATH, "CWT_", strrep(TrialTypes(dIndex), "_", "-"), ".jpg"), "-djpeg", "-r200");
    end
    save(strcat(FIGPATH, "ProcessData.mat"), "chMean", "chStd", "ChangeTime", "ProtocolStr", "TrialTypes", "t", "GroupTypes", "-mat");
    %% plot
    RatECOGPos = RatECOGPosConfig();
    for groupnum = 1 : size(GroupTypes, 1)
        clear h_FigCompare h_FigCompare_filte pairTypes pairTypes_filte pairMMN legendStrs;
        for submember = 1 : numel(GroupTypes{groupnum})
            pairTypes(submember).chMean = chMean{GroupTypes{groupnum}(submember)};
            pairTypes(submember).color = colors(submember);
            pairTypes_filte(submember).chMean = chMean_filte{GroupTypes{groupnum}(submember)};
            pairTypes_filte(submember).color = colors(submember);
            %MMN
            pairMMN(submember).chMean = chMean{GroupTypes{groupnum}(submember)} - chMean{GroupTypes{groupnum}(1)};%GroupTypes中第1个数字作为对照组的order
            pairMMN(submember).color = colors(submember);
        end

        legendStrs = strrep(TrialTypes(GroupTypes{groupnum})', "_", "-");
        f0All = unique(cellfun(@(x) double(x(1)), regexpi(legendStrs, "-", "split"))');
        diffratioAll = unique(cellfun(@(x) x(end), regexpi(legendStrs, "-", "split")));
        posAll = unique(cellfun(@(x) x(2), regexpi(legendStrs, "-", "split")));

        for changeLinesNum = 1 : numel(ChangeTimeLines)
            lines(changeLinesNum).X = ChangeTimeLines(changeLinesNum); lines(changeLinesNum).color = "k";
        end
        %raw wave
        FigCompare(groupnum) = plotRawWaveMulti_RatECOG(pairTypes, trialonset_Window, RatECOGPos);
        orderLine(FigCompare(groupnum), "LineStyle", "--", "bottom");
        h_FigCompare = get(FigCompare(groupnum));
        legend(h_FigCompare.Children(32), legendStrs);
        scaleAxes(FigCompare(groupnum), "x", plotWindow);
        scaleAxes(FigCompare(groupnum), "y", "on", "symOpt", "max");
        pause(1);
        addLines2Axes(FigCompare(groupnum), lines);
        print(FigCompare(groupnum), strcat(FIGPATH, "f0", join(string(f0All), ","), "_dev", join(string(diffratioAll), "-"), "_", join(string(posAll), "-"), ".jpg"), "-djpeg", "-r200");
        %filte
%         FigCompare_filte(groupnum) = plotRawWaveMulti_RatECOG(pairTypes_filte, trialonset_Window, RatECOGPos);     
%         orderLine(FigCompare_filte(groupnum), "LineStyle", "--", "bottom");
%         h_FigCompare_filte = get(FigCompare_filte(groupnum));
%         legend(h_FigCompare_filte.Children(32), legendStrs);
%         scaleAxes(FigCompare_filte(groupnum), "x", plotWindow);
%         scaleAxes(FigCompare_filte(groupnum), "y", "on", "symOpt", "max");
%         addLines2Axes(FigCompare_filte(groupnum), lines);
%         print(FigCompare_filte(groupnum), strcat(FIGPATH, "f0", join(string(f0All), ","), "_dev", join(string(diffratioAll), "-"), "_pos", join(string(posAll), "-"), "_filte.jpg"), "-djpeg", "-r200");

        % MMN
        if plotMMN == 1
            % plot
            FigMMN(groupnum) = plotRawWaveMulti_RatECOG(pairMMN(2:end), trialonset_Window, RatECOGPos); 
            orderLine(FigMMN(groupnum), "LineStyle", "--", "bottom");
            h_FigMMN = get(FigMMN(groupnum));
            legend(h_FigMMN.Children(32), legendStrs(2:end));
            scaleAxes(FigMMN(groupnum), "x", plotWindow);
            pause(1);
            addLines2Axes(FigMMN(groupnum), lines);
            print(FigMMN(groupnum), strcat(FIGPATH, "f0", join(string(f0All), ","), "_dev", join(string(diffratioAll), "-"), "_pos", join(string(posAll), "-"), "_MMN.jpg"), "-djpeg", "-r200");
        end
        close all;
    end
end
