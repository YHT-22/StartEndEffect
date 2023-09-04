function [trialAll, trialsECOG, chIdx, fs] = SEeffectTrialsECOG(MATPATH, params, SEeffectparams)
narginchk(2, 3);
if nargin < 3
    Protocol = evalin("base", "ProtocolStr");
    run("SEeffectParamsSetting_ECOG.m");
else
    parseStruct(SEeffectparams);
end
%% Parameter settings
temp = string(split(MATPATH, '\'));
Protocol = temp(end - 1);

segOption = ["trial onset", "dev onset"];
flp = 300;
fhp = 0.1;
tTh = 0.1;
chTh = 0.1;

%% Processing
[trialAll, ECOGDataset] = ECOGPreprocess(MATPATH, params);
fs = ECOGDataset.fs;
trialAll(1) = [];
trialAll([trialAll.devOrdr] == 0) = [];
trialAll(end) = [];
OnsetTemp = {trialAll.soundOnsetSeq}';
ordTemp = {trialAll.ordrSeq}';
if contains(Protocol, "Oddball")
    temp = cellfun(@(x) x + StdDuration, OnsetTemp, "UniformOutput", false);
    trialAll = addFieldToStruct(trialAll, temp, "devOnset");
end

% filter
ECOGFDZ = mFTHP(ECOGDataset, fhp, flp);% filtered, dowmsampled, zoomed
% ECOGFDZ = ECOGResample(ECOGFDZ, fs);
trialsECOG = selectEcog(ECOGFDZ, trialAll, segOption(1), trialonset_Window);

[tIdx, chIdx] = excludeTrials(trialsECOG, tTh, chTh);
trialsECOG(tIdx) = [];
trialAll(tIdx) = [];

