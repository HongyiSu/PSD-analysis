%% Gen's code below
% Map limits
clear all; close all;
n = input('Enter mode(1 or 2): '); %mode 1, 1-15Hz mode 2, 15-100Hz
if n == 1
    iden = input('default value(y/n)?:','s');
    if iden == 'y'
        U_o = -12;
        L_o = -28;
    elseif iden == 'n'
        U_o= input('Upper bound for 1-15hz(recommend -12):');
        L_o= input('Lower bound for 1-15hz(recommend -28):');
    end
elseif n == 2
    iden = input('default value(y/n)?:','s');
    if iden == 'y'
        U_h = -10;
        L_h = -24.5;
    elseif iden == 'n'
        U_h= input('Upper bound for 15-100hz(recommend -10):')
        L_h= input('Lower bound for 15-100hz(recommend -24.5):')
    end
end
day_start = input('day start(July): ');


minlat=50.5;
maxlat=50.7;
minlon=-123.65;
maxlon=-123.25;
% Initialize map axes
figure(1);clf
h1=worldmap([minlat,maxlat], [minlon,maxlon]);
axes(h1);
setm(h1,'PLabelLocation',0.1,...% show latitude label at every 0.1 degree
    'MLabelLocation',0.2,...% show longitude label at every 0.2 degree
    'LabelUnits','degrees',... % Show label in degrees
    'Grid','on',... % Show grid
    'Plabelround',-1,...% Round meridian label to first decimal
    'Mlabelround',-1,... % Round meridian label to first decimal
    'FontSize',12,...
    'FFaceColor','w') % set the frame fill to white

% Add terrain elevation hillshade
load Meager_geography/HILLSHADE.mat
geoshow(Z,R)

% Add rivers
rivers = shaperead('Meager_geography/water_linear_flow_1.shp',...
    'BoundingBox', [minlon,minlat;maxlon,maxlat],...
    'Selector',{@(v) ~isempty(v), 'name_en'},...  % This only keeps rivers with a name to avoid showing all smaller creeks
    'UseGeoCoords', true);
plotm([rivers.Lat], [rivers.Lon], 'b-', 'linewidth',2)

% Extract water bodies
feat = shaperead('Meager_geography/waterbody_2.shp',...
    'BoundingBox', [minlon,minlat;maxlon,maxlat],...
    'UseGeoCoords', true);
geoshow(feat, 'DefaultFaceColor','blue','DefaultEdgeColor','blue')

% Extract glaciers
feat = shaperead('Meager_geography/permanent_snow_and_ice_2.shp',...
    'BoundingBox', [minlon,minlat;maxlon,maxlat],...
    'UseGeoCoords', true);
geoshow(feat, 'DefaultFaceColor',[219, 244, 255]./256,'DefaultEdgeColor',[219, 244, 255]./256, 'FaceAlpha',0.5) % FaceAlpha = transparency
%%  Hersh's code below


load HawklocT2.mat
Mat = importdata('mat_list');
for i = 1:length(Mat)
    load(cell2mat(Mat(i,:)));
end

cnt = 0;


time_start = 0;  % change time parameters here
for k = 0:47
    time_start = 0.5*k
    for i = 1:length(Mat)
        xxx = char(Mat(i));
        STN = xxx(1:4);
        eval(['find_days = find(' STN '.Periods.Day == ' num2str(day_start) ');']);
        find_times(i) = eval(['find(round(2.*hours(' STN '.time(find_days)))/2 == time_start);']);
        start_line_for_stn(i) = find_days(find_times(i));
        one = eval(strcat(STN,'.','one','(',mat2str(start_line_for_stn(i)), ',',':',')'));
        hundred = eval(strcat(STN,'.','hundred','(',mat2str(start_line_for_stn(i)), ',',':',')'));
        Tf.one(i,:) = one;
        Tf.hundred(i,:) = hundred;
        want = strmatch(string(STN),T2.station_name);
        Tf.lat(i,:) = T2.latitude(want,:);
        Tf.lon(i,:) = T2.longitude(want,:);
    
    end
    
%% Mike's code below

switch n
    case 1
        colorMap = hot(256);
        ccc = colormap(colorMap);
        amp_values = log(Tf.one);

      for i = 1:length(amp_values)
            if amp_values > U_o
                amp_values = U_o
            end
      end
      amp_values = amp_values - L_o
      for i=1:length(amp_values)
          x = amp_values(i);
          y = max(amp_values);
          z(i) = ccc_val(x,y);
      end
        colormap(hot);
        h1 = scatterm(Tf.lat,Tf.lon,150,ccc(z,:),'filled','MarkerEdgeColor','w');
        hold on
        hour = floor(time_start) - 8 ;%UTC time to local BC Pacific time
        min_t = (time_start - floor(time_start))*60;
        tt = datestr(datenum(2019,07,day_start,hour,min_t,0),'mmm.dd,yyyy HH:MM:SS');
        wants = datestr(tt,30)
        title(strcat(wants,'__1-15HZ','___Energy level(median)','=',string(median(Tf.hundred))));
        xlabel('longitude');
        ylabel('latitude');
        colorbar;
        fig_name = strcat(wants,'__1-15hz','.jpg');
        mkdir_name = strcat(wants(1:8),'_1_15HZ');
        express = strcat('mkdir',{' '},wants(1:8),'_1_15HZ');
        express1 = join(express);
        express2 = strjoin(express1);
        system(express2);
        dir = strcat('',pwd, '/',mkdir_name,'/',fig_name,'');
        saveas(gcf,dir)
    case 2
        colorMap = hot(256);
        ccc = colormap(colorMap);
        amp_values = log(Tf.hundred);

      for i = 1:length(amp_values)
            if amp_values >  U_h % Upper_bound(-11)
                amp_values =  U_h;
            end
      end
         amp_values = amp_values - L_h % Low_bound(-25)
         for i=1:length(amp_values)
              x = amp_values(i);
              y = max(amp_values);
              z(i) = ccc_val(x,y);
      
         end
     
        
        colormap(hot);
        h1 = scatterm(Tf.lat,Tf.lon,150,ccc(z,:),'filled','MarkerEdgeColor','w');
        hold on
        hour = floor(time_start) - 8 ;%UTC time to local BC Pacific time
        min_t = (time_start - floor(time_start))*60;
        tt = datestr(datenum(2019,07,day_start,hour,min_t,0),'mmm.dd,yyyy HH:MM:SS');
        wants = datestr(tt,30)
        title(strcat(wants,'__15-100HZ','___Energy level(median)','=',string(median(Tf.hundred))));
        xlabel('longitude');
        ylabel('latitude');
        colorbar;
        fig_name = strcat(wants,'__15-100hz','.jpg');
        mkdir_name = strcat(wants(1:8),'_15_100HZ');
        express = strcat('mkdir',{' '},wants(1:8),'_15_100HZ');
        express1 = join(express);
        express2 = strjoin(express1);
        system(express2);
        dir = strcat('',pwd, '/',mkdir_name,'/',fig_name,'');
        saveas(gcf,dir)
        
    otherwise 
        disp('wrong value, please enter either 1 or 2')
end

end


 function [w]=ccc_val(x,y)
    if round(x/y*256) == 0
        w = 1;
    else
        w = round((x/y)*256);
    end
 end
 %% 
 