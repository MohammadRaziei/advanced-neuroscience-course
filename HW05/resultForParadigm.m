function resultForParadigm(u,r,preTrainLen, TrainLen, name, sigma2, sigma0, frameRate)
% preTrainLen = 20;
% TrainLen = 20;
fileName = fullfile('results' , name);

idxW = 0:preTrainLen+TrainLen;
idxS = idxW(2:end);
% r = [ones(1,preTrainLen), 2*ones(1,TrainLen)];
% u = [repmat([1;0],1,preTrainLen), repmat([1;1],1,TrainLen)];

w = zeros(size(u,1), size(u,2)+1);
% sigma2 = 0.01;
tau2 = 0.1;
W = sigma2*eye(2);
% sigma0 = 0.6;
Sigma = sigma0*eye(2);
Sigma_s = zeros(4,size(u,2));
Gain_s = zeros(2,size(u,2));
for t = 1:length(u)
    Sigma_s(:,t) = Sigma(:);
    C = u(:,t)';
    Sigma = Sigma + W;
    G = Sigma * C' /(C*Sigma*C' + tau2);
    Sigma = Sigma - G*C*Sigma;
    w(:,t+1) = w(:,t) + G*(r(t)-C*w(:,t));
    Gain_s(:,t) = G;
end

plotFig = figure('Color','w','ToolBar','none','MenuBar','none', 'units','normalized','outerposition',[0.1 0.2 0.9 0.6]);
subplot(1,3,1); 
    plot(idxW, w(1,:), idxW, w(2,:)); 
    ylim([0,1.5]);
    vline(preTrainLen,'--k')
    title([name ' with kalman-filter']);
    ylabel('weights')

subplot(1,3,2); 
    plot(idxS, Sigma_s(1,:), idxS, Sigma_s(4,:));
    ylim([0,1]);
    vline(preTrainLen+1,'--k')
    title([name ' with kalman-filter']);
    ylabel('\sigma^2')
    
subplot(1,3,3); 
    plot(idxS, Gain_s(1,:), idxS, Gain_s(2,:));
    vline(preTrainLen+1,'--k')
%     ylim([0,1]);
    title([name ' with kalman-filter']);
    ylabel('Gain')
% G
% saveas(plotFig, [fileName, '.jpg']);


%% 
videoFig = figure('Color','w','ToolBar','none','MenuBar','none');%, 'units','normalized','outerposition',[0 0 1 1]);
myVideo = VideoWriter([fileName '-' num2str(sigma2)],'MPEG-4'); %open video file
myVideo.FrameRate = frameRate;  
cmap = gray(128);
try
open(myVideo)
x = linspace(-1,2);
for t = 1:length(u)    
    clf
    p = zeros(length(x));
    SIGMA = reshape(Sigma_s(:,t),2,2);
    mu = w(:,t)';
    for i = 1:length(x)
        for j = 1:length(x)
            p(i,j) = mvnpdf([x(i),x(j)],mu,SIGMA); 
        end
    end
    colormap(cmap)
    contourf(x,x,p')
    xlabel('w_1'); ylabel('w_2')
    if t > preTrainLen
        title({['Trial : ' num2str(t,'%02.0f')],'train'}); 
    else
        title({['Trial : ' num2str(t,'%02.0f')],'pretrain'}); 
    end
    
    pause(0.01) %Pause and grab frame
    frame = getframe(videoFig);
    writeVideo(myVideo, frame);
end
catch
close(myVideo);
end
close(myVideo); close(videoFig);
