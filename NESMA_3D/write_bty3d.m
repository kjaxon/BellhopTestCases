function write_bty3d(filename, lon, lat, depth, varargin)
% WRITE_BTY3D  Write a Bellhop3D bathymetry (.bty) file from a gridded dataset.
% Claude assisted
%
%   WRITE_BTY3D(FILENAME, LON, LAT, DEPTH) writes a Bellhop3D-compatible
%   .bty file from a pre-gridded dataset.
%
%   Inputs:
%     filename  - Output file path. '.bty' extension added automatically if absent.
%     lon       - 1×Nx vector of longitudes, monotonically increasing.
%     lat       - 1×Ny vector of latitudes,  monotonically increasing.
%     depth     - Ny×Nx matrix of water depths in metres (positive downward).
%                 depth(i,j) corresponds to lat(i), lon(j).
%
%   Optional name-value options:
%
%     'InterpType', 'L' or 'C'
%         Bellhop3D interpolation: 'L' = piecewise linear (default), 'C' = curvilinear.
%
%     'Subsample', N  (default: 1, i.e. no subsampling)
%         Take every N-th point in both lon and lat directions.
%
%     'SubsampleLon', Nx  and  'SubsampleLat', Ny
%         Specify desired number of output points along each axis.
%
%     'CropLon', [lonMin lonMax]
%         Crop to a longitude range before writing.
%
%     'CropLat', [latMin latMax]
%         Crop to a latitude range before writing.
%
%     'ConvertToKm', true/false  (default: false)
%         Convert lon/lat coordinates to kilometres relative to a source point.
%         Requires 'SourceLon' and 'SourceLat' to also be set.
%
%     'SourceLon', value
%         Longitude of the Bellhop source point (origin for km conversion).
%
%     'SourceLat', value
%         Latitude of the Bellhop source point (origin for km conversion).
%
%   Example:
%     % Write .bty in km coords relative to source at (-62.5, 37.8)
%     write_bty3d('bellhopseamount.bty', lon, lat, depth, ...
%                 'CropLon',      [-63.5, -62.0], ...
%                 'CropLat',      [37.5,  39.0],  ...
%                 'Subsample',    10,             ...
%                 'ConvertToKm',  true,           ...
%                 'SourceLon',    -62.5,          ...
%                 'SourceLat',    37.8);

% ---- Parse optional arguments ------------------------------------------
p = inputParser;
addParameter(p, 'InterpType',   'C',   @(x) ischar(x) && ismember(upper(x(1)),{'L','C'}));
addParameter(p, 'Subsample',     1,    @(x) isnumeric(x) && isscalar(x) && x >= 1);
addParameter(p, 'SubsampleLon', [],    @(x) isnumeric(x) && isscalar(x) && x >= 1);
addParameter(p, 'SubsampleLat', [],    @(x) isnumeric(x) && isscalar(x) && x >= 1);
addParameter(p, 'CropLon',      [],    @(x) isnumeric(x) && numel(x) == 2);
addParameter(p, 'CropLat',      [],    @(x) isnumeric(x) && numel(x) == 2);
addParameter(p, 'ConvertToKm',  true, @islogical);
addParameter(p, 'SourceLon',    [],    @(x) isnumeric(x) && isscalar(x));
addParameter(p, 'SourceLat',    [],    @(x) isnumeric(x) && isscalar(x));
parse(p, varargin{:});
opt = p.Results;
interp_type = upper(opt.InterpType(1));

% ---- Validate km conversion inputs -------------------------------------
if opt.ConvertToKm
    if isempty(opt.SourceLon) || isempty(opt.SourceLat)
        error('write_bty3d: ConvertToKm requires SourceLon and SourceLat to be set.');
    end
end

% ---- Flatten to row/column vectors -------------------------------------
lon = lon(:)';   % 1×Nx
lat = lat(:);    % Ny×1

% ---- Validate grid size ------------------------------------------------
Nx_in = numel(lon);
Ny_in = numel(lat);
if size(depth,1) ~= Ny_in || size(depth,2) ~= Nx_in
    error(['write_bty3d: depth must be Ny×Nx.\n' ...
           '  Expected [%d %d], got [%d %d].\n' ...
           '  If your depth is transposed, pass depth''.'], ...
          Ny_in, Nx_in, size(depth,1), size(depth,2));
end
if any(diff(lon) <= 0)
    error('write_bty3d: lon must be strictly monotonically increasing.');
end
if any(diff(lat) <= 0)
    error('write_bty3d: lat must be strictly monotonically increasing.');
end

% ---- Crop --------------------------------------------------------------
if ~isempty(opt.CropLon)
    ix = lon >= opt.CropLon(1) & lon <= opt.CropLon(2);
    if sum(ix) < 2
        error('write_bty3d: CropLon [%.4f %.4f] contains fewer than 2 lon points.', ...
              opt.CropLon(1), opt.CropLon(2));
    end
    lon   = lon(ix);
    depth = depth(:, ix);
