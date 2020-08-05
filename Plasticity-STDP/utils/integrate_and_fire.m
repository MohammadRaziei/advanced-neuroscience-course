%% part a
clc; clear; close all;

trials = 1;
fr = 30; dt = 1e-3;
[spikeMat,tVec] = poissonSpikeGen(fr,1,trials,0.001);
plotRaster(spikeMat, tVec, 'Raster Plot', 'blue');

trials = 10;
fr = 30; dt = 1e-3;
[spikeMat,tVec] = poissonSpikeGen(fr,1,trials,0.001);
plotRaster(spikeMat, tVec, 'Raster Plot', 'blue');


%% part b
clc; clear; close all;
trials = 1000;
fr = 100;
dt = 1e-3;
[spikeMat,~] = poissonSpikeGen(fr,1,trials,dt);
h = sum(spikeMat,2);
figure;
histogram(h,100)
mean(h)

fr = 30;
figure; hold on;
% Poisson = @(n,landa) landa.^n ./ factorial(n) * exp(-landa);
x = 0:60;
y = poisspdf(x,fr);
plot(x,1e3*y,'LineWidth',3);
[spikeMat,~] = poissonSpikeGen(fr,1,trials,dt);
h = sum(spikeMat,2);
histogram(h,100)
mean(h)
%% part c
clc; clear; close all;
trials = 1000;
fr = 30;
dt = 1e-3;

[spikeMat,tVec] = poissonSpikeGen(fr,1,trials,dt);
nonzeros = find(spikeMat);
isi = diff(nonzeros)*dt;
figure;hold on;
landa = fr;
x = 0.0:0.01:0.5;
y = landa*exp(-landa*x);
plot(x,1e2*y,'LineWidth',3);
histogram(isi,100);

%% integrate and fire 
clc; clear; close all;
trials = 1;
fr = 30;
tSim = 1000;
dt = 1e-3;
k = 9;

[spikeMat,tVec] = poissonSpikeGen(fr,tSim,trials,dt);
spikeMat_post = zeros(size(spikeMat));
indice = find(spikeMat);
indice2 = downsample([zeros(1,k-1),indice],k);
indice2(1) = [];

for i = 1:length(indice2)
    spikeMat_post(indice2(i))=1;     
end
isi = diff(find(spikeMat_post'))*dt;

figure;hold on;
Erlang = @(x,k,l) (l^k*x.^(k-1).*exp(-l*x))/factorial(k-1);
x = 0:0.01:1;
landa = fr;
y = Erlang(x,k,landa);
plot(x,70*y,'LineWidth',3);

histogram(isi)

%% part d
clc; clear; close all;
trials = 1;
fr = 30;
tSim = 100;
dt = 0.001;

for k = 1:100
[spikeMat,~] = poissonSpikeGen(fr,tSim,trials,dt);

indice = find(spikeMat');
indice2 = downsample([ones(k-1,1);indice],k);
indice2(1) = [];


spikeMat_post = zeros(size(spikeMat));
spikeMat_post(indice2)=1;     

isi = diff(find(spikeMat_post'))*dt;

Cv(k) = std(isi)/mean(isi);
end

figure; hold on;
k = 1:100;
y = 1./sqrt(k);
plot(y,'LineWidth',3)
stem(Cv)

%% F
clear; clc; close all;
trials = 1;
fr = 30;
tSim = 6;
dt = 0.001;

k = 4;

[spikeMat,tVec] = poissonSpikeGen(fr*k,tSim,trials,dt);
indice = find(spikeMat');
indice2 = downsample([ones(k-1,1);indice],k);
indice2(1) = [];


spikeMat_post = zeros(size(spikeMat));
spikeMat_post(indice2)=1;     

plot(spikeMat_post)


%% G
clear; clc; close all;
trials = 1;
fr = 30;
tSim = 6;
dt = 0.001;

% k = 4;
rf = 40;
% [spikeMat,tVec] = poissonSpikeGen(fr*k,tSim,trials,dt);
% indice = find(spikeMat');
% indice2 = downsample([ones(k-1,1);indice],k);
% indice2(1) = [];
% 
% ref = indice2(1);
% indice_diff = diff(indice2);
% indice_diff(find(indice_diff < rf)) = rf;
% indice_m = [ref;ref + cumsum(indice_diff)];
% 
% spikeMat_post = zeros(size(spikeMat));
% spikeMat_post(indice_m)=1;     
% 
% isi = diff(find(spikeMat_post'))*dt;

k = 8;
c = 0;
for fr = 10:200
c = c + 1;
[spikeMat,tVec] = poissonSpikeGen(fr,tSim,trials,dt);


indice = find(spikeMat');
indice2 = downsample([ones(k-1,1);indice],k);
indice2(1) = [];

ref = indice2(1);
indice_diff = diff(indice2);
indice_diff(find(indice_diff < rf)) = rf;
indice_m = [ref;ref + cumsum(indice_diff)];

spikeMat_post = zeros(size(spikeMat));
spikeMat_post(indice2)=1;  

spikeMat_post_m = zeros(size(spikeMat));
spikeMat_post_m(indice_m)=1;

isi = diff(find(spikeMat_post'))*dt;
isi_m = diff(find(spikeMat_post_m'))*dt;

Cv(c) = std(isi)/mean(isi);
Cv_m(c) = std(isi_m)/mean(isi_m);
end

figure; hold on;
% k = 1:100;
% y = 1./sqrt(k);
% plot(y,'LineWidth',3)
plot(Cv,'b')
plot(Cv_m,'r')

