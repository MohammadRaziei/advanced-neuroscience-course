clc; clear all; close all;

preTrainLen = 200;
TrainLen = 400;
ep = 0.05;


idxW = 0:preTrainLen+TrainLen;

%% Extinction
r = [ones(1,preTrainLen), zeros(1,TrainLen)]; 
u = [ones(1,preTrainLen), ones(1,TrainLen)];
w = zeros(size(r,1), size(r,2)+1);
for t = 1:length(r)
    v = w(t) * u(t);
    d = r(t) - v;
    w(t+1) = w(t) + ep*d*u(t);
end
plot(idxW, w);
title('Extinction');

%% Partial
r = [zeros(1,preTrainLen), randi([0,1],1,TrainLen)]; 
u = [zeros(1,preTrainLen), ones(1,TrainLen)];
w = zeros(size(u,1), size(u,2)+1);
for t = 1:length(r)
    v = w(:,t) * u(:,t);
    d = r(t) - v;
    w(:,t+1) = w(:,t) + ep*d*u(:,t);
end
plot(idxW, w);
title('Partial');

%% Blocking
r = [ones(1,preTrainLen), ones(1,TrainLen)];
u = [repmat([1;0],1,preTrainLen), repmat([1;1],1,TrainLen)];
w = zeros(size(u,1), size(u,2)+1);
for t = 1:length(u)
    v = w(:,t)' * u(:,t);
    d = r(t) - v;
    w(:,t+1) = w(:,t) + ep*d*u(:,t);
end
plot(idxW, w(1,:), idxW, w(2,:));
title('Blocking');

%% Inhibitory
map = [1,1,0; 1 0 1]';
randIdx = randi(2,1,TrainLen);
u = [zeros(2,preTrainLen), map([1 2],randIdx)];
r = [zeros(1,preTrainLen), map(3,randIdx)];
w = zeros(size(u,1), size(u,2)+1);
for t = 1:length(u)
    v = w(:,t)' * u(:,t);
    d = r(t) - v;
    w(:,t+1) = w(:,t) + ep*d*u(:,t);
end
plot(idxW, w(1,:), idxW, w(2,:));
title('Inhibitory');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Blocking with kalmanFilter
% preTrainLen = 10;
% TrainLen = 20;
% idxW = 0:preTrainLen+TrainLen;
% 
% r = [ones(1,preTrainLen), ones(1,TrainLen)];
% u = [repmat([1;0],1,preTrainLen), repmat([1;1],1,TrainLen)];
% 
% w = zeros(size(u,1), size(u,2)+1);
% sigma2 = 0.1;
% tau2 = 0.05;
% W = sigma2*eye(2);
% Sigma = zeros(2);
% for t = 1:length(u)
%     C = u(:,t)';
%     Sigma = Sigma + W;
% 
%     G = Sigma * C' /(C*Sigma*C' + tau2);
%     Sigma = Sigma - G*C*Sigma;
%     w(:,t+1) = w(:,t) + G*(r(t)-C*w(:,t));
% end
% 
% plot(idxW, w(1,:), idxW, w(2,:));
% title('Blocking with kalmanFilter');
% 
% 

% %% Unblocking with kalmanFilter
% close all;
% preTrainLen = 20;
% TrainLen = 20;
% idxW = 0:preTrainLen+TrainLen;
% idxS = idxW(2:end);
% r = [ones(1,preTrainLen), 2*ones(1,TrainLen)];
% u = [repmat([1;0],1,preTrainLen), repmat([1;1],1,TrainLen)];
% 
% w = zeros(size(u,1), size(u,2)+1);
% sigma2 = 0.01;
% tau2 = 0.1;
% W = sigma2*eye(2);
% Sigma = 0.6*eye(2);
% Sigma_s = zeros(4,size(u,2));
% for t = 1:length(u)
%     Sigma_s(:,t) = Sigma(:);
%     C = u(:,t)';
%     Sigma = Sigma + W;
%     G = Sigma * C' /(C*Sigma*C' + tau2);
%     Sigma = Sigma - G*C*Sigma;
%     w(:,t+1) = w(:,t) + G*(r(t)-C*w(:,t));
% end
% 
% figure; plot(idxW, w(1,:), idxW, w(2,:));
% ylim([0,1.5]);
% figure; plot(idxS, Sigma_s(1,:), idxS, Sigma_s(4,:));
% ylim([0,1]);
% title('Unblocking with kalmanFilter');
% 
% % G
% 
% %% 
% videoFig = figure('Color','w','ToolBar','none','MenuBar','none');%, 'units','normalized','outerposition',[0 0 1 1]);
% videoFileName = 'Unblocking';
% myVideo = VideoWriter(videoFileName,'MPEG-4'); %open video file
% myVideo.FrameRate = 5;  
% cmap = gray(128);
% try
% open(myVideo)
% x = linspace(-1,2);
% for t = 1:length(u)    
%     clf
%     p = zeros(length(x));
%     SIGMA = reshape(Sigma_s(:,t),2,2);
%     mu = w(:,t)';
%     for i = 1:length(x)
%         for j = 1:length(x)
%             p(i,j) = mvnpdf([x(i),x(j)],mu,SIGMA); 
%         end
%     end
%     colormap(cmap)
%     contourf(x,x,p')
%     xlabel('w_1'); ylabel('w_2')
%     if t > preTrainLen
%         title({['Trial : ' num2str(t,'%02.0f')],'train'}); 
%     else
%         title({['Trial : ' num2str(t,'%02.0f')],'pretrain'}); 
%     end
%     
%     pause(0.01) %Pause and grab frame
%     frame = getframe(videoFig);
%     writeVideo(myVideo, frame);
% end
% catch
% close(myVideo);
% end
% close(myVideo); close(videoFig);

%% Blocking with kalmanFilter
preTrainLen = 10; TrainLen = 20;
u = [repmat([1;0],1,preTrainLen), repmat([1;1],1,TrainLen)];
r = [ones(1,preTrainLen), ones(1,TrainLen)];
resultForParadigm(u,r,preTrainLen, TrainLen, 'Blocking', 0.01, 0.6, 5);

%% Unblocking with kalmanFilter
preTrainLen = 20; TrainLen = 20;
r = [ones(1,preTrainLen), 2*ones(1,TrainLen)];
u = [repmat([1;0],1,preTrainLen), repmat([1;1],1,TrainLen)];
resultForParadigm(u,r,preTrainLen, TrainLen, 'Unblocking', 0.0, 0.6, 5);
