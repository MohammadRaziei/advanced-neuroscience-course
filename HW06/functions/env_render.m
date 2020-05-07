function env_render(env,RL, video)
    map = env.map;
    map(env.s1,env.s2) = env.color_agent;
    pause(0.01); clf;
    subplot(121);
        imagesc(map); colormap('gray');
        grid_on(0.5:env.dimSize+0.5,0.5:env.dimSize+0.5); 
        if not(isempty(video.title1))
           title(video.title1);
        end

    subplot(122);
%         heatmap(RL.V); caxis([-1,1]*2);  %colormap('gray');
        imagesc(RL.V); caxis([-1,1]*3); colorbar %colormap('gray'); 
        grid_on(0.5:env.dimSize+0.5,0.5:env.dimSize+0.5); hold on;
%         quiver(x,y,RL.V,RL.V)
        if not(isempty(video.title2))
           title(video.title2);
        end
%         grid_on(0.5:env.dimSize+0.5,0.5:env.dimSize+0.5);
%     colorbar;
    if not(isempty(video.fig))
        frame = getframe(video.fig);
        writeVideo(video.stream, frame);
    end


end