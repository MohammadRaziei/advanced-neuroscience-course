clc; clear all; close all
%%
env = env_make();
numEpisodes = 1000;
%% RL
RL.beta = 0.8; 
RL.eta = 0.2;
RL.epsilon = 0.1;
RL.gamma = 0.95;
RL.lambda = 0.8;
RL.m_act = zeros(size(env.mask));
RL.V = zeros(env.dimSize);
RL.policy = env.mask./repmat(sum(env.mask,3),1,1,4);

%%
save_all_s = cell(1,numEpisodes);

%%
% video = video_make('OneTarget_v2');
video.title2 = 'value map';

for episode = 1:numEpisodes
    [s1,s2, env] = env_reset(env);
    all_s = [];

    video.title1 = ['episode = ' num2str(episode)];
    disp(video.title1);
%     env_render(env,RL,video);

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
       
%        env_render(env,RL,video);
    end
    save_all_s{episode} = all_s;
end
% close(video.stream);


beep;pause(1);beep;pause(1);beep;pause(1);beep;pause(1);beep;pause(1);beep;pause(1);beep;pause(1);beep;pause(1);








