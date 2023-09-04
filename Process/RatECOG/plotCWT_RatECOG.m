function Fig = plotCWT_RatECOG(chMeanCWT, t, f, coi, RatECOGPos, titleStr, visible)
    narginchk(3, 6);

    if nargin < 5
        RatECOGPos = RatECOGPosConfig();
    end

    if nargin < 5 || isempty(titleStr)
        titleStr = '';
    else
        titleStr = [' | ', char(titleStr)];
    end

    if nargin < 6
        visible = "on";
    end

    Fig = figure("Visible", visible);
    margins = [0.05, 0.05, 0.1, 0.1];
    paddings = [0.01, 0.03, 0.01, 0.01];
    maximizeFig(Fig);
    plotSize = [6, 6];

    for rIndex = 1:plotSize(1)

        for cIndex = 1:plotSize(2)
            chNum = (rIndex - 1) * plotSize(2) + cIndex;

            if chNum > size(chMeanCWT, 1)
                continue;
            end
            
            mSubplot(Fig, plotSize(1), plotSize(2), RatECOGPos(chNum), [1, 1], margins, paddings);
            
            imagesc('XData', t * 1000, 'YData', f, 'CData', chMeanCWT{chNum});
            colormap("jet");
            hold on;
            if exist("coi", "var")
                plot(t * 1000, coi, 'w--', 'LineWidth', 0.6);
            end
            title(['CH ', num2str(chNum), titleStr]);

            if ~(rIndex == 1 && cIndex == 1)
                yticks([]);
                yticklabels('');
            end

            if ~(rIndex == 6 && cIndex == 2)
                xticklabels('');
            end

        end

    end

%     scaleAxes(Fig, "x", "on");
%     scaleAxes(Fig, "y", "on");
    yRange = scaleAxes(Fig, "y");
    allAxes = findobj(Fig, "Type", "axes");

    for aIndex = 1:length(allAxes)
        clear h;
        h = plot(allAxes(aIndex), [0, 0], yRange, "k--", "LineWidth", 0.6); hold on;
        set(get(get(h, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
    end
    set(allAxes, 'Color', 'none');
    return;
end
