function [xdeg, ydeg] = screen_to_deg(x, y, scrd, scrw, scrh, xres, yres)
% Translate from pixel based coordinates to dimensionless (degrees) given
% some info about the screen and eye-screen distances used
%
% screen width, height and distance in millimeters!
% 
% Expects this type of coordinates as input:
%
%     Given (e.g.) xres = (0,1280) and yres = (0,1024), calibrated 
%     coordinates will have the following form.
%     
%     (0,0) ___________________ 
%           |                 |
%           |                 |
%           |                 |
%           |                 |
%           |_________________| (1280,1024)
% NOTE: x and y vectors must have the same dimensions (length)
d2r = pi / 180.0;
r2d = 180.0 / pi;
xpixs = scrw/xres;
ypixs = scrh/yres;
mmx = [];
mmy = [];
%from pixel to mm and place 0 in the middle of the screen
for i = 1: length(x)
    mmx = [mmx; xpixs * x(i) - 0.5 * scrw];
    mmy = [mmy; ypixs * y(i) - 0.5 * scrh];
end
%from mm to angle...
mx = mmx/scrd;
my = mmy/scrd;
xdeg = r2d * atan(mx);
ydeg = r2d * atan(my);
end
