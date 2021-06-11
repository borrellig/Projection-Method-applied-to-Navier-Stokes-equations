clear 
close all
clc

% the script generates a file each 500 iterations, containing columns
% describing x,y,u,v
it_min = 0;
it_max = 16000;

% The .dat file evaluates the elements at each one of the 50 steps
% in the y-direction. For each y-steps, 122 evaluations are carried out in
% the x-direction
Lx = 8;
Nx = 122;
x = linspace(0,Lx,Nx);
x = x';
dx = Lx/(Nx-1);

Ly = 1;
Ny = 50;
y = linspace(0,Ly,Ny);
y = y';
dy = Ly/(Ny-1);

for n = 0:500:it_max
    % routine to load the data acquired each 500 iterations
    if n<1000
        xx = ['ave00',num2str(n),'.dat'];
    elseif n < 10000 && n > 1000
        xx = ['ave0',num2str(n),'.dat'];
    elseif n < 100000 && n > 10000
        xx = ['ave',num2str(n),'.dat'];
    end
    
    A = readtable(xx);
    A1 = table2array(A);
    
    u = A1(:,3);
    v = A1(:,4);
    
    u = reshape(u,Nx,Ny-1);
    v = reshape(v,Nx,Ny-1);
    
    % now calculating the modulus of the velocity given from the 2 
    % components u and v
    for i = 1:Nx
        for j = 1:Ny 
            vel1(i,j) = sqrt(u(i,j)^2+v(i,j)^2);
        end
    end
    
    figure(1)
    % plotting the velocity fields at different time instants (1 second =
    % 100 iterations, being the time step = 0.01)
    if n == 4000
        subplot(4,1,2)
        surf(y,x,vel1)
        shading interp
        colormap jet
        %colorbar
        axis equal
        caxis('auto')
        view(90,270)
        title('t = 40 [seconds]')
    end
    
    % if n == 8000
    %     subplot(4,1,..)
    % more subplot may be added to include the velocity field
    % representation at different time intants
    
    % to introduce a common colorbar in the subplot
    hp4 = get(subplot(4,1,4),'Position');
    colorbar('Position', [hp4(1)+hp4(3)+0.01  hp4(2)  0.04  hp4(2)+hp4(3)*0.9])

    if n == 16000
        % to plot the directional field, in order to visualize the 
        % streamlines
        figure(2)
        axis([0,8,0,1])
        xlabel('X [m]')
        ylabel('Y [m]')
        hold on
        quiver(A1(:,1),A1(:,2),A1(:,3),A1(:,4),'k')
        title('Directional Field')
        
        % defining the vectors describing u and v components of the
        % fluctuations in order to compare them at a chosen spanwise 
        % station (being the total length = 8, and having 120 points in the
        % x-direction, 15 points = 1 meter)

        % X = 2 meters
        u_2 = u(30,:);
        v_2 = v(30,:);
        y_span = linspace(0,1,49);
        
        % X = 7 meters
        u_end = u(105,:);
        v_end = v(105,:);
        
        figure(3)
        
        subplot(2,2,1)
        ylabel('Y [m]')
        xlabel('u [m/s]')
        hold on
        plot(u_2,y_span)
        title('u component, station = 2.0m')
        grid on
        
        % subplot(2,2,..)
        % some more subplot may be added to represent evaluations at
        % different x-positions
    end
end
