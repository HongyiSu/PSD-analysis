%load MM07.mat
%load MM08.mat
Mat = importdata('mat_list');
for i = 1:length(Mat)
    load(cell2mat(Mat(i,:)));
end
load Hawk_loc.mat;
colorMap = hsv(256);
ccc = colormap(colorMap);

scatter(TT.longitude,TT.latitude,100,'p')
hold on;
text(TT.longitude(8),TT.latitude(8),'MM07')
text(TT.longitude(9),TT.latitude(9),'MM08')

for i = 1:length(MM07.one)
    MM07.one(i,:);
    time_07 = strcat(cellstr(MM07.Periods(i,:)),'_',cellstr(MM07.time(i,:)));
    tt = cell2mat(time_07);
    year = str2double(tt(1:4));
    mm = str2double(tt(6:7));
    dd = str2double(tt(9:10));
    hh = str2double(tt(12:13));
    MM = str2double(tt(15:16));
    ss = str2double(tt(18:19));
    t_07(i) = datenum(year,mm,dd,hh,MM,ss);
end

for j = 1:length(MM08.one)
    MM08.one(j,:);
    time_08 = strcat(cellstr(MM08.Periods(j,:)),'_',cellstr(MM08.time(j,:)));
    tt = cell2mat(time_08);
    year = str2double(tt(1:4));
    mm = str2double(tt(6:7));
    dd = str2double(tt(9:10));
    hh = str2double(tt(12:13));
    MM = str2double(tt(15:16));
    ss = str2double(tt(18:19));
    t_08(j) = datenum(year,mm,dd,hh,MM,ss);
end
fid = fopen('xxx.txt','w')
for i=1:length(MM08.one)
    if t_07(2) == t_08(i); 
        fprintf(fid,'for t_07(2) t_08(?) index is %f\n',i)
    end
end
fclose(fid);

% t_08(44) t_07(2) at same time 
datestr(t_07(2),31)
datestr(t_08(44),31)
x7 = MM07.one(2);
max7 = max(MM07.one);
x8 = MM08.one(44);
max8 = max(MM08.one);


%[status want] = system("grep '2019-07-20             19:00:00' POWER/MM*/EPZ/*txt")

z = [ccc_val(x7,max7) ccc_val(x8,max8)]
h1 = scatter(TT.longitude(8:9),TT.latitude(8:9),400,ccc(z,:),'filled','MarkerEdgeColor','k'); hold on
 
 function [w]=ccc_val(x,y)
    if round(x/y*256) == 0
        w = 1;
    else
        w = round((x/y)*256);
    end
 end
 
 function [t] = get_time(varagin)
    for i = 1:height(x)
        x.one(i,:);
        time = strcat(cellstr(x.Periods(i,:)),'_',cellstr(x.time(i,:)));
        tt = cell2mat(time_07);
        year = str2double(tt(1:4));
        mm = str2double(tt(6:7));
        dd = str2double(tt(9:10));
    hh = str2double(tt(12:13));
    MM = str2double(tt(15:16));
    ss = str2double(tt(18:19));
    t(i) = datenum(year,mm,dd,hh,MM,ss);
    end
 end