%% part a
clc
clear;
close all;
trials = 1;
fr = 100;

[spikeMat,tVec] = poissonSpikeGen(fr,1,trials,0.001);
plotRaster(spikeMat, tVec, 'Raster Plot', 'blue')


%% part b
clc
clear;
close all;
trials = 1000;
fr = 100;

[spikeMat,tVec] = poissonSpikeGen(fr,1,trials,0.001);
transposed_spikeMat = spikeMat';
histogram(sum(transposed_spikeMat))

%% part c
clc
clear;
close all;
trials = 1000;
fr = 100;
dt = 0.001;

[spikeMat,tVec] = poissonSpikeGen(fr,1,trials,dt);
nonzeros = find(spikeMat);
isi = diff(nonzeros)*dt;
histogram(isi)

%% integrate and fire post synaptic neuron
clc
clear;
close all;
trials = 1;
fr = 400;
tSim = 1000;
dt = 0.001;
k = 9;

[spikeMat,tVec] = poissonSpikeGen(fr,tSim,trials,dt);
[m,n] = size(spikeMat);
post_spikeMat_transposed = zeros(n,m);
indice = find(spikeMat');
indice_new = downsample([ones(k-1,1);indice],k);
indice_new(1) = [];

for i = 1:length(indice_new)
    post_spikeMat_transposed(indice_new(i))=1;     
end
post_spikeMat = post_spikeMat_transposed';

nonzeros = find(post_spikeMat);
isi = diff(nonzeros)*dt;
histogram(isi)

%% part d
clc
clear;
close all;
trials = 1;
fr = 400;
tSim = 100;
dt = 0.001;

for k = 100:-1:1
[spikeMat,tVec] = poissonSpikeGen(fr,tSim,trials,dt);
[m,n] = size(spikeMat);
post_spikeMat_transposed = zeros(n,m);

indice = find(spikeMat');
indice_new = downsample([ones(k-1,1);indice],k);
indice_new(1) = [];



for i = 1:length(indice_new)
    post_spikeMat_transposed(indice_new(i))=1;     
end
post_spikeMat = post_spikeMat_transposed';


nonzeros = find(post_spikeMat);
isi = diff(nonzeros)*dt;

Cv(k) = std(isi)/mean(isi);
end

k = 1:100;
theoretic_func = 1./sqrt(k);

plot(Cv)
hold on
plot(theoretic_func)




