function [ x, y ] = sn2xy( s, n, centerlinex, centerliney, varargin )
%sn2xy: Transform curvilinear orthogonal to cartesian coordinates
%usage: [x,y] = sn2xy(s,n,centerlineX,centerlineY)
%usage: [x,y] = sn2xy(s,n,centerlineX,centerlineY,discretisation)
%
%arguments:
%   s - a jx1 real numeric vector containing the s-coordinates of the
%       points to be transformed, as fractional distances along the
%       centerline. s has to be between 0 and 1
%   n - a jx1 real numeric vector containing the n-coordinates of the
%       points to be transformed, as normal distances from the
%       centerline
%   cx, cy - kx1 real numeric vectors containing the x and y coordinates of
%       the points describing the centerline
%   discretisation - integer specifying how many samples to use for
%       discretising the spline interpolation of the centerline.
%       Defaults to 10.
%       A value of 0 specifies the use of the full spline (very slow).
%
%Requires the distance2curve function by John D'Errico
%   http://www.mathworks.de/matlabcentral/fileexchange/34869-distance2curve
%
%Based on Merwade et al (2005) "Geospatial Representation of River Channels"
%   Journal of Hydrological Engineering, 10, 243-251
%
%
%Usage example:
% % Generate test data
% dataX = sin( (0:0.01:1)' *2*pi) + (rand(101,1) - 0.5) * 0.4;
% dataY = (0:0.02:2)' - 0.4*sin((0:0.01:1)' *4*pi)  + ...
%     (rand(101,1)-0.5) * 0.4;
% 
% hold off
% scatter(dataX, dataY);
% 
% % Provide centerline path
% centerlineX = sin( (0:0.05:1)' *2*pi);
% centerlineX = [-0.2; centerlineX; 0.2];
% 
% centerlineY = (0:0.1:2)' - 0.4 * sin( (0:0.05:1)'*4*pi);
% centerlineY = [0.1; centerlineY; 1.9];
% 
% hold all
% plot(centerlineX, centerlineY);
% hold off
% 
% % Transform to flow-oriented S-N coordinate system
% [S, N, L] = xy2sn(dataX, dataY, centerlineX, centerlineY);
% 
% % Plot points in S-N coordinate system
% scatter(S*L, N, [], S, 'f')
% axis equal
% 
% % Plot points in X-Y coordinate system, using S for colour
% scatter(dataX, dataY, [], S, 'f')
% axis equal
% 
% 
% %% Generate a grid in the S-N coordinate system and transform it to X-Y
% gridlinesS=repmat( (0:0.02:1), 5, 1);
% gridlinesN=repmat( (-0.2:0.1:0.2)',1,51);
% plot(gridlinesS*L,gridlinesN, 'k')
% axis equal
% hold all
% plot(gridlinesS'*L,gridlinesN', 'k')
% hold off
% 
% [gridlinesX, gridlinesY] = sn2xy(gridlinesS, gridlinesN, ...
%     centerlineX, centerlineY);
% 
% % Reshape resulting vector back to matrix structure
% gridlinesX = reshape(gridlinesX, size(gridlinesS));
% gridlinesY = reshape(gridlinesY, size(gridlinesS));
% 
% % Plot data and grid in XY and SN coordinates
% subplot(3,2,[1 3])
% plot(gridlinesX,gridlinesY, 'k')
% axis equal
% hold all
% plot(gridlinesX',gridlinesY', 'k')
% colormap('winter')
% scatter(dataX, dataY, [], S, 'f')
% hold off
% subplot(3,2,[5:6])
% plot(gridlinesS*L,gridlinesN, 'k')
% hold all; axis equal; plot(gridlinesS'*L,gridlinesN', 'k')
% scatter(S*L, N, [], S, 'f')

if nargin == 4
    splinesampling = 10;
elseif nargin == 5
    splinesampling = varargin{1};
end

if splinesampling > 0
    % Use a linear approximation of the spline interpolation
    nCenterline = length(centerlinex);
    t = 1:nCenterline;
    ts = 1:1/splinesampling:nCenterline;
    cx = spline(t,centerlinex,ts)';
    cy = spline(t,centerliney,ts)';

    [Pnew, Ttnew] = interparc(s, cx, cy, 'linear');
else
    % Use the full spline interpolation
    [Pnew, Ttnew] = interparc(s, centerlinex, centerliney, 'sp');% interparc: interpolate points along a curve in 2 or more dimensions
end
    
%%
% Calculate normal vectors on thalweg curve
Tnnew = [-Ttnew(:,2), Ttnew(:,1)];
Tnnew = bsxfun(@rdivide, Tnnew, sqrt(sum(Tnnew.^2,2)));

x = Pnew(:,1) + Tnnew(:,1).*n(:);
y = Pnew(:,2) + Tnnew(:,2).*n(:);

end

