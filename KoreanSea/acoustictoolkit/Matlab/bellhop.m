function bellhop( filename )
% run the BELLHOP program
%
% usage: bellhop( filename )

if nargin < 2, runtype = 'P'; end

paths = setup_paths();

if ispc
    if strcmpi( runtype, 'C' )
        runbellhop = fullfile( paths.bin, 'bellhopcuda.exe' );
    elseif strcmpi( runtype, 'P' )
        runbellhop = fullfile( paths.bin, 'bellhopcxx.exe' );
    end
else
    if strcmpi( runtype, 'C' )
        runbellhop = fullfile( paths.bin, 'bellhopcuda' );
    elseif strcmpi( runtype, 'P' )
        runbellhop = fullfile( paths.bin, 'bellhopcxx' );
    end
end
if ~isfile( runbellhop )
   error( 'bellhop not found: %s', runbellhop )
else
   eval( [ '! "' runbellhop '" "' filename '"' ] );
end