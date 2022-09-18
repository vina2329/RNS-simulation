clc, clear, close all
%% First Section: Connecting to your mobile device
m = mobiledev;
m.Connected
%% Main Section
accel = [];

% window of 10 datapoints for calculating the sigmoid
accel_win = zeros(10, 3); 
before = zeros(1,3); % storing the previous x,y,z axis acceleration data
RTI_Interval = 20;
RESET = 1;
te = 500; % time threshold (ms) for increasing the amplitude of the stimulation
tp = 0;

% Real-time Plot Initialization
fig1 = figure;
set(fig1, 'units', 'inches', 'position', [3 2 9 5])
yyaxis left
anstim = animatedline(0,0,'color',[0 0.4470 0.7410], 'LineWidth',0.8);
ylim([-25 25])
ylabel('Output Current (\muA)')

yyaxis right
anacc = animatedline(0,0,'color',[0.8500 0.3250 0.0980], 'LineWidth',0.5);

ax1 = gca;
ylim([-70 70])
xlabel('Time (s)')
ylabel('X axis acceleration (m/s^2)')
legend('stimulation current', 'acceleration', 'location', 'northeast')
title('Real Time Graph of X-axis Acceleration wrt Stimulation Output','FontSize',15)
grid on
drawnow

while m.AccelerationSensorEnabled == 1
    acc_now = m.Acceleration;
    if sum(before ~= acc_now) > 0
        % storing the accel log from all previous time points till now
        accel = [accel; acc_now];
        accel_win = [accel_win; acc_now];
        accel_win(1, :) = [];

        before = acc_now;

        % Calculate the sigmoid in a 10-datapoint window
        sigmoid1 = round(1./(1+exp(-1/10.*(abs(accel_win(:,1))-1.5*mean(abs(accel(:,1)))))));
        sig_mean = mean(sigmoid1); % Calculating the mean of sigmoid outputs in window
        
        % state machine
        [chA] = neuro_stimulation(RESET, RTI_Interval, sig_mean, te, 1); 
        
        % plotting
        addpoints(anstim, tp, chA)   
        addpoints(anacc, tp, acc_now(1))
        drawnow limitrate
        tp = tp + 0.1;

    if RESET == 1
        RESET = 0;
    end
    end
end

%% State Machine
function [chA] = neuro_stimulation(RESET, RTI_Interval, sigmoid1, te, thres)

persistent tA
persistent stateA
persistent tepisode

if RESET == 1
    tA = 0;
    stateA = 0;
    tepisode = 0;
end

% if time of seizure is over te, increase the amplitude
if tepisode > te
    AMPA = 15;
else
    AMPA = 10;
end

if thres == 0
    stateA = 0;
end

switch stateA
    case 0 % no pulse
        tA = tA + RTI_Interval;
        chA = 0;
        if sum(sigmoid1) > 0.2
            tA = 0;
            stateA = 1;
        else
            tepisode = 0;
        end

    case 1 % time-determined pulse
        tA = tA + RTI_Interval;
        tepisode = tepisode + RTI_Interval;
        if tA <= 10*2 % initial no pulse
            chA = 0;
        elseif tA > 10*2 && tA <= 40*2 %positive pulse
            chA = AMPA;
        elseif tA > 40*2 && tA <= 60*2 % inner pulse phase
            chA = 0;
        elseif tA > 60*2 && tA <= 90*2 %negative pulse
            chA = -AMPA;
        elseif tA > 90*2 && tA <= 110*2
            chA = 0;
        else
            tA = 0;
            chA = 0;
            stateA = 0;
        end
end
end

