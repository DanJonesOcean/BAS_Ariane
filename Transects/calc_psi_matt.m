function psi = calc_psi_matt( v, grid, mask )
% global barotropic stream function for nemo model, time slabs are
% handled as cell objects, integration from sea floor to surface
 
%% ------------------------------------------------------------------------
 
% Calculate the area of the northern cell face.
dxdz = repmat( grid.dx, [ 1 1 grid.nz ] ) .* grid.dz;
 dxdz = dxdz .* mask;
%% ------------------------------------------------------------------------
 
% Integrate from the sea floor to surface
 
% Calculate flux through the nothern face

vdxdz = v.*dxdz;
 
% Sum in the zonal (northerm basin is roughly 820 - 1100).
vbar = squeeze( sum( vdxdz(:,:,:), 1 ) );
 
% Do the integration (cumulative summation), placing streamfunction on
% vorticity points.
psi = zeros( grid.ny, grid.nz+1 );
psi( 1:end, 2:end ) = cumsum( vbar , 2);

%% ------------------------------------------------------------------------
    
  return
 
%% ------------------------------------------------------------------------