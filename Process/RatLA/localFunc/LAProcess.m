function trialAll = LAProcess(DATAPATH, params, varargin)
    % Description: load data from *.mat or TDT block
    % Input:
    %     DATAPATH: full path of *.mat or TDT block path
    %     params:
    %         - posStr: all possible recording storages
    %         - posIndex: position number, 1-AC, 2-PFC
    %         - choiceWin: choice window, in ms
    %         - processFcn: behavior processing function handle
    %     behaviorOnly: if set true, return [trialAll] only
    % Output:
    %     trialAll: n*1 struct of trial information

    mIp = inputParser;
    mIp.addRequired("DATAPATH");
    mIp.addRequired("params", @(x) isstruct(x));
    mIp.addParameter("behaviorOnly", false, @(x) validateattrbutes(x, 'logical', {'scalar'}));

    mIp.parse(DATAPATH, params, varargin{:});

    behaviorOnly = mIp.Results.behaviorOnly;

    %% Parameter settings
    parseStruct(params);

    %% Validation
    if isempty(processFcn)
        error("Process function is not specified");
    end

    %% Loading data
        try
            disp("Try loading data from MAT");
            load(strcat(SaveMatPath, SavefileName, ".mat"), "-mat", "trialAll");
    
        catch e
            disp(e.message);
            disp("Try loading data from TDT BLOCK...");
    
            temp = TDTbin2mat(char(DATAPATH), 'TYPE', {'epocs'});
            processparams.temp = temp;
            eval(strcat("trialAll = ", string(processFcn)));  

        end
    return;
end