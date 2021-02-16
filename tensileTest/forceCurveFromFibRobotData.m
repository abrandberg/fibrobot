%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%
clear; close all; clc
format compact

% forceFile = 'data\tensile_comp_2021-01-29-12-32-25_force.csv';

calibrationFile = 'calibrationPolynomForForceSensor_data=tensile_comp_2021-01-29-12-32-25_force.mat';
forceFile = 'data\tensile_comp_2021-02-15-12-39-24_force.csv';



fprintf('          -> %40s      %s \n','Start of','forceCurveFromFibRobotData.m')
fprintf('          -> %40s      %s \n','Current directory is:',cd)


fprintf('          -> %40s      %s\n','Voltage file to import is:',forceFile)
fprintf('          -> %40s      %s\n','Calibration constants loaded from:',calibrationFile)

load(calibrationFile)

fibRobot_voltageMeasured = fibRobot_importVoltageSignal(forceFile);
sizeVoltage = size(fibRobot_voltageMeasured,1);


fibRobot_force(:,1) = fibRobot_voltageMeasured(:,1)- fibRobot_voltageMeasured(1,1);
fibRobot_force(:,2) = fibRobot_voltageMeasured(:,2)*kExport + mExport;
fibRobot_force(:,2) = fibRobot_force(:,2);


figure;
plot(fibRobot_force(:,1),fibRobot_force(:,2))
xlabel('Time [s]')
ylabel('Force [N]')
legend(strrep(flip(strtok(flip(forceFile),'\')),'_',' '),'location','northeast')
