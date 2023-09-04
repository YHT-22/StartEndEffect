%%CF plot online
clear;clc;

BlockPath = 'K:\DATA_202307_RatLinearArray_StartEndEffect\Data\Tank\RatG\RatG20230602\Block-2';
SaveRootPath = 'K:\ANALYSIS_202307_RatLinearArray_StartEndEffect\';
temp = regexp(BlockPath, '\', 'split');
RatName = temp(end - 2);
DateStr = temp(end - 1);
FigSavePath = string(strcat(SaveRootPath, RatName, '\', DateStr));
mkdir(FigSavePath);
ChannelSelect = [1,2];
height = 0.1;
width = 0.03;

for chIdx = 1:numel(ChannelSelect)
    temp = TDTbin2mat(BlockPath, 'TYPE', {'epocs', 'snips'}, 'CHANNEL', ChannelSelect(chIdx));
    SpikeTime = temp.snips.eNeu.ts * 1000;%spike time
    FreqAll = temp.epocs.vair.data;%fs
    FreqPool = unique(FreqAll);%26 frequence
    AttAll = temp.epocs.var2.data;%att
    TrialOnset = temp.epocs.Swep.onset * 1000;%trial onset
    TrialOff = temp.epocs.Swep.offset * 1000;%trial offset
    
    FreqAtt = zeros(numel(FreqPool), numel(unique(AttAll)) / numel(FreqPool) + 1);
    for freqIdx = 1:length(FreqPool)
        TargetFreqIdx = find(FreqAll == FreqPool(freqIdx));
        TargetAtt = AttAll(TargetFreqIdx);
        FreqAtt(freqIdx, 1) = FreqPool(freqIdx);
        FreqAtt(freqIdx, 2:end) = unique(TargetAtt);
    end
    
    %plot
    AttStr = ["0", "10", "20", "30", "40", "50", "60"];
    figure;maximizeFig;
    title(strcat("CH",num2str(ChannelSelect(chIdx))));axis off;
    for freqIdx = 1:size(FreqAtt,1)
        for AttIdx = 2:size(FreqAtt,2)
            nTrial = 0;
            axes('Position', [0.04 + width * (freqIdx - 1), 0.88 - height * (AttIdx - 1), width, height]);
            TargetTrialsIdx = intersect(find(FreqAll ==  FreqAtt(freqIdx,1)), find(AttAll == FreqAtt(freqIdx, AttIdx)));
            for TrialIdx = 1:numel(TargetTrialsIdx)
                SpikeIdx = [];SpikeTimeSeq = [];
                SpikeIdx = intersect(find(SpikeTime > TrialOnset(TargetTrialsIdx(TrialIdx))), find(SpikeTime < TrialOff(TargetTrialsIdx(TrialIdx))));
                SpikeTimeSeq = SpikeTime(SpikeIdx);
                nTrial = nTrial + 1;
                scatter(SpikeTimeSeq - TrialOnset(TargetTrialsIdx(TrialIdx)), repmat(nTrial, numel(SpikeIdx),1), 'r.');hold on;
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
maximizeFig;
print(gcf, strcat(FigSavePath, "\CH", num2str(ChannelSelect(chIdx)), '_CF'), "-djpeg", "-r200");
close;
end







