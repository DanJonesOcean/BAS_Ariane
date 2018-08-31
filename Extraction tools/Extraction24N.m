% ----------------------------------------------------------------- %
%% Extracts particles that go through the 24N detection region 

%% Filter latitude
extraction = traj((traj(:,3) < 25) & (traj(:,3) > 23), :);

%% Filter longitude
extraction = extraction((extraction(:,2) < -40) ...
                                & (extraction(:,2) > -50), :);

%% Filter depth
extraction = extraction((extraction(:,4) < -1500) ...
                                & (extraction(:,4) > -2500), :);

%% Create empty vector to house particle identities
particles = zeros(size(extraction_temp(:,1)));                            

%% Extract distict particle numbers from intersecting positions and put into empty vector
count = 1;
for i = 1:size(extraction(:,1))
    if ismember(extraction(i,1),particles)
        
    else
        particles(count,1) = extraction(i,1);
        count = count + 1;
    end
end

%% Remove any unfilled cells
particles( ~any(particles,2), : ) = [];

%% Extract trajectories of particles with numbers in this array
particle_traj = traj( ismember(traj(:,1), particles(:,1)) , : );

%% Print some results to screen
fprintf('The number of particles that go through 24N is: \n\t');
fprintf(char(string(count - 1)));
fprintf('\n');

%% Clear temporary variables
clear extraction;
clear particles;
clear i;
clear count;

% ----------------------------------------------------------------- %
