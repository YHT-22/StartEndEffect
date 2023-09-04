clear;clc;
%data info
RootPath = 'K:\DATA_202307_RatLinearArray_StartEndEffect\Data\';
RawDatainfo = table2struct(readtable('K:\DATA_202307_RatLinearArray_StartEndEffect\DataRecording.xlsx'));
ExportIdx = [1, 5];

RatName = {RawDatainfo.SubjName}';
Area = {RawDatainfo.Area}';
TankDate = {RawDatainfo.TankDate}';
Blocks = {RawDatainfo.Block}';
BlocksNum = cellfun(@(x) x{2}, cellfun(@(x) regexpi(x, '-', 'split'), Blocks, "UniformOutput", false), "UniformOutput", false);
Protocol = {RawDatainfo.Protocol}';
BlockPath = cellfun(@(x,y,z) [RootPath, 'Tank\', x, '\', y, '\', z], RatName, TankDate, Blocks, "UniformOutput", false);

%save
MatSavePath = cellfun(@(x) [RootPath, 'Mat\', x, '\'], Protocol, "UniformOutput", false);
KilosortSavePath = cellfun(@(x, y) [RootPath, 'Sort\', x, '\'], Protocol, "UniformOutput", false);

%others
params_in.SaveFileName = cellfun(@(x, y, z) [x, '_', y, '_B', char(z)], TankDate, Area, BlocksNum, "UniformOutput", false);
params_in.TrialAllprocessFcn = {RawDatainfo.TrialAllProcessFcn}';
params_in.ElectrodeMap = {RawDatainfo.ElectrodeMap}';

ExportANDSave(BlockPath, MatSavePath, KilosortSavePath, params_in, ExportIdx(1), ExportIdx(2));

%%
function ExportANDSave(BlockPath, SavePath, KilosortSavePath, params_in, startIdx, endIdx)
    narginchk(4, 6)
    if nargin < 5
        startIdx = 1;
    end
    if nargin < 6
        endIdx = length(BlockPath);
    end

    for index = startIdx:endIdx
        params.processFcn = params_in.TrialAllprocessFcn(index);
        parseStruct(params_in);

        temp = string(split(SaveFileName{index}, '_'));
        DateStr = temp(1);
        AreaStr = temp(2);
        SaveMatPath = strcat(SavePath{index}, DateStr, "_", AreaStr, "\");
        SortSavePath = strcat(KilosortSavePath{index}, DateStr, "_", AreaStr, "\");
        mkdir(SaveMatPath);
        mkdir(SortSavePath);

        disp(strcat("Export ", DateStr, ' ', AreaStr, " Data..."));
        tic
        %% trialAll
%         trialAll = LAProcess(BlockPath{index}, params);
%         %% kilosort
%         binPath = strcat(SortSavePath, 'Wave.bin'); 
%         if ~exist(binPath,'file')
%             TDT2binSingle(string(BlockPath{index}), SortSavePath);
%         end
%         run('K:\Program\RatLA_StartEndEffect\Process\Spikesort\electrode_config\configFileRat.m');
%         % treated as linear probe if no chanMap file
%         ops.chanMap = ['K:\Program\RatLA_StartEndEffect\Process\Spikesort\electrode_config\', ElectrodeMap{index}, '.mat'];
%         % total number of channels in your recording
%         ops.NchanTOT = 32;
%         % sample rate, Hz 
%         ops.fs = 12207.03125;
%         for th2 = [6 7 8]
%             ops.Th = [7 th2];
%             savePath = fullfile(SortSavePath, ['th', num2str(ops.Th(1))  , '_', num2str(ops.Th(2))]);
%             if ~exist(strcat(savePath, '\params.py'))
%                 mKilosort(binPath, ops, savePath);
%             end
%         end
%         kilo_fs = ops.fs;
%         %%
%         save(strcat(SortSavePath, SaveFileName{index}, ".mat"), "trialAll", "kilo_fs", "-mat", "-v7.3");
%         close all;
        %% Llfp
        disp("Saving Lfp...");
        Wave_temp = TDTbin2mat(char(BlockPath{index}), 'TYPE', {'streams'});
        LlfpDataset = Wave_temp.streams.Llfp.data;
        fs = Wave_temp.streams.Llfp.fs;
        save(strcat(SaveMatPath, "LlfpDataset.mat"), "LlfpDataset", "fs", "-mat", "-v7.3");
        toc
    end
end