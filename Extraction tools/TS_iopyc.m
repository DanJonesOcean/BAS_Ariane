%%%% TS_isopyc
%{
 This program plots TS diagrams with isopycnals, with 
 the colour representing several variables. It saves them
 as .fig files and then closes the figures.

 You need the program Tscadre in your path

 You need to be in a directory containing traj.txt and
 ariane_trajectories_qualitative.nc
%}

%% Import data
traj = dlmread('traj.txt', ' ');
traj( :, ~any(traj,1) ) = [];

%% Load variables
% Replacing traj in this section with the name of another 
% Nx8 array with plot the TS for that instead
lon = traj(:,2);
lat = traj(:,3);
depth = traj(:,4);
time = traj(:,5);
T = traj(:,6);
S = traj(:,7);
sigma_a = traj(:,8);

%% Plot the TS figures 
% Longitude
figure();
scatter(S,T,20,lon,'filled');
colormap('jet');
caxis([min(lon) max(lon)]);
hold on;
Tscadre(S,T);
scatter(S(1), T(2), '*k');
colorbar;
title('Temperature Salinity diagram - Longitude');
saveas(gca,'TS-lon.fig','fig')
close()

% Latitude
figure();
scatter(S,T,20,lat,'filled');
colormap('jet');
caxis([min(lat) max(lat)]);
hold on;
Tscadre(S,T);
scatter(S(1), T(2), '*k');
colorbar;
title('Temperature Salinity diagram - Latitude');
saveas(gca,'TS-lat.fig','fig')
close()

% Depth
figure();
scatter(S,T,20,depth,'filled');
colormap('jet');
caxis([min(depth) max(depth)]);
hold on;
Tscadre(S,T);
scatter(S(1), T(2), '*k');
colorbar;
title('Temperature Salinity diagram - Depth');
saveas(gca,'TS-depth.fig','fig')
close()

% Time
figure();
scatter(S,T,20,time,'filled');
colormap('jet');
caxis([min(time) max(time)]);
hold on;
Tscadre(S,T);
scatter(S(1), T(2), '*k');
colorbar;
title('Temperature Salinity diagram - Time');
saveas(gca,'TS-time.fig','fig')
close()

% Calculated density
figure();
scatter(S,T,20,sigma_a,'filled');
colormap('jet');
caxis([min(sigma_a) max(sigma_a)]);
hold on;
Tscadre(S,T);
scatter(S(1), T(2), '*k');
colorbar;
title('Temperature Salinity diagram - Calculated density');
saveas(gca,'TS-dens.fig','fig')
close()

