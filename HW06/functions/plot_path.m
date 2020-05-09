function plot_path(env,save_path,k)
    map_path = ones(env.dimSize,env.dimSize);
    ind = save_path{k}';
    start = ind(:,1);
    d_ind = diff(ind,1,2);
    for i = 1:size(ind,2)
        map_path(ind(1,i),ind(2,i)) = (env.color_agent + map_path(ind(1,i),ind(2,i)) )/2;
    end
    map_path(env.Target(1),env.Target(2)) = 0;
	if not(isequal(env.Target2,[0 0]))
        map_path(env.Target2(1),env.Target2(2)) = 0;
    end
    map_path(env.Hole(1),env.Hole(2)) = 0.45;
    map_path(start(1),start(2)) = 0.8;
    imagesc(map_path); colormap('gray');
    title(['episode = ' num2str(k)])
    hold on
%     quiver(ind(1,1:size(ind,2)-1),ind(2,1:size(ind,2)-1),d_ind(1,:),d_ind(2,:),0, 'Color','r')
    quiver(ind(2,1:size(ind,2)-1),ind(1,1:size(ind,2)-1),d_ind(2,:),d_ind(1,:),0, 'Color','r')
    set(gca,'YDir','reverse')
    hold off
end