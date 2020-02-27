%% part a
clc
clear;
close all;

dt = 0.0001;
tSim = 0.1;
vr = 0;
Vth = 15;
RI = 20;
v = zeros(1,tSim/dt);
tau_m = 0.005;

for i = 1:(tSim/dt)-1
    
   dv =  (dt*(-v(i)+RI))/tau_m;
   v(i+1) = v(i)+dv;
   if v(i+1) >= Vth
      v(i) = 120;
      v(i+1) = vr; 
   end
    
end
plot(v)

%% part c
clc
clear;
close all;
k = 8;
dt = 1e-4;
fr = 500;
% Vth = 30;
Vth = 20e-3;
Vr = -30e-3;
% Vr = 0;
tsim = 5;
tau_m = 5e-3;
t_peak = 1.5e-3;
[spikeMat,tVec] = poissonSpikeGen(fr,tsim,1,dt);
delta_index = find(spikeMat);
% delta_index_k = delta_index(1:k);
% t0 = delta_index_k(end)*dt;
% v =@(t) vr*exp(-(t-t0)/taw_m)+(R/taw_m)*sum()
run lambda_functions
%
t = 0:dt:tsim-dt;
t0 = 0;
v = zeros(size(t));
Is = 20* t.*exp(-t/t_peak);
Is = Is(1:200);
I = filter(Is,1,spikeMat);
% I = conv(Is,spikeMat);
R = 1;numberOfFiring = 0; 

start_idx = 1;
for i = 1:length(t)
    initial = Vr*exp(-(t(i) - t0)/tau_m);
    sumation = 0;
%     s = 0;
    for s = 0:dt:(t(i)-t0)
        idx = 1+round((t(i)-s)/dt);
        sumation = sumation + exp(-s/tau_m).*I(idx) * dt; 
    end
    v(i) = initial + R/tau_m * sumation;
    if(v(i) >= Vth)
        v(i) = 0.45 ;
        t0 = t(i+1);
        
        numberOfFiring = numberOfFiring + 1;
        integrate_index(numberOfFiring) = i;
        end_idx = i;
        integrate_mat(numberOfFiring) = sum(spikeMat(start_idx:end_idx));
        start_idx = i;         
    end
end
v = v - 50e-3;
%
figure;
subplot(4,1,1:3);
hold on;
plot(t,v, t,Vth*ones(size(t))-50e-3,'r', t,zeros(size(t))-50e-3,'y');
plotts(I-50e-3,dt,'g')

subplot(414);
plot((0:length(spikeMat)-1)*dt, 0.1*spikeMat,'color',[0,0,0]+0.9);
hold on;plotts(I,dt,'g'); 

figure; histogram(integrate_mat);
%% part D

clc
clear;
close all;
k = 8;
dt = 1e-4;
fr = 500;
% Vth = 30;
Vth = 20e-3;
Vr = -30e-3;
% Vr = 0;
tsim = 5;
tau_m = 5e-3;
t_peak = 1.5e-3;
[spikeMat,tVec] = poissonSpikeGen(fr,tsim,1,dt);
delta_index = find(spikeMat); spikeMat = double(spikeMat);
n_spikes = length(delta_index);
ie_ratio = 0.2;
ipsp_idx = randsample(n_spikes ,floor(ie_ratio*n_spikes));
spikeMat(delta_index(ipsp_idx)) = -1;
% plot(spikeMat)
run lambda_functions
%
t = 0:dt:tsim-dt;
t0 = 0;
v = zeros(size(t));
Is = 20* t.*exp(-t/t_peak);
Is = Is(1:200);
I = filter(Is,1,spikeMat);
% I = conv(Is,spikeMat);
R = 1;numberOfFiring = 0; 
%
start_idx = 1;
for i = 1:length(t)
    initial = Vr*exp(-(t(i) - t0)/tau_m);
    sumation = 0;
%     s = 0;
    for s = 0:dt:(t(i)-t0)
        idx = 1+round((t(i)-s)/dt);
        sumation = sumation + exp(-s/tau_m).*I(idx) * dt; 
    end
    v(i) = initial + R/tau_m * sumation;
    if(v(i) >= Vth)
        v(i) = 0.45 ;
        t0 = t(i+1);
        
        numberOfFiring = numberOfFiring + 1;
%         integrate_index(numberOfFiring) = i;
        end_idx = i;
        integrate_mat(numberOfFiring) = sum(spikeMat(start_idx:end_idx));
        integrate_mat_idx(1:2,numberOfFiring) = [start_idx; end_idx]; 
        start_idx = i+1;         
    end
end
v = v - 50e-3;
%%
figure;
subplot(4,1,1:3);
hold on;
plot(t,v, t,Vth*ones(size(t))-50e-3,'r', t,zeros(size(t))-50e-3,'y');
plotts(I-50e-3,dt,'g')

subplot(414);
plot((0:length(spikeMat)-1)*dt, 0.1*spikeMat,'color',[0,0,0]+0.9);
hold on;plotts(I,dt,'g'); 

figure; histogram(integrate_mat,100);


