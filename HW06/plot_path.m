function plot_path(env,save_path,save_Start,k)
    map_path = ones(env.dimSize,env.dimSize);
    ind = save_path{k}';
    d_ind = diff(ind,1,2);
    for i = 1:size(ind,2)
        map_path(ind(1,i),ind(2,i)) = 0.95;
    end
    map_path(env.Target(1),env.Target(2)) = 0;
    map_path(env.Hole(1),env.Hole(2)) = 0.45;
    map_path(save_Start(1,k),save_Start(2,k)) = 0.8;
    imagesc(map_path); colormap('gray');
    title(['episode = ' num2str(k)])
    hold on
%     quiver(ind(1,1:size(ind,2)-1),ind(2,1:size(ind,2)-1),d_ind(1,:),d_ind(2,:),0, 'Color','r')
    quiver(ind(2,1:size(ind,2)-1),ind(1,1:size(ind,2)-1),d_ind(2,:),d_ind(1,:),0, 'Color','r')
    set(gca,'YDir','reverse')
    hold off
end