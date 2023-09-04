SpikeTimeAll = {trialAll.spiketime}';
FreqAll = cell2mat({trialAll.Frequence}');%fs
FreqPool = unique(FreqAll);%26 frequence
AttAll = cell2mat({trialAll.Att}');%att
TrialOnset = cell2mat({trialAll.TrialOnset}');%trial onset
TrialOff = cell2mat({trialAll.TrialOffset}');%trial offset
FreqAtt = zeros(numel(FreqPool), numel(unique(AttAll)) / numel(FreqPool) + 1);
for freqIdx = 1:length(FreqPool)
    TargetFreqIdx = find(FreqAll == FreqPool(freqIdx));
    TargetAtt = AttAll(TargetFreqIdx);
    FreqAtt(freqIdx, 1) = FreqPool(freqIdx);
    FreqAtt(freqIdx, 2:end) = unique(TargetAtt);
end

%plot
height = 0.1;
width = 0.03;
AttStr = ["0", "10", "20", "30", "40", "50", "60"];
figure;maximizeFig;
title(strrep(strrep(trialAllmatFiles{matIdx}, ".mat", ""), "_", "-"));axis off;
for freqIdx = 1:size(FreqAtt,1)
    for AttIdx = 2:size(FreqAtt,2)
        nTrial = 0;
        axes('Position', [0.04 + width * (freqIdx - 1), 0.88 - height * (AttIdx - 1), width, height]);
        TargetTrialsIdx = intersect(find(FreqAll ==  FreqAtt(freqIdx,1)), find(AttAll == FreqAtt(freqIdx, AttIdx)));
        for TrialIdx = 1:numel(TargetTrialsIdx)
            SpikeTimeSeq = [];
            SpikeTimeSeq = cell2mat(SpikeTimeAll(TargetTrialsIdx(TrialIdx)));
            nTrial = nTrial + 1;
            scatter(SpikeTimeSeq - TrialOnset(TargetTrialsIdx(TrialIdx)), repmat(nTrial, numel(SpikeTimeSeq),1), 'r.');hold on;
        end
        if freqIdx ~= 1
            if AttIdx == 2
                title(string(FreqAtt(freqIdx, 1)));
            end
            set(gca,'xtick',[],'xticklabel',[]);
            set(gca,'ytick',[],'yticklabel',[]);
        elseif freqIdx == 1
            if AttIdx == size(FreqAtt,2)
                xlabel('Time (ms)');
                ylabel(strcat(AttStr(AttIdx - 1), "dB"));
            elseif AttIdx == 2
                title(string(FreqAtt(freqIdx, 1)));
                ylabel(strcat(AttStr(AttIdx - 1), "dB"));                
            else
                ylabel(strcat(AttStr(AttIdx - 1), "dB"));
            end
        end
    end
end
print(gcf, strcat(SavePath, "\", strrep(trialAllmatFiles{matIdx}, ".mat", ""), '_CF'), "-djpeg", "-r200");
close;