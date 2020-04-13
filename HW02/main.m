% load('UnitsData.mat');


% run('calc_psth.m');

%%

% clear;clc;close all;
% x = [2100 2300 2500 2700 2900 3100 ...
%      3300 3500 3700 3900 4100 4300]';
% n = [48 42 31 34 31 21 23 23 21 16 17 21]';
% y = [1 2 0 3 8 8 14 17 19 15 17 21]';
% 
% b = glmfit(x,[y n],'poisson');
% % Compute the estimated number of successes. Plot the percent observed and estimated percent success versus the x values.
% 
% yfit = glmval(b,x,'poisson','size',n);
% plot(x, y./n,'o',x,yfit./n,'-','LineWidth',2)


%%
clear
% run('generate__meanFr_values.m');
load('meanFr_values2.mat');
fixShape = @(a) reshape(permute(a,[2,1,3]),size(a,1)*size(a,2),size(a,3));
x_raw = fixShape(meanFr);
y_raw = fixShape(values);
v_raw = fixShape(notValid);

valids = find(~v_raw);
x_valid = x_raw(valids,:);
labels = [3    -1;3     1;6    -1;6     1;9    -1;9     1];
y_valid = rows_labeling(y_raw(valids,:), labels);

m = size(x_valid,1); p_train = 0.8;
[test_idx, train_idx] = devide_test_train_indices(m,p_train);

train_X = x_valid(train_idx,:);
train_Y = y_valid(train_idx,:);
test_X = x_valid(test_idx,:);
test_Y = y_valid(test_idx,:);

% % mdl=fitcsvm(train_X, train_Y,'Standardize',true);
% % [label,score] = predict(mdl,test_X);
% % pred = mean(label == test_Y);

results = multisvm(train_X, train_Y, test_X);
mean(results == test_y)*100; % output : 71.34






