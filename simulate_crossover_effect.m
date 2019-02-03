more off; clear all; 
%f = figure('visible','off');
%all_h=[1 1]; ALL_SNR=[2 2]; ALLrateLow=[10 50]; index='changeL';
%all_h=[0.5 1 2]; ALL_SNR=[2 2 2].*sqrt(all_h); ALLrateLow=[50 50 50];index='constSNR';
%all_h=[.25 1 4]; ALL_SNR=[2 2 2]; ALLrateLow=[50 50 50]; index='changeh'; %S/sqrt(h)=[4 2 1]
all_h=[1 1 1]; ALL_SNR=[4 2 1]; ALLrateLow=[50 50 50]; index='changeS'; %S/sqrt(h)=[4 2 1]

snr=@(x,y)(y-x)/sqrt(x+y);
stimulusLength=3;
numTrials=10000

MAXACC=zeros(1,length(all_h));
DATA={};
PARS={};
for ii=1:length(all_h)
    clear pars;
    pars.all_h=all_h; 
    pars.ALL_SNR=ALL_SNR;   
    pars.ALLrateLow=ALLrateLow;
    PARS{ii}=pars;
    SNR=ALL_SNR(ii);
    h=all_h(ii);
    rateLow=ALLrateLow(ii);
    rateHigh=1/2*(SNR^2+sqrt(SNR^4+8*SNR^2*rateLow)+2*rateLow);
    disp([rateLow rateHigh snr(rateLow,rateHigh) (rateHigh-rateLow)/(sqrt(h)*sqrt(rateLow+rateHigh))])
    kappa=log(rateHigh/rateLow);
    seed=1; randn('state',seed); rand('state',seed)
    dt=0.001; 
    INT=0:dt:stimulusLength;
    num_it=length(INT);
    
    y=zeros(numTrials,num_it);
    H=zeros(numTrials,num_it);
    highClicks=rand(numTrials,num_it)<rateHigh*dt;
    lowClicks=rand(numTrials,num_it)<rateLow*dt;
    H(:)=1;
    tic
    minus2hdt=-dt*2*h;
    for i=1:num_it-1
        H(:,i+1)=H(:,i).*(-1).^(rand(numTrials,1)<h*dt);
        y(:,i+1)=y(:,i) + minus2hdt*sinh(y(:,i));
        y(:,i+1)=y(:,i+1)+kappa*(highClicks(:,i)-lowClicks(:,i)).*H(:,i);%.*(-1).^(rand(numTrials,1)<q);
    end
    toc
    y=sign(y);
    prediction=y.*abs(y)+(1-abs(y)).*(-1).^(rand(numTrials,num_it)<.5);
    correct=mean(prediction==H);
startT=0;
remaining_index=length(INT)-startT/dt;
    correct=NaN(numTrials,remaining_index);
    for i=numTrials:-1:1
        index_changes=find(diff(H(i,1+startT/dt:end))~=0);
        if ~isempty(index_changes)
            i0=index_changes(end);
            %shift data so that change_point_time->0
            shifted_data=sign(y(i,1+startT/dt+i0:end))==H(i,1+startT/dt+i0:end);
            correct(i,1:remaining_index-i0)=shifted_data;
        end
    end
    DATA{ii}=[(dt:dt:remaining_index*dt);nice_mean(correct)];
    plot((dt:dt:remaining_index*dt),nice_mean(correct),'LineWidth',2); 
    xlim([0,1]); hold on
    LEGEND_LABEL{ii}=['h=' num2str(all_h(ii)) ', S=' num2str(ALL_SNR(ii)) ];
end
legend(LEGEND_LABEL)
hold off
