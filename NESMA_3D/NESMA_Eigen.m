% Simple NESMA script that uses Mike Porters method to plotting eigen rays
subdirectory = './EnvironmentFiles/';
if ~isfolder( subdirectory )
    mkdir( subdirectory );
end
filename = 'NESMA_eigen'
fileroot = [subdirectory filename]

copyfile( [subdirectory 'seamount.bty'], [ fileroot '.bty' ] )
copyfile( [subdirectory 'NESMA.ssp'], [ fileroot '.ssp' ] )

bellhop3d( fileroot )

figure
plotbdry3d( [ fileroot '.bty' ] )
hold on
   
plotray3d( [ fileroot '.ray' ] )
title('NE Seamount - TR & Sam Mooring')

delete( [ fileroot '.bty' ] )
delete( [ fileroot '.ssp' ] )