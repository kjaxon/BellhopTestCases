% run the Taiwan 3D test cases
% mbp, July 2011
%
% edited by Khalil Jackson 2026
% Changed bellhop3d calls for Nx2D to bellhopnx2d

% the polar and sideview plots should be done in separate BELLHOP runs for
% speed ...

global units
units = 'km';
subdirectory = './EnvironmentFiles/'

%Bathy = LoadBathymetry( 'Taiwan.xyz' );   % load the xyz file from ETOPO1
%writebdry3d( 'Taiwan.bty', Bathy );        % save it in my bty format
figure
plotbdry3d([subdirectory 'Taiwan.bty'])                          % howzit look?
caxis( [ -7500 7500 ] )

%parula_dat = parula;
jet_dat = jet( 60 );

%ocean = flipud( parula_dat( 1 : 30, : ));
ocean = flipud( jet_dat( 1 : 30, : ));

land_dat  = copper( 60 );

ocean_land = [ land_dat( 15 : 44, : ) ; ocean ];
colormap( ocean_land )


%%
plotssp3d ([subdirectory 'Taiwan'])
caxis( [ 1510 1535 ])
print -dpng TaiwanSSP

% makebty;             % make the bathymetry
%%

% 2D Transmission Loss runs

filename = 'TaiwanNx2D'
fileroot = [subdirectory filename]

copyfile( [subdirectory 'Taiwan.bty'], [ fileroot '.bty' ] )
copyfile( [subdirectory 'Taiwan.ssp'], [ fileroot '.ssp' ] )

bellhopnx2d( fileroot )

% polar plot of the TL
figure
plotshdpol( [ fileroot '.shd' ], [ 175 300 ], [ 200 300 400 ], 500 )
caxisrev( [ 60 100 ] )

% sideview of the TL
figure
plotshd(    [ fileroot '.shd' ] )
caxisrev( [ 60 100 ] )

delete( [ fileroot '.bty' ] )
delete( [ fileroot '.ssp' ] )

%%

% 3D Transmission Loss runs

filename = 'Taiwan3D'
fileroot = [subdirectory filename]

copyfile( [subdirectory 'Taiwan.bty'], [ fileroot '.bty' ] )
copyfile( [subdirectory 'Taiwan.ssp'], [ fileroot '.ssp' ] )

bellhop3d( fileroot )

% polar plot of the TL
figure
plotshdpol( [ fileroot '.shd' ], [ 175 300 ], [ 200 300 400 ], 500 )
caxisrev( [ 60 100 ] )

print -depsc2 Taiwan3DTL

% sideview of the TL
figure
plotshd(    [ fileroot '.shd' ] )
caxisrev( [ 60 100 ] )

print -depsc2 Taiwan3D_side

delete( [ fileroot '.bty' ] )
delete( [ fileroot '.ssp' ] )


%%

% ray trace runs

filename = 'TaiwanNx2D_ray'
fileroot = [subdirectory filename]

copyfile( [subdirectory 'Taiwan.bty'], [ fileroot '.bty' ] )
copyfile( [subdirectory 'Taiwan.ssp'], [ fileroot '.ssp' ] )

bellhopnx2d( fileroot )

figure
plotbdry3d( [ fileroot '.bty' ] )
caxis( [ -7500 7500 ] )
colormap( ocean_land )

hold on

plotray3d( [ fileroot '.ray' ] )

print -depsc2 TaiwanNx2D_ray

delete( [ fileroot '.bty' ] )
delete( [ fileroot '.ssp' ] )

%%

filename = 'Taiwan3D_ray'
fileroot = [subdirectory filename]

copyfile( [subdirectory 'Taiwan.bty'], [ fileroot '.bty' ] )
copyfile( [subdirectory 'Taiwan.ssp'], [ fileroot '.ssp' ] )

bellhop3d( fileroot )

figure
plotbdry3d( [ fileroot '.bty' ] )
caxis( [ -7500 7500 ] )
colormap( ocean_land )

hold on

plotray3d( [ fileroot '.ray' ] )
axis( [ 0 350 150 600 -7500 7500 ] )

print -depsc2 Taiwan3D_ray

%%
delete( [ fileroot '.bty' ] )
delete( [ fileroot '.ssp' ] )
