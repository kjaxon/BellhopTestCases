function bellhopnx2d( filename, runtype )
% run the BELLHOPNx2D program
%
% usage: bellhop( filename )
% where filename is the environmental file

paths = setup_paths();

if ispc
    if runtype == 1
        runbellhop = fullfile( paths.bin, 'bellhopcudanx2d.exe' );
    else
        runbellhop = fullfile( paths.bin, 'bellhopcxxnx2d.exe' );
    end
else
    if runtype == 1
        runbellhop = fullfile( paths.bin, 'bellhopcudanx2d' );
    else
        runbellhop = fullfile( paths.bin, 'bellhopcxxnx2d' );
    end
end
if ~isfile( runbellhop )
   error( 'bellhop not found: %s', runbellhop )
else
   eval( [ '! "' runbellhop '" "' filename '"' ] );
end