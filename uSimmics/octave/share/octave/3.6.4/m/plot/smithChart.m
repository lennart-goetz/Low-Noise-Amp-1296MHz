%
% function h = smithChart(S, style, ...);
%
% Draws s-parameter 'S' into a Smith chart.
%
% Input Parameter:   same as plot() function
% Output Parameter:  (optional) handle of graph
%
% examples:
%    smithChart(S11)
%    smithChart(S22, 'r')
%    smithChart(S11, 'b', S22, 'r', "linewidth",3)
%
% Copyright (C) 2023: Michael Margraf, dd6um@darc.de
% This is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License (GPL v2).
% NO WARRANTY AT ALL!
%

function h = smithChart(varargin);

if nargin < 1
    error("Input parameter missing!");
end
if ischar(varargin{1})
    error("First input parameter must be numeric!");
end

rMAX = max(max(1, max(abs(varargin{1}))));  % unity circle or larger
if rMAX > 1
    rMAX = 1.05*rMAX;   % a little bit larger than necessary
end
rMAXq = rMAX*rMAX; 

nn = 50;  % points per circle
sm = 5;   % number of circles with Im(z)=const
linecolor = [0.8 0.8 0.8];

holdOff = ~ishold();

if holdOff   % draw new diagram?
    plot([-rMAX rMAX], [0 0], "color",linecolor);   % x axis
    hold on
    
    % draw arcs with Im(z)=const
    for m=1:sm
        r  = exp(j*pi*m/(sm+1));     % distribute arcs equally on |r|=1
        Im = imag((1+r)/(1-r)) / (rMAX^0.7);  % distribute arcs equally
        center  = 1 + j/Im;
        radius = 1 / abs(Im);
        
        if rMAX == 1       % Smith chart with |r|=1
            theta = 1.5*pi;
            beta  = angle(r - center);
        else               % Smith chart with |r|>1
            Re = (rMAXq+1)/(rMAXq-1);
            root = Re*Re - Im*Im-1;
            if root < 0   % circle completely within Smith chart?
                beta = 0;       % yes, ...
                theta = 2*pi;   % ... full circle
            else
                r = sqrt(root) - Re; % intersection with outer circle
                r = (r+j*Im - 1) / (r+j*Im + 1);
                beta = angle(r - center);    % start angle

                r = -sqrt(root) - Re; % intersection with outer circle
                r = (r+j*Im - 1) / (r+j*Im + 1);
                theta = angle(r - center);   % end angle
            end
        end
        
        if beta < 0
            beta = 2*pi + beta;   % adjust values 0...2*pi
        end
        if (theta<0) || (theta<beta)
            theta = 2*pi + theta;   % adjust values (less than 2*pi)
        end
        
        circle = center + radius*exp(j*linspace(beta,theta,nn));
        plot(circle, "color",linecolor);     %draw upper arcs
        
        circle = real(circle) - j*imag(circle);  % mirror the arcs about axis Im(r)=0
        plot(circle, "color",linecolor);     % draw lower arcs
    end

    % draw circles with Re(z)=const
    for m=1:sm
        r = m*(rMAX+1)/(sm+1) - rMAX;   % distribute circles equally
        z = real((1+r) / (1-r));
        radius = 1 / (z+1);
        center  = z * radius;
        circle = center + radius*exp(j*2*pi*(0:nn)/nn);
        if abs(abs(r)-1) > 0.1   % avoid ugly circles (too close to |r|=1)
            plot(circle, "color",linecolor);  % draw arcs on the left-hand side
        end
        
        if rMAX > 1  % Are there arcs on the right-hand side?
            r = center + 3*radius;
            Re = (1+r)/(1-r);
            Im = -Re*Re - 2*Re*(rMAXq+1)/(rMAXq-1) - 1;
            if Im <= 0     % circle completely within Smith chart?
                circle = 2 - circle;  % mirror the circle about r=1
            else
                r = (Re+j*sqrt(Im)-1) / (Re+j*sqrt(Im)+1);
                beta = angle(r - 2+center);    % start angle
                circle = 2-center + radius*exp(j*linspace(beta,2*pi-beta,nn));
            end
            plot(circle, "color",linecolor);   % draw circle
        end
    end

    theta = 0:2*pi/nn:2*pi;  % angles for a full circle
    circle = exp(j*theta);
    plot(circle, 'k');  % draw circle with |r|=1 in black
    if rMAX > 1
        plot(rMAX*circle, "color",linecolor);  % outer-most circle
        plot([1 1], sqrt(rMAXq-1)*[1 -1], "color",linecolor);  % verticle line at r=1
        text(-rMAX, -rMAX, sprintf("r = %0.3g", rMAX), "verticalalignment","bottom");
    end
end

hh = plot(varargin{:});  % plot data
if nargout > 0  % return handle?
    h = hh;
end

if holdOff
    axis equal  % aspect ratio 1:1
    axis off    % no axes
    hold off
end
