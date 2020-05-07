clc; clear all; close all; addpath('functions')
%%
env = env_make();
numEpisodes = 10000;
maxNumSteps = 10000;
%% RL
RL.beta = 0.9; 
RL.eta = 0.2;
RL.epsilon = 0.1;
RL.gamma = 0.95;
RL.lambda = 0.8;
RL.m_act = zeros(size(env.mask));
RL.V = zeros(env.dimSize);

%% save variables
save_path = cell(1,numEpisodes);
save_V = zeros(env.dimSize,env.dimSize ,numEpisodes);
save_Start = zeros(2,numEpisodes);
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
    save_Start(:,episode) = env.Start;
    save_numSteps(episode) = env.numSteps;
    save_optimalPath(episode) = env_calc_optimalPath(env);
    %% verbose
    disp(['episode = ' num2str(episode) ' --> ' num2str(it)])
end
beep
% close(video.stream);

%% Results
%% plot number of steps
figure('Color','w','ToolBar','none','MenuBar','none');
plot(save_numSteps); title('number of steps');
ylim([0,1000]); xlabel('episode');

%% plot optimal path ratio
figure('Color','w','ToolBar','none','MenuBar','none');
optimalPathRatio = save_optimalPath ./ save_numSteps;
optimalPathRatio = smooth(optimalPathRatio,100);
plot(optimalPathRatio); title('optimal path ratio');
ylim([0 1]); xlabel('episode');

%% path plot:
figure('Color','w','ToolBar','none','MenuBar','none');
trials = [1 10 100 1000];
for  i = 1:length(trials)
    subplot(2,2,i);
    plot_path(env,save_path,save_Start,trials(i))
end
figure('Color','w','ToolBar','none','MenuBar','none');
plot_path(env,save_path,save_Start,10000)


%% plot path
figure('Color','w','ToolBar','none','MenuBar','none');%, 'units','normalized','outerposition',[0.1 0.2 0.8 0.7]);
trials = [1 10 100 1000];
for  i = 1:length(trials)
    subplot(2,2,i);
    plot_valuemap(save_V, trials(i))
end
figure('Color','w','ToolBar','none','MenuBar','none');
plot_valuemap(save_V, 10000)




