%% TS_pdf.m
%{
 Plots the start and end position of the particles, and the probability 
 density functions at the begining and end of the run.

 You need to be in a directory containing traj.txt and
 ariane_trajectories_qualitative.nc

 You also need all of the MATLAB scripts that come with 
 the ariane software to be in the PATH, they will dump a 
 load of variables in your workspace.
%}

%% Import data
traj = dlmread('traj.txt', ' ');
traj( :, ~any(traj,1) ) = [];

%% Find initial postition 
init_pos_vec = zeros(max(traj(:,1)),8);
for i = 1:max(traj(:,1))
    temp = traj(traj(:,1) == i, :);
    init_pos_vec(i,:) = temp(temp(:,5) == max(temp(:,5)),:);
end

%% Find final position 
fin_pos_vec = zeros(max(traj(:,1)),8);
for i = 1:max(traj(:,1))
    temp = traj(traj(:,1) == i, :);
    fin_pos_vec(i,:) = temp(temp(:,5) == min(temp(:,5)),:);
end

%% Plot the initial position TS pdf
% Load variables
T = init_pos_vec(:,6);
S = init_pos_vec(:,7);

% Make pdf using a 3D histogram with Cdata turned on
figure();
hist3([S,T],'CdataMode','auto','Nbins',[100,100])
xlabel('Salinity')
ylabel('Temperature')
colormap('jet')
colorbar
title('Temperature-Salinity density function at the initial positions')

% Remove the zeros from the plot for clarity
h = get(gca,'child');
heights = get(h,'Zdata');
mask = ~logical(filter2(ones(3), heights));
heights(mask) = NaN;
set(h,'ZData',heights)

% View from above
view(2);

% Add isobars
hold on;
Tscadre(S,T);

%{
 This can be used to view the 3D histogram above the 2D pdf, but looks a
 little messy if the spread of data is too large.
 comment out lines 59, 60 and 71

hold on
N = hist3([S,T],'CdataMode','auto', 'Nbins',[100,100]);
N(size(N,1)+1,size(N,2)+1) = 0;
Sb = linspace(min(S),max(S),size(N,1));
Tb = linspace(min(T),max(T),size(N,2));
h = pcolor(Sb,Tb,N');
colormap('jet')
colorbar
h.ZData = ones(size(N))*-max(max(N));
ax = gca;
ax.ZTick(ax.ZTick < 0) = [];
%}
hold off

%% Plot the final position TS pdf
% Load variables
TF = fin_pos_vec(:,6);
SF = fin_pos_vec(:,7);

% Make pdf using a 3D histogram with Cdata turned on
figure();
hist3([SF,TF],'CdataMode','auto','Nbins',[100,100])
xlabel('Salinity')
ylabel('Temperature')
colormap('jet')
colorbar
title('Temperature-Salinity density function at 24 north')

% Remove the zeros from the plot for clarity
h = get(gca,'child');
heights = get(h,'Zdata');
mask = ~logical(filter2(ones(3), heights));
heights(mask) = NaN;
set(h,'ZData',heights)

% View from above
view(2);

% Add isobars
hold on;
Tscadre(S,T);
%{
 This can be used to view the 3D histogram above the 2D pdf, but looks a
 little messy if the spread of data is too large.
 comment out lines 105,106 and 117

hold on
N = hist3([SF,SF],'CdataMode','auto', 'Nbins',[100,100]);
N(size(N,1)+1,size(N,2)+1) = 0;
SFb = linspace(min(SF),max(SF),size(N,1));
TFb = linspace(min(TF),max(TF),size(N,2));
h = pcolor(SFb,TFb,N');
colormap('jet') % Change color scheme 
colorbar % Display colorbar
h.ZData = ones(size(N))*-max(max(N));
ax = gca;
ax.ZTick(ax.ZTick < 0) = [];
%}
hold off

%% Generate new figure
fid = figure();

%% Read grid
a_ncreadgrid;

%% Set a few plot attributes 
ocean_plot;

%% Initialize the map projection. 
a_projection;

%% Land mask
a_mask_land

%% Autorize to plot again on the same figure
hold on;

%% Bathymetry
a_bathy;

%% Plot final and initial positions
m_plot((init_pos_vec(:,2)), init_pos_vec(:,3), 'rx','LineWidth',2);
m_plot((fin_pos_vec(:,2)), fin_pos_vec(:,3), 'kx','LineWidth',2);
title('Initial and final positions of the particles');
hold off;

%% Clear temporary variables
clear extraction;clear particles;clear extraction_temp;clear count;
clear lon_min;clear lon_max;clear lat_min;clear lat_max;clear depth_min;
clear depth_max; clear i;clear lat;clear lon;clear depth;clear P;clear S;
clear T;clear sigma_a;clear temp;clear time; clear h; clear heights;
clear mask; clear init_pos_vec; clear fin_pos_vec; clear SF; clear TF;
clear SFb; clear TFb; clear Tb; clear Sb;
