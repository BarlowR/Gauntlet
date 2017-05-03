

[px,py]=meshgrid(-0.2:0.1:3,-0.2:0.1:1.6);
[xlim,ylim] = size(px);
V = zeros(xlim, ylim);

for i=1:xlim
    for j=1:ylim
%this is the equation and integral with ranges for a specific object:  you
%should be able to figure out what this is and edit appropriately to get
%what you want
    
    V(i,j) = 1./sqrt((px(i, j)-.812).^2 + (py(i, j) - .812).^2);
    V(i,j) = V(i, j) + 1./sqrt((px(i, j)-1.9).^2 + (py(i, j) - .15).^2);
    V(i,j) = V(i, j) + 1./sqrt((px(i, j)-1.57).^2 + (py(i, j) - 1.39).^2);
    V(i,j) = V(i, j) - 30./sqrt((px(i, j)-2.75).^2 + (py(i, j) - 1.35).^2);
    end
end

hold off
contour(px,py,V)
[Ex,Ey] = gradient(V);
hold on
mag = sqrt(Ex.^2 + Ey.^2)
quiver(px,py,-Ex./mag,-Ey./mag)
robotpos = [0;0] %x;y
robotmove = [0;0] % r; theta
bob = [2.75; 1.35]
distan = 0.5
rate = 0.9

while mean(abs(robotpos-bob), 1) > 0.2
    [minval, ind] = min(dist([px(:) py(:)], robotpos));
    robposold = robotpos;
     mean(abs(robotpos-bob), 1)
    
    cart2pol(distan*(Ex(ind)/mag(ind)),  distan*(Ey(ind)/mag(ind)))
   
    
    robotpos = [robotpos(1) - distan*(Ex(ind)/mag(ind)); robotpos(2) - distan*(Ey(ind)/mag(ind))];
    plot([robposold(1), robotpos(1)], [robposold(2), robotpos(2)], 'k');
    distan = distan*rate;
end
   