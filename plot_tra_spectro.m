close all; clear all;

movieTStep  =  0.02; 
movieStartDate = '2019-07-26'; movieStartTime = '16:36:30'; 
movieEndDate =   '2019-07-26'; movieEndTime   = '16:40:00';

[value1 value2 value3] = strread(movieStartDate,'%s%s%s','delimiter','-');
movieStartYear  = str2double(value1{1}); movieStartMonth = str2double(value2{1});
str2double(value2{1}); movieStartDay   = str2double(value3{1}); 
[value1 value2 value3] = strread(movieStartTime,'%s%s%s','delimiter',':'); 
movieStartHour  = str2double(value1{1}); movieStartMinute = str2double(value2{1});
movieStartSecond = str2double(value3{1}); 
t1 = datetime(movieStartYear,movieStartMonth,movieStartDay,movieStartHour,movieStartMinute,movieStartSecond);

[value1 value2 value3] = strread(movieEndDate,'%s%s%s','delimiter','-');
movieEndYear  = str2double(value1{1}); movieEndMonth = str2double(value2{1});
movieEndDay   = str2double(value3{1}); 
[value1 value2 value3] = strread(movieEndTime,'%s%s%s','delimiter',':'); 
movieEndHour  = str2double(value1{1}); movieEndMinute = str2double(value2{1}); 
movieEndSecond = str2double(value3{1}); 
t2 = datetime(movieEndYear,movieEndMonth,movieEndDay,movieEndHour,movieEndMinute,movieEndSecond);

movieStartJday        = jday(movieStartYear, movieStartMonth, movieStartDay); % get julian day
movieStartEpoch       = epoch(movieStartYear,movieStartJday,movieStartHour,movieStartMinute,movieStartSecond); %now, translate all events times into epochal
movieEndJday        = jday(movieEndYear, movieEndMonth, movieEndDay); % get julian day
movieEndEpoch       = epoch(movieEndYear,movieEndJday,movieEndHour,movieEndMinute,movieEndSecond);

tArray = [double(movieStartEpoch); double(movieEndEpoch); movieTStep];

flow  = 5; 
fhigh = .5; 
ftype = 'BP'; 
channel = 'HHZ'; 
sacFileExtension = '.SAC'; 
filter = [flow;fhigh]; 
dataPath              = 'MG*';

[value1 value2 value3] = strread(movieStartDate,'%s%s%s','delimiter','-');
[staName staCoord seisData] = getSeis(ftype, filter, dataPath, tArray, strcat('*',channel,'*',char(value1),char(value2),char(value3),'*',sacFileExtension));

nsta = length(staName); 
npts = size(seisData,2); 
sampletimes = linspace(t1,t2,npts);

N = 7;

for i = 1:N;
y = seisData(i,:);
% Parameters
frequencyLimits = [0 50]; % Normalized frequency (*pi rad/sample)
leakage = 0.1;
timeResolution = 150; % samples
overlapPercent = 90;

%%
% Index into signal time region of interest
timeLimits = [1 length(y)]; % samples
y_ROI = y(:);
y_ROI = y_ROI(timeLimits(1):timeLimits(2));

% Compute spectral estimate
subplot(N,1,i);
pspectrum(y_ROI, ...
    'spectrogram', ...
    'FrequencyLimits',frequencyLimits, ...
    'Leakage',leakage, ...
    'TimeResolution',timeResolution, ...
    'OverlapPercent',overlapPercent);
title(staName(i));
end
% 
% cnt = 0;
% want = [1 3 7]; nw = length(want);
% figure(2)
% for i = want;
% cnt = cnt + 1;
%     subplot(nw,1,cnt);
% y = seisData(i,:);
% plot(sampletimes,y); datetick
% title(staName(i));
% axis tight
% end
