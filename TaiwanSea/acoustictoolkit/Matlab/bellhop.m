function bellhop( filename )
% run the BELLHOP program
%
% usage: bellhop( filename )
% where filename is the environmental file

paths = setup_paths();

if ispc
    runbellhop = fullfile( paths.bin, 'bellhopcuda.exe' );
else
    runbellhop = fullfile( paths.bin, 'bellhopcuda' );
end

if ~isfile( runbellhop )
   error( 'bellhop not found: %s', runbellhop )
else
   eval( [ '! "' runbellhop '" "' filename '"' ] );
end