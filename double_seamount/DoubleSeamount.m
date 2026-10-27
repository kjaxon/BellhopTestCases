% run the double seamount test case (created by YT Lin)

paths = setup_paths()

global units
units = 'km';

%%
makebty

figure
plotbdry3d( btyfil )
axis( [ 0 6 -4 4 ] )

%print -depsc2 Bathy

% ray trace
caseName = 'DoubleSeamount3D_ray'
fileroot = fullfile( paths.env, caseName );


bellhop3d(fileroot)

hold on
plotray3d( [fileroot '.ray'] )
axis( [ 0 6 -4 4 0 900 ] )
print -depsc2 DoubleSeamount3D_ray

%%
% default beam spacing becomes about 300 beams in each direction
caseName = 'DoubleSeamount3D'
fileroot = fullfile( paths.env, caseName );

bellhop3d(fileroot)


%%
figure
plotshdpol( [fileroot '.shd'],  0, 0, 400 )
caxis( [ 40 80 ] )
axis equal
axis( [ 0 6 -4 4 ] )

print -depsc2 3DGaussian
%%
% default beam spacing becomes about 300 beams in each direction

copyfile( [paths.env '/DoubleSeamount3D.bty'], [paths.env '/DoubleSeamount3DHat.bty'] )

caseName = 'DoubleSeamount3DHat'
fileroot = fullfile( paths.env, caseName );

bellhop3d(fileroot)

%%
figure
plotshdpol( [fileroot '.shd'],  0, 0, 400 )
caxis( [ 40 80 ] )
axis equal
axis( [ 0 6 -4 4 ] )

print -dpng 3DHat

%%
delete([paths.env '/DoubleSeamount3D.bty'])
delete([paths.env '/DoubleSeamount3DHat.bty'])
