Figure(matIdx) = figure;
maximizeFig;
%% Raster
mSubplot(6, 3, 1);%order 1
for trialIdx = 1:numel(cdrplot(matIdx).raster{1, 1})
    plot(cdrplot(matIdx).raster{1, 1}{trialIdx, 1}(:, 1),...
         cdrplot(matIdx).raster{1, 1}{trialIdx, 1}(:, 2), '.k');hold on;
end
title("Freq Diff Ratio:1.005");
xlim([RasterPlotwindow(1) RasterPlotwindow(2)]);

mSubplot(6, 3, 4);%order 2
for trialIdx = 1:numel(cdrplot(matIdx).raster{2, 1})
    plot(cdrplot(matIdx).raster{2, 1}{trialIdx, 1}(:, 1),...
         cdrplot(matIdx).raster{2, 1}{trialIdx, 1}(:, 2), '.k');hold on;
end
xlim([RasterPlotwindow(1) RasterPlotwindow(2)]);

mSubplot(6, 3, 7);%order 3
for trialIdx = 1:numel(cdrplot(matIdx).raster{3, 1})
    plot(cdrplot(matIdx).raster{3, 1}{trialIdx, 1}(:, 1),...
         cdrplot(matIdx).raster{3, 1}{trialIdx, 1}(:, 2), '.k');hold on;
end
xlim([RasterPlotwindow(1) RasterPlotwindow(2)]);

mSubplot(6, 3, 10);%order 4
for trialIdx = 1:numel(cdrplot(matIdx).raster{4, 1})
    plot(cdrplot(matIdx).raster{4, 1}{trialIdx, 1}(:, 1),...
         cdrplot(matIdx).raster{4, 1}{trialIdx, 1}(:, 2), '.k');hold on;
end
xlim([RasterPlotwindow(1) RasterPlotwindow(2)]);

mSubplot(6, 3, 2);%order 1
for trialIdx = 1:numel(cdrplot(matIdx).raster{1, 1})
    plot(cdrplot(matIdx).raster{1, 1}{trialIdx, 1}(:, 1),...
         cdrplot(matIdx).raster{1, 1}{trialIdx, 1}(:, 2), '.k');hold on;
end
title("Freq Diff Ratio:1.01");
xlim([RasterPlotwindow(1) RasterPlotwindow(2)]);

mSubplot(6, 3, 5);%order 5
for trialIdx = 1:numel(cdrplot(matIdx).raster{5, 1})
    plot(cdrplot(matIdx).raster{5, 1}{trialIdx, 1}(:, 1),...
         cdrplot(matIdx).raster{5, 1}{trialIdx, 1}(:, 2), '.k');hold on;
end
xlim([RasterPlotwindow(1) RasterPlotwindow(2)]);

mSubplot(6, 3, 8);%order 6
for trialIdx = 1:numel(cdrplot(matIdx).raster{6, 1})
    plot(cdrplot(matIdx).raster{6, 1}{trialIdx, 1}(:, 1),...
         cdrplot(matIdx).raster{6, 1}{trialIdx, 1}(:, 2), '.k');hold on;
end
xlim([RasterPlotwindow(1) RasterPlotwindow(2)]);

mSubplot(6, 3, 11);%order 7
for trialIdx = 1:numel(cdrplot(matIdx).raster{7, 1})
    plot(cdrplot(matIdx).raster{7, 1}{trialIdx, 1}(:, 1),...
         cdrplot(matIdx).raster{7, 1}{trialIdx, 1}(:, 2), '.k');hold on;
end
xlim([RasterPlotwindow(1) RasterPlotwindow(2)]);

mSubplot(6, 3, 3);%order 1
for trialIdx = 1:numel(cdrplot(matIdx).raster{1, 1})
    plot(cdrplot(matIdx).raster{1, 1}{trialIdx, 1}(:, 1),...
         cdrplot(matIdx).raster{1, 1}{trialIdx, 1}(:, 2), '.k');hold on;
end
title("Freq Diff Ratio:1.05");
xlim([RasterPlotwindow(1) RasterPlotwindow(2)]);

