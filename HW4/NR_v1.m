clc; clearvars;

% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    x1 = 50;             % initial guess
    x2 = -10;
    x3 = 10;
    x_current = [x1; x2; x3];     % initial guess


    cc = 10^-4;             % convergence critieria
    h = 10^-8;              % numerical step size
    k = 1;                  % counter for loop
    f_of_x = [F(x_current); H(x_current); G(x_current)];             % function output at x
    residual = f_of_x - zeros(1, 3);    % difference between output and solution
    max_iter = 10^2;        % maximum number of iterations to prevent blow up
    targetVals = [10; -6; 1];
    n = length(x_current);                  % number of dimensions 
    x_new = zeros(n,1);
    jacobian = zeros(n, n);

% Newton-Raphson Loop %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while k<=max_iter       % check to make sure the number of iterations is lower than max allowed

        %Fdir(1) = F(x_current);   % evaluate current guess

        
        FunctionCurrent = [F(x_current); H(x_current); G(x_current)];
        breakPoint = abs(norm(FunctionCurrent - targetVals));

        if  breakPoint < 0.0001
            fprintf('breakEarly')
            break;
        end

        for i = 1:n
            x_iter = x_current;
            x_iter(i) = x_current(i) + h;
            jacobian(1, i) = (F(x_iter) - F(x_current)) / h;
        end

        for i = 1:n
            x_iter = x_current;
            x_iter(i) = x_current(i) + h;
            jacobian(2, i) = (H(x_iter) - H(x_current)) / h;
        end

        for i = 1:n
            x_iter = x_current;
            x_iter(i) = x_current(i) + h;
            jacobian(3, i) = (G(x_iter) - G(x_current)) / h;
        end
        residual = FunctionCurrent - targetVals;
        x_next = x_current - jacobian \ residual;
        x_current = x_next;

        k = k + 1;  % Increment the iteration counter
        
    
end


x_current


function [Fout] = F(x)
    Fout = x(1).^3+0.5*x(2).^2+x(3);
end

function [Hout] = H(x)
    Hout = x(1).^2 + 1.5*x(2) - x(3);
end

function [Gout] = G(x)
    Gout = 2*x(2) + x(3);
end



