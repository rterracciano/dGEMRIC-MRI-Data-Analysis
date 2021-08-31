function [fitresult, gof] = createFit_T2(x, y)
%  Author: Rossana Terracciano
%  Date: 2021-01-04
%  Info:

%  Create a fit for 1/T2 values.
%
%  Data for fit:
%      X Input : x
%      Y Output: y
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( x, y );

% Set up fittype and options.
ft = fittype( 'a*exp(-b*x)+c', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Algorithm = 'Levenberg-Marquardt';
opts.Display = 'Off';
opts.StartPoint = [100 0.01 0.5059];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% % Plot fit with data.
% figure( 'Name', 'Mono-Exponential Fitting' );
% h = plot( fitresult, xData, yData ,'*');
% legend( h, 'Signal Intensity', 'Mono-Exponential Fitting', 'Location', 'NorthEast', 'Interpreter', 'none' );
% %Label axes
% xlabel( 'TE (ms)', 'Interpreter', 'none' );
% ylabel( 'S(TE)', 'Interpreter', 'none' );
% grid on


