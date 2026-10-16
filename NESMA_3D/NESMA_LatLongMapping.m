clearvars -except lar lor zr
if ~exist('lar', 'var') || ~exist('lor', 'var') || ~exist('zr', 'var')
    load(".\NESMA_RR2409_bathy_25m.mat")
end
lon = lor;
lat = lar;
depth = zr;

% Subsample to ~1000 points per side
sL = ceil(numel(lar)/1000);
sO = ceil(numel(lor)/1000);
latS = lar(1:sL:end);
lonS = lor(1:sO:end);
Zs   = zr(1:sL:end, 1:sO:end);

figure('Color','w')
imagesc(lonS, latS, Zs)
set(gca, 'YDir', 'normal')                   % latitude increases upward
axis equal tight
daspect([1 cosd(mean(lar)) 1])               % true distance aspect ratio

colormap(flipud(jet))
cb = colorbar; cb.Label.String = 'Depth (m)';
xlabel('Longitude'); ylabel('Latitude')
title('NESMA RR2409 bathymetry')