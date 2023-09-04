function Fig = plotRawWaveMulti_RatECOG(chData, window, RatECOGPos, titleStr, visible)
narginchk(2, 5);

    if nargin < 3
        RatECOGPos = RatECOGPosConfig();
    end

    if nargin < 4 || isempty(titleStr)
        titleStr = '';
    else
        titleStr = [' | ', char(titleStr)];
    end

    if nargin < 5
        visible = "on";
    end

    Fig = plotRawWave_RatECOG(chData(1).chMean, [], window, RatECOGPos, titleStr, visible);
    setLine(Fig, "Color", chData(1).color, "LineWidth", 1.5);
    
    if length(chData) > 1
        for i = 2 : length(chData)
            lineSetting.color = chData(i).color;
            Fig_MultiWave = plotRawWaveAdd(Fig, chData(i).chMean, [], window, lineSetting);
        end
    end

end