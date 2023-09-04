clear;clc;
%% load data
DataRootPath = 'K:\DATA_202307_RatLinearArray_StartEndEffect\Data\Mat\';
ProtocolStrs = {};% empty for all protocols
TankStrs = {};% empty for all tanks
AreaStrs = {["IC"]};% empty for all areas

% protocols
if isempty(ProtocolStrs)
    AllProtocols = dir(DataRootPath);
    AllProtocols([find(string({AllProtocols.name}') == '.'), find(string({AllProtocols.name}') == '..')]) = [];
    ProtocolStrs = {AllProtocols.name}';
end

for proIdx = 3:numel(ProtocolStrs)
    %% get shank .mat file path
    %protocol level
    ProtocolPath = strcat(DataRootPath, ProtocolStrs{proIdx});
    AllTanks = dir(fullfile(ProtocolPath));
    AllTanks([find(string({AllTanks.name}') == '.'), find(string({AllTanks.name}') == '..')]) = [];
    %tank level
    if isempty(TankStrs) && isempty(AreaStrs)
        TankStrs = {AllTanks.name}';
    elseif ~isempty(TankStrs) && isempty(AreaStrs)
        TankStrs = {AllTanks(contains(string({AllTanks.name}'), string(TankStrs))).name}';
    elseif isempty(TankStrs) && ~isempty(AreaStrs)
        TankStrs = {AllTanks(contains(string({AllTanks.name}'), string(AreaStrs))).name}';
    elseif ~isempty(TankStrs) && ~isempty(AreaStrs)
        TankStrs = {AllTanks(contains(string({AllTanks.name}'), string(TankStrs)) && contains(string({AllTanks.name}'), string(AreaStrs))).name}';
    end
    %generate target dirpath
    TargetDirPaths = cellfun(@(x) strcat(ProtocolPath, "\", x), TankStrs, "UniformOutput", false);

    %% Process
    for targetIdx = 1:numel(TargetDirPaths)
        % create save path
        TargetDirPath = TargetDirPaths{targetIdx};
        SavePath = strrep(TargetDirPath, "DATA_202307_RatLinearArray_StartEndEffect\Data\Mat", ...
            "ANALYSIS_202307_RatLinearArray_StartEndEffect");
        mkdir(SavePath);
        % get area
        temp0 = regexpi(TargetDirPath, "\", "split");
        TankStr = temp0(end);
        temp1 = regexpi(TankStr, "_", "split");
        Area = temp1(end);
        % params setting
        if ~strcmp(ProtocolStrs{proIdx}, "CF")
            run("SEeffectparamsSetting.m");%!!!!!setting params here!!!!!!!
        end
        % get trialAll and spikedata .mat
        fileinfo_temp = dir(TargetDirPath);
        trialAllmatFiles = {fileinfo_temp(contains(string({fileinfo_temp.name}'), ".mat")).name}';
        cdrplot = [];
        for matIdx = 1:numel(trialAllmatFiles)
            load(strcat(TargetDirPath, "\", trialAllmatFiles{matIdx}), "-mat", "trialAll");
            if strcmp(ProtocolStrs{proIdx}, "CF")
                run("Process_CF.m");
            else
                run("Process_Raster_PSTH.m");
                run("Plot_Raster_PSTH.m");
                print(Figure(matIdx), strcat(SavePath, "\", strrep(trialAllmatFiles{matIdx}, '.mat', ''), ".jpg"), "-djpeg", "-r200");
                save(strcat(SavePath, "\cdrPlot_", trialAllmatFiles{matIdx}), "cdrplot", "-mat");
                close;
            end
        end
    end
end


