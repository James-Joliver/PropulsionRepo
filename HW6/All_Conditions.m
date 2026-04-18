clear; clc;
% This script will define all the run conditions of HW 6

simIn = Simulink.SimulationInput('HW6_JamesWilkinson2');
%warning('off', 'all')
% These values have been grabbed from https://www.engineeringtoolbox.com/standard-atmosphere-d_604.html
Alt = [0, 25000, 50000];    % ft
%T = [288.15, 238.65, 217];     % K
%P = [0.101325353, 0.03765227, 0.011665929];   % MPa

T = [238.65];     % K
P = [0.03765227];   % MPa

HeatRate = 10^8;
DesignedPR = 15;   % Nominally 7.5


tempLabels = {'T1', 'T2', 'T3', 'T4', 'T5', 'T6'};
pressLabels = {'P1', 'P2', 'P3', 'P4', 'P5', 'P6'};

%AirFlow = [100, 150];  % kg/sec

AirFlow = 100;

Temp_results = cell(3,2);
Pressure_results = cell(3,2);
Time = cell(3,2);



for i = 1:numel(T)

    for j = 1:numel(AirFlow)
        

        Temp = T(i);
        Pressure = P(i);
        Air_mdot = AirFlow(j);

        data = sim(simIn);
        Temp_results{i, j} = data.Temps.Data(:, :);
        Pressure_results{i, j} = data.Pressures.Data;
        Time{i, j} = data.tout;
        fprintf("run with Temp: %f, Pressure: %f, AirFlow: %f\n", T(i), P(i), AirFlow(j));
       

        % Plots

        figure;
        subplot(2, 3, 1);
        plot(data.tout, data.Temps.Data);
        title("Temperature");
        xlabel('time'); ylabel('Temp (K)');
        legend(tempLabels);
        grid on;

        subplot(2, 3, 4);
        plot(data.tout, data.Pressures.Data);
        title('Pressure');
        xlabel('time'); ylabel('Pressure (MPa)');
        legend(pressLabels);
        grid on;
                
        subplot(2, 3, 2);
        plot(data.tout, data.RPM.Data);
        title('Shaft RPM');
        xlabel('time'); ylabel('RPM');
        grid on;
              
        subplot(2, 3, 3);
        plot(data.tout, data.OPR.Data);
        title('OPR');
        xlabel('time'); ylabel('OPR');
        grid on;
                
        subplot(2, 3, 5);
        plot(data.tout, data.SFC.Data);
        title('SFC');
        xlabel('time'); ylabel('SFC');
        grid on;
                
        subplot(2, 3, 6);
        plot(data.tout, data.Thrust.Data);
        title('Thrust');
        xlabel('time'); ylabel('Thrust (N)');
        grid on;

        sgtitle(['Alt =', num2str(Alt(i)), 'ft, AirSpeed = ', num2str(AirFlow(j))], 'FontSize', 14, 'FontWeight', 'bold');


    end
end


%%
%%%%%%%%% Calculating T-s %%%%%%%%%%%%%%%

% Only run this bit when the specific case you want to generate the plot
% for has run

cp = 1005;   % J/kg·K - specific heat of air
R  = 287;    % J/kg·K - specific gas constant

T1 = Temp_results{1, 1}(end, 1);
T2 = Temp_results{1, 1}(end, 2);
T3 = Temp_results{1, 1}(end, 3);
T4 = Temp_results{1, 1}(end, 4);
T5 = Temp_results{1, 1}(end, 5);
T6 = Temp_results{1, 1}(end, 6);

P1 = Pressure_results{1, 1}(end, 1);
P2 = Pressure_results{1, 1}(end, 2);
P3 = Pressure_results{1, 1}(end, 3);
P4 = Pressure_results{1, 1}(end, 4);
P5 = Pressure_results{1, 1}(end, 5);
P6 = Pressure_results{1, 1}(end, 6);

Tref = 298.15;  % K
Pref = 101325;  % Pa
sref = 1717;    % J/kg·K - standard specific entropy of air

% Absolute entropy at station 0
s1 = cp*log(T1/Tref) - R*log(P1/Pref) + sref;

% Reference state (station 0)
%s1 = 0;  % define ambient as zero reference

% Entropy at each station relative to station 0
s2 = s1 + cp*log(T2/T1) - R*log(P2/P1);
s3 = s1 + cp*log(T3/T1) - R*log(P3/P1);
s4 = s1 + cp*log(T4/T1) - R*log(P4/P1);
s5 = s1 + cp*log(T5/T1) - R*log(P5/P1);
s6 = s1 + cp*log(T6/T1) - R*log(P6/P1);

% Collect into arrays (use final/steady-state values)
s_stations = [s1, s2, s3, s4, s5, s6];
T_stations = [T1, T2, T3, T4, T5, T6];

