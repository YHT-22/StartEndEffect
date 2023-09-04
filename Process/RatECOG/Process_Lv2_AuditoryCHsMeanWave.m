clear;clc;
%% initiation
DataROOTPath = "K:\ANALYSIS_202307_RatECOG_StartEndEffect\";
ConfigExcelPATH = "K:\Program\RatECOG_StartEndEffect\SEparams.xlsx";
ProtocolStrs = ["f01000_SingleDur300_dev0.05_0.1_change4period",...
"f01000_SinglelDur300_dev0.005_0.01_0.05_change30ms",...
"f06000_SingleDur300_dev0.0001_change4period_pos3-150-296ms",...
"f06000_SingleDur300_dev0.0001_change4period_pos3-32.3-61.6-90.9-120.2-149.5-178.8-208.1-237.4-266.7-296ms",...
"f06000_SingleDur300_dev-0.0001_change4period_pos3-32.3-61.6-90.9-120.2-149.5-178.8-208.1-237.4-266.7-296ms",...
"f06000_SingleDur300_dev0.1_change4period_pos3-32.3-61.6-90.9-120.2-149.5-178.8-208.1-237.4-266.7-296ms",...
"f08000_SingleDur300_dev0.0001_change4period_pos3-32.3-61.6-90.9-120.2-149.5-178.8-208.1-237.4-266.7-296ms",...
"f08000_SingleDur300_dev-0.0001_change4period_pos3-32.3-61.6-90.9-120.2-149.5-178.8-208.1-237.4-266.7-296ms",...
"f010000_SingleDur300_dev0.00001_change4period_pos3-32.3-61.6-90.9-120.2-149.5-178.8-208.1-237.4-266.7-296ms",...
"f010000_SingleDur300_dev-0.00001_change4period_pos3-32.3-61.6-90.9-120.2-149.5-178.8-208.1-237.4-266.7-296ms",...
"f036000_SinglelDur300_dev0.00001_change1period_pos3-32.3-61.6-90.9-120.2-149.5-178.8-208.1-237.4-266.7-296ms"];
AverageChs = [12:32];
plotWin = [0, 500];
Colors = ["#000000", "#0000FF", "#FF0000", "#808080"];

%% get data & params
ProtocolsDir = dir(DataROOTPath);
ProtocolsDir(cell2mat({ProtocolsDir.isdir}) ~= 1 | strcmp(string({ProtocolsDir.name}), '.') | strcmp(string({ProtocolsDir.name}), '..')) = [];
for protocolIdx = 4 : numel(ProtocolStrs)
    clear idx AudichMean lines
    idx = find(strcmp(ProtocolStrs(protocolIdx), {ProtocolsDir.name}));
    DatePath = strcat(DataROOTPath, string(ProtocolsDir(idx).name), "\");
    DateDir = dir(DatePath);
    DateDir(strcmp(string({DateDir.name}), '.') | strcmp(string({DateDir.name}), '..')) = [];
    AudichMean = [];
    for MatIdx = 1 : numel(DateDir)
        MatPath = strcat(DatePath, {DateDir(MatIdx).name});
        load(strcat(MatPath, "\ProcessData.mat"), "-mat");
    
        for GroupNum = 1 : numel(GroupTypes)
            for typeIdx = 1 : numel(GroupTypes{GroupNum})
                AudichMean{typeIdx} = mean(chMean{GroupTypes{GroupNum}(typeIdx)}(AverageChs, :), 1);
                lines(typeIdx).X = ChangeTime(GroupTypes{GroupNum}(typeIdx));lines(typeIdx).color = 'k';
                plot(t, AudichMean{typeIdx}, "LineWidth", 2, "Color", Colors(typeIdx));hold on;
    
            end
            scaleAxes(gcf, "x", plotWin);
            addLines2Axes(gcf, lines);
            legendStrs = strrep(TrialTypes(GroupTypes{GroupNum})', "_", "-");
            f0All = unique(cellfun(@(x) double(x(1)), regexpi(legendStrs, "-", "split"))');
            diffratioAll = unique(cellfun(@(x) x(end), regexpi(legendStrs, "-", "split")));
            posAll = unique(cellfun(@(x) x(2), regexpi(legendStrs, "-", "split")));
    
            h_Fig = get(gcf);
            legend(h_Fig.Children, legendStrs);
            titleStr = strcat("f0", join(string(f0All), ","), "-dev", join(string(diffratioAll), "-"), "-", join(string(posAll), "-"));
            title(titleStr);
            pause(2);
            print(gcf, strcat(MatPath, "\AuditoryChsAve_", titleStr, ".jpg"), "-djpeg", "-r200");
            close;
        end
    
    end
end

