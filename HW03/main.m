clc; close all; clear all;
%% init
data_path = (fullfile('pvc-11','data_and_scripts')); 

gratingSpikes_monkey =@(m)(fullfile([data_path '/spikes_gratings'],['data_monkey' num2str(m) '_gratings.mat']));
resamp = @(x,tx,a,meth) resample(x,tx,a/(tx(2)-tx(1)),meth,1,1); % 'linear', 'spline', 'pchip'


monkey_number = 3;


%% Q1
close all;clc
load(gratingSpikes_monkey(monkey_number))

[num_units, num_stimulus, num_trials] = size(data.EVENTS);


tuning = zeros(num_units, num_stimulus);
numberOfSpikes = zeros(size(data.EVENTS));
for i = 1:num_units
    for j = 1:num_stimulus
        mean_len = 0;
        for k = 1:num_trials   
            len = length(data.EVENTS{i,j,k});
            mean_len = mean_len + len;   
            numberOfSpikes(i,j,k) = len;
        end
        mean_len = mean_len/num_trials;
        tuning(i,j) = mean_len;
    end      
end
%%
units_plot = [3,25,30,57,65,90,102,104,106
              3,8,14,22,57,65,72,86,88
              4,8,16,22,58,67,88,99,105];
          
fig = figure('Color','w','units','normalized','outerposition',[0 0 1 1]); i = 0;
set(fig,'Name',['For Monkey : ' num2str(monkey_number)],'NumberTitle','off','ToolBar','none','MenuBar','none');

for n = units_plot(monkey_number,:)
    i  = i + 1;
    subplot(3,3,i);
    tx = 0:30:360;
    x = tuning(n,:); x = [x,x(1)];
    [y,ty] = resamp(x,tx,10,'pchip');
    hold on;
    plot(ty,y)
    plot(tx,x,'*')
    title(['unit = ' num2str(n)])
    xlim([0,360]);
    xticks(tx(1:2:end));
end
%%
figure('Color','w','units','normalized','outerposition',[0 0.2 1 0.6],'ToolBar','none','MenuBar','none');
imagesc(imresize(tuning', [360 106]));
xlabel('Unit');
ylabel('Angle');
title(['For monkey ' num2str(monkey_number)]);
%% Q2


% x = tuning(n,:); x = [x x(1)];
% TF = islocalmax([max(x)/2 x max(x)/2],'MinProminence',1);
% TF = TF(2:end-1);
% b = find(TF);
% if not(length(b) == 2 && mod(diff(b),6) == 0)
%     disp(n)
% end
% direction = max(1)
%         
% plot(tx,x,t(TF),x(TF),'r*')

for n = 1:num_units
    x = tuning(n,:); x = [x x(1)];
    [A,idx] = max(x);
    direction(n) = 30 * mod(idx,6);
    amplitude(n) = A;
end
%%
direction_2D = NaN(10);
save_map = NaN(10);

for n = 1:num_units
   channel = data.CHANNELS(n, 1);
   [i,j] = find(channel == data.MAP);
   if isnan(direction_2D(i,j)) || amplitude(save_map(i,j)) < amplitude(n)
       direction_2D(i,j) = direction(n);
       save_map(i,j) = n;
   end
end
%%
figH = figure('units','normalized','outerposition',[0 0 1 1]);
set(figH,'Name',['Heatmap For Monkey : ' num2str(monkey_number)],'NumberTitle','off','Color','w','ToolBar','none','MenuBar','none');

direction_2D_color = (direction_2D/30)+1;
direction_2D_color(isnan(direction_2D_color)) = 0;

subplot(211)
imagesc(direction_2D_color);
% gridlines ---------------------------
grid_on(0.5:10.5,0.5:10.5)
xticks(1:10); yticks(1:10);
cbh=colorbar('v');
set(cbh,'YTick', 0:6, 'YTickLabel',{'NaN','0','30','60','90','120','150'})


subplot(212)
heatmap(direction_2D)
%% Q3
signal_corr = corrcoef(tuning');
select_idx = nchoosek(1:num_units,2);
for i = 1:size(select_idx,1)
    temp(i) = signal_corr(select_idx(i,1),select_idx(i,2));
end
signal_corr = temp;

% noise_corr = NaN(num_units,num_units, num_stimulus);

cat1 = select_idx((signal_corr >= 0.5),:);
cat2 = select_idx((signal_corr < 0.5 & signal_corr >=0),:);
cat3 = select_idx((signal_corr >= -0.5 & signal_corr < 0),:);
cat4 = select_idx((signal_corr < -0.5),:);

%%


figure('Color','w','ToolBar','none','MenuBar','none'); hold on; 
lineWidth_arr = [5,4,3,2];
plot_cell = NaN(5,1);
plot_cell(1) = plot(0,'w');

for cat_n = 1:4
    cat = eval(['cat' num2str(cat_n)]);
%     clear noise_corr distance mean_trial_n_corr mean_dis_n_corr 
    noise_corr = zeros(length(cat),num_stimulus);
    distance = zeros(length(cat),1);
    for c = 1:length(cat)
        for st = 1:num_stimulus       
            corr_mat = corrcoef(squeeze(numberOfSpikes(cat(c,:),st,:))');
            noise_corr(c,st) = corr_mat(2);
        end
        % calc distance:
        channel_neuron = data.CHANNELS(cat(c,:));
        [x1,y1] = find(data.MAP == channel_neuron(1));
        [x2,y2] = find(data.MAP == channel_neuron(2));
        distance(c) = (abs(complex(x1,y1) - complex(x2,y2)));    
    end
    
    descreted_distance = round(distance);
    ud_distance = unique(descreted_distance);
    ud_distance(ud_distance == 0) = [];
    out_mean = zeros(size(ud_distance));
    out_err = zeros(size(ud_distance));
    for i = 1:length(ud_distance)
        index = find(descreted_distance == ud_distance(i));
        out_mean(i) = mean2(noise_corr(index,:));
        out_err(i) = std2(noise_corr(index,:));
    end
    
    plot_cell(cat_n + 1) = plot(ud_distance,out_mean,'LineWidth',lineWidth_arr(cat_n));
    colour = get(plot_cell(cat_n + 1) ,'Color');
    errorbar(ud_distance,out_mean,out_err/10,'Color',0.8*colour)
    
end
legend(plot_cell,'r_{signal}','         > 0.5','       0 to 0.5','       0 to -0.5','         < -0.5');
legend boxoff
ylabel('Spike count correlation (r_{sc})');
















