%% Hongyi Su(30053908), Supervisor: Hersh Gilbert, department of geoscience, University of Calgary

close all; clear all;

Mat = importdata('mat_list');
for i = 1:length(Mat)
    load(cell2mat(Mat(i,:)));
end

sta={'27','23'}
for i=1:length(sta)
    want = strcat('MM',sta(i));
    want = string(want);
    %UTC to local BC time
    startDate = datenum(eval([strcat(want,'.Periods(1)')]))+datenum(eval([strcat(want,'.time(1)')]))-datenum(hours(8));
    st_cut = datenum(2019,07,09);
    %st_cut = datenum(2019,07,17,00,00,00)
    endDate = datenum(eval([strcat(want,'.Periods(end)')]))+datenum(eval([strcat(want,'.time(end)')]))-datenum(hours(8));
    end_cut = datenum(2019,08,03);
    %end_cut = datenum(2019,07,18,23,59,59);
    x = linspace(startDate,endDate,length(eval([strcat(want,'.one')])));
    subplot(4,1,i)
    plot(x,log(eval([strcat(want,'.one')])));
    title( strcat(want,'__1-15Hz'));
    ylabel('log(PSD)');
    xlim([st_cut,end_cut]);
    %xlabel('time')
    datetick('x',20,'keepticks');
end

load('Volume.mat');
time_t1 = T1.DatePST;
discharge = T1.Valuem3s;

%Water Level (Primary sensor) m
load('water_level.mat');
time_t2 = T2.DatePST;
w_level = T2.Valuem;
startDate = datenum(2019,07,09);
endDate = datenum(2019,08,03);
cut_s = datenum(2019,07,17,00,00,00);
cut_e = datenum(2019,07,18,23,59,59);
x = linspace(startDate,endDate,length(T2.Valuem));

subplot(413)

plot(x,T1.Valuem3s);
ylabel('discharge (m/s)')
%xlabel('time')

%xlim([cut_s,cut_e])
title('discharge')
datetick('x',20,'keepticks')

subplot(414)
plot(x,T2.Valuem);
ylabel('water level(m)');
xlabel('time');
title('water level');
%xlim([cut_s,cut_e])
datetick('x',20,'keepticks');

