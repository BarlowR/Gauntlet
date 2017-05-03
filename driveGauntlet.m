function driveGauntlet()
f1 = figure;
f2 = figure;
theta = 0
clen = 5*pi/6
bob = [2.819; 1.4095]
%rosinit('10.0.75.2',11311, 'NodeHost','10.0.75.1')
        
    unitConv = 3.281;
    d = .25 * unitConv;
    function setWheelV(vl,vr)
        msg = rosmessage(pub_vel);
        msg.Data = [vl vr];
        send(pub_vel,msg); 
    end
    
    pub_vel = rospublisher('/raw_vel');
    sub_scan = rossubscriber('/encoders');
    ang_sub = rossubscriber('/odom');
    global running
    running = 1;
    sub = rossubscriber('/stable_scan');
    % Collect data at the room origin 
    scan_message = receive(sub); 
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
    
    V = zeros(2, 2);
    [px,py]=meshgrid(-0.1:0.1:0.1,-0.1:0.1:0.1);
    while true
        
            scan_message = receive(sub); 
            r_1 = scan_message.Ranges(1:end-1);

            theta_clean = [];
            r_clean = [];
            for i = 1:length(r_1)
                if (r_1(i) > 0.01 && r_1(i) < 5)
                    theta_clean = [theta_clean,  theta_1(i)];
                    r_clean = [r_clean, r_1(i)];
                end
            end

            r = [r_clean.* cosd(theta_clean); r_clean.*sind(theta_clean)];

            for i = 1:size(px,1)
                for j = 1:size(px,2)
                    x_val = px(i,j);
                    y_val = py(i,j);
                    weight = 0;
                    for k = 1:length(r)

                        if (~(sqrt((x_val-r(1, k)).^2 + (y_val - r(2,k)).^2) < .1))                             
                            weight = weight + 1./sqrt(4*(x_val-r(1, k)).^2 + (y_val - r(2,k)).^2);
                        end

                    end
                    weight = weight - 100./sqrt((x_val - bob(1)).^2 + (y_val - bob(2)).^2);

                    V(i, j) = weight;
                end
            end

            [Gx, Gy] = gradient(V);

                
            bob(1)
            bob(2)



            [theta,rho] = cart2pol(Gx(2, 2),Gy(2, 2));
            rotation = [cos(theta), -sin(theta); sin(theta), cos(theta)];
            figure(f1)
            quiver(px,py,-Gx,-Gy);
            axis([-2, 2, -2, 2])
            hold on

            contour(px, py, V);
            plot(r(1, :), r(2, :), 'ob')
            

            drawnow
            

            
            v = .05;

            
            
            if (theta < clen && theta >0)
                    ((2*pi-theta) * wheelbase)/(4*v)
                    vr = -v;
                    vl = -vr;
                    setWheelV(vl, vr)
                    pause(((2*pi-theta) * wheelbase)/(4*v))
                    bob = -rotation*bob
            end
            if (theta < 0 && theta > -clen)
                %turn right
                vr = v;
                vl = -vr;
                setWheelV(vl, vr)
                pause(abs(((-2*pi-theta)  * wheelbase)/(4*v)))
                    bob = -rotation*bob
            end
            setWheelV(0, 0)
            
            setWheelV(0.1, 0.1)
            pause(1)
            
            bob = [bob(1)- 0.1; bob(2)]

            theta - clen;
            figure(f1)
            plot([0 bob(1)], [0 bob(2)], '*k')
            
            hold off



    %         setWheelV(-moveAng/20, moveAng/20)
    %        
        end
            

end

