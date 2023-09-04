function getparams = getSEeffctparams(SEeffectparams)
    parseStruct(SEeffectparams);
    getparams.plotMMN = double(string(plotMMN));
    getparams.colors = regexpi(string(colors), ',', 'split');
    getparams.trialonset_Window = double(regexpi(string(trialonset_Window), ',', 'split'));
    getparams.ICAWindow = double(regexpi(string(ICAWindow), ',', 'split'));
    getparams.plotWindow = double(regexpi(string(plotWindow), ',', 'split'));
    getparams.CWTplotWindow = double(regexpi(string(CWTplotWindow), ',', 'split'));
    getparams.Diffratio = double(regexpi(string(Diffratio), ',', 'split'));
    getparams.GroupTypes = cellfun(@double, rowFcn(@(x) regexpi(x, ',', 'split'), regexpi(string(GroupTypes), ';', 'split')', ...
        "UniformOutput", false), "UniformOutput", false);
    getparams.ChangeTime = ChangeTime;
    if isempty(regexpi(string(f0), ",", "split"))
        getparams.f0 = double(f0);
    else
        getparams.f0 = double(regexpi(f0, ",", "split"));
    end

    if exist('StdDuration', 'var') 
        getparams.StdDuration = StdDuration;
    end
    
    return;
end