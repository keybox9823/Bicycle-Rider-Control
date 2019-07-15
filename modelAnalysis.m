
clear;
addpath(genpath('functions'), genpath('Measurements'),genpath('simulink'));
close all;
%%
%load('C:\dev\bicycle-rider-control-identification\Measurements\all_data_steer_koen.mat')
% load('C:\dev\bicycle-rider-control-identification\Measurements\all_data_rope.mat');
r(1)=load('C:\dev\bicycle-rider-control-identification\Measurements\roll\all_data_lars.mat');
r(2)=load('C:\dev\bicycle-rider-control-identification\Measurements\roll\all_data_leo.mat');
r(3)=load('C:\dev\bicycle-rider-control-identification\Measurements\roll\all_data_dani.mat');
r(4)=load('C:\dev\bicycle-rider-control-identification\Measurements\roll\all_data_pier.mat');
r(5)=load('C:\dev\bicycle-rider-control-identification\Measurements\roll\all_data_koen.mat');
r(6)=load('C:\dev\bicycle-rider-control-identification\Measurements\roll\all_data_prodromos.mat');
r(7)=load('C:\dev\bicycle-rider-control-identification\Measurements\roll\all_data_wylke.mat');
r(8)=load('C:\dev\bicycle-rider-control-identification\Measurements\roll\all_data_nikos.mat');
r(9)=load('C:\dev\bicycle-rider-control-identification\Measurements\roll\all_data_katerina.mat');
r(10)=load('C:\dev\bicycle-rider-control-identification\Measurements\roll\all_data_marko.mat');
r(11)=load('C:\dev\bicycle-rider-control-identification\Measurements\roll\all_data_jork.mat');
r(12)=load('C:\dev\bicycle-rider-control-identification\Measurements\roll\all_data_thomas.mat');
r(13)=load('C:\dev\bicycle-rider-control-identification\Measurements\roll\all_data_camilo.mat');
r(14)=load('C:\dev\bicycle-rider-control-identification\Measurements\roll\all_data_michael.mat');

%save('C:\dev\bicycle-rider-control-identification\Measurements\all_subjects');
for i=1:length(r)
  if (i==1)
    r(i).results.nofb.data(2)=[];
    r(i).results.nofb.black_box(2)=[];

    r(i).results.nofb.data(5)=[];
    r(i).results.nofb.black_box(5)=[];

  elseif(i==2)
    r(i).results.nofb.data(2)=[];
    r(i).results.nofb.black_box(2)=[];

    r(i).results.fb.data(5)=[];
    r(i).results.fb.black_box(5)=[];

  elseif(i==3)
    r(i).results.nofb.data(3)=[];
    r(i).results.nofb.black_box(3)=[];

    r(i).results.fb.data(2)=[];
    r(i).results.fb.black_box(2)=[];

    r(i).results.fb.data(5)=[];
    r(i).results.fb.black_box(5)=[];
  elseif(i==5)
    r(i).results.nofb.data(2)=[];
    r(i).results.nofb.black_box(2)=[];
    r(i).results.nofb.data(2)=[];
    r(i).results.nofb.black_box(2)=[];
  elseif(i==6)
    r(i).results.nofb.data(4)=[];
    r(i).results.nofb.black_box(4)=[];
  elseif(i==10)
    r(i).results.nofb.data(4)=[];
    r(i).results.nofb.black_box(4)=[];
  elseif(i==11)
    r(i).results.nofb.data(2)=[];
    r(i).results.nofb.black_box(2)=[];
    r(i).results.nofb.data(3)=[];
    r(i).results.nofb.black_box(3)=[];
  elseif(i==12)
    r(i).results.nofb.data(2)=[];
    r(i).results.nofb.black_box(2)=[];
    r(i).results.fb.data(3)=[];
    r(i).results.fb.black_box(3)=[];
  elseif(i==13)
    r(i).results.fb.data(4)=[];
    r(i).results.fb.black_box(4)=[];
  elseif(i==14)
    r(i).results.fb.data(4)=[];
    r(i).results.fb.black_box(4)=[];
  end
end

% load('C:\dev\bicycle-rider-control-identification\Measurements\all_data.mat')
% load('C:\dev\bicycle-rider-control-identification\Measurements\olddata.mat')
%%
fb_results.data=fb_runs;

nofb_results.data=nofb_runs;
%%

for i=1:length(fb_results.data)
dat=fb_results.data(i); 
np = nonparaID(dat);
fb_results.black_box(i)=np;
end

for i=1:length(nofb_results.data)
dat=nofb_results.data(i); 
np = nonparaID(dat);
nofb_results.black_box(i)=np;
end
%%
results.fb=fb_results;
results.nofb=nofb_results;
results.Name='Leo';

clearvars -except results
%save('C:\dev\bicycle-rider-control-identification\Measurements\steer\all_data_steer_leo.mat');

