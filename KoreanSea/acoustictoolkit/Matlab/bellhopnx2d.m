function bellhopnx2d( filename, runtype )
% run the BELLHOPNx2D program
%
% usage: bellhop( filename )

if nargin < 2, runtype = 'P'; end

paths = setup_paths();

if ispc
    if strcmpi( runtype, 'C' )
        runbellhop = fullfile( paths.bin, 'bellhopcudanx2d.exe' );
    elseif strcmpi( runtype, 'P' )
        runbellhop = fullfile( paths.bin, 'bellhopcxxnx2d.exe' );
    end
else
    if strcmpi( runtype, 'C' )
        runbellhop = fullfile( paths.bin, 'bellhopcudanx2d' );
    elseif strcmpi( runtype, 'P' )
        runbellhop = fullfile( paths.bin, 'bellhopcxxnx2d' );
    end
end
if ~isfile( runbellhop )
   error( 'bellhop not found: %s', runbellhop )
else
   eval( [ '! "' runbellhop '" "' filename '"' ] );
end