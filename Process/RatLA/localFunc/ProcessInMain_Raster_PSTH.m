%% data initialize
parseStruct(SEeffectparams);
SpikeTimeAll = {trialAll.spiketime}';
orderAll = cell2mat({trialAll.ordr}');
trialTypes = unique(orderAll);
TrialOnset = cell2mat({trialAll.TrialOnset}');%trial onset, in ms

height = 0.15;
width = 0.3;
bootstart = [PSTHPlotwindow(1):step:PSTHPlotwindow(2)]';
%% calculate raster & PSTH
cdrplot(matIdx).info = trialAllmatFiles{matIdx};
for dtypeIdx = 1:numel(trialTypes)
    trialIdx = find(orderAll == trialTypes(dtypeIdx));
    nTrial = 0;
    % plot raster
    SpikeTimeSeq = [];SpikeTimeall = [];
    for tIdx = 1:numel(trialIdx)
        SpikeTimeSeq = cell2mat(SpikeTimeAll(trialIdx(tIdx)));
        nTrial = nTrial + 1;
        SpikeTime_x = SpikeTimeSeq - TrialOnset(trialIdx(tIdx));
        SpikeTime_y = repmat(nTrial, numel(SpikeTimeSeq),1);
%         scatter(SpikeTime_x, SpikeTime_y, 'r.');hold on;
        SpikeTimeall = [SpikeTimeall; SpikeTime_x];
        cdrplot(matIdx).raster{dtypeIdx, 1}{tIdx, 1}(:, 1) = SpikeTime_x;
        cdrplot(matIdx).raster{dtypeIdx, 1}{tIdx, 1}(:, 2) = SpikeTime_y;

    end
    % PSTH
    Firerate = CalPSTH(SpikeTimeall, bootstart, bin);
    cdrplot(matIdx).PSTH{dtypeIdx, 1}(:, 1) = linspace(PSTHPlotwindow(1), PSTHPlotwindow(2), numel(Firerate))';
    cdrplot(matIdx).PSTH{dtypeIdx, 1}(:, 2) = Firerate;
end


