clc; clear all; close all; addpath('functions'); rng(41)
%% create environment
env = env_make();
numEpisodes = 5000;
maxNumSteps = 10000;

%% save B
save_B_numSteps = zeros(10,10,3);
save_B_ratio = zeros(10,10,3);
save_B_diff = zeros(10,10,3);

%% 
gamma_list = linspace(0.4,0.95 ,10);
eps_list = linspace(0.01,0.1,10);
for i_gamma = 1:length(gamma_list)
    for i_eps = 1:length(eps_list)
        disp(['(' num2str(i_gamma) ',' num2str(i_eps) ')']);
        RL.beta = 15; 
        RL.eta = 0.2;
        RL.epsilon = eps_list(i_eps);
        RL.gamma = gamma_list(i_gamma);
        RL.lambda = 0.8;
        RL.m_act = zeros(size(env.mask));
        RL.V = zeros(env.dimSize);

        %% save variables
        save_path = cell(1,numEpisodes);
        save_numSteps = zeros(1,numEpisodes);
        save_optimalPath = zeros(1,numEpisodes);

        %%
        % video = video_make('OneTarget_v2');
%         video.title2 = 'value map';

        for episode = 1:numEpisodes
%             video.title1 = ['episode = ' num2str(episode)];
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
            save_numSteps(episode) = env.numSteps - 1;
            save_optimalPath(episode) = env_calc_optimalPath(env);
            %% verbose
%             disp(['episode = ' num2str(episode) ' --> ' num2str(it)])
        end
        % close(video.stream);

        %% Results
        %% plot number of steps
        x = 1:length(save_numSteps); [B,~] = fit_exponential(x, save_numSteps, [50;0;10]);
        save_B_numSteps(i_gamma,i_eps,:) = B;
        %% plot optimal path ratio
        optimalPathRatio = save_optimalPath ./ save_numSteps;
        x = 1:length(optimalPathRatio); [B,~] = fit_exponential(x, optimalPathRatio,[-1;0;1]);
        save_B_ratio(i_gamma,i_eps,:) = B;
        %% plot optimal path differance
        optimalPathDiff = abs(save_numSteps - save_optimalPath);
        x = 1:length(optimalPathDiff); [B,~] = fit_exponential(x, optimalPathDiff, [50;0;10]);
        save_B_diff(i_gamma,i_eps,:) = B;
    end
end
%%
beep; pause(1); beep; pause(1); beep; pause(1); beep; pause(1); beep;

save save_B save_B_numSteps save_B_ratio save_B_diff
%%
figure('Color','w','ToolBar','none','MenuBar','none', 'units','normalized','outerposition',[0.15 0 0.65 1]);
imagesc(save_B_diff(:,:,2)); title('Learning Delay using number of steps');
xlabel('epsilon(\epsilon)'); xticklabels(cellstr(string(num2str(eps_list','%.3f'))))
ylabel('gamma(\gamma)'); yticklabels(cellstr(string(num2str(gamma_list','%.3f'))))
save_figure(gcf, 'results/partC_heatmap_B2_diff.png')
%%
figure('Color','w','ToolBar','none','MenuBar','none', 'units','normalized','outerposition',[0.15 0 0.65 1]);
imagesc(save_B_ratio(:,:,2)); title('Learning Delay using optimal-path-ratio');
xlabel('epsilon(\epsilon)'); xticklabels(cellstr(string(num2str(eps_list','%.3f'))))
ylabel('gamma(\gamma)'); yticklabels(cellstr(string(num2str(gamma_list','%.3f'))))
save_figure(gcf, 'results/partC_heatmap_B2_ratio.png')
%%
figure('Color','w','ToolBar','none','MenuBar','none', 'units','normalized','outerposition',[0.15 0 0.65 1]);
imagesc(save_B_numSteps(:,:,2)); title('Learning Delay using optimal-path-differance');
xlabel('epsilon(\epsilon)'); xticklabels(cellstr(string(num2str(eps_list','%.3f'))))
ylabel('gamma(\gamma)'); yticklabels(cellstr(string(num2str(gamma_list','%.3f'))))
save_figure(gcf, 'results/partC_heatmap_B2_numSteps.png')