% run the double seamount test case (created by YT Lin)

global units
units = 'km';

%%
makebty

figure
plotbdry3d( btyfil )
axis( [ 0 6 -4 4 ] )

%print -depsc2 Bathy

% ray trace
filename = 'DoubleSeamount3D_ray'
subdirectory = './EnvironmentFiles/'
fileroot = [subdirectory filename]

bellhop3d(fileroot)

hold on
plotray3d( [fileroot '.ray'] )
axis( [ 0 6 -4 4 0 900 ] )
print -depsc2 DoubleSeamount3D_ray

%%
% default beam spacing becomes about 300 beams in each direction
filename = 'DoubleSeamount3D'
subdirectory = './EnvironmentFiles/'
fileroot = [subdirectory filename]

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

copyfile( [subdirectory 'DoubleSeamount3D.bty'], [subdirectory 'DoubleSeamount3DHat.bty'] )

filename = 'DoubleSeamount3DHat'
subdirectory = './EnvironmentFiles/'
fileroot = [subdirectory filename]

bellhop3d(fileroot)

%%
figure
plotshdpol( [fileroot '.shd'],  0, 0, 400 )
caxis( [ 40 80 ] )
axis equal
axis( [ 0 6 -4 4 ] )

print -dpng 3DHat

%%
delete([subdirectory 'DoubleSeamount3D.bty'])
delete([subdirectory 'DoubleSeamount3DHat.bty'])
