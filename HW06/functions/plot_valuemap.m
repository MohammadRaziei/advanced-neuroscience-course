function plot_valuemap(save_V, tr)
    imagesc(save_V(:,:,tr))
    caxis([-1 1])
    [px,py] = gradient(save_V(:,:,tr));
    x = 1:size(save_V,1); y = 1:size(save_V,2);
    hold on
    h = quiver(x,y,px,py);
    title(['value map after ' num2str(tr) ' episodes'])
%     set(h,'AutoScale','on', 'AutoScaleFactor', 3)
    hold off
%     title([num2str(txt(i+2)) ' Trials'])
    colorbar
end