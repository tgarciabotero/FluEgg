function y=reorient(b);
%   Recalculates the coordinates by moving the first coordinates
%   (i.e. {b(1,1),b(1,2)}) to the origin {0,0}
%
%                           ?nci-Burak Güneralp
%                           March 24, 2007
%                           Prolific Oven, Palo Alto, CA

H=b;                    % reassign the input matrix b to local variable H
dummy(1,1)=H(1,1);      % create dummy matrix populated with
dummy(1,2)=H(1,2);      % first coordinates of H
for r=1:size(H,1),      % for all rows of H
    for c=1:size(H,2),  % for all columns of H
        H(r,c)=H(r,c)-dummy(1,c);   % subtract the first coordinates from all
    end                 % end for-c
end                 % end for-r

y=H;
end