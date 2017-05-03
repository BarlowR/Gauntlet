[p1, p2, clean, clwoin] = robustLineFit(r, theta);
polarplot(pi*clean(1)/180, clean(2), 'o')
figure
 xy = [clwoin(2, :).*cosd(clwoin(1, :)); clwoin(2, :).*sind(clwoin(1, :))]
 
 clwoin
 line([p1(1) p2(1)], [p1(2), p2(2)])
 hold on

 
 
 [p1, p2, clean, clwoin] = robustLineFit(clwoin(2, :),clwoin(1, :));
 xy = [clwoin(2, :).*cosd(clwoin(1, :)); clwoin(2, :).*sind(clwoin(1, :))]
 clwoin;
 line([p1(1) p2(1)], [p1(2), p2(2)])
 hold on
 
 [p1, p2, clean, clwoin] = robustLineFit(clwoin(2, :),clwoin(1, :));
 xy = [clwoin(2, :).*cosd(clwoin(1, :)); clwoin(2, :).*sind(clwoin(1, :))]
 clwoin;
 line([p1(1) p2(1)], [p1(2), p2(2)])
 hold on
 
 [p1, p2, clean, clwoin] = robustLineFit(clwoin(2, :),clwoin(1, :));
 xy = [clwoin(2, :).*cosd(clwoin(1, :)); clwoin(2, :).*sind(clwoin(1, :))]
 clwoin;
 line([p1(1) p2(1)], [p1(2), p2(2)])
 hold on
 
 [p1, p2, clean, clwoin] = robustLineFit(clwoin(2, :),clwoin(1, :));
 xy = [clwoin(2, :).*cosd(clwoin(1, :)); clwoin(2, :).*sind(clwoin(1, :))]
 clwoin;
 line([p1(1) p2(1)], [p1(2), p2(2)])
 hold on
 
 [p1, p2, clean, clwoin] = robustLineFit(clwoin(2, :),clwoin(1, :));
 xy = [clwoin(2, :).*cosd(clwoin(1, :)); clwoin(2, :).*sind(clwoin(1, :))]
 clwoin;
 line([p1(1) p2(1)], [p1(2), p2(2)])
 hold on
 
 [p1, p2, clean, clwoin] = robustLineFit(clwoin(2, :),clwoin(1, :));
 xy = [clwoin(2, :).*cosd(clwoin(1, :)); clwoin(2, :).*sind(clwoin(1, :))]
 clwoin;
 line([p1(1) p2(1)], [p1(2), p2(2)])
 hold on
 
 [p1, p2, clean, clwoin] = robustLineFit(clwoin(2, :),clwoin(1, :));
 xy = [clwoin(2, :).*cosd(clwoin(1, :)); clwoin(2, :).*sind(clwoin(1, :))]
 clwoin;
 line([p1(1) p2(1)], [p1(2), p2(2)])
 hold on
  
 
 [p1, p2, clean, clwoin] = robustLineFit(clwoin(2, :),clwoin(1, :));
 xy = [clwoin(2, :).*cosd(clwoin(1, :)); clwoin(2, :).*sind(clwoin(1, :))]
 clwoin;
 line([p1(1) p2(1)], [p1(2), p2(2)])
 hold on
 plot(xy(1, :), xy(2, :), 'o')  