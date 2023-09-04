function trialAll = TrialAllProcess_CFplot(processparams)
parseStruct(processparams);
%% Information extraction
FreqAll = temp.epocs.vair.data;%fs
FreqPool = unique(FreqAll);%26 frequence
AttAll = temp.epocs.var2.data;%att
TrialOnsetIndex = 1:length(temp.epocs.Swep.onset);
TrialOnset = temp.epocs.Swep.onset * 1000;%trial onset, ms
TrialOff = temp.epocs.Swep.offset * 1000;%trial offset, ms

n = length(TrialOnsetIndex);
size_temp = cell(n, 1);
trialAll = struct('TrialNum', size_temp, ...
    'TrialOnset', size_temp, ...
    'TrialOffset', size_temp, ...
    'Frequence', size_temp, ...
    'Att', size_temp);

for tIndex = 1:length(TrialOnsetIndex)
    trialAll(tIndex, 1).TrialNum = tIndex;
    trialAll(tIndex, 1).TrialOnset = TrialOnset(tIndex);
    trialAll(tIndex, 1).TrialOffset = TrialOff(tIndex);    
    trialAll(tIndex, 1).Frequence = FreqAll(tIndex);
    trialAll(tIndex, 1).Att = AttAll(tIndex);
end

return;
end
