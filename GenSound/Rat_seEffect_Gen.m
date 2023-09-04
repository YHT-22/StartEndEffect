%% start-end effect pure tone
ccc;

ord = arrayfun(@(x) strrep(x, ' ', '0'), num2str((1:1000)'));
SoundRootPath = "K:\Program\RatLA_StartEndEffect\sound\";
SoundConfigPath = 'K:\Program\RatLA_StartEndEffect\sound\Sound_Config.xlsx';
SoundConfigSheet = "PeriodChange";

SoundNumber = [3.1562, 3.1563, 3.171, 3.172, 3.181, 3.182];

%% Params
% -----------------fixed time params---------------------
% risefall time, in sec;
rfTime = 1e-3;
% wave amp, in volt
Amp = 0.5;

% -----------------get sound params---------------------
Sound_Config_temp = table2struct(readtable(SoundConfigPath, "Sheet", SoundConfigSheet));

%% Generate
for soundNumIdx = 1 : numel(SoundNumber) 
    disp(strcat("Generate No.", string(SoundNumber(soundNumIdx)), " now..."));
   
    %%%%%%%%%%%%%%%%%%%%%%% inition
    Sound_idx = find(cell2mat({Sound_Config_temp.Number}) == SoundNumber(soundNumIdx));
    Sound_Config = Sound_Config_temp(Sound_idx);
    switch SoundConfigSheet
        case "DurChangePercent"
            SoundParams = getSoundParams_DurChangePercent(Sound_Config);
            parseStruct(SoundParams);
            ChangeDuration = TotalDuration * ChangePercent;
            if ChangePosition + ChangeDuration > TotalDuration
                error("Change part is longer than TotalDuration!");
            end
        case "DurChangeAbsolute"
            SoundParams = getSoundParams_DurChangeAbsolute(Sound_Config);
            parseStruct(SoundParams);
            if ChangePosition + ChangeDuration > TotalDuration
                error("Change part is longer than TotalDuration!");
            end
        case "PeriodChange"
            SoundParams = getSoundParams_PeriodChange(Sound_Config);
            parseStruct(SoundParams);

    end 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%% make sound save dir
    f0SeqStr = [];
    for f0idx = 1 : numel(f0)
        f0SeqStr = strcat(f0SeqStr, '-', string(f0(f0idx)));
    end
    FreqDiffRatioStr = [];
    for fDifflevel = 1 : numel(FreqDiffRatio)
        FreqDiffRatioStr = strcat(FreqDiffRatioStr, '_', string(FreqDiffRatio(fDifflevel)));
    end
    if strcmp(SoundConfigSheet, "PeriodChange")
        SoundSavePath = strcat(SoundRootPath, datestr(now, "yyyy-mm-dd"), '_No.', string(SoundNumber(soundNumIdx)), ...
            '_f0Seq', f0SeqStr, '_SoundDur', string(TotalDuration * 1000), 'ms', '_nChangePeriod', string(ChangePeriod), ...
            '_FDiffRatio', FreqDiffRatioStr);
    else
        SoundSavePath = strcat(SoundRootPath, datestr(now, "yyyy-mm-dd"), '_No.', string(SoundNumber(soundNumIdx)), ...
            '_f0Seq', f0SeqStr, '_SoundDur', string(TotalDuration * 1000), 'ms', '_ChangeDur', string(ChangeDuration * 1000), 'ms', ...
            '_FDiffRatio', FreqDiffRatioStr);
    end
    mkdir(fullfile(SoundSavePath));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%% Gen sound Fcn
    % time point
    t = 1 / fs:1 / fs:TotalDuration;
    if strcmp(SoundConfigSheet, "PeriodChange")
        % Generate Single tones
        run("Rat_seEffect_Gen_Single_FreqLoc_changePeriod.m");
        % Generate Oddball Sequence
%         run("Rat_seEffect_Gen_Oddball_FreqLoc_changePeriod.m");
    elseif contains(SoundConfigSheet, "DurChange")
        % Generate Single tones
        run("Rat_seEffect_Gen_Single_FreqLoc_changeDur.m");
        % Generate Oddball Sequence
        run("Rat_seEffect_Gen_Oddball_FreqLoc_changeDur.m");
    end
end