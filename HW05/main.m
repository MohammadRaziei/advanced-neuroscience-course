clc; clear all; close all;
%%
preTrainLen = 200;
TrainLen = 400;
ep = 0.05;


idxW = 0:preTrainLen+TrainLen;
%%
paradigmFig = figure('Color','w','ToolBar','none','MenuBar','none',...
    'units','normalized','outerposition',[0 0 1 1]);
%% Pavlovian
u = [zeros(1,preTrainLen), ones(1,TrainLen)];
r = [zeros(1,preTrainLen), ones(1,TrainLen)];
w = weightsWithDeltaRull(u,r,ep);
subplot(231); plot(idxW, w);
ylim([0 1.5]); vline(preTrainLen+1,'--k');
title('Pavlovian');
%% Extinction
r = [ones(1,preTrainLen), zeros(1,TrainLen)]; 
u = [ones(1,preTrainLen), ones(1,TrainLen)];
w = weightsWithDeltaRull(u,r,ep);
subplot(232);plot(idxW, w); 
ylim([0 1.5]); vline(preTrainLen+1,'--k');
title('Extinction');

%% Partial
r = [zeros(1,preTrainLen), randi([0,1],1,TrainLen)]; 
u = [zeros(1,preTrainLen), ones(1,TrainLen)];
w = weightsWithDeltaRull(u,r,ep);
subplot(233);plot(idxW, w);
ylim([0 1]); vline(preTrainLen+1,'--k');
title('Partial');

%% Blocking
r = [ones(1,preTrainLen), ones(1,TrainLen)];
u = [repmat([1;0],1,preTrainLen), repmat([1;1],1,TrainLen)];
w = weightsWithDeltaRull(u,r,ep);
subplot(234);plot(idxW, w(1,:), idxW, w(2,:));
ylim([0 1.5]); vline(preTrainLen+1,'--k');
title('Blocking');

%% Inhibitory
map = [1,1,0; 1 0 1]';
randIdx = randi(2,1,TrainLen);
u = [zeros(2,preTrainLen), map([1 2],randIdx)];
r = [zeros(1,preTrainLen), map(3,randIdx)];
w = weightsWithDeltaRull(u,r,ep);
subplot(235); plot(idxW, w(1,:), idxW, w(2,:));
ylim([-1 1]); vline(preTrainLen+1,'--k');
title('Inhibitory');
%% Overshadow
u = [zeros(2,preTrainLen), ones(2,TrainLen)];
r = [zeros(1,preTrainLen), ones(1,TrainLen)];
w = weightsWithDeltaRull(u,r,ep);
subplot(236); plot(idxW, w(1,:), idxW, w(2,:));
ylim([0 1]); vline(preTrainLen+1,'--k');
title('Overshadow');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Blocking with kalmanFilter
preTrainLen = 10; TrainLen = 20;
u = [repmat([1;0],1,preTrainLen), repmat([1;1],1,TrainLen)];
r = [ones(1,preTrainLen), ones(1,TrainLen)];
resultWithKalman(u,r,preTrainLen, TrainLen, 'Blocking', 0.0, 0.6, 5);

%% Unblocking with kalmanFilter
preTrainLen = 20; TrainLen = 20;
u = [repmat([1;0],1,preTrainLen), repmat([1;1],1,TrainLen)];
r = [ones(1,preTrainLen), 2*ones(1,TrainLen)];
resultWithKalman(u,r,preTrainLen, TrainLen, 'Unblocking', 0.0, 0.6, 5);
%% backward blocking with kalmanFilter
preTrainLen = 20; TrainLen = 20;
u = [ones(2,preTrainLen), repmat([1;0],1,TrainLen)];
r = [ones(1,preTrainLen), ones(1,TrainLen)];
resultWithKalman(u,r,preTrainLen, TrainLen, 'backward blocking', 0.0, 0.6, 5);