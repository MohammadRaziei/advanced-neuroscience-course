function grid_on(g_x,g_y)
hold on
% g_y=.5:10.5; % user defined grid Y [start:spaces:end]
% g_x=.5:10.5; % user defined grid X [start:spaces:end]
for i=1:length(g_x)
hold on
plot([g_x(i) g_x(i)],[g_y(1) g_y(end)],'k-') %y grid lines
plot([g_x(1) g_x(end)],[g_y(i) g_y(i)],'k-') %y grid lines
end
end