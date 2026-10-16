function write_eig_env(name, Dmax, rR)

%% SSP: simple Munk profile down to the deepest point
z = (0:50:Dmax)';
if z(end) < Dmax, z(end+1) = Dmax; end
eta = 2*(z - 1300)/1300;
c   = 1500*(1 + 0.00737*(eta - 1 + exp(-eta)));

SSP.NMedia = 1;
SSP.N      = 0;              % 0 = let Bellhop pick the mesh
SSP.sigma  = 0;              % surface roughness
SSP.depth  = [0 Dmax];       % top and bottom of the water column

SSP.raw(1).z      = z;
SSP.raw(1).alphaR = c;                   % sound speed
SSP.raw(1).betaR  = zeros(size(z));      % shear speed (none in water)
SSP.raw(1).rho    = ones(size(z));       % density
SSP.raw(1).alphaI = zeros(size(z));      % attenuation
SSP.raw(1).betaI  = zeros(size(z));

%% Boundaries
Bdry.Top.Opt = 'CVW';        % linear SSP interp, vacuum surface, dB/wavelength
Bdry.Bot.Opt = 'A*';         % acoustic halfspace, * = read the .bty

Bdry.Bot.HS.alphaR = 1600;   % bottom sound speed (m/s)
Bdry.Bot.HS.betaR  = 0;      % shear speed
Bdry.Bot.HS.rho    = 1.8;    % density (g/cm^3)
Bdry.Bot.HS.alphaI = 0.8;    % attenuation (dB/wavelength)
Bdry.Bot.HS.betaI  = 0;

%% Source and receiver
Pos.s.z = 1200;               % source depth (m)
Pos.r.z = 1440;               % receiver depth (m)
Pos.r.r = rR;                % receiver range (km)

%% Beams
Beam.RunType = 'E';          % eigenrays
Beam.Nbeams  = 5101;
Beam.alpha   = [-90 90];     % launch angles (deg)
Beam.deltas  = 0;            % 0 = automatic step size
Beam.Box.z   = Dmax + 100;   % stop rays below this depth (m)
Beam.Box.r   = rR * 1.02;    % stop rays past this range (km)

write_env(name, 'BELLHOP', 'NESMA eigenrays', 1000, ...
    SSP, Bdry, Pos, Beam, [], []);
