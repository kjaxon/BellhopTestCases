function fileroot = prep_envfiles( paths, caseName )
% copy the shared KoreanSea bty/ssp to match the case's env file name

fileroot = fullfile( paths.env, caseName );
btyfileroot = fullfile( paths.env, 'seamount.bty' );
sspfileroot = fullfile( paths.env, 'NESMA.ssp' );
copyfile( btyfileroot, [ fileroot '.bty' ] )
copyfile( sspfileroot, [ fileroot '.ssp' ] )