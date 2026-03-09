clc; clearvars;

% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    x_init = 1;             % initial guess
    x_current = x_init;     % initial guess
    cc = 10^-4;             % convergence critieria
    h = 10^-8;              % numerical step size
    k = 1;                  % counter for loop
    f_of_x = 0;             % function output at x
    f_of_x_plus_h =0;       % function output at x plus h
    residual = f_of_x-0;    % difference between output and solution
    numericalResidual = 0;  % difference between output and soultion at x+h 
    m = 0;                  % slope
    max_iter = 10^2;        % maximum number of iterations to prevent blow up
    targetValue = 2;

% Newton-Raphson Loop %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    while k<=max_iter       % check to make sure the number of iterations is lower than max allowed

        f_of_x = mySpecialFunction(x_current);   % evaluate current guess
        residual = f_of_x-targetValue;                     % determine distance from desired goal

            if abs(residual)<cc         % determine if current distance from goal is close enough
                break
            end

        f_of_x_plus_h = mySpecialFunction(x_current+h);   % evaluate function at small distance from current guess
        numericalResidual = f_of_x_plus_h-targetValue;    % difference between output and soultion at x+h 
        m = (numericalResidual-(residual))/h;                     % Determine slop from approximation of derivative
        x_current=x_current-residual/m;                     % Find next guess from x intercept of slope of tangent line
    
        k=k+1;                                            % track number if iterations
    end
    
% Plots %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    x = linspace(-1.2,-0.5);
    y = mySpecialFunction(x);

    plot(x,y)
    hold on
    grid on

    plot(x_current,f_of_x,'*k')

