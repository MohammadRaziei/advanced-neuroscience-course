function sim_env_render(env,video,path_states)
    map_path = env.map;
    start = path_states(1,:);
    map_path(start(1),start(2)) = env.color_agent;  
    for it = 2:size(path_states)
        pause(0.001); clf;
        ind = path_states(1:it,:)';
        d_ind = diff(ind,1,2);
        map_path(ind(1,it),ind(2,it)) = (env.color_agent + map_path(ind(1,it),ind(2,it)))/2;


        imagesc(map_path); colormap('gray'); hold on
        quiver(ind(2,1:size(ind,2)-1),ind(1,1:size(ind,2)-1),d_ind(2,:),d_ind(1,:),0, 'Color','r')
        set(gca,'YDir','reverse')
        grid_on(0.5:env.dimSize+0.5,0.5:env.dimSize+0.5);
        hold off
    
        if not(isempty(video.title1))
           title(video.title1);
        end
        if not(isempty(video.fig))
            frame = getframe(video.fig);
            writeVideo(video.stream, frame);
        end
    
    end
    
    
    
    
end