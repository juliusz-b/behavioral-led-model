function eyediag(x,n,varargin)
%EYEDIAG  Generates an better eye diagram. Current version does not support
%I/Q signals :(.
%   AUTHORS: JULIUSZ BOJARCZUK AND GRZEGORZ STĘPNIAK, WARSAW UNIVERSITY OF TECHNOLOGY
%   
%   Y = EYEDIAG(X,N) plot an eye diagram of input signal X with N samples per
%   one window.
%   
%   Y = EYEDIAG(X,N,OFFSET) plot an eye diagram of input signal X with
%   an floating point OFFSET with N samples per one window. The offset is
%   calculated using an FFT.
%   
%   Y = EYEDIAG(X,N,OFFSET,FS) plot an eye diagram of input signal X with
%   an floating point OFFSET with N samples per one window. FS is a
%   sampling frequency of the input signal, which is used to specify
%   x-axis period of the signal. 
%   
%   
%   Additionally you can set the following extra parametrs:
%   'Color' - specifies color line of eyediagram plot. Default is 'blue'. 
%   Example: EYEDIAG(X,N,'Color','red') OR EYEDIAG(X,N,'Color',[1 0 0])
%   plot eyediagram with red colored lines.
%   
%   'NormalizeSignal' - allows for normalization of the input signal. The
%   signal is normalized to the power of unity and its bias is removed.
%   Example: EYEDIAG(X,N,'NormalizeSignal',true);
%
%   'LineOpacity' - changes opacity of the eyediagram line.
%   Example: EYEDIAG(X,N,'LineOpacity',0.1);
%
%   'PlotHistogram' - shrinks eydiagram horizontally and puts on the right
%   side an histogram of values.
%   Example: EYEDIAG(X,N,'PlotHistogram',true);
%   
%   
%   See also EYEDIAGRAM, HISTOGRAM.


%Check number of inputs
narginchk(2,Inf);
nargoutchk(0,0);

%Make x as vector
x = x(:);

%Generate parser for eyediag
p = generateParser();

%Parse input variables
parse(p,x,n,varargin{:});

%Extract input variables into function workspace - for convience
extractParsed(p);

%Clear parse object
clear p

%n = n+1;

%If Fs is set to inf then we use arbitrary time [-.5,.5] on x axis
if isinf(Fs)
    t_on_x = false;
else
    t_on_x = true;
end

%If Offset is set to inf then function searches for the highest eye opening
if isinf(Offset)
    auto_del = true;
    Offset = 0;
else
    auto_del = false;
end

%Normalization of the signal to the total power of 1
if ischar(NormalizeSignal)
    x = normalize(x,'range',[-1 1]);
else
    if NormalizeSignal
        x = x-mean(x);
        x = x/std(x);
    end
end

%Perform shifting of the signal
x = real(ifft(ifftshift(fftshift(fft(x)).*exp(-1i*2*pi*(Offset)*linspace(-.5,.5,length(x))'))));

%Reshape signal in order to plot it as eye diagram
N = length(x);
N = N - mod(N,n);
y = x(1:N);
y_to_plot = reshape(y,n,N/n);

%Calculate limits of the y-axis
spn = max(y)-min(y);
mn = mean(y);
chg = abs(spn)*.1;
y_limits = [(mn-spn/2)-chg  (mn+spn/2)+chg];

%Calculate x-axis values
if t_on_x
    x_name = 'Time [ns]';
    x_to_plot = linspace(-n/2/Fs,n/2/Fs,n)*1e9;
    x_limits = [min(x_to_plot) max(x_to_plot)];
else
    x_name = 'Time [a.u.]';
    x_to_plot = (0:n-1)/(n-1)-0.5;
    x_limits = [-1 1]*0.5;
%     x_to_plot = linspace(-n/2,n/2,n);
%     x_limits = [min(x_to_plot) max(x_to_plot)];

end
y_name = 'Amplitude [a.u.]';

%Search for highest eye opening
if auto_del
    var_y = var(y_to_plot,[],2);
    var_y = max(y_to_plot')-min(y_to_plot');
    [~,ix] = max(var_y);
    circ_val = round(n/2-ix);
    y_to_plot = reshape(circshift(y,circ_val),n,N/n);
end

%Remove unwanted artifacts after shifting the signal
if size(y_to_plot,2)>1
    if (auto_del && circ_val>0) || (~auto_del && Offset>0)
        y_to_plot = y_to_plot(:,2:end);
    else
        y_to_plot = y_to_plot(:,1:end-1);
    end
end

%Plotting
p = plot(x_to_plot,y_to_plot,'-','color',Color,'HandleVisibility','off');

%Change opacity of the line - if necessary
for i=1:length(p)
    p(i).Color(4) = LineOpacity;
end


xlim(x_limits);
ylim(y_limits);
xlabel(x_name);
ylabel(y_name);


%%%%
%%% Histogram part
%%%%

if PlotHistogram

    %Shrink current plot
    shrink_scale_x = 0.8387;
    eye_line_parent = get(p(1),'Parent');
    eye_line_parent_pos = get(eye_line_parent,'Position');
    if ~ishold(eye_line_parent)
        eye_line_parent_pos(3) = eye_line_parent_pos(3)*shrink_scale_x;
        set(eye_line_parent,'Position',eye_line_parent_pos);
    end

    %Create new axes
    start_x = eye_line_parent_pos(1)+eye_line_parent_pos(3);
    ax=axes('Parent',gcf,'Position',[start_x eye_line_parent_pos(2) eye_line_parent_pos(3)*(1-shrink_scale_x) eye_line_parent_pos(4)]);

    h = histogram(ax,y_to_plot(:),100,'FaceColor',Color,'EdgeAlpha',0,'Normalization','probability','FaceAlpha',1);
    
    set(ax,'Color','none');
    xlim(y_limits);
    view(90,-90);
    %set(ax,'xtick',[]);
    %set(ax,'ytick',[]);
    axis off
    %box off
    ax.XAxis.Visible = 'off';
    ax.YAxisLocation = 'right';
    %ax.YAxis
    %yticks([0 round(max(max(h.Values)),2)]);

    axes(eye_line_parent); 

end



end

%%%
% Additional functions
%%%

function p = generateParser()
    p = inputParser;
    p.CaseSensitive = false;
    p.StructExpand = true;
    addRequired(p,'x',@(x) validateattributes(x,{'single','double'},{'nonempty','nonnan','finite'}));
    addRequired(p,'n',@isPositiveIntegerValuedNumeric);
    addOptional(p,'Offset',0,@isscalar);
    addOptional(p,'Fs',-Inf,@(x) isfinite(x) && isnumeric(x) && isscalar(x) && (x > 0));
    addParameter(p,'Color','blue',@(x) validateattributes(validatecolor(x),{'double'},{'nonempty'}));
    addParameter(p,'NormalizeSignal',false,@(x) isa(x,'logical')||isa(x,'char'));
    addParameter(p,'LineOpacity',1,@isnumeric);
    addParameter(p,'PlotHistogram',false,@islogical);
end

function extractParsed(p)
    for i=1:length(p.Parameters)
        nm = p.Parameters{i};
        assignin('caller',nm,getfield(p.Results,nm));
    end
end