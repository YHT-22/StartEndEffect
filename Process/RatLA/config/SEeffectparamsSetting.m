keyboard;
switch ProtocolStrs{proIdx}
    case "SingleDur100"
        TrialType0 = ["f0_Nochange", "f0_Head_0.005", "f0_Middle_0.005","f0_Tail_0.005",...
                     "f0_Head_0.01", "f0_Middle_0.01", "f0_Tail_0.01", ...
                      "f0_Head_0.05", "f0_Middle_0.05", "f0_Tail_0.05"];
        SEeffectparams.f0 = 4458;
        SEeffectparams.TrialTypes = strrep(TrialType0, "f0", num2str(SEeffectparams.f0));
        SEeffectparams.Duration = 100;% ms
        SEeffectparams.ChangePercent = 0.1;%
        SEeffectparams.ChangePosition = [3, 45, 87];% ms
        SEeffectparams.loadSoundchoice = false;
        SEeffectparams.PSTHPlotwindow = [0, SEeffectparams.Duration];% ms
        SEeffectparams.RasterPlotwindow = [0, 200];% ms
        SEeffectparams.bin = 20;% ms
        SEeffectparams.step = 10;% ms
        parseStruct(SEeffectparams);
        if loadSoundchoice
            keyboard;
            load(strcat('K:\Program\RatLA_StartEndEffect\sound\2023-07-08_ConfigNumber_1\Single_FreqLoc\fs', num2str(f0), '\SoundSequence.mat'));
            SEeffectparams.ChangeTime = {soundinfo.changestage}';
        else
            SEeffectparams.ChangeTime = cat(1, {[0,0]}, ...
           repmat({[SEeffectparams.ChangePosition(1), SEeffectparams.ChangePosition(1) + SEeffectparams.Duration * SEeffectparams.ChangePercent];...
           [SEeffectparams.ChangePosition(2) SEeffectparams.ChangePosition(2) + SEeffectparams.Duration * SEeffectparams.ChangePercent];...
           [SEeffectparams.ChangePosition(3) SEeffectparams.ChangePosition(3) + SEeffectparams.Duration * SEeffectparams.ChangePercent]}, 3, 1));
        end

    case "SingleDur300"
        TrialType0 = ["f0_Nochange", "f0_Head_0.005", "f0_Middle_0.005","f0_Tail_0.005",...
                     "f0_Head_0.01", "f0_Middle_0.01", "f0_Tail_0.01", ...
                      "f0_Head_0.05", "f0_Middle_0.05", "f0_Tail_0.05"];
        SEeffectparams.f0 = 4458;
        SEeffectparams.TrialTypes = strrep(TrialType0, "f0", num2str(SEeffectparams.f0));
        SEeffectparams.Duration = 300;% ms
        SEeffectparams.ChangePercent = 0.1;%
        SEeffectparams.ChangePosition = [3, 135, 267];% ms
        SEeffectparams.loadSoundchoice = false;
        SEeffectparams.PSTHPlotwindow = [0, SEeffectparams.Duration];% in ms
        SEeffectparams.RasterPlotwindow = [0, 600];% ms
        SEeffectparams.bin = 20;% ms
        SEeffectparams.step = 10;% ms
        parseStruct(SEeffectparams);
        if loadSoundchoice
            keyboard;
            load(strcat('K:\Program\RatLA_StartEndEffect\sound\2023-07-08_ConfigNumber_2\Single_FreqLoc\fs', num2str(f0), '\SoundSequence.mat'));
            SEeffectparams.ChangeTime = {soundinfo.changestage}';
        else
            SEeffectparams.ChangeTime = cat(1, {[0,0]}, ...
           repmat({[SEeffectparams.ChangePosition(1), SEeffectparams.ChangePosition(1) + SEeffectparams.Duration * SEeffectparams.ChangePercent];...
           [SEeffectparams.ChangePosition(2) SEeffectparams.ChangePosition(2) + SEeffectparams.Duration * SEeffectparams.ChangePercent];...
           [SEeffectparams.ChangePosition(3) SEeffectparams.ChangePosition(3) + SEeffectparams.Duration * SEeffectparams.ChangePercent]}, 3, 1));
        end

    case "SingleDur500"
        TrialType0 = ["f0_Nochange", "f0_Head_0.005", "f0_Middle_0.005","f0_Tail_0.005",...
                     "f0_Head_0.01", "f0_Middle_0.01", "f0_Tail_0.01", ...
                      "f0_Head_0.05", "f0_Middle_0.05", "f0_Tail_0.05"];
        SEeffectparams.f0 = 4458;
        SEeffectparams.TrialTypes = strrep(TrialType0, "f0", num2str(SEeffectparams.f0));
        SEeffectparams.Duration = 500;% ms
        SEeffectparams.ChangePercent = 0.1;%
        SEeffectparams.ChangePosition = [3, 225, 447];% ms
        SEeffectparams.loadSoundchoice = false;
        SEeffectparams.PSTHPlotwindow = [0, SEeffectparams.Duration];% in ms
        SEeffectparams.RasterPlotwindow = [0, 1000];% ms
        SEeffectparams.bin = 20;% ms
        SEeffectparams.step = 10;% ms
        parseStruct(SEeffectparams);
        if loadSoundchoice
            keyboard;
            load(strcat('K:\Program\RatLA_StartEndEffect\sound\2023-07-09_ConfigNumber_3\Single_FreqLoc\fs', num2str(f0), '\SoundSequence.mat'));
            SEeffectparams.ChangeTime = {soundinfo.changestage}';
        else
            SEeffectparams.ChangeTime = cat(1, {[0,0]}, ...
           repmat({[SEeffectparams.ChangePosition(1), SEeffectparams.ChangePosition(1) + SEeffectparams.Duration * SEeffectparams.ChangePercent];...
           [SEeffectparams.ChangePosition(2) SEeffectparams.ChangePosition(2) + SEeffectparams.Duration * SEeffectparams.ChangePercent];...
           [SEeffectparams.ChangePosition(3) SEeffectparams.ChangePosition(3) + SEeffectparams.Duration * SEeffectparams.ChangePercent]}, 3, 1));
        end

    case "OddballDur100"
        TrialType0 = ["f0_Nochange", "f0_Head_0.005", "f0_Middle_0.005","f0_Tail_0.005",...
                     "f0_Head_0.01", "f0_Middle_0.01", "f0_Tail_0.01", ...
                      "f0_Head_0.05", "f0_Middle_0.05", "f0_Tail_0.05"];
        SEeffectparams.f0 = 4458; % !!!!!!!!!!!!!!!
        SEeffectparams.TrialTypes = strrep(TrialType0, "f0", num2str(SEeffectparams.f0));
        SEeffectparams.Duration = 100;% ms !!!!!!!!!!!!!!!!!
        SEeffectparams.StdNum = 9;% ms        
        SEeffectparams.ChangePercent = 0.1;%
        SEeffectparams.ChangePosition = [3, 45, 87];% ms !!!!!!!!!!!!!!!!!
        SEeffectparams.loadSoundchoice = true;
        SEeffectparams.PSTHPlotwindow = [SEeffectparams.Duration * 2 * SEeffectparams.StdNum, SEeffectparams.Duration * 2 * (SEeffectparams.StdNum + 1)];% in ms
        SEeffectparams.RasterPlotwindow = [0, SEeffectparams.Duration * 2 * (SEeffectparams.StdNum + 1)];% ms
        SEeffectparams.bin = 20;% ms
        SEeffectparams.step = 10;% ms
        parseStruct(SEeffectparams);
        StdDuratin = Duration * 2 * StdNum;
        if loadSoundchoice
            keyboard;
            load(strcat('K:\Program\RatLA_StartEndEffect\sound\2023-07-08_ConfigNumber_1\Oddball_FreqLoc\fs', num2str(f0), '\SoundSequence.mat'));
            SEeffectparams.ChangeTime = {soundinfo.changestage}';
        else
            SEeffectparams.ChangeTime = cat(1, {[0,0]}, ...
           repmat({[SEeffectparams.ChangePosition(1), SEeffectparams.ChangePosition(1) + SEeffectparams.Duration * SEeffectparams.ChangePercent] + StdDuratin;...
           [SEeffectparams.ChangePosition(2) SEeffectparams.ChangePosition(2) + SEeffectparams.Duration * SEeffectparams.ChangePercent] + StdDuratin;...
           [SEeffectparams.ChangePosition(3) SEeffectparams.ChangePosition(3) + SEeffectparams.Duration * SEeffectparams.ChangePercent] + StdDuratin}, 3, 1));
        end

    case "OddballDur300"
        TrialType0 = ["f0_Nochange", "f0_Head_0.005", "f0_Middle_0.005","f0_Tail_0.005",...
                     "f0_Head_0.01", "f0_Middle_0.01", "f0_Tail_0.01", ...
                      "f0_Head_0.05", "f0_Middle_0.05", "f0_Tail_0.05"];
        SEeffectparams.f0 = 4458; % !!!!!!!!!!!!!!!
        SEeffectparams.TrialTypes = strrep(TrialType0, "f0", num2str(SEeffectparams.f0));
        SEeffectparams.Duration = 300;% ms !!!!!!!!!!!!!!!!!
        SEeffectparams.StdNum = 9;% ms        
        SEeffectparams.ChangePercent = 0.1;%
        SEeffectparams.ChangePosition = [3, 135, 267];% ms !!!!!!!!!!!!!!!!!
        SEeffectparams.loadSoundchoice = true;
        SEeffectparams.PSTHPlotwindow = [SEeffectparams.Duration * 2 * SEeffectparams.StdNum, SEeffectparams.Duration * 2 * (SEeffectparams.StdNum + 1)];% in ms
        SEeffectparams.RasterPlotwindow = [0, SEeffectparams.Duration * 2 * (SEeffectparams.StdNum + 1)];% ms
        SEeffectparams.bin = 20;% ms
        SEeffectparams.step = 10;% ms
        parseStruct(SEeffectparams);
        StdDuratin = Duration * 2 * StdNum;
        if loadSoundchoice
            load(strcat('K:\Program\RatLA_StartEndEffect\sound\2023-07-08_ConfigNumber_2\Oddball_FreqLoc\fs', num2str(f0), '\SoundSequence.mat'));
            SEeffectparams.ChangeTime = {soundinfo.changestage}';
        else
            SEeffectparams.ChangeTime = cat(1, {[0,0]}, ...
           repmat({[SEeffectparams.ChangePosition(1), SEeffectparams.ChangePosition(1) + SEeffectparams.Duration * SEeffectparams.ChangePercent] + StdDuratin;...
           [SEeffectparams.ChangePosition(2) SEeffectparams.ChangePosition(2) + SEeffectparams.Duration * SEeffectparams.ChangePercent] + StdDuratin;...
           [SEeffectparams.ChangePosition(3) SEeffectparams.ChangePosition(3) + SEeffectparams.Duration * SEeffectparams.ChangePercent] + StdDuratin}, 3, 1));
        end
end

%save
save(strcat(SavePath, "\SEeffectparams.mat"), "SEeffectparams", "-mat");