clc; clear all; close all
%%
env = env_make();
numEpisodes = 50;
%% RL
RL.beta = 1; 
RL.eta = 0.2;
RL.epsilon = 0.1;
RL.gamma = 0.95;
RL.lambda = 0.8;
RL.m_act = zeros(size(env.mask));
RL.V = zeros(env.dimSize);
%%
save_all_s = cell(1,numEpisodes);
%%
video.fig = figure('Color','w','ToolBar','none','MenuBar','none', 'units','normalized','outerposition',[0.1 0.2 0.8 0.7]);
video.name = 'OneTarget';
video.title2 = 'value map';
video.stream = VideoWriter(video.name,'MPEG-4'); %open video file
video.stream.FrameRate = 5;  
open(video.stream)

for episode = 1:numEpisodes
    [s1,s2, env] = env_reset(env);
    all_s = [];

%     action = env_action_space_sample(env);
    video.title1 = ['episode = ' num2str(episode)];
    env_render(env,RL,video);

    while not(env.done)
       [action, RL] = RL_policy_softmax(env, RL);
       [o1,o2, reward,env] = env_step(env, action); 
       RL = RL_action_space_softmax(RL,action,o1,o2);

%        %% TD(0)
%        delta = reward + RL.gamma * RL.V(o1,o2) - RL.V(s1,s2);
%        RL.V(env.s1,env.s2) = RL.V(s1,s2) + RL.eta * delta;
%        s1 = o1; s2 = o2; env.s1 = s1; env.s2 = s2;
%        env_render(env,RL,video);
       %% TD(lambda) 
       all_s = [all_s;s1,s2]; 
       V_old = RL.V;
       RL.V(s1,s2) = reward + RL.V(o1,o2);
       for t=1:size(all_s,1)-1
           st = all_s(end-t,:);
           RL.V(st(1),st(2)) = V_old(st(1),st(2)) + RL.lambda^t*(RL.V(s1,s2) - V_old(s1,s2)); 
       end
       s1 = o1; s2 = o2; env.s1 = s1; env.s2 = s2;
       env_render(env,RL,video);
    end
    save_all_s{episode} = all_s;
end
close(video.stream);


beep;pause(1);beep;pause(1);beep;pause(1);beep;pause(1);beep;pause(1);beep;pause(1);beep;pause(1);beep;pause(1);








