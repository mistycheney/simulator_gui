function line = build_line(varargin)

if nargin == 0
    line = struct('polar',{},'cart',{},'e1',{},'e2',{},'Cl',{});
elseif nargin == 1
    line = struct('polar',[0;0],'cart',[0;0;0],'e1',[0;0],'e2',[0;0],'Cl',[0 0;0 0]);
elseif nargin == 2
    e1 =    varargin{1};
    e2 =    varargin{2};
    cart = line_endpoints2cart(e1,e2);
    polar = line_cart2polar(cart);
    line = struct('polar',polar,'cart',cart,'e1',e1,'e2',e2,'Cl',[0 0;0 0]);
elseif nargin == 4
    
end

end

% function line = build_line(polar, x)
%
% % cart = line_polar2cart(polar);
% % a = cart(1);
% % b = cart(2);
% % c = cart(3);
% %
% % x1 = x(:,1);
% % x2 = x(:,end);
% % line = struct('polar',polar,'cart',cart,'e1',[x1;(-c-a*x1)/b],'e2',[x2;(-c-a*x2)/b]);
%
%
% end