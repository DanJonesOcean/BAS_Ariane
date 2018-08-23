extraction_temp = traj((traj(:,3) < 25) & (traj(:,3) > 23), :);
extraction = extraction_temp((extraction_temp(:,2) < -40) ...
                                & (extraction_temp(:,2) > -50), :);

particles = zeros(size(extraction_temp(:,1)));                            
count = 1;

for i = [1:size(extraction(:,1))]
    if ismember(extraction(i,1),particles)
        
    else
        particles(count,1) = extraction(i,1);
        count = count + 1;
    end
end

particles( ~any(particles,2), : ) = [];
particle_traj = traj( ismember(traj(:,1), particles(:,1)) , : );

fprintf('The number of particles that go through 24N is: \n\t');
fprintf(char(string(count - 1)));
fprintf('\n');

clear extraction;
clear particles;
clear extraction_temp;
clear i;
clear count;
