function [spikeMat, tVec] = poissonSpikeGen(fr, tSim, nTrials, dt)
nBins = floor(tSim/dt);
spikeMat = rand(nTrials, nBins) < fr*dt;
tVec = 0:dt:tSim-dt; 