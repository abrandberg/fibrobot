%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% fibRobot calibration script
%
% ABOUT:
% This script imports the two force cell signals and lets the user adjust
% the offset and gain of the fibRobot signal so that the two signals match,
% effectively calibrating the fibRobot force sensor.
%
% USAGE:
% 1.    Put the two force signals somewhere, provide the links and string
%       arrays.
%
% 2.    Run the script once, as the force signals are independently
%       recorded the first step is to align the signals in time. You need
%       to do this by hand, by removing part of the initial signal such
%       that the first load sequence happens at the same time for both
%       signals.
%
%       Perform this adjustment by altering the values of 
%       refTimeAdjust and fibTimeAdjust.
%
% 3.    Once the signals are aligned in time, it will be possible to
%       calibrate the force signal. Do this by running the script and
%       letting the function
%
%       estimateCalibrationConstants.m
%       
%       Find the optimal parameters to the scaling equation 
%
%       fibCalibrated = k * fibRobot_voltageMeasured + m
%
%       It may be that the fitting does not converge properly in the
%       beginning, however the script can be run several times, updating
%       the parameters
%
%       fibForceOffset (corresponding to the term m in the equation above)
%
%       fibForceScale  (corresponding to the term k in the equation above)
%
%       The code first applies these two factors, and then attempts to
%       minimze the RMS error between the two force signals.
%
%       Therefore, when it works, the function 
%
%       estimateCalibrationConstants.m
%
%       should return the vector [ 0 , 1 ], corresponding to no change to
%       the given m value, and a multiplication of the current k value by
%       1.
%
% 4.    Finally, the two signals are plotted together, such that the
%       quality of the fit can be inspected.
%
% created by: August Brandberg augustbr at kth dot se
% date: 2021-02-07
%       

clear; close all; clc;
format compact

% Inputs
referenceForceFile = 'data\Test2_2021-01-29.csv';
fibRobotForceFile = 'data\tensile_comp_2021-01-29-12-32-25_force.csv';


% Import data
referenceForceData = importRefForceCellData(referenceForceFile);
fibRobot_voltageMeasured = fibRobot_importVoltageSignal(fibRobotForceFile);


% Align in time
refTimeAdjust = 5.46;
fibTimeAdjust = 11.1;

% Supply guesses for m and k
fibForceOffset = 0.20867;
fibForceScale = 0.11525;

% Perform minimization
constsOut = estimateCalibrationConstants([1 -1].*referenceForceData,fibRobot_voltageMeasured,refTimeAdjust,fibTimeAdjust,fibForceOffset,fibForceScale,'2');

% Print result of operations
fprintf('           %s \n','Calibration of fibRobot force sensor');
fprintf('           %s \n','Fitting by function y = k*x + m');
fprintf('           %s %d %s\n','Resampled signal contains',length(referenceForceData(:,1))-1,'data points');
fprintf('           %s %3.2f , %3.2f %s\n','Range of force is [',min(referenceForceData(:,2)*-1), max(referenceForceData(:,2)*-1),'] N');
fprintf('           %s %4.2f (multiplier) \n','Adjustment, k = ',constsOut(2))
fprintf('           %s %4.2f (added) \n','Adjustment, m = ',constsOut(1))
fprintf('           %s %4.2f %s %4.2f \n','Calibrated: fibRobotForce =',fibForceScale*constsOut(2),'* fibRobot_voltageMeasured +',fibForceOffset+constsOut(1))
fprintf('           %s \n','Inspect fit to confirm quality.');

kExport = fibForceScale*constsOut(2);
mExport = fibForceOffset+constsOut(1);
explainerExport = 'To get Force, take Voltage and apply F = kExport*Voltage + mExport';

saveName = flip(strtok(flip(fibRobotForceFile),'\'));
saveName = strtok(saveName,'.');

save(['calibrationPolynomForForceSensor_data=' saveName '.mat'],'kExport','mExport','explainerExport')


% Export all figures
ctrl.plotFlag = 1;
if ctrl.plotFlag
    mkdir(horzcat(cd,filesep,'Plots'))
    FigIdx = findall(0, 'type', 'figure');
    for mm = 1:length(FigIdx)
        figure(mm)
        foo = get(gcf,'Name');
        foo = strrep(foo, '.', ',');
        print(foo,'-dpng','-r600')    
        movefile(horzcat(foo,'.png'),horzcat(cd,filesep,'Plots',filesep,foo,'.png'))
    end
end

