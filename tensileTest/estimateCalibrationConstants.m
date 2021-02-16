function constsOut = estimateCalibrationConstants(refForce,FIBForce,refOffset,FIBOffset,fibForceOffset,fibForceScaleFactor,dataName)


% Rough cleaning
refForce(refForce(:,1)<refOffset,:) = [];           % Remove signal before time refOffset
FIBForce(FIBForce(:,1)<FIBOffset,:) = [];           % Remove signal before time FIBOffset
refForce(:,1) = refForce(:,1)-refOffset;            % Zero the remaining time
FIBForce(:,1) = FIBForce(:,1)-FIBOffset;            % Zero the remaining time
FIBForce(:,2) = FIBForce(:,2)*fibForceScaleFactor + fibForceOffset;  % Add offset term and multiply with scale factor

% Resample one of them for error minimization
FIBForceRES = interp1(FIBForce(:,1),FIBForce(:,2),refForce(:,1));

% Error minimization routine:
y1 = FIBForceRES(2:end);
yReal = refForce(2:end,2);

costFunc = @(x) sqrt( 1/(length(yReal)+1) * sum( ( (y1.*x(2)+x(1)) - yReal).^2     )      );
x0 = [0 0];

constsOut = fminsearch(costFunc,x0);

figure('name',horzcat('comparisonPlot',dataName));
plot(refForce(2:end,1),yReal,'linewidth',1)
hold on
plot(refForce(2:end,1),y1.*constsOut(2)+constsOut(1),'linewidth',1)
xlabel('Time (adjusted) [s]')
ylabel('Force signal [N]')
legend('Ref.','FibRobot','location','best')
title(['OFFSET = ' num2str(fibForceOffset+constsOut(1)) '     SCALE = ' num2str(fibForceScaleFactor*constsOut(2))])
