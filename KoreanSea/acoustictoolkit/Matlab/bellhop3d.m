function bellhop3d( filename, runtype )
% run the BELLHOP3D program
%
% usage: bellhop( filename )

if nargin < 2, runtype = 'P'; end

paths = setup_paths();

if ispc
    if strcmpi( runtype, 'C' )
        runbellhop = fullfile( paths.bin, 'bellhopcuda3d.exe' );
    elseif strcmpi( runtype, 'P' )
        runbellhop = fullfile( paths.bin, 'bellhopcxx3d.exe' );
    end
else
    if strcmpi( runtype, 'C' )
        runbellhop = fullfile( paths.bin, 'bellhopcuda3d' );
    elseif strcmpi( runtype, 'P' )
        runbellhop = fullfile( paths.bin, 'bellhopcxx3d' );
    end
end
if ~isfile( runbellhop )
   error( 'bellhop not found: %s', runbellhop )
else
   eval( [ '! "' runbellhop '" "' filename '"' ] );
end