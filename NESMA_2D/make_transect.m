function [rkm, zb, lat, lon, rR] = make_transect(src, rcv, lar, lor, depth)
%
% Sample the line
nPts = 500;
t   = linspace(0, 1.05, nPts)';
lat = src(1) + t*(rcv(1) - src(1));
lon = src(2) + t*(rcv(2) - src(2));

% lat = src(1) + (rcv(1) - src(1));
% lon = src(2) + (rcv(2) - src(2));

% Cumulative range along track in km
R    = 6371.0088;
dlat = deg2rad(diff(lat));  dlon = deg2rad(diff(lon));
a    = sin(dlat/2).^2 + cos(deg2rad(lat(1:end-1))) .* ...
    cos(deg2rad(lat(2:end))) .* sin(dlon/2).^2;
rkm  = [0; cumsum(2*R*asin(sqrt(a)))];

% Depth along track 
zb = interp2(lor, lar, depth, lon, lat); 

rR   = interp1(t, rkm, 1);   % receiver range (km) for the .env