mSubplot(6, 3, 6);%order 8
for trialIdx = 1:numel(cdrplot(matIdx).raster{8, 1})
    plot(cdrplot(matIdx).raster{8, 1}{trialIdx, 1}(:, 1),...
         cdrplot(matIdx).raster{8, 1}{trialIdx, 1}(:, 2), '.k');hold on;
end
xlim([RasterPlotwindow(1) RasterPlotwindow(2)]);

mSubplot(6, 3, 9);%order 9
for trialIdx = 1:numel(cdrplot(matIdx).raster{9, 1})
    plot(cdrplot(matIdx).raster{9, 1}{trialIdx, 1}(:, 1),...
         cdrplot(matIdx).raster{9, 1}{trialIdx, 1}(:, 2), '.k');hold on;
end
xlim([RasterPlotwindow(1) RasterPlotwindow(2)]);

mSubplot(6, 3, 12);%order 10
for trialIdx = 1:numel(cdrplot(matIdx).raster{10, 1})
    plot(cdrplot(matIdx).raster{10, 1}{trialIdx, 1}(:, 1),...
         cdrplot(matIdx).raster{10, 1}{trialIdx, 1}(:, 2), '.k');hold on;
end
xlim([RasterPlotwindow(1) RasterPlotwindow(2)]);

%% PSTH
% compare
colors_compare = {[002 048 074]/255, [144 201 231]/255, [250 134 000]/255, [033 158 188]/255};
mSubplot(6, 3, 13);% compare order 1,2-4 dev1.005
lineidx = 0;
for dIdx = 1:4
    lineidx = lineidx + 1;
    plot(cdrplot(matIdx).PSTH{dIdx, 1}(:, 1),...
        cdrplot(matIdx).PSTH{dIdx, 1}(:, 2), 'Color', colors_compare{lineidx}, 'LineWidth', 2);hold on;
end

mSubplot(6, 3, 14);% compare order 1,5-7 dev1.01
lineidx = 0;
for dIdx = [1, 5:7]
    lineidx = lineidx + 1;
    plot(cdrplot(matIdx).PSTH{dIdx, 1}(:, 1),...
        cdrplot(matIdx).PSTH{dIdx, 1}(:, 2), 'Color', colors_compare{lineidx}, 'LineWidth', 2);hold on;
end

mSubplot(6, 3, 15);% compare order 1,8-10 dev1.05
lineidx = 0;
for dIdx = [1, 8:10]
    lineidx = lineidx + 1;
    plot(cdrplot(matIdx).PSTH{dIdx, 1}(:, 1),...
        cdrplot(matIdx).PSTH{dIdx, 1}(:, 2), 'Color', colors_compare{lineidx}, 'LineWidth', 2);hold on;
end

% difference
colors_diff = {[144 201 231]/255, [250 134 000]/255, [033 158 188]/255};
control_PSTH = cdrplot(matIdx).PSTH{1, 1}(:, 2);
mSubplot(6, 3, 16);
lineidx = 0;
for dIdx = 2:4
    lineidx = lineidx + 1;
    plot(cdrplot(matIdx).PSTH{dIdx, 1}(:, 1),...
        cdrplot(matIdx).PSTH{dIdx, 1}(:, 2) - control_PSTH, 'Color', colors_diff{lineidx}, 'LineWidth', 2);hold on;
end

mSubplot(6, 3, 17);
lineidx = 0;
for dIdx = 5:7
    lineidx = lineidx + 1;
    plot(cdrplot(matIdx).PSTH{dIdx, 1}(:, 1),...
        cdrplot(matIdx).PSTH{dIdx, 1}(:, 2) - control_PSTH, 'Color', colors_diff{lineidx}, 'LineWidth', 2);hold on;
end

mSubplot(6, 3, 18);
lineidx = 0;
for dIdx = 8:10
    lineidx = lineidx + 1;
    plot(cdrplot(matIdx).PSTH{dIdx, 1}(:, 1),...
        cdrplot(matIdx).PSTH{dIdx, 1}(:, 2) - control_PSTH, 'Color', colors_diff{lineidx}, 'LineWidth', 2);hold on;
end

