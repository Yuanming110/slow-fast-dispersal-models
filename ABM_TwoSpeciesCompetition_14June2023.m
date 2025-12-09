
% ABM_TwoSpeciesCompetition_14June2023

% Spatially Explicit ABM for two-species competition in heterogeneous emvironemt
% 30 January 2023

% Updated 05 June 2023

% There can be biased movement to right, away from high quality habitat, due to toxin. See line 75 to make bias = 0.25 per time step.
% But currently there is no biased movement, only purely random movement.

% Two competitors, 1 and 2 on two patches, left and right moving randomly with different step
% sizes. The competitors are identical otherwise. 

% Competitor 1 has locations x1(i) and y1(i) where i is the ith competitor
% 1
% Competitor 2 has locations x2(i) and y2(i) where i is the ith competitor
% 2

% The two patches are as follows;

% 1. The area for negative values of x is the highly productive patch, where both competitors have higher birther rates.

% 2. The area of positive values of x is the less productive patch, where both competitors have lower growth rates. 



clear all
close all

% rand('state',6); %05August2022
% rand('state',7); %05August2022
% rand('state',8); %05August2022
rand('state',15); %05August2022



n1 = 20 % Initial number of species 1, fast random mover
n2 = 800 % initial number of species 2, slow random mover
hequil = 0;

pi = 3.1415926

boundary = 25  % Organisms are bounded by 25 units on both left and right. The center is zero
boundary = 24;

carrcapleft = 22000  % Carrying capacity on the left-hand side
carrcapright = 4000 % Carrying capacity on the right-hand side

% carrcapleft = 2200  % Carrying capacity on the left-hand side
% carrcapright = 400 % Carrying capacity on the right-hand side


growthrateleft = 0.08 % Growth rate on the left-hand side
growthrateright = 0.01 % Growth rate on the right-hand side

growthrateleft = 0.16 % Growth rate on the left-hand side
growthrateright = 0.02 % Growth rate on the right-hand side

growthrateleft = 0.04 % Growth rate on the left-hand side
growthrateright = 0.005 % Growth rate on the right-hand side


% growthrateleft = 0.03 % Growth rate on the left-hand side
% growthrateright = 0.01 % Growth rate on the right-hand side

% growthrateleft = 0.04 % Growth rate on the left-hand side
% growthrateright = 0.005 % Growth rate on the right-hand side
% 
% growthrateleft = 0.02 % Growth rate on the left-hand side
% growthrateright = 0.0025 % Growth rate on the right-hand side
% 
% growthrateleft = 0.01 % Growth rate on the left-hand side
% growthrateright = 0.00125 % Growth rate on the right-hand side

% growthrateleft = 0.005 % Growth rate on the left-hand side
% growthrateright = 0.000625 % Growth rate on the right-hand side

% growthrateleft = 0.0025 % Growth rate on the left-hand side
% growthrateright = 0.0003125 % Growth rate on the right-hand side

% growthrateleft = 0.00125 % Growth rate on the left-hand side
% growthrateright = 0.00015625 % Growth rate on the right-hand side


% Assign initial conditions of the two competitors in space between x = -25
% and x = +25, and between y = 0 and y = 100
for i=1:n1
    x1(i) = boundary -2*boundary*rand;
    alive1(i) = 1;
end
for i=1:n1
    y1(i) = 100*rand;
end

for i=1:n2
    x2(i) = boundary -2*boundary*rand;
    alive2(i) = 1;
end
for i=1:n2
   y2(i) = 100*rand;
end

totalleft = 0;   % Total initial individuals in left-hand side
totalright = 0;  % Total initial individuals in right-hand side

% Print initial spatial distributions of fast and slow diffusers
figure
hold on
plot([hequil hequil],[0 100])
scatter(x1,y1,'o','r');
title('n1, fast diffuser, initial condition')
figure
hold on
plot([hequil hequil],[0 100])
scatter(x2,y2,'.','b');
title('n2, slow diffuser, initial condition')



bias = 0.0  % This means there is no biased direction of movement. Movement is purely random, so the slow mover should exclude the fast mover


ntime = 1000 % Number of time steps of movement
ntime = 10000
ntime = 50000


meantotal = 0;

n1right = 0;
n1left = 0;
n2left = 0;
n2right = 0;

%  Iteration over time
for itime =1:ntime

     
if itime > 1

for iii=1:n1
    x1(iii) = x1new(iii);
    y1(iii) = y1new(iii);
    alive1(iii) = alive1new(iii);
end

for iii=1:n2
    x2(iii) = x2new(iii);
    y2(iii) = y2new(iii);
    alive2(iii) = alive2new(iii);
end
end


n1before(itime) = n1;
n2before(itime) = n2;


