function paths = setup_paths()
% Set up paths for this test case folder; returns the folder locations

root = fileparts( mfilename( 'fullpath' ) );

paths.root = root;
paths.env  = fullfile( root, 'env' );
paths.bin  = fullfile( root, 'bellhop' );
paths.at   = fullfile( root, 'acoustictoolkit' );

addpath( genpath( paths.at ) );
addpath( paths.bin );

% make an env folder if there isn't one
if ~isfolder( paths.env ), mkdir( paths.env ); end