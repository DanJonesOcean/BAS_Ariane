%% Creates and saves a plot of Density against longitude from the traj.txt file

figure();
scatter(traj(:,2),traj(:,8), 20, traj(:,6), 'filled');
colormap('jet');
colorbar;
title(string('Density vs Longitude plot for the interesting reverse run - colour represents temperature'));
set(gca,'Ydir','reverse');
hold on;
scatter(traj(1,2),traj(1,8), '*k');
xlabel('Longitude');
ylabel('Density calculated by Ariane');
saveas(gca,'Dens-lon.fig','fig');
saveas(gca,'Dens-lon','pdf');
close();
