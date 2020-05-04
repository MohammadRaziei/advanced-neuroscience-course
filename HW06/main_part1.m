clc; clear all; close all
%%
env = env_make();
numEpisodes = 500;
maxNumSteps = 100;
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
    [s1,s2, env] = env_reset(env);

    all_s = [];

    video.title1 = ['episode = ' num2str(episode)];
    disp(video.title1);
%     env_render(env,RL,video);

    for it = 1:maxNumSteps 
       [action, RL] = RL_policy_softmax(env, RL);
       [o1,o2, reward,env] = env_step(env, action); 
       RL = RL_action_space_softmax(env,RL,action,o1,o2);

       %% TD(0)
       all_s = [all_s;s1,s2]; 

       delta = reward + RL.gamma * RL.V(o1,o2) - RL.V(s1,s2);
       RL.V(s1,s2) = RL.V(s1,s2) + RL.eta * delta;
%        s1 = o1; s2 = o2; env.s1 = s1; env.s2 = s2;
%        env_render(env,RL,video);
%        %% TD(lambda) 
%        V_old = RL.V;
%        RL.V(s1,s2) = reward + RL.V(o1,o2);
%        for t=1:size(all_s,1)-1
%            st = all_s(end-t,:);
%            RL.V(st(1),st(2)) = V_old(st(1),st(2)) + RL.lambda^t*(RL.V(s1,s2) - V_old(s1,s2)); 
%        end
        %%
        s1 = o1; s2 = o2; env.s1 = s1; env.s2 = s2;
       
%        env_render(env,RL,video);

        if env.done
            break;
        end
    end
    save_V(:,:,episode) = RL.V;
    save_path{episode} = all_s;
    save_Start(:,episode) = env.Start;
    save_numSteps = env.numSteps;
end
% close(video.stream);


beep;pause(1);beep;pause(1);beep;pause(1);beep;pause(1);beep;pause(1);beep;pause(1);beep;pause(1);beep;pause(1);


%% path plot:
for j = [1,5,10,20,100,200,500]
    map_path = ones(env.dimSize,env.dimSize);
    ind = save_path{j}';
    d_ind = diff(ind,1,2);
    for i = 1:size(ind,2)
        map_path(ind(1,i),ind(2,i)) = 0.95;
    end
    map_path(env.Target(1),env.Target(2)) = 0;
    map_path(env.Hole(1),env.Hole(2)) = 0.45;
    map_path(save_Start(1,j),save_Start(2,j)) = 0.8;
    figure;
    imagesc(map_path); colormap('gray');
    title(['episode = ' num2str(j)])
    hold on
%     quiver(ind(1,1:size(ind,2)-1),ind(2,1:size(ind,2)-1),d_ind(1,:),d_ind(2,:),0, 'Color','r')
    quiver(ind(2,1:size(ind,2)-1),ind(1,1:size(ind,2)-1),d_ind(2,:),d_ind(1,:),0, 'Color','r')
    set(gca,'YDir','reverse')
    hold off
end


%%
% figure('Color','w','ToolBar','none','MenuBar','none');%, 'units','normalized','outerposition',[0.1 0.2 0.8 0.7]);
%     imagesc(save_V(:,:,1000))
% %     caxis([-5 5])
%     [px,py] = gradient(save_V(:,:,1000));
%     x = 1:env.dimSize; 
%     hold on
%     h = quiver(x,x,px,py);
%     set(h,'AutoScale','on', 'AutoScaleFactor', 3)
%     hold off
% %     title([num2str(txt(i+2)) ' Trials'])
%     colorbar



