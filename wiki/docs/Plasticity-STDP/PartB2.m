clc; clear all; close all;
addpath('Codes'); addpath('utils');
%%
alpha = 1;
rng(1);

tr = 1;

preRates_ex = randi([15 40],1,19); %19 
preRates_in = alpha(tr) * randi([5 25],1,11); %11

numPreNeuEx = length(preRates_ex);
numPreNeuIn = length(preRates_in);
numPreNeu = numPreNeuIn + numPreNeuEx;


tSim = 5; dt = 1e-3;
preSpikesMat = zeros(numPreNeu, ceil(tSim/dt));
for i = 1:numPreNeuEx
    preSpikesMat(i,:) = poissonSpikeGen(preRates_ex(i), tSim, 1, dt);
end
for i = 1:numPreNeuIn
    preSpikesMat(numPreNeuEx+i,:) = poissonSpikeGen(preRates_in(i), tSim, 1, dt);
end

%%
preSpikesEx = cell(1, numPreNeuEx);
preSpikesIn = cell(1, numPreNeuIn);

for i = 1:numPreNeuEx
    preSpikesEx{i} = find(preSpikesMat(i,:));
end
for i = 1:numPreNeuIn
    preSpikesIn{i} = find(preSpikesMat(numPreNeuEx+i,:));
end
%%
W_ex = 0.5 * ones(1, numPreNeuEx);
W_in = ones(1, numPreNeuIn);
Ws = [W_ex, W_in];


C = 30e-3;
gl = 1;
ge_0 = 0;
gi_0 = 0;
tau_ge = 3e-3;
tau_gi = 5e-3;
vr = -70e-3;
ve = 0;
vi = -80e-3;
Vth = -50e-3;
Vsp = -30e-3;


dt = 1e-3;
Time = 1;
times = 0:dt:Time-dt;
v = zeros(1,ceil(Time/dt)) + vr;
PostSpikes = zeros(size(v));
g_save = zeros(2,size(v,2));
%%
ge = ge_0; gi = gi_0;
preSpikesTimeStack = cell(numPreNeu ,1);
numPostSpikes = 0;
postSpikeTime = zeros(1,0);
for i = 1:length(times)
   t = times(i);
   d_ge = -ge/tau_ge * dt;
   d_gi = -gi/tau_gi * dt;
   ge = ge + d_ge;
   gi = gi + d_gi;
   
%    g
   [neuIdx,~] = find(preSpikesMat(:,i));
   sw_e = sum(Ws(neuIdx(neuIdx<=numPreNeuEx)));
   sw_i = sum(Ws(neuIdx(neuIdx>numPreNeuEx)));
   
   ge = ge + sw_e;
   gi = gi + sw_i;
   
   d_v = ( gl*(vr-v(i)) + ge*(ve-v(i)) + gi*(vi-v(i)) ) * dt/C;
   v(i+1) = v(i) + d_v;
   
   
   g_save(1,i) = ge;
   g_save(2,i) = gi;
   
   if v(i+1) >= Vth
        numPostSpikes = numPostSpikes + 1;
        PostSpikes(i) = 1;
        postSpikeTime = [postSpikeTime i*dt];
        %       ge = ge_0;
        %       gi = gi_0;
        v(i) = Vsp;
        v(i+1) = vr; 
        dw_prev = zeros(1,numPreNeu);
        dw_next = zeros(1,numPreNeu);
        for neu_i = 1:numPreNeu
            if numPostSpikes > 1
                minP = min(preSpikesTimeStack{neu_i});
                if minP 
                    dw_next(neu_i) = stdp_curve(postSpikeTime(end-1) - minP);
                end
            end
            maxP = max(preSpikesTimeStack{neu_i});
            if maxP
                dw_prev(neu_i) = stdp_curve(postSpikeTime(end) - maxP);
            end
        end
        dw = (dw_prev + dw_next).* Ws;
        Ws = Ws + dw;
        preSpikesTimeStack = cell(numPreNeu ,1);
   else
        for neu_i = 1:length(neuIdx) 
            preSpikesTimeStack{neuIdx(neu_i)} = [preSpikesTimeStack{neuIdx(neu_i)} i*dt];
        end
   end
   
end
v(end-1) = [];
%%
figure_position([0.05 0.2 0.9 0.4]);
plot(times, v, times, zeros(size(times))+Vth, 'y')
ylabel('v'); xlabel('time');
save_figure(gcf,'results/partB2_1-v.png')

figure_position([0.05 0.2 0.9 0.7]);
subplot(211); plot(times, g_save(1,:)); ylabel('ge'); xlabel('time');
subplot(212); plot(times, g_save(2,:)); ylabel('gi'); xlabel('time');
save_figure(gcf,'results/partB2_2-ge-gi.png')

sum(PostSpikes)