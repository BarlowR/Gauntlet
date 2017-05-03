function driveGauntlet()
f1 = figure;
f2 = figure;
theta = 0
clen = 5*pi/6
bob = [2.819; 1.4095]
movedist = 0;
angtrav = 0;
%rosinit('10.0.75.2',11311, 'NodeHost','10.0.75.1')
        
    unitConv = 3.281;
    d = .25 * unitConv;
    function setWheelV(vl,vr)
        msg = rosmessage(pub_vel);
        msg.Data = [vl vr];
        send(pub_vel,msg); 
    end
    function setOrientation()
        msg1 = rosmessage(pub_ori);
        msg1.Pose.Pose.Orientation.X = 0;
        msg1.Pose.Pose.Orientation.Y = 0;
        msg1.Pose.Pose.Orientation.Z = 0;
        msg1.Pose.Pose.Orientation.W = 1;
        send(pub_ori,msg1); 
    end

    
    pub_vel = rospublisher('/raw_vel');
    pub_ori = rospublisher('/odom');
    sub_scan = rossubscriber('/encoders');
    ang_sub = rossubscriber('/odom');
    global running
    running = 1;
    sub = rossubscriber('/stable_scan');
    % Collect data at the room origin 
    scan_message = receive(sub); 
    wheel = receive(sub_scan);
    encodeInit = wheel.Data
    dat = receive(ang_sub);
        
             X1 = dat.Pose.Pose.Orientation.X;
             Y1 = dat.Pose.Pose.Orientation.Y;
             Z1 = dat.Pose.Pose.Orientation.Z;
             W1 = dat.Pose.Pose.Orientation.W;

            quat = [X1 Y1 Z1 W1];
            ang3D = quat2eul(quat);
            anginit = ang3D(3);
            
    r_1 = scan_message.Ranges(1:end-1); 
    theta_1 = [0:359]';  
    
    wheelsub = receive(sub_scan);
    wheeldata = wheelsub.Data;

    initialEncoder = wheeldata;
    
    
    wheelbase = 0.24*1.07;
    % Define the gradient vector
    BOB = [2; 2];
    lambda = 1/16;
    % Define the step-size multiplier
    delta = 1.2;
    time = 0;
    stop = 30;
    
    

    [px,py]=meshgrid(-0.2:0.1:3,-0.2:0.1:1.6);
    [xlim,ylim] = size(px);
    V = zeros(xlim, ylim);

    for i=1:xlim
        for j=1:ylim
    %this is the equation and integral with ranges for a specific object:  you
    %should be able to figure out what this is and edit appropriately to get
    %what you want

        V(i,j) = 1./sqrt((px(i, j)-.812).^2 + (py(i, j) - .812).^2);
        V(i,j) = V(i, j) + 4./sqrt((px(i, j)-1.9).^2 + (py(i, j) - .15).^2);
        V(i,j) = V(i, j) + 2./sqrt((px(i, j)-1.57).^2 + (py(i, j) - 1.39).^2);
        V(i,j) = V(i, j) - 40./sqrt((px(i, j)-2.75).^2 + (py(i, j) - 1.55).^2);
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
    distan = 0.3
    rate = 0.9

    setOrientation()
    while mean(abs(robotpos-bob), 1) > 0.15
        dat = receive(ang_sub);
        wheel = receive(sub_scan);
        traveled = wheel.Data - encodeInit; 
        disttrav = (traveled(1) + traveled(2))/2
        
         X1 = dat.Pose.Pose.Orientation.X;
         Y1 = dat.Pose.Pose.Orientation.Y;
         Z1 = dat.Pose.Pose.Orientation.Z;
         W1 = dat.Pose.Pose.Orientation.W;
        
        quat = [X1 Y1 Z1 W1];
        ang3D = quat2eul(quat);
        ang = ang3D(3) - anginit;
        
        
        [minval, ind] = min(dist([px(:) py(:)], robotpos));
        robposold = robotpos;
        
        [theta, rho] = cart2pol(distan*(Ex(ind)/mag(ind)),  distan*(Ey(ind)/mag(ind)));

        while abs(angdiff(theta, angtrav)) > 0.01
            wheel = receive(sub_scan);
            traveled = wheel.Data - encodeInit; 
            angtrav = mod((traveled(2) - traveled(1))/wheelbase + pi, 2*pi) - pi
%             dat = receive(ang_sub);
%         
%              X1 = dat.Pose.Pose.Orientation.X;
%              Y1 = dat.Pose.Pose.Orientation.Y;
%              Z1 = dat.Pose.Pose.Orientation.Z;
%              W1 = dat.Pose.Pose.Orientation.W;
% 
%             quat = [X1 Y1 Z1 W1];
%             ang3D = quat2eul(quat);
%             ang = ang3D(3);
            angdiff(theta, angtrav);
            
            if (angdiff(theta, angtrav) < 0)
                setWheelV(-abs(angdiff(theta, angtrav))/10, abs(angdiff(theta, angtrav))/10)
            else
                setWheelV(abs(angdiff(theta, angtrav))/10, -abs(angdiff(theta, angtrav))/10)
            end
            
        end
        setWheelV(0, 0)
        movedist = movedist + distan
        while (disttrav < movedist)
            wheel = receive(sub_scan);
            traveled = wheel.Data - encodeInit; 
            disttrav = (traveled(1) + traveled(2))/2
            setWheelV(0.1, 0.1)
        end
        

        robotpos = [robotpos(1) - distan*(Ex(ind)/mag(ind)); robotpos(2) - distan*(Ey(ind)/mag(ind))];
        plot([robposold(1), robotpos(1)], [robposold(2), robotpos(2)], 'k');
        distan = distan*rate;
    end
   
            
    setWheelV(0,0)
end

