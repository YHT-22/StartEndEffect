 %% ICA
    % align to certain duration
    
    ICAName = strcat(FIGPATH, "comp_", AREANAME, ".mat");

    trialsECOG_Temp = trialsECOG;
    channels = 1 : size(trialsECOG{1}, 1);
    
    if ~exist(ICAName, "file")
        chs2doICA = channels;
        chs2doICA(ismember(chs2doICA, badCHs)) = [];
        [comp, ICs, FigTopoICA, FigWave, FigIC] = ICA_Population_RatECOG(trialsECOG_Temp, fs, ICAWindow, chs2doICA);
        temp = validateInput(['Input bad channel number (empty for default: ', num2str(badCHs'), '): '], @(x) validateattributes(x, {'numeric'}, {'2d', 'integer', 'positive'}));
        if ~isempty(temp)
            badCHs = unique([badCHs; reshape(temp, [numel(temp), 1])]);
        end
        compT = comp;
        compT.topo(:, ~ismember(1:size(compT.topo, 2), ICs)) = 0;
        if length(chs2doICA) < length(channels)
            icaOpt = "on";
            trialsECOG = cellfun(@(x) x(chs2doICA, :), trialsECOG, "UniformOutput", false);
            trialsECOG = reconstructData(trialsECOG, comp, ICs);
            trialsECOG = cellfun(@(x) insertRows(x, channels(ismember(channels, badCHs) & ~ismember(channels, chs2doICA))), trialsECOG, "UniformOutput", false);
       
        else
            trialsECOG = cellfun(@(x) compT.topo * comp.unmixing * x, trialsECOG_Temp, "UniformOutput", false);
        end
        mPrint(FigTopoICA, fullfile(FIGPATH, "ICA_Topo.jpg"));
        mPrint(FigIC, fullfile(FIGPATH, "ICA_IC.jpg"));
        mPrint(FigWave(1), fullfile(FIGPATH, "RawWave.jpg"));
        mPrint(FigWave(2), fullfile(FIGPATH, "Restructed Wave.jpg"));
        close([FigTopoICA, FigIC, FigWave]);
        save(ICAName, "compT", "comp", "ICs", "icaOpt", "chs2doICA", "badCHs", "-mat");
    else       
        load(ICAName);
        
        if strcmpi(icaOpt, "on")
            trialsECOG = cellfun(@(x) x(chs2doICA, :), trialsECOG, "UniformOutput", false);
            trialsECOG = reconstructData(trialsECOG, comp, ICs);
            trialsECOG = cellfun(@(x) insertRows(x, channels(ismember(channels, badCHs) & ~ismember(channels, chs2doICA))), trialsECOG, "UniformOutput", false);
        else
            trialsECOG = cellfun(@(x) compT.topo * comp.unmixing * x, trialsECOG_Temp, "UniformOutput", false);
        end
    end


clear trialsECOG_Temp
