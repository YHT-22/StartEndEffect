clear;clc;
%% initiation
% DataPath = "K:\ANALYSIS_202307_RatECOG_StartEndEffect\" + ...
%     "f036000_SinglelDur300_dev0.00001_change1period_pos3-32.3-61.6-90.9-120.2-149.5-178.8-208.1-237.4-266.7-296ms\" + ...
%     "RatZ20230821\";
DataROOTPath = "K:\ANALYSIS_202307_RatECOG_StartEndEffect\";
ConfigExcelPATH = "K:\Program\RatECOG_StartEndEffect\SEparams.xlsx";
RMSWindow = {[0, 50], [0, 100], [0, 150]};% ChangeTime is "0", eg:ChangeTime is 4ms, then RMSWindow is [4, 4+100]
SelectCHsRMS = [17:32];
ProtocolsDir = dir(DataROOTPath);
ProtocolsDir(cell2mat({ProtocolsDir.isdir}) ~= 1 | strcmp(string({ProtocolsDir.name}), '.') | strcmp(string({ProtocolsDir.name}), '..')) = [];
for ProtocolNum = 1:numel(ProtocolsDir)
    if strcmp(ProtocolsDir(ProtocolNum).name, "f06000-10902.7-19811.6-36000_SingleDur300_dev0.00003_change4period")
        continue;
    end
    SonPath = strcat(DataROOTPath, ProtocolsDir(ProtocolNum).name, "\");
    SonDir = dir(SonPath);
    SonDir(cell2mat({SonDir.isdir}) ~= 1 | strcmp(string({SonDir.name}), '.') | strcmp(string({SonDir.name}), '..')) = [];
    for SonDirNum = 1:numel(SonDir)
        clear MATPath chMean chStd types tRMS_idx MMN_temp MMN_RMS
        MATPath = strcat(SonPath, SonDir(SonDirNum).name, "\");
        %%
%         if ~contains(string(SonDir(SonDirNum).name), "0824")
%             continue;
%         end
        load(strcat(MATPath, "ProcessData.mat"));
        % get params
        SEparamsAll = table2struct(readtable(ConfigExcelPATH));
        idx = find(strcmp(ProtocolStr, {SEparamsAll.ProtocolType}));
        TargetSEparams = SEparamsAll(idx);
        
        for RMSWinNum = 1 : numel(RMSWindow)
            % processing
            for typeIdx = 1 : numel(chMean)
                MMN_temp{typeIdx} = chMean{typeIdx} - chMean{1};
                tRMS_idx{typeIdx} = find(t > ceil(ChangeTime(typeIdx)) + RMSWindow{RMSWinNum}(1) & t < ceil(ChangeTime(typeIdx)) + RMSWindow{RMSWinNum}(2));   
                MMN_RMS{typeIdx} = rms(MMN_temp{typeIdx}(:, tRMS_idx{typeIdx}), 2);
            end
            types = 1 : numel(MMN_RMS);
            CHsRMS = changeCellRowNum(MMN_RMS');
            MMN_RMS_Mean = cellfun(@(x) mean(x(SelectCHsRMS)), MMN_RMS);
            MMN_RMS_Std = cellfun(@(x) std(x(SelectCHsRMS)), MMN_RMS);
            Strstemp = regexpi(TrialTypes, "_", "split");
        
            % plot
            figure;
            for plotCH = SelectCHsRMS
                fitpoints = polyfit(types, CHsRMS{plotCH}, 6);
                %interp
                % fitline_x = linspace(1, numel(types));
                % fitline_y = interp1(types, CHsRMS{1}, fitline_x);
                %polyfit
                fitline_x = linspace(1, numel(types));
                fitline_y = polyval(fitpoints, fitline_x);
                scatter(types, CHsRMS{plotCH}, "k", 'filled', "LineWidth", 2);hold on;
                plot(fitline_x, fitline_y, '--', 'Color', '#CCCCCC');hold on;
            end
            
            errorbar(1 : numel(types), MMN_RMS_Mean, MMN_RMS_Std, "Color", "#666666", "LineWidth", 2);hold on;
            xticks([1 : numel(types)]);
            xticklabels(strrep(TrialTypes, "_", "-"));hold on;
            scaleAxes(gcf, "x", [0.5, numel(MMN_RMS) + 0.5]);hold on;
            RMSWinStr = strcat("[", string(RMSWindow{RMSWinNum}(1)), ", ", string(RMSWindow{RMSWinNum}(2)), "]");
            title(strcat("RMSWindow", RMSWinStr));
            print(gcf, strcat(MATPath, "RMS_Tunning_RMSWin", RMSWinStr, ".jpg"), "-djpeg", "-r200");
            close;
        end

    end
end


