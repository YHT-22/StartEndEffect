    %% load data
    disp("loading data...");
    tic
%     if exist(strcat(FIGPATH, "SEeffectparams.mat"), "file")
%         load(strcat(FIGPATH, "SEeffectparams.mat"));
%     else
        save(strcat(FIGPATH, "SEeffectparams.mat"), "SEeffectparams", "-mat");
%     end
        getparams = getSEeffctparams(SEeffectparams);
        parseStruct(getparams);
    if ~exist(strcat(FIGPATH, "ECOGData.mat"), "file")
        [trialAll, trialsECOG, badCHs, fs] = SEeffectTrialsECOG(MATPATHs{mIndex}, params, getparams);
        mSave(strcat(FIGPATH, "ECOGData.mat"), "trialsECOG", "trialAll", "badCHs", "fs");
    else
        load(strcat(FIGPATH, "ECOGData.mat"));
    end

    badCHs = [];
    toc