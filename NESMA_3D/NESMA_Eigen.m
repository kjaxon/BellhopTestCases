% Simple NESMA script that uses Mike Porters method to plotting eigen rays
paths = setup_paths

fileroot = prep_envfiles(paths, 'NESMA_eigen')
bellhop3d( fileroot )

figure
plotbdry3d( [ fileroot '.bty' ] )
hold on
   
plotray3d( [ fileroot '.ray' ] )
title('NE Seamount - TR & Sam Mooring')

delete( [ fileroot '.bty' ] )
delete( [ fileroot '.ssp' ] )