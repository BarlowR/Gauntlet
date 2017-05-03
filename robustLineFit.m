function [point1 point2 cleandata, clwoin] = robustLineFit(r, theta)
n = length(r)*2;
threshold = 0.005;
theta_clean = [];
r_clean = [];
for i = 1:length(r)
    if (r(i) > 0.1 && r(i) < 4)
        theta_clean = [theta_clean,  theta(i)];
        r_clean = [r_clean, r(i)];
    end
end

theta = theta_clean;
r = r_clean;
cleandata = [theta; r];
inliernumber = 0;
clwoin = cleandata;

for i  = 1:n
    i;
    index1 = int16(rand * (size(theta, 2) -1)) +1;
    index2 = int16(rand * (size(theta, 2) -1)) +1;
    % add in 180 degree thing later
       
    p1 = [r(index1) * cosd(theta(index1)); r(index1) * sind(theta(index1))];
    p2 = [r(index2) * cosd(theta(index2)); r(index2) * sind(theta(index2))];
    
    xytemp = [r.*cosd(theta)-p1(1); r.*sind(theta)-p1(2)];
    
    
    hold on
       
    dist = p2 - p1;
    rotat = -atan2(dist(2), dist(1));
    %plot(dist(1), dist(2), 'xk')
    %plot(0, 0, 'xk')
    hold off
    xy = [cos(rotat), -sin(rotat); sin(rotat), cos(rotat)] * xytemp;
    
    %plot(xy(1, :), xy(2, :), 'o')
    
    inliers = [ ; ];
    minx = 0;
    maxx = 0;
    size(xy, 2);
    for j = 1: size(xy, 2)
        abs(xy(2, j));
        if (abs(xy(2, j)) < threshold)
            inliers = [inliers, xy(:, j)];
        end
    end
    length(inliers);
    if (length(inliers) > inliernumber)
        clwoin = cleandata;
        indexes = [];       
        for j = 1:length(inliers)
            if (inliers(1, j) < minx)
                minx = inliers(1, j);
            end
            if (inliers(1, j) > maxx)
                maxx = inliers(1, j);
            end
            for k = 1:length(clwoin) 
                if (inliers(1, j) == xy(1, k) && inliers(2, j) == xy(2, k))
                    indexes = [indexes, k];
                end
            end
        end
         
        for j = length(indexes):-1:1
            clwoin(:, indexes(j)) = [];
        end
            
        dist2 = p2 - p1;
        constmin = (minx)/sqrt((dist2(1)^2 +dist2(2)^2));
        constmax = (maxx)/sqrt((dist2(1)^2 +dist2(2)^2));
                
        point1 = dist2.*constmin + p1;
        point2 = dist2.*constmax + p1;
        
        inliernumber = length(inliers);
    end
   
    
end

