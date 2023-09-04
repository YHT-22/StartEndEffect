function trialAll = TrialAllProcess_StartEndEffect(processparams)
parseStruct(processparams);
%% Information extraction
ordrAll = temp.epocs.ordr.data; % Hz
TrialOnsetIndex = 1:length(temp.epocs.ordr.data);
TrialOnset = temp.epocs.ordr.onset * 1000;%trial onset, ms

n = length(TrialOnsetIndex);
size_temp = cell(n, 1);
trialAll = struct('TrialNum', size_temp, ...
    'TrialOnset', size_temp, ...
    'TrialOffset', size_temp, ...
    'Ordr', size_temp);

%% All trials
for tIndex = 1:length(TrialOnsetIndex)
    trialAll(tIndex, 1).TrialNum = tIndex;
    trialAll(tIndex, 1).TrialOnset = TrialOnset(tIndex);
%     trialAll(tIndex, 1).TrialOffset = TrialOff(tIndex);    
    trialAll(tIndex, 1).ordr = ordrAll(tIndex);
end

return;
end
