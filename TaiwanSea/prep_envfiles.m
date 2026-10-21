function fileroot = prep_envfiles( paths, caseName )
% copy the shared KoreanSea bty/ssp to match the case's env file name

fileroot = fullfile( paths.env, caseName );
copyfile( fullfile( paths.env, 'Taiwan.bty' ), [ fileroot '.bty' ] );
copyfile( fullfile( paths.env, 'Taiwan.ssp' ), [ fileroot '.ssp' ] );