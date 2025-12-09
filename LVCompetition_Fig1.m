% LVCompetition_Fig1 (fixed)

clear; close all;

% Time
tspan = [0 60000];

% Initial conditions: [S1_LHS, S2_LHS, S1_RHS, S2_RHS]
y0 = [100 100 100 100];

% Solve
[t,y] = ode45(@LVCompetition_07September2023, tspan, y0);

% Parameters only needed for plotting K lines
K1 = 200000;
K2 = 25000;

% Plot (4 states + 2 constant K lines)
figure
plot(t,y(:,1), t,y(:,2), t,y(:,3), t,y(:,4), ...
     t, K1*ones(size(t)), t, K2*ones(size(t)), 'LineWidth',2)
xlabel('Time'); ylabel('Biomass')
xlim([0 60000])
legend('Fast mover LHS','Slow mover LHS', ...
       'Fast mover RHS','Slow mover RHS', ...
       'Carrying capacity LHS','Carrying capacity RHS')
title('Lotka–Volterra Competition on Two Patches')
grid on


figure
plot(t,y(:,1) ,'r--' , 'LineWidth',3); hold on
plot(t,y(:,2) ,'b--' , 'LineWidth',3)
plot(t,y(:,3) ,'r-.',  'LineWidth',3)
plot(t,y(:,4) ,'b-.', 'LineWidth',3)
plot(t,200000*ones(size(t)) ,'c-' , 'LineWidth',2)   % K LHS
plot(t,25000*ones(size(t))  ,'m-', 'LineWidth',2)   % K RHS
hold off

grid off
axis([0 1e4 0 210000])   % only change to axis: shorten X to 1e4
xlabel('Time','FontSize',30)
ylabel('Abundance','FontSize',30)
legend('Fast mover LHS','Slow mover LHS','Fast mover RHS','Slow mover RHS', ...
       'Carrying capacity LHS','Carrying capacity RHS','FontSize',14)

% Make ticks and axes easier to read
set(gca,'FontSize',12,'LineWidth',1.5)

% ---------------- ODE system ----------------
function dydt = LVCompetition_07September2023(~,y)
    % Params
    r1 = 0.04;  r2 = 0.005;
    K1 = 200000; K2 = 25000;
    d  = 0.02;   D  = 0.08;

    % States
    y1 = y(1); y2 = y(2); y3 = y(3); y4 = y(4);

    % RHS
    rhs1 = (r1/K1)*y1*(K1 - y1 - y2) - D*(y1 - y3);  % S1, LHS
    rhs2 = (r1/K1)*y2*(K1 - y2 - y1) - d*(y2 - y4);  % S2, LHS
    rhs3 = (r2/K2)*y3*(K2 - y3 - y4) + D*(y1 - y3);  % S1, RHS
    rhs4 = (r2/K2)*y4*(K2 - y4 - y3) + d*(y2 - y4);  % S2, RHS

    dydt = [rhs1; rhs2; rhs3; rhs4];
end