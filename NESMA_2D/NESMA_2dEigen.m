clearvars -except lar lor zr

paths = setup_paths()

if ~exist('lar', 'var') || ~exist('lor', 'var') || ~exist('zr', 'var')
    load(".\NESMA_RR2409_bathy_25m.mat")
end

cases = struct( ...
    'name', {'Case1', 'Case2', 'Case3'}, ...
    'src',  {[38.80 -64.30], [38.60 -63.80], [39.10 -64.90]}, ...
    'rcv',  {[38.80 -63.85], [38.60 -62.85], [39.10 -64.45]});

for k = 1:numel(cases)
    tag = fullfile( paths.env, sprintf( 'NESMA_%s', cases(k).name ) );

    [rkm, zb, lat, lon, rR] = make_transect(cases(k).src, cases(k).rcv, lar, lor, zr);
    Dmax = ceil(max(zb)); % Max depth

    % Write out env and bty file
    writebdry([tag '.bty'], 'L', [rkm zb]);
    write_eig_env(tag, Dmax, rR);

    % Run bellhop
    bellhop(tag)

    figure;
    plotray(tag);
    hold on;
    plotbty(tag)
    title(sprintf('%s Seamount — %.1f km transect', cases(k).name, rR))
end