figure;
plot(s_stations, T_stations, 'bo-', 'LineWidth', 2, 'MarkerSize', 8);
% Label each station point
labels = {'1 (Ambient)', '2 (Comp. In)', '3 (Comp. Out)', ...
          '4 (Turb. In)', '5 (Turb. Out)', '6 (Nozzle Exit)'};
for i = 1:length(s_stations)
    text(s_stations(i)+2, T_stations(i)+5, labels{i}, 'FontSize', 9);
end

xlabel('Specific Entropy s (J/kg·K)');
ylabel('Temperature T (K)');
title('T-s for 25,000ft 100kg/s');      % REMEMBER TO CHANGE THIS BIT 
grid on;


%%
%%%%%%%%% PLOTS %%%%%%%%%%

% Temperature
figure;

% T = 288.15K, P = 0.1013MPa, AirSpeed = 100kg/s
subplot(2, 3, 1);
plot(Time{1, 1}, Temp_results{1, 1});
title('Alt = 0ft, AirSpeed = 100kg/s');
xlabel('time'); ylabel('Temp (K)');
legend(tempLabels);
grid on;

% --- Plot 2: Cosine Wave ---
subplot(2, 3, 4);
plot(Time{1, 2}, Temp_results{1, 2});
title('Alt = 0ft, AirSpeed = 150kg/s');
xlabel('time'); ylabel('Temp (K)');
legend(tempLabels);
grid on;

% --- Plot 3: Exponential Decay ---
subplot(2, 3, 2);
plot(Time{2, 1}, Temp_results{2, 1});
title('Alt = 25000ft, AirSpeed = 100kg/s');
xlabel('time'); ylabel('Temp (K)');
legend(tempLabels);
grid on;

% --- Plot 4: Scatter Plot ---
subplot(2, 3, 5);
plot(Time{2, 2}, Temp_results{2, 2});
title('Alt = 25000ft, AirSpeed = 150kg/s');
xlabel('time'); ylabel('Temp (K)');
legend(tempLabels);
grid on;

% --- Plot 5: Bar Chart ---
subplot(2, 3, 3);
plot(Time{3, 1}, Temp_results{3, 1});
title('Alt = 50000ft, AirSpeed = 100kg/s');
xlabel('time'); ylabel('Temp (K)');
legend(tempLabels);
grid on;

% --- Plot 6: Parabola ---
subplot(2, 3, 6);
plot(Time{3, 2}, Temp_results{3, 2});
title('Alt = 50000ft, AirSpeed = 150kg/s');
xlabel('time'); ylabel('Temp (K)');
legend(tempLabels);
grid on;

% Overall title
sgtitle('Temperature across each state', 'FontSize', 14, 'FontWeight', 'bold');


% Pressure
figure;

% T = 288.15K, P = 0.1013MPa, AirSpeed = 100kg/s
subplot(2, 3, 1);
plot(Time{1, 1}, Pressure_results{1, 1});
title('Alt = 0ft, AirSpeed = 100kg/s');
xlabel('time'); ylabel('Temp (K)');
legend(pressLabels);
grid on;

% --- Plot 2: Cosine Wave ---
subplot(2, 3, 4);
plot(Time{1, 2}, Pressure_results{1, 2});
title('Alt = 0ft, AirSpeed = 150kg/s');
xlabel('time'); ylabel('Pressure (MPa)');
legend(pressLabels);
grid on;

% --- Plot 3: Exponential Decay ---
subplot(2, 3, 2);
plot(Time{2, 1}, Pressure_results{2, 1});
title('Alt = 25000ft, AirSpeed = 100kg/s');
xlabel('time'); ylabel('Pressure (MPa)');
legend(pressLabels);
grid on;

% --- Plot 4: Scatter Plot ---
subplot(2, 3, 5);
plot(Time{2, 2}, Pressure_results{2, 2});
title('Alt = 25000ft, AirSpeed = 150kg/s');
xlabel('time'); ylabel('Pressure (MPa)');
legend(pressLabels);
grid on;

% --- Plot 5: Bar Chart ---
subplot(2, 3, 3);
plot(Time{3, 1}, Pressure_results{3, 1});
title('Alt = 50000ft, AirSpeed = 100kg/s');
xlabel('time'); ylabel('Pressure (MPa)');
legend(pressLabels);
grid on;

% --- Plot 6: Parabola ---
subplot(2, 3, 6);
plot(Time{3, 2}, Pressure_results{3, 2});
title('Alt = 50000ft, AirSpeed = 150kg/s');
xlabel('time'); ylabel('Pressure (MPa)');
legend(pressLabels);
grid on;

% Overall title
sgtitle('Pressure across each state', 'FontSize', 14, 'FontWeight', 'bold');