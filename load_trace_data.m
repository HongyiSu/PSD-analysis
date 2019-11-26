close all; clear all;
%M = importdata('text_list');
%load dots
%colormap(cmap);
%ccc = colormap;
colorMap = hsv(256);
ccc = colormap(colorMap);

%xxx = importdata('hawk_locations.csv',',');
load Hawk_loc.mat
%stns = xxx.rowheaders;
lat = TT.latitude(:,1);
lon = TT.longitude(:,1);

movieTStep  =  0.25;
%movieTStep  =  0.5;
movieStartDate = '2019-07-25'; movieStartTime = '12:00:00';
movieEndDate =   '2019-07-25'; movieEndTime   = '13:59:59';

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

flow  = 3;
fhigh = .1;
ftype = 'BP';
channel = 'HHZ';
sacFileExtension = '.SAC';
filter = [flow;fhigh];
dataPath              = 'MG*';

[value1 value2 value3] = strread(movieStartDate,'%s%s%s','delimiter','-');
[staName staCoord seisData] = getSeis(ftype, filter, dataPath, tArray, strcat('*',channel,'*',char(value1),char(value2),char(value3),'*',sacFileExtension));

lats = staCoord(:,2); lons = staCoord(:,1);
[nsta,npts] = size(seisData);

amp = zeros(npts,nsta)*nan;
k = 1;
for i = 1:npts
  amp(i,:) = 50*seisData(:,i);
end

vidObj = VideoWriter('Meager_Dots.avi');
open(vidObj);

cnt = 0;
tstart = 500;
set(gca,'nextplot','replacechildren');
while tstart < 7000
 cnt = cnt + 1;
 z = ((length(ccc)/2-1)*amp(tstart,:))+length(ccc)/2;

 ii = find(z < 1); z(ii) = 1;
 ii = find(z > length(ccc)); z(ii) = length(ccc);

 c_amp = ccc(round(z),:);
 h1 = scatter(lons,lats,400,c_amp,'filled','MarkerEdgeColor','k'); hold on
 pause(0.05);
% F = getframe(gcf);
% writeVideo(vidObj,F);
 tstart = tstart + 50;
 if mod(tstart,1000) == 0; fprintf ('tstart is %d\n',tstart); end
end

close(vidObj);
