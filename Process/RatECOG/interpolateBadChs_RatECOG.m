function trialsECOG = interpolateBadChs_RatECOG(trialsECOG, badCHs, topoSize)
    narginchk(2, 3);

    if nargin < 3
        topoSize = [6, 6]; % [nx, ny]
    end

    % Replace bad chs by averaging neighbour chs
    channels = [0, 1:4, 0, 5:28, 0, 29:32, 0];
    [~, neighbours] = PrepareNeighbours_RatECOG(channels, topoSize);
    for bIndex = 1:numel(badCHs)
        for tIndex = 1:length(trialsECOG)
            chsTemp = neighbours{badCHs(bIndex)};
            trialsECOG{tIndex}(badCHs(bIndex), :) = mean(trialsECOG{tIndex}(chsTemp(~ismember(chsTemp, badCHs)), :), 1);
        end
    end

    return;
end