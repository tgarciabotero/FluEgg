function [out,x_der1,y_der1]=pcscurvature(X,Y,in2)
% PARAMETRIC CUBIC SPLINE INTERPOLATION AND ARC-LENGTH PARAMETERIZATION OF
% DIGITIZED DATA POINTS OF MEANDERING RIVERS - CURVATURE CALCULATION
%
%                           I-B Güneralp
%                           March 24, 2007
%                           Prolific Oven, Palo Alto, CA
%
% in1m;
% ins1m;               % reads the X and Y coodinates of the digitized points
% Smoothing with Savitzky-Golay steps 

ins1 = [X,Y];

% DOUBLE SMOOTHING OF THE INPUT CENTERLINE COORDS WITH SAVITZKY-GOLAY 
% disp(['The input centerline must now be smoothed to reduce noise.'])
% disp(['Choose the smoothing window (channel width is a good first guess).'])
% window_size = input('Enter the window size for smoothing (# of points along centerline): '); % specifies the # of points to be used in the smooting
% disp(['Enter the polynomial degree for'])
% poly_degree = input('smoothing (must be smaller than window size, between 3-5 works best): '); % specifies the polynomial degree used in the smooting

prompt={'Enter the window size for smoothing (# of points along centerline, must be odd): ','Enter the polynomial degree for'};
name='Cubic spline interpolation of centerline.';
numlines=1;
defaultanswer = {'5','3'};
ans1 = inputdlg(prompt,name,numlines,defaultanswer);
window_size = str2num(ans1{1});  poly_degree = str2num(ans1{2});
% window_size = 6;
% poly_degree = 3;

% Run centerline through double sgolay filter (curve fitting TB not req)
X = savitzkyGolayFilt(ins1(:,1),poly_degree,0,window_size); % Smooting of x -window size, polynomial degree
X = savitzkyGolayFilt(X,poly_degree,0,window_size); % Smooting of x -window size, polynomial degree
Y = savitzkyGolayFilt(ins1(:,2),poly_degree,0,window_size); % Smooting of y -window size, polynomial degree
Y = savitzkyGolayFilt(Y,poly_degree,0,window_size); % Smooting of y -window size, polynomial degreeX = smooth(ins1(:,1),window_size,'sgolay',poly_degree); % Smooting of x -window size, polynomial degree

% X = smooth(ins1(:,1),window_size,'sgolay',poly_degree); % Smooting of x -window size, polynomial degree
% X = smooth(X,window_size,'sgolay',poly_degree); % Smooting of x -window size, polynomial degree
% Y = smooth(ins1(:,2),window_size,'sgolay',poly_degree); % Smooting of y -window size, polynomial degree
% Y = smooth(Y,window_size,'sgolay',poly_degree); % Smooting of y -window size, polynomial degree
ins1 = [X, Y]; % Smoothed centerline coordinates


in1 = ins1;
rB1=reorient(ins1);  % moves the first data point to origin (0,0) 
                    % and recalculates the new coords of the rest
                    % of the data points accordingly