% Iteration over individuals of type 1. fast diffusers

newbirths1 = 0;

for i=1:n1  % Iteration over individuals of type 1, fast mover

% This moves the individuals randomly along the x-axis each time step    
% Movement in term of units 8*rand left or right each time

if rand < 0.08
delt = 1.0;
if rand < 0.5
delt = -1.0;
end
x1(i) = x1(i) + 24*rand*delt;
% x1(i) = x1(i) + bias;
if x1(i) < -boundary 
    %x1(i) = -boundary*rand;  % Keeps individual from going to less than -25. It is reassigned randomly between -25 and 0.
    x1(i) = -boundary*rand + 2;  % Keeps individual from going to less than -25. It is reassigned randomly between -25 and 0.
end
if x1(i) > boundary
    %x1(i) = boundary*rand; % Keeps individual from going to greater than 25. It is reassigned randomly between 25 and 0.
    x1(i) = boundary*rand - 2; % Keeps individual from going to greater than 25. It is reassigned randomly between 25 and 0.
end
end

% Mortality is density dependent
if x1(i) < 0.0;
if rand < growthrateleft*((n1left+n2left)/carrcapleft) % Mortality of individuals can occur
   alive1(i) = 0;
end
end
if x1(i) > 0;
if rand < growthrateright*((n1right+n2right)/carrcapright)  % Mortality of individuals can occur
  alive1(i) = 0;
end
end

% Births. The number of births differs on the left- and right-hand sides
birththreshold = 0; % Births can occur through division (x>0 territory)
if alive1(i) > 0
if x1(i) <= 0;  % && growthrateleft*(totalleft/carrcapleft) > rand
    birththreshold = growthrateleft; % Births can occur at higher rate through division (x<0 territory)
end
if x1(i) > 0;  % 0 && growthrateright*(totalright/carrcapright) > rand
    birththreshold = growthrateright; % Births can occur at higher rate through division (x<0 territory)
end
if rand < birththreshold
    newbirths1 = newbirths1 + 1;
    newbirthplace1(newbirths1)= x1(i); % Newborne will be at same location as parent
end
end


end % End of iteration over individuals of type 1 %%%%%%%%%%%%%%%%%%%%%%%%%5555
newbirthsn1(itime) = newbirths1;



% Iteration over individuals of type 2. slow diffusers

newbirths2 = 0;

for i=1:n2 % Iteration over all species 2 individuals 

% This moves the individuals randomly along the x-axis each time step
% Movement is in terms of 1 left or right each time

if rand < 0.08
delt = 1.0;
if rand < 0.5
delt = -1.0;
end
x2(i) = x2(i) + 6*rand*delt ;
% x2(i) = x2(i) + bias;
if x2(i) < -boundary
   %x2(i) = -boundary*rand; % Keeps individual from going to less than -25. It is reassigned randomly between -25 and 0.
   x2(i) = -boundary*rand + 2; % Keeps individual from going to less than -25. It is reassigned randomly between -25 and 0.
end
if x2(i) > boundary
   %x2(i) = boundary*rand; % Keeps individual from going to greater than +25. It is reassigned randomly between 25 and 0.
   x2(i) = boundary*rand - 2; % Keeps individual from going to greater than +25. It is reassigned randomly between 25 and 0.
end
end

% Mortality is density dependent
if x2(i) < 0;
if rand < growthrateleft*(totalleft/carrcapleft);  % Mortality of individuals can occur
    alive2(i) = 0;  % This sets an individual to being dead in left-hand side
end
end
if x2(i) > 0;
if rand < growthrateright*(totalright/carrcapright) ; % Mortality of individuals can occur
    alive2(i) = 0;  % This sets an individual to being dead in right-hand side
end
end


% Births. The number of births differs on the left- and right-hand sides
birththreshold = 0;
if alive2(i) > 0;
if x2(i) <= 0;% && growthrateleft*(totalleft/carrcapleft) > rand
    birththreshold = growthrateleft; % Births can occur at higher rate through division (x<0 territory)
end
if x2(i) > 0;% && growthrateright*(totalright/carrcapright) > rand
    birththreshold = growthrateright; % Births can occur at higher rate through division (x<0 territory)
end
if rand < birththreshold
    newbirths2 = newbirths2 + 1;
    newbirthplace2(newbirths2) = x2(i);  % Newborne will be at same location as parent
end
end



end % End of iteration over individuals of type 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%5
newbirthsn2(itime) = newbirths2;


% end % End of iteration over individuals



% Print out plots of spatial distributions at time step 1.