%%

i=1;
dat=fb_results.data(i); 
%np=fb_results.black_box(i); 

figure('units','normalized','outerposition',[0 0 1 1])
plot(dat.t,dat.y(:,2)*180/pi);
hold on
plot(dat.t,dat.y(:,1)*180/pi)
plot(dat.t,dat.roll)
dat=fb_results.data(i); 
plot(dat.t,zeros(length(dat.w),1))
ylim([-0.3*180/pi 0.3*180/pi])
yyaxis right


plot(dat.t,dat.w)
ylim([-max(dat.w)-1 max(dat.w)+1]);



%% Create Generic Impulse
[fb_results,nofb_results] = getMeanResponse(r,1);
 data=cmpIRoutput(fb_results,nofb_results);
%%

fb_results = results.fb;
nofb_results =results.nofb;

for i=1:length(fb_results.data)
 delta= fb_results.data(i).y(:,2);
 Fs=fb_results.data(i).Fs;
 dt = 1 / Fs;
 U=fft(delta);
 Suu=1/length(delta)*U.*conj(U);
 f = (0:length(delta) / 2).' / length(delta) / dt;
 fb_results.data(i).Suu=real(Suu(1:length(delta)/2+1));
 fb_results.data(i).f =f;
 [fb_results.data(i).PSD, ~] = periodogram(delta, hann(length(delta)), length(delta),Fs);
end


for i=1:length(nofb_results.data)
 delta= nofb_results.data(i).y(:,2);
 Fs=nofb_results.data(i).Fs;
 dt = 1 / Fs;
 U=fft(delta);
 Suu=1/length(delta)*U.*conj(U);
 f = (0:length(delta) / 2).' / length(delta) / dt;
 nofb_results.data(i).Suu=real(Suu(1:length(delta)/2+1));
 nofb_results.data(i).f =f;
 [nofb_results.data(i).PSD, ~] = periodogram(delta, hann(length(delta)),length(delta),Fs);
end



%%
for i=1:length(r)
  
fb_results=r(i).results.fb;
nofb_results=r(i).results.nofb;
Name=r(i).results.Name;




%plotPSD(fb_results.data,nofb_results.data,Name)

% 
% plotSpeedIRF(fb_results.black_box,fb_results.data,Name)
% plotSpeedIRF(nofb_results.black_box,nofb_results.data,Name)

plotFBstatusIRF(fb_results.black_box,nofb_results.black_box,fb_results.data,nofb_results.data,Name)


end
%% Steer-by-wire Bicycle-Whipple model 
load('JBike6MCK.mat', 'C1', 'M0', 'K2', 'K0')

a = -fliplr(eye(2)) + eye(2);
M0 = a .* M0;
C1 = C1 .* a;
K0 = K0 .* a;
K2 = K2 .* a;
Hfw = [0.84; 0.014408]; % dfx/dTq

whipple.M0 = M0;
whipple.C1 = C1;
whipple.K0 = K0;
whipple.K2 = K2;
whipple.Hfw = Hfw;



%%

options = optimoptions('ga', "PopulationSize", 80, ...
  'EliteCount', 4, 'CrossoverFraction', 0.85, ...
  'InitialPopulationRange', [-50; 50],...
  'InitialPopulationMatrix',[-27.8688060508863 3.83424352600571 3.24115313899635 -1.4528375845157]);


 lb=[-250;-250;-250;-250];
 ub=[250;250;250;250];
 X0=[-17.4842654843009,2.26661177007119,-1.36578045475365,2.72081589849312 ];
 
for ii=11:length(r)
  
fb_results=r(ii).results.fb;
nofb_results=r(ii).results.nofb; 
 
for i=1:1
 np=fb_results.black_box(i);
 dat=fb_results.data(i);
 bike = delftbike(dat.v,whipple); 
 [K, fval, ~, ~] =ga(@(X)statefbError(X,np,bike,dat),4,[], [], [], [], lb, ub, [],options);
 output =modelSim(K,bike,dat);
 output.K=K;
 fb_results.final_model(i)= output;
end

r(ii).results.fb=fb_results;
r(ii).results.nofb=nofb_results;
end
%%
for i=1:1
output= fb_results.final_model(i) ;
np=fb_results.black_box(i);
dat=fb_results.data(i);
plotSimData(output,np,dat)
end
%%
for i=1:4
 dat=data(i);
 dat.N=length(data(i).w);
 np=dat;
 bike = delftbike(dat.v,whipple); 
 [K, fval, ~, ~] =ga(@(X)statefbError2(X,np,bike, dat),4,[], [], [], [], lb, ub, [],options);
 output =modelSim(K,bike,dat);
 output.K=K;
 final_model(i)= output;
end
%%
for i=1:4
output= final_model(i) ;
np=data(i);
dat=data(i);
plotSimData(output,np,dat)
end