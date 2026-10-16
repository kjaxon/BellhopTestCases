% New England Seamount 3D Transmission loss plotting script
% Claude assisted
%

clearvars -except lar lor zr
if ~exist('lar', 'var') || ~exist('lor', 'var') || ~exist('zr', 'var')
    load(".\NESMA_RR2409_bathy_25m.mat")
end
lon = lor;
lat = lar;
depth = zr;

src_lon = -64.0;
src_lat = 38.3;
R_earth = 6371.0;

subdirectory = './EnvironmentFiles/';
if ~isfolder( subdirectory )
    mkdir( subdirectory );
end

filename = 'NESMA_TLoss'
fileroot = [subdirectory filename]

write_bty3d([fileroot '.bty'], lon, lat, depth, ...
    'CropLon',     [-68.0, -61.0], ...
    'CropLat',     [36.5,  40.5],  ...
    'Subsample',   10,             ...
    'ConvertToKm', true,           ...
    'SourceLon',   src_lon,        ...
    'SourceLat',   src_lat);

bellhop3d(fileroot)

[ bx, by, bz, ~, ~ ] = readbdry3d([fileroot '.bty']);
[ ~, ~, ~, ~, ~, Pos, pressure ] = read_shd([fileroot '.shd']);

figure;
ax = axes;
view( ax, -45, 25 );   % set before plotting so the headlight matches the camera

plot_tl_slice( ax, Pos, pressure, 1, [ 50 120 ] );
plot_bathy3d( ax, bx, by, bz );

% Axis labels
x_range = [ min( bx ) max( bx ) ];
y_range = [ min( by ) max( by ) ];
xt = linspace( x_range( 1 ), x_range( 2 ), 6 );
yt = linspace( y_range( 1 ), y_range( 2 ), 6 );
km_per_deg = R_earth * pi / 180;

xticks( ax, xt );
xticklabels( ax, compose( '%.1f', src_lon + xt / ( km_per_deg * cos( deg2rad( src_lat ) ) ) ) );
yticks( ax, yt );
yticklabels( ax, compose( '%.1f', src_lat + yt / km_per_deg ) );
zticks( ax, -6:1:-1 );
zticklabels( ax, { '6000', '5000', '4000', '3000', '2000', '1000' } );

title(  ax, 'NE Seamount - Transmission Loss' );
xlabel( ax, 'Longitude' );
ylabel( ax, 'Latitude' );
zlabel( ax, 'Depth (m)' );
xlim( ax, x_range );
ylim( ax, y_range );
zlim( ax, [ -6 -1 ] );