if itime == 1
figure
hold on
plot([hequil hequil],[0 50])
scatter(x1,y1,'o','r');
title(['Fast diffuser on the ',num2str(itime),'th day']);
figure
hold on
plot([hequil hequil],[0 50])
scatter(x2,y2,'.','b');
title(['Slow diffuser on the ',num2str(itime),'th day']);
end


% Print out spatial distributions at periodic times

% if itime < 100
% re=rem(itime,10);
% if re==0
% figure
% scatter(x1,y1,'o','r');
% title(['n1, fast diffuser on the ',num2str(itime),'th day']);
% figure
% scatter(x2,y2,'.','b');
% title(['n2, slow diffuser on the ',num2str(itime),'th day']);
% end   
% end

% re=rem(itime,2000);
% if re==0
% figure
% scatter(x1,y1,'o','r');
% title(['n1, fast diffuser on the ',num2str(itime),'th day']);
% figure
% scatter(x2,y2,'.','b');
% title(['n2, slow diffuser on the ',num2str(itime),'th day']);
% end


% Calculate the numbers of species 1 and 2 in right and left patches
n1left = 0;
n1right = 0;
for ii=1:n1
%     if alive1(ii) > 0
        if x1(ii) <= 0;
            n1left = n1left + 1;
%         end
    end
end
for ii=1:n1
%     if alive1(ii) > 0
        if x1(ii) > 0;
            n1right = n1right + 1;
%         end
    end
end
n2left = 0;
n2right = 0;
for ii=1:n2
%     if alive2(ii) > 0
        if x2(ii) <= 0;
            n2left = n2left + 1;
        end
%     end
end
for ii=1:n2
%     if alive2(ii) > 0
        if x2(ii) > 0;
            n2right = n2right + 1;
        end
%     end
end

totalleft = n1left + n2left;
totalright = n1right + n2right;

n1leftsave(itime) = n1left;
n1rightsave(itime) =  n1right;
n2leftsave(itime) = n2left;
n2rightsave(itime) =  n2right;
totalleftsave(itime) = totalleft;
totalrightsave(itime) = totalright;


re=rem(itime,10);
if re==0
 n1l = n1left
 n12 = n1right
end


for ii=1:n1
    x1new(ii) = 0;
    y1new(ii) = 0;
end
for ii=1:n2
    x2new(ii) = 0;
    y2new(ii) = 0;
end



% Redistribute type 1 (fast diffuser) following deaths and births
% Individuals that were alive at the last time are distributed randomy
% across the whole x-axis, and randomly along the y-axis
% (vertical)
inew1 = 0;
for ii = 1:n1
if alive1(ii) > 0
    inew1 = inew1 + 1;
    x1new(inew1) = x1(ii);
    y1new(inew1) = 100*rand;
    alive1new(inew1) = 1;
end
end
% New-born individuals are distributed to same position as parentt; 
% and randomly on the y-axis
for i = 1:newbirths1
    ii = i + inew1;
    newbirth1 = newbirthplace1(i);
    x1new(ii) = newbirth1 + 0.5*(0.5-rand) ;
    y1new(ii) = rand*100;
    alive1new(ii) = 1;
end
sum1 = sum(x1new);
n1 = ii;



% Redistribute type 2 (slow diffuser) following deaths and birdts
% Individuals that were alive at the last time are placed back to exactly 
% their locatoin on the x-axis, but randomly oo the y-axis.
inew2 = 0;
for ii = 1:n2
if alive2(ii) > 0
    inew2 = inew2 + 1;
    x2new(inew2) = x2(ii);
    y2new(inew2) = 100*rand;
    alive2new(inew2) = 1;
end
end
% New-born individuals are distributed randomly on the high quality part
% of the plot; that is, the neagtive x-axis, and randomly on the y-axis
for i = 1:newbirths2
    ii = i + inew2;
    newbirth2 = newbirthplace2(i);
    x2new(ii) = newbirth2 + 0.5*(0.5-rand);
    y2new(ii) = rand*100;
    alive2new(ii) = 1;
end
sum2 = sum(x2new);
n2 = ii;




% Calculate the numbers of species 1 and 2 in right and left patches
n1left = 0;
n1right = 0;
for ii=1:n1
     if alive1new(ii) > 0
        if x1new(ii) <= 0;
            n1left = n1left + 1;
         end
    end
end
for ii=1:n1
     if alive1new(ii) > 0
        if x1new(ii) > 0;
            n1right = n1right + 1;
         end
    end
end
n2left = 0;
n2right = 0;
for ii=1:n2
     if alive2new(ii) > 0
        if x2new(ii) <= 0;
            n2left = n2left + 1;
        end
     end
end
for ii=1:n2
     if alive2new(ii) > 0
        if x2new(ii) > 0;
            n2right = n2right + 1;
        end
     end
end

totalleft = n1left + n2left;
totalright = n1right + n2right;

