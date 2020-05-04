clc; clear all; close all
%%
env = env_make();
numEpisodes = 5000;
maxNumSteps = 1000;
%% RL
RL.beta = 0.7; 
RL.eta = 0.2;
RL.epsilon = 0.1;
RL.gamma = 0.95;
RL.lambda = 0.8;
RL.m_act = zeros(size(env.mask));
RL.V = zeros(env.dimSize);
RL.policy = env.mask./repmat(sum(env.mask,3),1,1,4);

%% save variables
save_path = cell(1,numEpisodes);
save_V = zeros(env.dimSize,env.dimSize ,numEpisodes);
save_Start = zeros(2,numEpisodes);
save_numSteps = zeros(1,numEpisodes);

%%
% video = video_make('OneTarget_v2');
video.title2 = 'value map';

for episode = 1:numEpisodes
    video.title1 = ['episode = ' num2str(episode)];
    disp(video.title1);
    
    [s1,s2, env] = env_reset(env);
    all_s = zeros(2,0);
    all_r = zeros(1,0);
    all_v = zeros(1,0);
%     env_render(env,RL,video);
    all_s(:,1) = [s1,s2]; 
    all_v(1) = RL.V(s1,s2);

    for it = 1:maxNumSteps 
       [action, RL] = RL_policy_softmax(env, RL);
       [o1,o2, reward,env] = env_step(env, action); 
       RL = RL_action_space_softmax(env,RL,action,o1,o2);

       %% TD(0)
       all_s(:,it+1) = [o1,o2]; 
       all_r(it) = reward;
       all_v(it+1) = RL.V(o1,o2);
% %        delta = reward + RL.gamma * RL.V(o1,o2) - RL.V(s1,s2);
% %        RL.V(s1,s2) = RL.V(s1,s2) + RL.eta * delta;
%        s1 = o1; s2 = o2; env.s1 = s1; env.s2 = s2;
%        %% TD(lambda) 
%        V_old = RL.V;
%        RL.V(s1,s2) = reward + RL.V(o1,o2);
%        for t=1:size(all_s,1)
%            st = all_s(end-t,:);
%            RL.V(st(1),st(2)) = V_old(st(1),st(2)) + RL.lambda^t*(RL.V(s1,s2) - V_old(s1,s2)); 
%        end

        %% update states
        s1 = o1; s2 = o2; env.s1 = s1; env.s2 = s2;

%        env_render(env,RL,video); 

        if env.done
            break;
        end
    end
%     delta = all_r + RL.gamma * all_v(2:end) - all_v(1:end-1);
%     all_v = all_v(1:end-1) + RL.eta * delta;
%     for i = 1:length(v_path)
%         value_map(loc_path(1,i),loc_path(2,i)) = v_path(i);
%     end
    for t = length(all_s):-1:2
            delta = all_r(t-1) + RL.gamma * all_v(t) - all_v(t-1);
%             all_v = all_v(1:end-1) + RL.eta * delta;
%         RL.V(all_s(1,i),all_s(2,i)) = all_v(i-1);
        RL.V(all_s(1,t),all_s(2,t)) = all_v(t-1) + RL.eta * delta;

    end
    %% Save logs
    save_path{episode} = all_s';
    save_V(:,:,episode) = RL.V;
    save_Start(:,episode) = env.Start;
    save_numSteps(episode) = env.numSteps;
end
% close(video.stream);


% beep;pause(1);beep;pause(1);beep;pause(1);beep;pause(1);beep;pause(1);beep;pause(1);beep;pause(1);beep;pause(1);

figure; plot(save_numSteps); ylim([0,1000])
%% path plot:
figure; plot_path(env,save_path,save_Start,900)
% for j = [1,5,10,20,100,200,500,700,900,1000]
%     map_path = ones(env.dimSize,env.dimSize);
%     ind = save_path{j}';
%     d_ind = diff(ind,1,2);
%     for i = 1:size(ind,2)
%         map_path(ind(1,i),ind(2,i)) = 0.95;
%     end
%     map_path(env.Target(1),env.Target(2)) = 0;
%     map_path(env.Hole(1),env.Hole(2)) = 0.45;
%     map_path(save_Start(1,j),save_Start(2,j)) = 0.8;
%     figure;
%     imagesc(map_path); colormap('gray');
%     title(['episode = ' num2str(j)])
%     hold on
% %     quiver(ind(1,1:size(ind,2)-1),ind(2,1:size(ind,2)-1),d_ind(1,:),d_ind(2,:),0, 'Color','r')
%     quiver(ind(2,1:size(ind,2)-1),ind(1,1:size(ind,2)-1),d_ind(2,:),d_ind(1,:),0, 'Color','r')
%     set(gca,'YDir','reverse')
%     hold off
% end


%%
if(false)
figure('Color','w','ToolBar','none','MenuBar','none');%, 'units','normalized','outerposition',[0.1 0.2 0.8 0.7]);
    tr = 1000;
imagesc(save_V(:,:,tr))
%     caxis([-5 5])
    [px,py] = gradient(save_V(:,:,tr));
    x = 1:env.dimSize; 
    hold on
    h = quiver(x,x,px,py);
%     set(h,'AutoScale','on', 'AutoScaleFactor', 3)
    hold off
%     title([num2str(txt(i+2)) ' Trials'])
    colorbar


end
