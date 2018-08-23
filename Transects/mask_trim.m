%%
% Cutting down vmask to just the north atlantic basin with maximum effort
% by filling the undesired space with 0's 
function trim = mask_trim()
ncid1 = netcdf.open('mask.nc','NC_NOWRITE');
trim = single(netcdf.getVar(ncid1,6));

for i = 1:500
    for j = 1:900
        trim(j,i,:) = 0;
    end
end

for i = 1:1021
    for j = 1350:1442
        trim(j,i,:) = 0;
    end
end

for i = 1:620
    for j = 1250:1442
        trim(j,i,:) = 0;
    end
end

for i = 620:630
    for j = 1250:1442
        trim(j,i,:) = 0;
    end
end


for i = 1:1021
    for j = 1:700
        trim(j,i,:) = 0;
    end
end

for i = 500:670
    for j = 701:900
        if trim(j,i,:) == 0
            break
        end
        trim(j,i,:) = 0;
    end
end

for i = 6:700
    for j = 1:730
        trim(j,i,:) = 0;
    end
end


return

%% 
