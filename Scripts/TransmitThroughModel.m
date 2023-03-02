addpath(genpath('Functions\'))
% Set parameters of LED model
ledBandwidth3dB = 45e6;
frequencyOfZeroInH2 = ledBandwidth3dB*0.25;
calibrationAmplitude = 1.2;
lengthOfLedResponse = 50;
relativeSecondHarmonicPowerDb = -21;

% Load symbols
xInput = readmatrix('Sample data\example_PAM4_UF4_Alfa1_FilterSpan20.txt');

% Signal parameters
baudRate = 100e6;
upsamplingFactor = 4;
samplingFrequency = baudRate*upsamplingFactor;
signalAmplitudeCoefficient = 1.2;

%  ___ ___ _  _   ___   _____ ___  ___    _   _        _    ___ ___
% | _ ) __| || | /_\ \ / /_ _/ _ \| _ \  /_\ | |      | |  | __|   \
% | _ \ _|| __ |/ _ \ V / | | (_) |   / / _ \| |__    | |__| _|| |) |
% |___/___|_||_/_/ \_\_/ |___\___/|_|_\/_/ \_\____|   |____|___|___/
%

xOutput = ledbehavioral(xInput*signalAmplitudeCoefficient, ledBandwidth3dB,...
    frequencyOfZeroInH2, relativeSecondHarmonicPowerDb, calibrationAmplitude,...
    samplingFrequency, lengthOfLedResponse);

%
%
%
%

% Eyediagram
figure('color','w')
eyediag(xOutput(5e3:9e3), upsamplingFactor*2, Inf, samplingFrequency,...
    'Color','blue','PlotHistogram',true,'LineOpacity',0.5);

title([num2str(baudRate*1e-6) 'MBaud/s, amplitude: '...
    num2str(signalAmplitude,'%.2f')])