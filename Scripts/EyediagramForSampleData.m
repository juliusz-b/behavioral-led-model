addpath(genpath('Functions\'))
UF = 8;
BR = 100e6;

figure('color','w')
%%% Low modulation amplitude
subplot(2,1,1)

y = readmatrix('Sample data\rateeq_lin_PAM4_100MBaud_8G_UF8.txt');
eyediag(y(300:1e4),2*UF,Inf,BR*UF,'PlotHistogram',true,'NormalizeSignal',true)
hold on;

y = readmatrix('Sample data\behavioral_lin_PAM4_100MBaud_8G_UF8.txt');
eyediag(y(300:1e4),2*UF,.6,BR*UF,'Color','green','NormalizeSignal',true,'LineOpacity',0.08,'PlotHistogram',true)

title('100MBaud/s Vpp_{ref.} \color{blue}{model} \color{black}{vs} \color{green}{r.e.}','Interpreter','tex');

%%% High modulation amplitude
subplot(2,1,2)
y = readmatrix('Sample data\rateeq_nonlin_PAM4_100MBaud_8G_UF8.txt');
eyediag(y(300:1e4),2*UF,Inf,BR*UF,'PlotHistogram',true,'NormalizeSignal',true)
hold on;

y = readmatrix('Sample data\behavioral_nonlin_PAM4_100MBaud_8G_UF8.txt');
eyediag(y(300:1e4),2*UF,1.5,BR*UF,'Color','green','NormalizeSignal',true,'LineOpacity',0.08,'PlotHistogram',true)

title('100MBaud/s Vpp_{ref.} \color{blue}{model} \color{black}{vs} \color{green}{r.e.}','Interpreter','tex');

