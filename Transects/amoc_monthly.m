%% ---------------------------------------------------------------

for i = 01:12
    % Load Nemo output data
    
    str = [[string('ORCA025-N401_2010m'),sprintf('%02d',i),string('V.nc')]];
    filename = join(str,'');
    
    ncid1 = netcdf.open(filename,'NC_NOWRITE');
    ncid2 = netcdf.open('mesh_hgr_matt.nc','NC_NOWRITE');
    ncid3 = netcdf.open('mask.nc','NC_NOWRITE');

% Load mask and replace NaN values with 0
    %mask = single(netcdf.getVar(ncid3,6));
    %mask(isnan(mask))=0;
    mask = mask_trim();

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
        %grid(1).hfacw = ??; I do not know what this is

% Load global position data
    gphit = netcdf.getVar(ncid2,8);         %gphit
    gdept = netcdf.getVar(ncid2,25);        %gdept_0
        %e3v = netcdf.getVar(ncid2,26);         %e3v
        %mask = mask ./ e3v; this messes things up for some reason

%% ---------------------------------------------------------------
% Calculate psi
    psi = calc_psi_matt( v, grid, mask );

%% ---------------------------------------------------------------
% Plot psi
    figure()
    transplt = contourf(repmat(gphit(1039, 600:1021),75,1)', ...
        - repmat(gdept,1,422)', psi(600:1021,1:end -1), ...
        (-15:1:15)*1.E6);
    colormap default
    colorbar;
    caxis([-15*1.E6 15*1.E6]);
%caxis([-15*1.E6,15*1.E6]);
    hold on;
    xlabel('Lattitude/deg')
    ylabel('Depth/m')
%% 
%Overlay bathymetry - low res but black
%mask = double(mask);
%img = imresize(im2double(getframe(gca).cdata), size(squeeze(mask(1039,:,:))'));
%figure(); colorbar; axis off;
%imagesc(img.*queeze(mask(1039,:,:))'); 
%%
%Overlay bathymetry - high res but blue 
%img = imagesc(gphit(1039, 600:1021)', ...
%    -gdept', squeeze(mask(1039,600:1021,:))');
%alphamask = 1 - squeeze(mask(1039,600:1021,:))';
%alpha(img, alphamask);
%%
ttl = join([string('North Atlantic Overturning Stream function 2010 / m^2s^{-1} - Month'), sprintf('%02d',i)]);
    
    title(char(ttl));    
    str = [[string('amoc_'),sprintf('%02d',i),string('.png')]];
    outname = strjoin(str,'');
    saveas(gcf, char(outname),'png');
    hold off
    fprintf( char(join([sprintf('%02d',i), string('Complete')])) )
    fprintf('\n')
    close;
end
fprintf('Done')
fprintf('\n')
%%