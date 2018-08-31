%% Extraction_plot
%{
 You need to be in a directory containing traj.txt and
 ariane_trajectories_qualitative.nc

 You also need all of the MATLAB scripts that come with 
 the ariane software to be in the PATH, they will dump a 
 load of variables in your workspace.
%}
%% Import data
traj = dlmread('traj.txt', ' ');
traj( :, ~any(traj,1) ) = [];

%% Define intersection box
% set very large min/max values to include entire range 
% (i.e. depth_min = -100000, depth_max = 100000)
lon_min = -30;
lon_max = -25; 
lat_min = 36;
lat_max = 40;
depth_min = -100000;
depth_max = 1000000;

%% Locate intersecting particles 
% Locate particles that intersect lon
extraction= traj((traj(:,2) > lon_min) & ...
                 (traj(:,2) < lon_max), :);

% Locate particles that intersect lat
extraction = extraction((extraction(:,3) > lat_min) & ...
                        (extraction(:,3) < lat_max), :);

% Locate particles that intersect depth
extraction = extraction((extraction(:,4) > depth_min) & ...
                        (extraction(:,4) < depth_max), :);
                            
%% Extract intersecting particle identities
% Create blank vector to store particle numbers
particles = zeros(size(extraction(:,1)));  

% Extract distinct particle numbers from extraction and put in a vector, 
% loop over all rows in extraction and keep count
count = 1;
for i = [1:size(extraction(:,1))]
    if ismember(extraction(i,1),particles)
        
    else
        particles(count,1) = extraction(i,1);
        count = count + 1;
    end
end
% Remove any blank elements from vector
particles( ~any(particles,2), : ) = [];

%% Extract the particles trajectories from traj matrix
particle_traj = traj( ismember(traj(:,1), particles(:,1)) , : );

%% Print the number of extracted particles
fprintf('The number of particles that go through 24N is: \n\t');
fprintf(char(string(count - 1)));
fprintf('\n');

%% Generate new figure
fid = figure();

%% Read grid
a_ncreadgrid;

%% Set a few plot attributes 
projection = 'miller';
a_no_save_mask=1;
a_cstep = 0.05;

%% Initialize the map projection. 
a_projection;

%% Land mask
a_mask_land

%% Autorize to plot again on the same figure
hold on;

%% Bathymetry
a_bathy;

%% Plot trajectories and initial positions
for i = drange(1:count-1)
    extract = particle_traj((particle_traj(:,1) == i), :);
    m_plot((extract(:,2)), extract(:,3));
    if ~isempty(extract)
        m_plot(extract(1,2),extract(1,3), 'kx','LineWidth',2);
    end
end

%% Title and axis labels
title({'Particle trajectories'}, 'fontweight', 'b');
xlabel('longitude', 'fontweight', 'b');
ylabel('latitude', 'fontweight', 'b');

%% Save the figure
saveas(fid, 'particles_traj','fig');
saveas(fid, 'particles_traj','pdf');

%% Clear temporary variables
clear extraction;
clear particles;
clear extraction_temp;
clear i;
clear count;
clear lon_min;
clear lon_max;
clear lat_min;
clear lat_max;
clear depth_min;
clear depth_max;

