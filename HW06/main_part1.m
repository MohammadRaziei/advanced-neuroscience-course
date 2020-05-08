clc; clear all; close all; addpath('functions'); rng(41)
%% create environment
env = env_make();
numEpisodes = 10000;
maxNumSteps = 10000;
%% RL
RL.beta = 15; 
RL.eta = 0.2;
RL.epsilon = 0.05;
RL.gamma = 0.95;
RL.lambda = 0.8;
RL.m_act = zeros(size(env.mask));
RL.V = zeros(env.dimSize);

%% save variables
save_path = cell(1,numEpisodes);
save_V = zeros(env.dimSize,env.dimSize ,numEpisodes);
save_numSteps = zeros(1,numEpisodes);
save_optimalPath = zeros(1,numEpisodes);
%%
% video = video_make('OneTarget_v2');
video.title2 = 'value map';

for episode = 1:numEpisodes
    video.title1 = ['episode = ' num2str(episode)];
%     disp(video.title1);
    
    [s1,s2, env] = env_reset(env);
    all_s = zeros(2,0);
    all_r = zeros(1,0);
    all_v = zeros(1,0);
    all_p = zeros(4,0);
    all_a = zeros(1,0);
    all_s(:,1) = [s1,s2];
    for it = 1:maxNumSteps 
       [action, RL] = RL_policy_softmax(env, RL,s1,s2);
       [o1,o2, reward,env] = env_step(env, action); 
       %% RL
       all_s(:,it+1) = [o1,o2]; 
       all_r(it) = reward;
       all_v(it) = RL.V(s1,s2);
       all_p(:,it) = RL.policy;
       all_a(:,it) = action;

       %% update states
       s1 = o1; s2 = o2; env.s1 = s1; env.s2 = s2;
%        env_render(env,RL,video); 
       if env.done
           break;
       end
    end
    %% After finishing the episode
    %% TD(0)
    all_v(it+1) = 0;
    for t = it:-1:1
        o1 = all_s(1,t+1); o2 = all_s(2,t+1); 
        s1 = all_s(1,t);   s2 = all_s(2,t);
        delta = all_r(t) + RL.gamma * all_v(t+1) - all_v(t);
        RL.V(s1,s2) = all_v(t) + RL.eta * delta;
        policy = all_p(:,t); action = all_a(t); % action = do_action_softmax(policy);
        RL = RL_action_space_softmax(RL,s1,s2,o1,o2,policy,action);
    end
    %% Save logs
    save_path{episode} = all_s(:,1:end-1)';
    save_V(:,:,episode) = RL.V;
    save_numSteps(episode) = env.numSteps - 1;
    save_optimalPath(episode) = env_calc_optimalPath(env);
    %% verbose
    disp(['episode = ' num2str(episode) ' --> ' num2str(it)])
end
beep
% close(video.stream);

%% Results
%% plot number of steps
fig = figure('Color','w','ToolBar','none','MenuBar','none', 'units','normalized','outerposition',[0.1 0.2 0.8 0.5]);
plot(save_numSteps); title('number of steps');
ylim([0,1000]); xlabel('episode');
save_figure(fig,['partAB_numSteps_' 'beta' num2str(RL.beta) '_eps' num2str(RL.epsilon) '_gamma' num2str(RL.gamma) '_lambda' num2str(RL.lambda) '.png']);
%% plot optimal path ratio
fig = figure('Color','w','ToolBar','none','MenuBar','none', 'units','normalized','outerposition',[0.1 0.2 0.8 0.5]); hold on
optimalPathRatio = save_optimalPath ./ save_numSteps;
plot(optimalPathRatio,'Color',0.8*ones(1,3)); 
optimalPathRatio = smooth(optimalPathRatio,100);
plot(optimalPathRatio); title('optimal path ratio');
ylim([0 1.2]); xlabel('episode');
save_figure(fig,['results/partAB_optimalPathRatio_' 'beta' num2str(RL.beta) '_eps' num2str(RL.epsilon) '_gamma' num2str(RL.gamma) '_lambda' num2str(RL.lambda) '.png']);
%% plot optimal path differance
fig = figure('Color','w','ToolBar','none','MenuBar','none', 'units','normalized','outerposition',[0.1 0.2 0.8 0.5]);
optimalPathDiff = abs(save_numSteps - save_optimalPath);
plot(optimalPathDiff); title('plot optimal path differance');
ylim([0 400]); xlabel('episode');
save_figure(fig,['results/partAB_optimalPathDiff_' 'beta' num2str(RL.beta) '_eps' num2str(RL.epsilon) '_gamma' num2str(RL.gamma) '_lambda' num2str(RL.lambda) '.png']);

%% path plot:
fig = figure('Color','w','ToolBar','none','MenuBar','none', 'units','normalized','outerposition',[0.1 0 0.8 1]);
trials = [1 10 100 1000];
for  i = 1:length(trials)
    subplot(2,2,i);
    plot_path(env,save_path,trials(i))
end
save_figure(fig,['results/partAB_pathPlotAll_' 'beta' num2str(RL.beta) '_eps' num2str(RL.epsilon) '_gamma' num2str(RL.gamma) '_lambda' num2str(RL.lambda) '.png']);
fig = figure('Color','w','ToolBar','none','MenuBar','none', 'units','normalized','outerposition',[0.1 0 0.8 1]);
trials = [9970 9980 9990 10000];
for  i = 1:length(trials)
    subplot(2,2,i);
    plot_path(env,save_path,trials(i))
end
save_figure(fig,['results/partAB_pathPlotLast_' 'beta' num2str(RL.beta) '_eps' num2str(RL.epsilon) '_gamma' num2str(RL.gamma) '_lambda' num2str(RL.lambda) '.png']);


%% plot path
fig = figure('Color','w','ToolBar','none','MenuBar','none', 'units','normalized','outerposition',[0.1 0 0.8 1]);
trials = [1 10 100 1000];
for  i = 1:length(trials)
    subplot(2,2,i);
    plot_valuemap(save_V, trials(i))
end
save_figure(fig,['results/partAB_pathAll_' 'beta' num2str(RL.beta) '_eps' num2str(RL.epsilon) '_gamma' num2str(RL.gamma) '_lambda' num2str(RL.lambda) '.png']);
fig = figure('Color','w','ToolBar','none','MenuBar','none', 'units','normalized','outerposition',[0.1 0 0.8 1]);
trials = [9970 9980 9990 10000];
for  i = 1:length(trials)
    subplot(2,2,i);
    plot_valuemap(save_V, trials(i))
end
save_figure(fig,['results/partAB_pathLast_' 'beta' num2str(RL.beta) '_eps' num2str(RL.epsilon) '_gamma' num2str(RL.gamma) '_lambda' num2str(RL.lambda) '.png']);