end
if ~isempty(opt.CropLat)
    iy = lat >= opt.CropLat(1) & lat <= opt.CropLat(2);
    if sum(iy) < 2
        error('write_bty3d: CropLat [%.4f %.4f] contains fewer than 2 lat points.', ...
              opt.CropLat(1), opt.CropLat(2));
    end
    lat   = lat(iy);
    depth = depth(iy, :);
end

% ---- Subsample ---------------------------------------------------------
stride_lon = max(1, round(opt.Subsample));
stride_lat = max(1, round(opt.Subsample));

if ~isempty(opt.SubsampleLon)
    stride_lon = max(1, floor(numel(lon) / opt.SubsampleLon));
end
if ~isempty(opt.SubsampleLat)
    stride_lat = max(1, floor(numel(lat) / opt.SubsampleLat));
end

if stride_lon > 1 || stride_lat > 1
    lon_idx = 1:stride_lon:numel(lon);
    lat_idx = 1:stride_lat:numel(lat);
    lon     = lon(lon_idx);
    lat     = lat(lat_idx);
    depth   = depth(lat_idx, lon_idx);
    fprintf('Subsampled to %d lon × %d lat points (strides: lon=%d, lat=%d).\n', ...
            numel(lon), numel(lat), stride_lon, stride_lat);
end

% ---- Convert to km relative to source ----------------------------------
if opt.ConvertToKm
    src_lon = opt.SourceLon;
    src_lat = opt.SourceLat;

    % Earth radius in km
    R_earth = 6371.0;

    % Convert lon to km: scale by cos(lat) at source latitude
    lat_rad = deg2rad(src_lat);
    lon_km  = (lon - src_lon) * (pi/180) * R_earth * cos(lat_rad);

    % Convert lat to km: straightforward arc length
    lat_km  = (lat - src_lat) * (pi/180) * R_earth;

    fprintf('Converted to km coordinates relative to source (%.4f, %.4f).\n', ...
            src_lon, src_lat);
    fprintf('  X (lon) range: [%.2f, %.2f] km\n', lon_km(1), lon_km(end));
    fprintf('  Y (lat) range: [%.2f, %.2f] km\n', lat_km(1), lat_km(end));

    lon = lon_km;
    lat = lat_km;
end

Nx = numel(lon);
Ny = numel(lat);

% ---- Warn about very large grids ---------------------------------------
n_cells = Nx * Ny;
if n_cells > 2e6
    warning(['write_bty3d: output grid is %d×%d (%d M points).\n' ...
             '  Consider subsampling further.'], ...
            Nx, Ny, round(n_cells/1e6));
end

% ---- Depth checks ------------------------------------------------------
if any(depth(:) <= 0, 'all')
    warning('write_bty3d: %d depth values are <= 0 m (land or bad data).', ...
            sum(depth(:) <= 0, 'all'));
end
if any(isnan(depth(:)), 'all')
    n_nan = sum(isnan(depth(:)), 'all');
    warning('write_bty3d: %d NaN values in depth. Replacing with nearest valid depth.', n_nan);
    col_mean = mean(depth, 1, 'omitnan');
    for j = 1:Nx
        col = depth(:,j);
        col(isnan(col)) = col_mean(j);
        depth(:,j) = col;
    end
    depth(isnan(depth)) = mean(depth(:), 'omitnan');
end

% ---- Add .bty extension if missing -------------------------------------
[~, ~, ext] = fileparts(filename);
if ~strcmpi(ext, '.bty')
    filename = [filename '.bty'];
end

% ---- Write file --------------------------------------------------------
fprintf('Writing %s (%d lon × %d lat)...\n', filename, Nx, Ny);

fid = fopen(filename, 'w');
if fid == -1
    error('write_bty3d: cannot open ''%s'' for writing.', filename);
end

fprintf(fid, '''%s''\n', interp_type);

fprintf(fid, '%d\n', Nx);
fprintf(fid, '%12.6f', lon);
fprintf(fid, '\n');

fprintf(fid, '%d\n', Ny);
fprintf(fid, '%12.6f', lat(:)');
fprintf(fid, '\n');

for iy = 1:Ny
    fprintf(fid, '%12.4f', depth(iy, :));
    fprintf(fid, '\n');
end

fclose(fid);

% ---- Summary -----------------------------------------------------------
finfo = dir(filename);
fprintf('Done. File: %s\n', filename);
fprintf('  Grid     : %d lon × %d lat\n', Nx, Ny);
if opt.ConvertToKm
    fprintf('  X range  : [%.2f, %.2f] km\n', lon(1), lon(end));
    fprintf('  Y range  : [%.2f, %.2f] km\n', lat(1), lat(end));
else
    fprintf('  Lon range: [%.6f, %.6f]\n', lon(1), lon(end));
    fprintf('  Lat range: [%.6f, %.6f]\n', lat(1), lat(end));
end
fprintf('  Depth    : [%.1f, %.1f] m\n', min(depth(:)), max(depth(:)));
if ~isempty(finfo)
    fprintf('  File size: %.1f MB\n', finfo.bytes / 1e6);
end
end
