function Firerate = CalPSTH(SpikeSeq, bootstart, bin)
    bootend = bootstart + bin;
    Firerate = rowFcn(@(x, y) numel(intersect(find(SpikeSeq > x), find(SpikeSeq < y))) / bin / 1000, bootstart, bootend, "UniformOutput", false);
    Firerate = cell2mat(Firerate);
    return;
end