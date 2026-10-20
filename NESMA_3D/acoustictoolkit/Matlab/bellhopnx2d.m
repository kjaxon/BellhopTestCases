function bellhop( filename )
% run the BELLHOPNx2D program
%
% usage: bellhop( filename )
% where filename is the environmental file

paths = setup_paths();

if ispc
    runbellhop = fullfile( paths.bin, 'bellhopcudanx2d.exe' );
else
    runbellhop = fullfile( paths.bin, 'bellhopcudanx2d' );
end

if ~isfile( runbellhop )
   error( 'bellhop not found: %s', runbellhop )
else
   eval( [ '! "' runbellhop '" "' filename '"' ] );
end