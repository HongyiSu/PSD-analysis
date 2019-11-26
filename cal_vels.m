t_12 = 28;
t_14 = 16;
t_18 = 5;

dt_12_14 = abs(t_12 - t_14);
dt_12_18 = abs(t_12 - t_18);
dt_14_18 = abs(t_14 - t_18);

dist12_14 = distance(staCoord(1,2),staCoord(1,1),staCoord(3,2),staCoord(3,1));
dist12_14_km = deg2km(dist12_14);

dist12_18 = distance(staCoord(1,2),staCoord(1,1),staCoord(7,2),staCoord(7,1));
dist12_18_km = deg2km(dist12_18);

dist14_18 = distance(staCoord(3,2),staCoord(3,1),staCoord(7,2),staCoord(7,1));
dist14_18_km = deg2km(dist14_18);

vel12_14 = dist12_14_km/dt_12_14
vel12_18 = dist12_18_km/dt_12_18
vel14_18 = dist14_18_km/dt_14_18
