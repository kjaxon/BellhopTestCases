function s = plot_bathy3d( ax, bx, by, bz )
% Plot bathymetry as a lit gray surface (bz in m, plotted in km, negative down)
% Claude assisted.
% usage: s = plot_bathy3d( ax, bx, by, bz )

hold( ax, 'on' );
s = surf( ax, bx, by, -bz / 1000, ...
    'EdgeColor',    'none',            ...
    'FaceColor',    [ 0.4 0.4 0.4 ],   ...
    'FaceLighting', 'gouraud' );
camlight( ax, 'headlight' );