% does the piecewise cubic spline (pcs) interpolation:
[ xt, yt, tt ] = ParametricSpline(rB1(:,1),rB1(:,2));
[breaks_xt,coefs_xt,npolys_xt,ncoefs_xt,dim_xt]=unmkpp(xt);
[breaks_yt,coefs_yt,npolys_yt,ncoefs_yt,dim_yt]=unmkpp(yt);
coefs = [coefs_xt; coefs_yt];
npolys = size(coefs,1)/2; ncoefs = 4;
breaks = breaks_xt;
% [breaks,coefs,npolys,ncoefs,dim]=unmkpp(cscvn(rB1'));

% initializations
% in2 = input('Enter the arc-length, delta s: '); % specifies the arc-length (constant)        
spln_number = npolys;       % takes as input from pcs interpolation
splngt = 0;
cntr_t = 1;
ctotlngt = 0;
cintlngt = 0;               % initial value of the current arc-length (containing the remaining part from the previous spline + the increments on the current spline)
delta_t_default = 2;
delta_t = delta_t_default;  % initial cord-increment value to be used in the calculation of arc-lengths
cut_off = 1e-9;             % cut-off value for the arc-length determination
spln_no(cntr_t) = 0;
eq_t(cntr_t) = 0;
rem_intlngt = 0;            % initial value of the length of the remaining part of the previous spline
cintlngt = 0;

% rearrange the coefficient matrix as (ax bx cx dx, ay by cy dy)
coefs_pcs = [coefs(1:npolys,:) coefs(npolys+1:end,:)];
% for i=1:npolys
% 	coefs_pcs(i,:)=[coefs(2*i-1,:) coefs(2*i,:)];
% end;

% rearrange the break points matrix
breaks=breaks';

for counter1 = 1:spln_number    % for each spline returned by cscvnt at line 14
%     fprintf('Spline = %d\n', counter1);
    dax = coefs_pcs(counter1,1); dbx = coefs_pcs(counter1,2); dcx = coefs_pcs(counter1,3); ddx = coefs_pcs(counter1,4); % assigns the pcs' X function coefs
    day = coefs_pcs(counter1,5); dby = coefs_pcs(counter1,6); dcy = coefs_pcs(counter1,7); ddy = coefs_pcs(counter1,8); % assigns the pcs' Y function coefs
    F = @(q)sqrt((3*dax*q.^2+(2*dbx)*q+(dcx)).^2+(3*day*q.^2+(2*dby)*q+(dcy)).^2);%usesfirst derivative of X and Y
    splnend = breaks(counter1 + 1) - breaks(counter1); % calculates the cord-length of the current spline
    splngt = quad(F,0,splnend); % calculates the spline length for current spline. %Numerically calculates simpson's quadriture 
%     fprintf('Slength %f\n', splngt);
    nextspline = 1;     % resets to 1 
    leftover = splngt;  % initilizes the remaining portion to the whole length of the current spline
    while ((rem_intlngt + leftover) >= in2)     % while the length of the remaining portion of the current spline is equal or longer than the specified arc-length
%         fprintf('Leftover = %d\n', leftover);
        if (nextspline == 1)    % if this is a new spline
            cur_pnt = 0;        % shows the location on the cords (used in the arc-length calculation)
            cintlngt = 0;           % resets the current interval length to zero
            cintlngt = rem_intlngt + quad(F, cur_pnt, cur_pnt + delta_t); % the length of the remaining part of the privious spline + the length of the arc for delta t increment on the current spline
        else
            cur_pnt = eq_t(cntr_t); % assigns the length (location) of the current point to the sum of the cords + the increments on the current cord
            rem_intlngt = 0;        % resets the remaining length to 0 (in the current spline)
            cintlngt = 0;           % resets the current interval length to zero
            cintlngt = quad(F, cur_pnt, cur_pnt + delta_t); % calculates the current interval length for delta t
        end % for -if
        while (abs(cintlngt - in2) > cut_off)   % while the absolute value of the difference between cintlngt and the specified arc-length is larger than the cut-off
            while (cintlngt < in2)              % while cintlngt is smaller than the specified arc-length size
                
                cur_pnt = cur_pnt + delta_t;    % updates current point 
                cintlngt = cintlngt + quad(F, cur_pnt, cur_pnt + delta_t); % updates cintlngt
            end % for -inner while
            if (abs(cintlngt - in2) > cut_off)  % if the absolute value of the difference between cintlngt and the specified arc-length is larger than the cut-off
                cintlngt = cintlngt - quad(F, cur_pnt, cur_pnt + delta_t);  % takes back the most recent addition to cintlngt            
%                 cur_pnt = cur_pnt - delta_t;
                delta_t = delta_t / 10;                                     % updates delta t
                cintlngt = cintlngt + quad(F, cur_pnt, cur_pnt + delta_t);  % calculates the cintlngt using new delta t           
            end % for -if
        end % for -outer while
        
%         fprintf('currentinterval %f\n', cintlngt);
%         fprintf('equalt %f\n',cur_pnt + delta_t);
        cntr_t = cntr_t + 1;   
        spln_no(cntr_t) = counter1;         % keeps track of the spline numbers that correspond to the arc-lengths
        eq_t(cntr_t) = cur_pnt + delta_t;   % keeps track of the total cord-lengths that correspond to the coordinates of the coordinates of the arcs
        x (cntr_t)= dax * eq_t(cntr_t)^3 + dbx * eq_t(cntr_t)^2 + dcx * eq_t(cntr_t) +ddx;  % calculates the x coordinates on the arc-length parameterized composite curve
        y (cntr_t)= day * eq_t(cntr_t)^3 + dby * eq_t(cntr_t)^2 + dcy * eq_t(cntr_t) +ddy;  % calculates the y coordinates on the arc-length parameterized composite curve
        x_der1 (cntr_t)= 3* dax * eq_t(cntr_t)^2 + 2* dbx * eq_t(cntr_t) + dcx;             % calculates the first-order derivative of x
        y_der1 (cntr_t)= 3* day * eq_t(cntr_t)^2 + 2* dby * eq_t(cntr_t) + dcy;             % calculates the first-order derivative of y
        x_der2 (cntr_t)= 6* dax * eq_t(cntr_t) + 2* dbx;                                    % calculates the second-order derivative of x
        y_der2 (cntr_t)= 6* day * eq_t(cntr_t) + 2* dby;                                    % calculates the second-order derivative of y
        curv (cntr_t)= (((x_der1(cntr_t) * y_der2(cntr_t)) - (y_der1(cntr_t) * x_der2(cntr_t))) / (((x_der1(cntr_t))^2) + ((y_der1(cntr_t))^2))^1.5);   % calculates the parametric-curvature of (x,y)
        leftover = leftover - (cintlngt - rem_intlngt);     % the remaining length of the current arc
%         fprintf('Leftover = %f\n', leftover);
%         fprintf('cintlngt = %f\n', cintlngt);
%         fprintf('c eksi rem %f\n', cintlngt - rem_intlngt);
        rem_intlngt = 0;
        nextspline = 0;
        delta_t = delta_t_default;
    end
    rem_intlngt = rem_intlngt + abs(leftover);
%     fprintf('rem_intlngt = %f\n', rem_intlngt);
end % for -counter

    eq_t=eq_t';         % corresponding lengths on the cord-lengths for XY coordinates
    spln_no=spln_no';   % corresponding spline numbers of the XY coordinates
    
    x=x';               % X coordinates of the arc-length parameterized composite curve 
    y=y';               % Y coordinates of the arc-length parameterized composite curve
    x_der1=x_der1';     % 1st order derivatives of the X coordinates of the arc-length parameterized composite curve 
    y_der1=y_der1';     % 1st order derivatives of the Y coordinates of the arc-length parameterized composite curve 
    x_der2=x_der2';     % 2nd order derivatives of the X coordinates of the arc-length parameterized composite curve 
    y_der2=y_der2';     % 2nd order derivatives of the Y coordinates of the arc-length parameterized composite curve 
    curv=curv';         % curvatures of the arc-length parameterized composite curve 

    XY_coord= [x y];    % XY coordinates of arc-length parameterized composite curve
    XY_coord_org=[x+ins1(1,1) y+ins1(1,2)];
    
    for space=1:size(XY_coord,1),
        cikti(space,1) = XY_coord_org(space,1);
        cikti(space,2) = XY_coord_org(space,2);
        cikti(space,3) = curv(space,1);        
    end;
    
    Xplot=XY_coord_org(:,1);
    Yplot=XY_coord_org(:,2);
%     subplot(2,1,1), plot(in1(:,1),in1(:,2),'bo'), hold on, % plots the pcs-interpolated and arc-length parameterized smoothed XY coordinates obtained with arc-length interval given in _conf2  
%     subplot(2,1,1), plot(Xplot,Yplot,'.','MarkerSize',5), hold off; % plots the pcs-interpolated and arc-length parameterized smoothed XY coordinates obtained with arc-length interval given in _conf2  
%     subplot(2,1,2), plot(curv,'.','MarkerSize',5); % plots the curvature series of this planform
    
out=cikti;

end % function

function [xt,yt,tt] = ParametricSpline(x,y)
%ParametricSpline Generates ppform parametric splines
% Uses matlab's built-in spline function to generate parametric cubic
% splines that are are a f(x,y). This is an alternative to the Curve
% Fitting Toolbox's cscvn function. 
% 
% Taken from: http://www.physicsforums.com/showthread.php?t=468582

arc_length = 0;
n = length(x);
t = zeros(n, 1);
for i=2:n
    arc_length = sqrt((x(i)-x(i-1))^2 + (y(i)-y(i-1))^2);
    t(i) = t(i-1) + arc_length;
end
t=t./t(length(t));
xt = spline(t, x);
yt = spline(t, y);
tt = linspace(0,1,1000);
end


