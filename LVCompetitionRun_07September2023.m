% LVCompetitionRun_07September2023
 
% This runs the LV competition of two species on two patches
 
clear all
close all




% This specifies that the simulation runs from timw t = 0 to 1000
tspan = [0,5000];


% This sets the initial values of four variables.
% Initial value of Species 1 on Patch 1 is 10000
% Initial value of Species 2 on Patch 1 is 20
% Initial value of Species 1 on Patch 2 is 1000
% Initial value of Species 2 on Patch 2 is 20
yo = [100.,100.,100,100.];


% This calls the Runge-Kutta differential equation solver.
% It call the function 'LVCompetition_07September2023', which has the
% equations
[t,y] = ode45('LVCompetition_07September2023',tspan,yo);


% This produces a plot
size(t);
size(y);
figure
plot(t,y)
xlabel ('time')
ylabel ('Competitors')
legend('y1','y2','y3','y4')


figure
plot (t,y(:,1))
grid off
axis ([0 1000 0 500])
ylabel ('N1')
xlabel ('t')

figure
plot (t,y(:,2))
grid off
axis ([0 1000 0 500])
ylabel ('N2')
xlabel ('t')

% figure
% plot (t,y(:,1),t,y(:,3))
% grid off
% axis ([0 500 0 500])
% ylabel ('N2')
% xlabel ('N1')

figure
plot (t,y(:,2),t,y(:,4),'LineWidth',2)
grid off
axis ([0 5000 0 25000])
xlabel ('Time'), ylabel('Slow mover biomass')
legend('Left side','Right side')

figure
plot (t,y(:,1),t,y(:,3),'LineWidth',2)
grid off
axis ([0 5000 0 10000])
xlabel ('Time'), ylabel('Fast mover biomass')
legend('Left side','Right side')

% 
% 
% figure
% plot(t,y(2),t,y(4)),xlabel('Time'),ylabel('y2,y4')
% legend('y2','y4')
% 
% figure
% plot(t,y(1),t,y(3)),xlabel('Time'),ylabel('y1,y3')
% legend('y1','y3')




 
 
