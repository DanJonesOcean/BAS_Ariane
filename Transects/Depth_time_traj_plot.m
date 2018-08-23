figure();
hold on;
for i = drange(1:3600)
    extract = traj((traj(:,1) == i), :);
    plot(  extract(:,5) ,  extract(:,4));
end

hold off;