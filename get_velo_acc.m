function [V] = get_velo_acc(y, dn, freq)
%Compute the instantaneous velocity and of position samples using a
%polynomial fit on 2 * dn + 1 points.
%     parameters:
%     ***********
%
%     y : position data
%     dn : int
%         number of samples used on each side of a sample to fit the data
%     freq : int/float
%         machines sample rate in hz
%     
%     returns:
%     ********
%
%     V : fitted velocity for position samples
%     A : fitted acceleration for position samples
%
%     --------------------------------------------------------------------
%     Theoretically, we solve:
%
%     SUM(y-y') minimal, in which y' = a + bx + cx**2
%     gives three equations:
%
%       a           - SUM(y)     + b*SUM(x)   + c*SUM(x**2) = 0
%       b*SUM(x**2) - SUM(xy)    + a*SUM(x)   - c*SUM(x**3) = 0
%       c*SUM(x**4) - SUM(y*x**2)+ a*SUM(x**2)+ b*SUM(x**3) = 0
%
%     in which x=-dn:dn, and therefore N = 2*dn+1, SUM(x) = SUM(x**3) = 0,
%     yields:
%     b = sum(x*y) / sum(x**2)
%       = 'Velocity'
%     c = (N*sum(y*x**2)-sum(x**2)*sum(y))/(N*sum(x**4)-(sum(x**2))**2)
%       ='Acceleration'
%     a = (sum(y)-c*sum(x**2)])/SUM(x**4)
%       = 'Position'
%     --------------------------------------------------------------------

nry = length(y);
ncy = 1;
N = length(y);
x = -dn:1:dn;
x = x';
Nx = length(x);
x2 = repmat(x, 1, N, Nx);
%indx = repmat(x, N)
totile = linspace(1, N, N);
size(totile);
fitter = repmat(x, 1, N);
fitter2 = repmat(totile, Nx, 1);
indx = fitter2 + fitter;
mask1 = indx < 1;
mask2 = indx > N;
both = mask1 | mask2;
indx(both) = 1;
y = y(indx);
y(both) = NaN;
x2 = x2/freq;
Sx2 = [];
Sx4 = [];
Sy = [];
Sx2y = [];
Sxy = [];
t = 1; 
for i = 1: N
    %disp (x2(:,t))
    Sx2 = [Sx2; sum(x2(:,t).^2)];
    Sx4 = [Sx4; sum(x2(:,t).^4)];
    Sy = [Sy; sum(y(:,t))];
    Sx2y = [Sx2y; sum(x2(:,t) .* x2(:,t) .* y(:,t))];
    Sxy = [Sxy; sum(x2(:,t) .* y(:,t))];
    t = t + 1;
end
V = Sxy ./ Sx2;
end

%A = (N .* Sx2y - Sx2 .* Sy) ./ ((N .* Sx4 - Sx2).^2);%accelleration not ok (yet)