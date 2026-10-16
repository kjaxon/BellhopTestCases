function s = plot_tl_slice( ax, Pos, pressure, irz, tlLim )
% Plot a horizontal TL slice at receiver depth index irz
% Claude assisted
% usage: s = plot_tl_slice( ax, Pos, pressure, irz, tlLim )
%   irz   - receiver depth index (default 1)
%   tlLim - color limits in dB (default [50 120])

if nargin < 4 || isempty( irz ),   irz   = 1;          end
if nargin < 5 || isempty( tlLim ), tlLim = [ 50 120 ]; end

TL = -20 * log10( abs( squeeze( pressure( :, 1, irz, : ) ) ) );
TL( isinf( TL ) )     = NaN;
TL( TL > tlLim( 2 ) ) = NaN;

[ R, THETA ] = meshgrid( Pos.r.r / 1000, deg2rad( 90 - Pos.theta ) );
X = R .* cos( THETA );
Y = R .* sin( THETA );
Z = -Pos.r.z( irz ) / 1000 * ones( size( X ) );   % km, negative down

fprintf( 'Plotting receiver depth %.0f m\n', Pos.r.z( irz ) );

hold( ax, 'on' );
s = surf( ax, X, Y, Z, TL, ...
    'EdgeColor',    'none',   ...
    'FaceColor',    'interp', ...
    'FaceLighting', 'none',   ...
    'FaceAlpha',    0.9 );

colormap( ax, flipud( jet ) );
caxis( ax, tlLim );
cb = colorbar( ax );
cb.Direction    = 'reverse';
cb.Label.String = 'TL (dB re 1\muPa)';