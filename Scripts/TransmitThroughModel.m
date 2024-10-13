addpath(genpath('Functions\'))
% Set parameters of LED model
ledBandwidth3dB = 45e6;
fA = 11e6;
eta = 0.02;
lengthOfLedResponse = 50;
gamma = 10;

% Load symbols
xInput = readmatrix('Sample data\example_PAM4_UF4_Alfa1_FilterSpan20.txt');

% Signal parameters
baudRate = 100e6;
upsamplingFactor = 4;
samplingFrequency = baudRate*upsamplingFactor;
signalAmplitudeLow = .2;
signalAmplitudeHigh = 1.2;

%  ___ ___ _  _   ___   _____ ___  ___    _   _        _    ___ ___
% | _ ) __| || | /_\ \ / /_ _/ _ \| _ \  /_\ | |      | |  | __|   \
% | _ \ _|| __ |/ _ \ V / | | (_) |   / / _ \| |__    | |__| _|| |) |
% |___/___|_||_/_/ \_\_/ |___\___/|_|_\/_/ \_\____|   |____|___|___/
%

xOutputLow = ledbehavioral(xInput*signalAmplitudeLow, ledBandwidth3dB,...
    fA, gamma, eta,samplingFrequency, lengthOfLedResponse);
xOutputHigh = ledbehavioral(xInput*signalAmplitudeHigh, ledBandwidth3dB,...
    fA, gamma, eta,samplingFrequency, lengthOfLedResponse);

%
%
%
%

% Eyediagram
figure('color','w')
eyediag(xOutputLow(5e3:9e3), upsamplingFactor*2, Inf, samplingFrequency,...
    'Color','blue','PlotHistogram',true,'LineOpacity',0.5,'NormalizeSignal',true);
hold on;
eyediag(xOutputHigh(5e3:9e3), upsamplingFactor*2, Inf, samplingFrequency,...
    'Color','red','PlotHistogram',true,'LineOpacity',0.5,'NormalizeSignal',true);

title([num2str(baudRate*1e-6) 'MBaud/s, amplitude: \color{blue}'...
    num2str(signalAmplitudeLow,'%.2f') '\color{black} and \color{red}' num2str(signalAmplitudeHigh,'%.2f')])