function bellhop3d( filename, runtype )
% run the BELLHOP3D program
%
% usage: bellhop( filename )
% where filename is the environmental file
paths = setup_paths();

if ispc
    if runtype == 1
        runbellhop = fullfile( paths.bin, 'bellhopcuda3d.exe' );
    else
        runbellhop = fullfile( paths.bin, 'bellhopcxx3d.exe' );
    end
else
    if runtype == 1
        runbellhop = fullfile( paths.bin, 'bellhopcuda3d' );
    else
        runbellhop = fullfile( paths.bin, 'bellhopcxx3d' );
    end
end

if ~isfile( runbellhop )
   error( 'bellhop not found: %s', runbellhop )
else
   eval( [ '! "' runbellhop '" "' filename '"' ] );
end