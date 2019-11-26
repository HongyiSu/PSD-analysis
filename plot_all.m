Mat = importdata('mat_list');
figure
for i = 1:length(Mat)
    a = cell2mat(Mat(i,:))
    b = a(1:4)
    c = strcat('plot(log(',b,'.one))')
    eval(c)
    hold on
end
title('1-15HZ')
figure
for i = 1:length(Mat)
    a = cell2mat(Mat(i,:))
    b = a(1:4)
    c = strcat('plot(log(',b,'.hundred))')
    eval(c)
    hold on
end
title('15-100HZ')