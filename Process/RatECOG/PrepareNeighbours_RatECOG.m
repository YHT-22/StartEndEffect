function [neighbours, neighboursInDouble] = PrepareNeighbours_RatECOG(channels, topoSize)
    narginchk(0, 2);

    if nargin < 1
        channels = [0, 1:4, 0, 5:28, 0, 29:32, 0];
    end

    if nargin < 2
        topoSize = [6, 6]; % [nx, ny]
    end

    % neighbours
    A0 = reshape(channels, topoSize)';
    A = padarray(A0, [1, 1]);
    neighbours = struct("label", cellfun(@(x) num2str(x), num2cell(channels), 'UniformOutput', false), "neighblabel", cell(1, numel(A0)));
    for index = 1:numel(A0)
        if channels(index) ~= 0
            [row, col] = find(A == channels(index));
            temp = A(row - 1:row + 1, col - 1:col + 1);
            temp(temp == 0 | temp == channels(index)) = [];
            temp = num2str(temp');
            neighbours(index).neighblabel = mat2cell(temp, ones(size(temp, 1), 1));
        elseif channels(index) == 0
            neighbours(index).neighblabel = {0};
        end
    end

    neighboursInDouble = arrayfun(@(x) cellfun(@(y) str2double(y), x.neighblabel), neighbours, "UniformOutput", false)';
    invalid_idx = cellfun(@(x) ~isempty(x), cellfun(@(x) find(isnan(x)), neighboursInDouble, "UniformOutput", false));
    neighboursInDouble(invalid_idx) = [];

    return;
end