n1leftsave(itime) = n1left;
n1rightsave(itime) =  n1right;
n2leftsave(itime) = n2left;
n2rightsave(itime) =  n2right;
totalleftsave(itime) = totalleft;
totalrightsave(itime) = totalright;





n1save(itime) = n1left + n1right;
n2save(itime) = n2left + n2right;
itimesave(itime) = itime;
n1difference(itime) = n1save(itime) - n1before(itime);

carrcaprightsave(itime) = carrcapright;
carrcapleftsave(itime) = carrcapleft;
Totalcarrcapsave(itime) = carrcapright + carrcapleft;

itime

if itime > 5000
    meantotal = meantotal + (carrcapright + carrcapleft)/10000;
end

re=rem(itime,5000);
if re==0
figure
hold on
plot([hequil hequil],[0 100])
scatter(x1new,y1new,'.','r');
title(['Later n1, fast diffuser on the ',num2str(itime),'th day']);
figure
hold on
plot([hequil hequil],[0 100])
scatter(x2new,y2new,'.','b');
title(['Later n2, slow diffuser on the ',num2str(itime),'th day']);
end



end   % End of interation over time %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

% Plot out distributions of the populations

for i=1:boundary
    n2xdelt(i) = 0;
end

for i=1:n2
    for j=1:boundary
        loc1 = -boundary + (j-1)*2;
        loc2 = -boundary + 2 + (j-1)*2;
        locsave(j) = loc1 + 1;
        if x2new(i) >= loc1 && x2new(i)< loc2
        n2xdelt(j) = n2xdelt(j) + 1;
        end
    end
end

figure
hold on
plot(locsave,n2xdelt,'LineWidth',2)
plot([hequil hequil],[0 2500]), xlabel('Location'),ylabel('Slow diffusers')
%legend('n1, fast diffuser left side (x<0)','n1, fast diffuser right side (x>0)')
title('Slow diffusers versus location')

for i=1:boundary
    n1xdelt(i) = 0;
end

for i=1:n1
    for j=1:boundary
        loc1 = -boundary + (j-1)*2;
        loc2 = -boundary +2 + (j-1)*2;
        locsave1(j) = loc1 + 1;
        if x1new(i) >= loc1 && x1new(i)< loc2
        n1xdelt(j) = n1xdelt(j) + 1;
        end
    end
end

figure
hold on
plot([hequil hequil],[0 100])
plot(locsave1,n1xdelt), xlabel('Location'),ylabel('Slow diffusers')
%legend('n1, fast diffuser left side (x<0)','n1, fast diffuser right side (x>0)')
title('Fast diffusers versus location')




figure
plot(itimesave,carrcapleftsave,itimesave,totalleftsave), xlabel('Time'),ylabel('Total x<0 Population and Carrying Capacity')
legend('Carrying capacity left side','Total Population (fast+slow) left side (x<0)')

figure
plot(itimesave,carrcaprightsave,itimesave,totalrightsave), xlabel('Time'),ylabel('Total x>0 Population and Carrying Capacity')
legend('Carrying capacity right side','Total Population (fast+slow) right side (x>0)')


figure
plot(itimesave,totalleftsave,itimesave,totalrightsave,itimesave,carrcapleftsave,itimesave,carrcaprightsave), xlabel('Time'),ylabel('Total Left and Total Right diffusers')
legend('total (fast+slow) left-side population','total (fast+slow) right-side population','carrying capacity left side','carrying capacity right side')
title('Total left side and total right side populations')

figure
plot(itimesave,n2save,itimesave,n1save,itimesave,Totalcarrcapsave), xlabel('Time'),ylabel('Total Fast and Toal Slow diffusers')
legend('total n2, slow diffuser','n1, total fast diffuser','total carrying capacity')
title('Total slow differers and total fast diffusers (must zoom to see fast)')

figure
plot(itimesave,n2leftsave,itimesave,n2rightsave,itimesave,carrcapleftsave,itimesave,carrcaprightsave), xlabel('Time'),ylabel('Slow diffusers')
legend('Y1, slow diffuser left side (x<0)','Y2, slow diffuser right side (x>0)','carrying capacity left','carrying capacity right')
title('Slow diffusers on left-hand and right-hand sides')

figure
plot(itimesave,n1leftsave,itimesave,n1rightsave), xlabel('Time'),ylabel('Fast diffusers')
legend('X1, fast diffuser left side (x<0)','X2 fast diffuser right side (x>0)')
title('Fast diffusers on left-hand and right-hand sides')


meanslowleft = 0;
meanslowright = 0;
meanfastleft = 0;
meanfastright = 0;
meantotalslow = 0;
meantotalfast = 0;








