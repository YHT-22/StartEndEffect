function SoundParams = getSoundParams_DurChangeAbsolute(SoundConfig)
    %Tone Sequence
    ToneFreqMin = double(string(SoundConfig.ToneFreqMin));
    eval(SoundConfig.ToneFreqGen)
    SoundParams.f0 = ToneFreqSeq;%Hz

    %Change Params
    SoundParams.FreqDiffRatio = cell2mat(cellfun(@str2num, regexp(string(SoundConfig.FreqDiffRatio), ',', 'split'), "UniformOutput", false));
    SoundParams.ChangePosition = cell2mat(cellfun(@str2num, regexp(string(SoundConfig.ChangePosition), ',', 'split'), "UniformOutput", false));%sec
    SoundParams.ChangeDuration = SoundConfig.ChangeDuration;%sec

    %others
    SoundParams.fs = SoundConfig.fs;%Hz
    SoundParams.TotalDuration = SoundConfig.TotalDuration;%sec
    SoundParams.StdNum = SoundConfig.StdNum;
    SoundParams.OddballBlankChoice = double(string(SoundConfig.OddballBlankChoice));
    SoundParams.OddballBlankDuration = double(string(SoundConfig.OddballBlankDuration));
    return;
end