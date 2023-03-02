BR = 100e6;
M2=30;

Fmeas = linspace(-BR/4,BR/4,M2)*1e-6;

figure('color','w','Position',[680 100 560 2*420]);
subplot(2,1,1)
G2 = readmatrix('Measurement data\kernel_white_50mA_100M.txt');
plotG2(G2,Fmeas)
title('|G_2(f_1,f_2)| [a.u.] @50mA')

subplot(2,1,2)
G2 = readmatrix('Measurement data\kernel_white_200mA_100M.txt');
plotG2(G2,Fmeas);
title('|G_2(f_1,f_2)| [a.u.] @200mA')




function plotG2(G2,Fmeas)
limxy = [min(Fmeas) max(Fmeas)];
xlab = 'f_1 [MHz]';
ylab = 'f_2 [MHz]';
measmax = max(G2(:));
surf(Fmeas,Fmeas,G2,'LineStyle','none');
view([90 90])
xlabel(xlab)
ylabel(ylab)
xlim(limxy)
ylim(limxy)
c = colorbar;c.Location = 'north';c.Color = 'white';A = c.Position;c.Position = [A(1:2), 0.06, 0.02];
clim([0 round(measmax,2)]);
c.Ticks = [0 round(measmax,2)];
colormap hot
end

