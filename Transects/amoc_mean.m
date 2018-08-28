% --------------------------------------------------------------- %
% Plots an Overturning Circulation streamfunction as defined in 
% calc_psi_matt.m for a yearly mean of ORCA025-N401 data for the 
% North Atlantic Basin (Masked by mask_trim.m)

% Load Nemo output data
ncid1 = netcdf.open('ORCA025-N401_2010y01V.nc','NC_NOWRITE');
ncid2 = netcdf.open('mesh_hgr_matt.nc','NC_NOWRITE');
ncid3 = netcdf.open('mask.nc','NC_NOWRITE');

% Load mask and replace NaN values with 0
%mask = single(netcdf.getVar(ncid3,6));
mask = mask_trim();
mask(isnan(mask))=0;

% Load V velocity field and masking it
v = netcdf.getVar(ncid1,4);
v = v .* mask;

% Load grid structure
grid(1).name = 'grid';
grid(1).dx = netcdf.getVar(ncid2,14);   %e1v
grid(1).dyg = netcdf.getVar(ncid2,18);  %e2v
grid(1).dz = netcdf.getVar(ncid2,26);   %e3v
grid(1).nx = 1442;                      %Lon size
grid(1).ny = 1021;                      %Lat size
grid(1).nz = 75;                        %Depth size

% Load global position data
gphit = netcdf.getVar(ncid2,8);         %gphit
gdept = netcdf.getVar(ncid2,25);        %gdept_0

%% ---------------------------------------------------------------
% Calculate psi
psi = calc_psi_matt( v, grid, mask );

%% ---------------------------------------------------------------
% Plot psi
figure()
transplt = contourf(repmat(gphit(1039, 600:1021),75,1)', ...
    - repmat(gdept,1,422)', psi(600:1021,1:end -1), ...
    (-25:1:25)*1.E6);
colormap default
colorbar;
caxis([-10*1.E6,10*1.E6]);
hold on;
xlabel('Lattitude/deg')
ylabel('Depth/m')

%% 
%Overlay bathymetry - low res but black
%mask = double(mask);
%img = imresize(im2double(getframe(gca).cdata), size(squeeze(mask(1039,:,:))'));
%figure(); colorbar; axis off;
%imagesc(img.*squeeze(mask(1039,:,:))'); 

%%
%Overlay bathymetry - high res but blue 
img = imagesc(gphit(1039, 600:1021)', ...
    -gdept', squeeze(mask(1039,600:1021,:))');
alphamask = 1 - squeeze(mask(1039,600:1021,:))';
alpha(img, alphamask);

%%
%title and save 
title('North Atlantic Overturning Stream function 2010 / m^2s^{-1}');
saveas(gcf, 'AMOC-2010-NA_FULL','png');

% --------------------------------------------------------------- %
