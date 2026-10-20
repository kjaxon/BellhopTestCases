function fileroot = prep_envfiles( paths, caseName )
% copy the shared KoreanSea bty/ssp to match the case's env file name

fileroot = fullfile( paths.env, caseName );
copyfile( fullfile( paths.env, 'KoreanSea.bty' ), [ fileroot '.bty' ] );
copyfile( fullfile( paths.env, 'KoreanSea.ssp' ), [ fileroot '.ssp' ] );