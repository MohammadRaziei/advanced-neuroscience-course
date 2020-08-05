clc; clear all; close all;
addpath('Codes'); addpath('utils'); rng(1)
%% Generate poisson spikes
fr = 12; durationTime=1; dt = 1e-3;
[spikes,tVec] = poissonSpikeGen(fr,durationTime,1,dt);

%% Plot the spikes
figure_position([0.2 0.2 0.5 0.3]); hold on
plotRaster(spikes,tVec,'poisson spikes','b')
save_figure(gcf,'results/partA_1-plotRaster.png')

%% Calc FanoFactor
fr = 120; durationTime=100; dt = 1e-3;
spikesMat = poissonSpikeGen(fr,durationTime,1000,dt);

spikesMatFr = sum(spikesMat,2);
fanoFactor = var(spikesMatFr)/mean(spikesMatFr);
disp(['Fano-Factor : ' num2str(fanoFactor)]);

%% Calc ISI and CV
fr = 120; durationTime=1000; dt = 1e-3;
spikes = poissonSpikeGen(fr,durationTime,1,dt);
isi = diff(find(spikes == 1));
Cv = std(isi)/mean(isi);

figure_position([0.2 0.2 0.5 0.5]);
histfit(isi,120,'exponential')
disp(['Cv :          ' num2str(Cv)]);
save_figure(gcf,'results/partA_2-isi.png')

%% plot STDP Curve
dt = 1e-3; t = -0.1:dt:0.1; 
figure_position([0.2 0.2 0.5 0.5]); 
plot(t, stdp_curve(t) *100 , t,zeros(size(t)), 'r');
xlabel('time, t(ms)')
ylabel('synaptic change, %')
legend('STDP'); legend box off
save_figure(gcf,'results/partA_3-STDP-curve.png')

%% plot 'calculate_synaptic_change_1' function:
clear all;
durationTime = 10;
colors = 'rbgpmyk';
preRates= [8 24]; 
postRates = 1:4:40;
nTrials = 30;

figure_position([0.2 0.2 0.5 0.5]); hold on;
legend_cell = cell(1,length(preRates));
for i = 1:length(preRates)
    w_all = zeros(nTrials,length(postRates));
    for j = 1:length(postRates)
    %     disp(['==> calc wall :  ' num2str(100*i/length(postRates),'%.2f') ' %'])
        for tr = 1:nTrials
            w_all(tr, j) = calculate_synaptic_change_1(durationTime, preRates(i), postRates(j));
        end
    end
    plot(postRates, mean(w_all, 1), ['*' colors(i)]);
    xlabel('postsynaptic firing-rate'); ylabel('synaptic change, %')
    title('all-to-all')
    legend_cell{i} = ['presynaptic firing-rate = ' num2str(preRates(i))];
end
legend(legend_cell)
save_figure(gcf,'results/partA_4-func1.png')

% ylim([-50 0])
%% plot 'calculate_synaptic_change_2' function:
clear all;
durationTime = 15;
colors = 'rbgpmyk';
preRates= [8 24]; 
postRates = 1:4:40;
nTrials = 30;

figure_position([0.2 0.2 0.5 0.5]); hold on;
legend_cell = cell(1,length(preRates));
for i = 1:length(preRates)
    w_near = zeros(nTrials,length(postRates));
    for j = 1:length(postRates)
    %     disp(['==> calc wall :  ' num2str(100*i/length(postRates),'%.2f') ' %'])
        for tr = 1:nTrials
            w_near(tr, j) = calculate_synaptic_change_2(durationTime, preRates(i), postRates(j));
        end
    end
    plot(postRates, mean(w_near, 1), ['*' colors(i)])
    legend_cell{i} = ['presynaptic firing-rate = ' num2str(preRates(i))];
end
legend(legend_cell, 'Location','northwest')
xlabel('postsynaptic firing-rate'); ylabel('synaptic change, %')
title('nearest neighbor')
save_figure(gcf,'results/partA_5-func2.png')

%% plot 'calculate_synaptic_change_3' function:
clear all;
durationTime = 15;
colors = 'rbgpmyk';
preRates= [8 24]; 
postRates = 1:4:40;
nTrials = 30;

figure_position([0.2 0.2 0.5 0.5]); hold on;
legend_cell = cell(1,length(preRates));
for i = 1:length(preRates)
    w_near = zeros(nTrials,length(postRates));
    for j = 1:length(postRates)
    %     disp(['==> calc wall :  ' num2str(100*i/length(postRates),'%.2f') ' %'])
        for tr = 1:nTrials
            w_near(tr, j) = calculate_synaptic_change_3(durationTime, preRates(i), postRates(j));
        end
    end
    plot(postRates, mean(w_near, 1), ['*' colors(i)])
    legend_cell{i} = ['presynaptic firing-rate = ' num2str(preRates(i))];
end
legend(legend_cell, 'Location','northwest')
xlabel('postsynaptic firing-rate'); ylabel('synaptic change, %')
title('nearest neighbor')
save_figure(gcf,'results/partA_6-func3.png')




