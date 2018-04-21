load_module_swi_toolkit;
clear
%%
s0=100;
t2sTrue = 30e-3;
te = linspace(3e-3,50e-3,12);
nPoint = 50;

s = Signal_mGRE(s0,t2sTrue,te);

smap = repmat(s(:),1,nPoint,nPoint,nPoint);
smap = permute(smap,[2,3,4,1]);

nLv = 1;
noise = (randn(size(smap)) + randn(size(smap))*1i)*nLv;

sinput = smap + noise;

nT =sqrt( mean(abs(noise(:)).^2)/2);

[r2s,t2s_CRSI,m0] = R2starmapping_CRSI(sinput,te,nT,'m',50);
accuracy_CRSI = mean(abs(t2s_CRSI(:)-t2sTrue(:)))/t2sTrue;
precision_CRSI = std(t2s_CRSI(:))/t2sTrue;

[r2s,t2s_trape,m0] = R2starmapping_trapezoidal(sinput,te);
accuracy_trapezoidal = mean(abs(t2s_trape(:)-t2sTrue(:)))/t2sTrue;
precision_trapezoidal = std(t2s_trape(:))/t2sTrue;