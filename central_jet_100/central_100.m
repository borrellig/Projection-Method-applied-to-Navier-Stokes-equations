clear 
close all
clc

% the script generates a file each 500 iterations, containing columns
% describing x,y,u,v

it_min = 0;
it_max = 16000;

% The .dat file evaluates the elements at each one of the 50 steps
% in the y-direction. for each y-steps, 122 evaluations are carried out in
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

Re = 100;

%% t = 0; initial condition

A = readtable('ave00000.dat');
A1 = table2array(A);

u = A1(:,3);
v = A1(:,4);

u = reshape(u,Nx,Ny);
v = reshape(v,Nx,Ny);
for i = 1:Nx
    for j = 1:Ny % due to problem (1)
        vel(i,j) = sqrt(u(i,j)^2+v(i,j)^2);
    end
end

figure(1)
subplot(4,1,1)
colorbar
surf(y,x,vel)
shading interp
colormap jet
axis equal
caxis('auto')
view(90,270)
title('t = 0 [seconds]')
    

%% t > 0
% (1) don't know why at time >0, when loading the table, the last 122 values
% are not loaded.. (1)
y = y(1:end-1); % due to problem (1)
it = 1;
for n = 500:500:it_max
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
    
    % now calculating the modulus of the velocity given from the 2 components
    % u and v
    
    for i = 1:Nx
        for j = 1:Ny-1 % due to problem (1)
            vel1(i,j) = sqrt(u(i,j)^2+v(i,j)^2);
        end
    end
    
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
        % change the time when changing the value of n which is plotted
    end

    if n == 8000
        subplot(4,1,3)
        surf(y,x,vel1)
        shading interp
        colormap jet
        %colorbar
        axis equal
        caxis('auto')
        view(90,270)
        title('t = 80 [seconds]')
        % change the time when changing the value of n which is plotted
    end
    
    if n == 16000
        subplot(4,1,4)
        surf(y,x,vel1)
        shading interp
        colormap jet
        %colorbar
        axis equal
        caxis('auto')
        view(90,270)
        title('t = 160 [seconds]')
        % change the time when changing the value of n which is plotted
    end
    
    hp4 = get(subplot(4,1,4),'Position');
    colorbar('Position', [hp4(1)+hp4(3)+0.01  hp4(2)  0.04  hp4(2)+hp4(3)*0.9])
%     it = it+1;
%     figure(it)
%     surf(y,x,vel1)
%     shading interp
%     colormap jet
%     colorbar
%     axis equal
%     caxis('auto')
%     view(90,270)

    if n == 16000
        
        % to plot the directional field in order to visualize the streamlines
        figure(2)
        axis([0,8,0,1])
        xlabel('X [m]')
        ylabel('Y [m]')
        hold on
        quiver(A1(:,1),A1(:,2),A1(:,3),A1(:,4),'k')
        title('Directional Field')
        
        % defining the vectors describing u and v components of the
        % fluctuations in order to compare them at a chosen spanwise station
        
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
        
        subplot(2,2,2)
        ylabel('Y [m]')
        xlabel('v [m/s]')
        hold on
        plot(v_2,y_span,'r')
        title('v component, station = 2.0m')
        grid on
        
        subplot(2,2,3)
        ylabel('Y [m]')
        xlabel('u [m/s]')
        hold on
        plot(u_end,y_span)
        title('u component, station = 7.0m')
        grid on
        subplot(2,2,4)
        ylabel('Y [m]')
        xlabel('v [m/s]')
        hold on
        plot(v_end,y_span,'r')
        title('v component, station = 7.0m')
        grid on 
    end

end
