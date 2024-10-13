function [y] = ledbehavioral(x,ledBandwidth3dB,fA,gamma,eta,samplingFrequency,N)
%LEDBEHAVIORAL  Implements behavioral model in MATLAB for signal transmission.
%   AUTHOR: GRZEGORZ STĘPNIAK, WARSAW UNIVERSITY OF TECHNOLOGY
%   
%   Y = LEDBEHAVIORAL(X,LEDBANDWIDTH3DB,FA,GAMMA,ETA,
%   SAMPLINGFREQUENCY,N) transmits X signal through LED utilizing
%   two filter model presented in the paper entitled
%   "A Behavioral Model of the Light Emitting Diode Nonlinearity".
%   
%   
%   Function takes folowing parameters:
%   X   - input signal as single column or row vector. [.]
%   
%   LEDBANDWIDTH3DB - LED 3dB bandwidth. [Hz]
%   
%   FA - cutoff of second filter(h2). Typically around 0.2-0.3
%   of LEDBANDWIDTH3DB. [Hz]
%   
%   GAMMA - nonlinearity factor [1/W]
%   
%   ETA - Elctro optic conversion [W/A]
%   
%   SAMPLINGFREQUENCY - Sampling frequency of the signal X. [Hz]
%   
%   N - Number of filter coefficients. [#]
%   
%   
%   See also AWGN.

% Only 7 inputs are allowed.
narginchk(7,7);


% Check input variables
if ~isvector(x) || ~isnumeric(x)
    error('Input signal vector cannot be a matrix.')
end
if (~isreal(ledBandwidth3dB)||ledBandwidth3dB<0)
    error('3dB bandwidth must be a member of R+.')
end
if (~isreal(fA)||fA<0)
    error('fA frequency must be a member of R+.')
end
if ~isreal(gamma)
    error('Gamma must be real.')
end
if ~isreal(eta)
    error('Eta must be real.')
end
if ~isreal(samplingFrequency) || samplingFrequency<=0
    error('Sampling frequency must be real.')
end
if (~isreal(N)||N<=0||~(N==floor(N)))
    error('N must be greater than 0 and be integer.')
end

% Sampling interval
T=1/samplingFrequency;

%Time vector
t=0:T:(N-1)*T;

% Calculate response of h1 filter (lowpass)
h1=eta*2*pi*ledBandwidth3dB*exp(-t*2*pi*ledBandwidth3dB);

% Calculate response of h2 filter (highpass).
h2=gamma*ledBandwidth3dB/fA*(2*pi*fA*exp(-t*2*pi*ledBandwidth3dB) -...
    2*pi*ledBandwidth3dB*exp(-(t)*2*pi*ledBandwidth3dB));
h2=h2+kroneckerdelta(t)*(2*pi*ledBandwidth3dB*sum(exp(-(t)*2*pi*ledBandwidth3dB)))*...
    gamma*ledBandwidth3dB/fA;

% Convolve input signal with h1
x1=conv(x,h1)*T;

% Convolve squared x1 signal with h2
x2=0.5*conv(x1.^2,h2)*T;

% Trim x2 so it matches x1;
x2=x2(1:length(x1));

y=x1+x2;

end

function y = kroneckerdelta(t)
y = zeros(size(t));
y(t==0) = 1;
end
