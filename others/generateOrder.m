clear;
%% RLA_seEffect_Oddball
meanNum1 = 30;
devType = 10;
SAVEPATH = 'D:\yht\parameters';
orders = repmat((1:devType)', meanNum1, 1);
atts = repmat((ones(devType, 1) * 21.2), meanNum1, 1); %
idx =randperm(meanNum1 * devType);
params.orderRLAseEffect_odd = orders(idx);
params.attRLAseEffect_odd = atts(idx);
generateParamsFiles(SAVEPATH, params);

%% RLA_seEffect_Single
meanNum1 = 40;%control
meanNum2 = 30;
devType = 10;
SAVEPATH = 'D:\yht\parameters';
orders_test = repmat((2:devType)', meanNum2, 1);
orders_control = repmat([1], meanNum1, 1);
orders = [orders_test;orders_control];
atts = repmat((ones(1, 1) * 21.2), (1 * meanNum1 + (devType - 1) * meanNum2), 1); %
idx =randperm((1 * meanNum1 + (devType - 1) * meanNum2));
params.orderRLAseEffect_sig = orders(idx);
params.attRLAseEffect_sig = atts(idx);
generateParamsFiles(SAVEPATH, params);

%% others
clear;clc;
order = [1:4]';
number = repmat([40], numel(order), 1);
SAVEPATH = 'D:\yht\parameters';
orderseq = cell2mat(rowFcn(@(x, y) repmat([x], y, 1), order, number, "UniformOutput", false));
atts = repmat(21.2, numel(orderseq), 1);
idx = randperm(numel(orderseq));
params.orderRatECOG_G4_N40 = orderseq(idx);
params.attRatECOG_G4_N40 = atts(idx);
generateParamsFiles(SAVEPATH, params);

%% 
order = [1:6]';
number = [30,50,30,50,30,50]';
SAVEPATH = 'D:\yht\parameters';
orderseq = cell2mat(rowFcn(@(x, y) repmat([x], y, 1), order, number, "UniformOutput", false));
atts = repmat(21.2, numel(orderseq), 1);
idx = randperm(numel(orderseq));
params.orderRatECOG_Change_0727 = orderseq(idx);
params.attRatECOG_Change_0727 = atts(idx);
generateParamsFiles(SAVEPATH, params);