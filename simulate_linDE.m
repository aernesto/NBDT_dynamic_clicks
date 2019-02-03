% core code to simulate click task 
clear all;
h=1; %hazard rate
rateLow=30; %lambda_low
rateHigh=58.17; %lambda_high
stimulusLength=1; %T
numTrials=10000; %number of simulations
gamma=9.12790; % linear discounting rate

snr=@(x,y)(y-x)/sqrt(x+y); 
disp(snr(rateLow,rateHigh))
disp(snr(rateLow,rateHigh))
%h=(rateHigh-rateLow)^2/(4.0825^2*(rateHigh+rateLow))
kappa=log(rateHigh/rateLow); 
%the following may have to be modified in Matlab/Octave
seed=0; randn('state',seed); rand('state',seed)
dt=0.0001; 
%interval from 0 to stimulusLength
INT=0:dt:stimulusLength;
%number of iterations
num_it=length(INT);
%initialize y_t and environment
y=zeros(numTrials,num_it);
E=zeros(numTrials,num_it);
%create clicks from the high and low rate
%the assignment to left and right is done later
highClicks=rand(numTrials,num_it)<rateHigh*dt;
lowClicks=rand(numTrials,num_it)<rateLow*dt;
%initial environment
E(:,1)=1;
tic
for i=1:num_it-1
    %update environment. Note: E\in {-1,1}
    E(:,i+1)=E(:,i).*(-1).^(rand(numTrials,1)<h*dt);
    %update y using Euler's method
    y(:,i+1)=y(:,i) -gamma*dt*y(:,i);
    %update y using clicks. the mult by E(:,i) assigns left and right
    y(:,i+1)=y(:,i+1)+kappa*(highClicks(:,i)-lowClicks(:,i)).*E(:,i);%.*(-1).^(rand(numTrials,1)<q);
end
toc
%get the sign of y_t
y=sign(y);
%the following forces the prediction to be random if y=0
prediction=y.*abs(y)+(1-abs(y)).*(-1).^(rand(numTrials,num_it)<.5);
%compute the average accuracy across trials
correct=mean(prediction==E);
%plotting
plot(INT*h,correct,'LineWidth',2); 
xlabel('interrogation time')
ylabel('percentage correct')
title(['h=' num2str(h) ', lambda_L=' num2str(rateLow) ', lambda_H=' num2str(rateHigh)]);
xlim([0 0.4])
hold off
