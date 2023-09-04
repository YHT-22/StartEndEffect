clear;clc;

SortPath = 'K:\DATA_202307_RatLinearArray_StartEndEffect\Data\Sort\';
RawDatainfo = table2struct(readtable('K:\DATA_202307_RatLinearArray_StartEndEffect\DataRecording.xlsx'));
SelectIdx = [1:5];
ClusterLabel = ["good", "mua"];

SelecWindowAll = {RawDatainfo.SpikeSelectWin}';% 0 for trial onset!!!!!!!!!!!!! 
Area = {RawDatainfo.Area}';
TankDate = {RawDatainfo.TankDate}';
Protocol = {RawDatainfo.Protocol}';
Thresh0 = {RawDatainfo.SortTh}';
FinishSortIdx = find(cellfun(@(x) ~isempty(x), Thresh0));% find file after sort
FinallSortIdx = intersect(SelectIdx, FinishSortIdx);

SelecWindow = cellfun(@str2num, SelecWindowAll(FinallSortIdx), "UniformOutput", false);
Thresh = cellfun(@(x) regexpi(x, ',', 'split'), Thresh0(FinallSortIdx), "UniformOutput", false);
NPYPATH = cellfun(@(x, y, z, v) [SortPath, x, '\', y, '_', z, '\th', v{1}, '_', v{2}, '\'], ...
            Protocol(FinallSortIdx), TankDate(FinallSortIdx), Area(FinallSortIdx), Thresh(FinallSortIdx), ...
            "UniformOutput", false);

%% read kilosort results(.npy & .tsv)
for fileIdx = 1:numel(NPYPATH)
    %% get spike info
    spikeTimeIdx = readNPY([NPYPATH{fileIdx}, 'spike_times.npy']);% spkie points
    spikeCluster = readNPY([NPYPATH{fileIdx}, 'spike_clusters.npy']);% cluster ID for each spike point
    
    %% get all clusters info
    fid = fopen([NPYPATH{fileIdx}, 'cluster_info.tsv']);
    C = textscan(fid, '%f %f %f %s %f %f %f %f %s %f %f', 'HeaderLines', 1);
    fclose(fid);
    for CluIdx = 1:numel(C{1})
        ClusterInfoRaw(CluIdx, 1).ID = C{1}(CluIdx);
        ClusterInfoRaw(CluIdx, 1).Channel = C{6}(CluIdx) + 1;% in kilosort: 0-31; Actually, 1-32;
        ClusterInfoRaw(CluIdx, 1).Depth = C{7}(CluIdx);
        ClusterInfoRaw(CluIdx, 1).Label = C{9}(CluIdx);
    end
    %select ClusterLabel
    ClusterInfo = ClusterInfoRaw;
    ClusterInfo(~contains(string({ClusterInfo.Label}), ClusterLabel)') = [];

    %% load trialAll .mat
    loadpath_temp = regexpi(NPYPATH{fileIdx}, '\', 'split');
    MatfilePath = fullfile(loadpath_temp{1:end - 2});
    fileinfo = dir(MatfilePath);
    load(fullfile(MatfilePath, fileinfo(contains({fileinfo.name}, '.mat')).name), "-mat", "trialAll", "kilo_fs");

    %% save .mat for each channel and each cluster
    savepath_temp = regexpi(strrep(NPYPATH{fileIdx}, 'Sort', 'Mat'), '\', 'split');
    MatSavePath = fullfile(savepath_temp{1:end - 2});
    MatName = savepath_temp{end - 2};
    mkdir(MatSavePath);

    %% find spkie time of each cluster
    spikeTimeSeqAll = double(spikeTimeIdx) ./ kilo_fs * 1000;%spike time, in ms
    for cluIDidx = 1:numel(ClusterInfo)
        CluID =[];CluChannel = [];Cluster_spiketime = [];
        CluID = ClusterInfo(cluIDidx).ID;
        CluChannel = ClusterInfo(cluIDidx).Channel;
        Cluster_spiketime = spikeTimeSeqAll(double(spikeCluster) == ClusterInfo(cluIDidx, 1).ID);%cluster ID idx
        Cluster_spiketime_intrial = cellfun(@(x) Cluster_spiketime(Cluster_spiketime > (x + SelecWindow{fileIdx, 1}(1)) & Cluster_spiketime < (x + SelecWindow{fileIdx, 1}(2))), {trialAll.TrialOnset}', ...
            "UniformOutput", false);
        for trialIdx = 1:numel(trialAll)
            trialAll(trialIdx,1).spiketime = Cluster_spiketime_intrial{trialIdx};
        end
        save(strcat(MatSavePath, '\', MatName, '_CH', num2str(CluChannel), '_ID', num2str(CluID), '.mat'), "trialAll", "SelecWindow", '-mat');
        trialAll = rmfield(trialAll, 'spiketime');
    end

end

