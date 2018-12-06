function [NaN] = plot_expbased_t(t, px, py, dx, dy, v, ...   
                    xon_fix,yon_fix,xof_fix,yof_fix,...
                    ton_fix,tof_fix,dur_fix,...
                    start_trial, start_sound, end_trial,...
                    ID, trial_no, opt)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT TO INSPECT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nanProp = det_raw_nan_prop(px);
                
lenz = linspace(-1000, 1000); %generic large, should be tied to axes
maker = ones(1, length(lenz));

% to create nice plot lines for time events
onset = start_trial * maker;
soundon = start_sound * maker;
offset = end_trial * maker;


titel = ([ID ' exp time based ID trial:' num2str(trial_no)]);

h = figure('Visible', 'On','Renderer', 'painters', 'Position', [10 10 1200 1600]);

title(titel);

subplot(3,2,1);
plot(px, py, 'k-.');
hold on
ax = scatter(xof_fix, yof_fix, dur_fix * 0.08);
set(ax,'MarkerFaceColor','r');
alpha(ax, .2);
hold on;

for w = 1:length(dur_fix)
    text(xof_fix(w), yof_fix(w), num2str((w)));
end

aoi = opt.aoi;

plot([aoi(1) aoi(3)], [aoi(2) aoi(2)], 'r');
plot([aoi(1) aoi(1)], [aoi(2) aoi(4)], 'r');
plot([aoi(1) aoi(3)], [aoi(4) aoi(4)], 'r');
plot([aoi(3) aoi(3)], [aoi(2) aoi(4)], 'r');

    
%plot the entire screen dimensions
plot([0  1280], [0 0], 'k-.','LineWidth',1.5);
plot([0  0],[0 1024], 'k-.','LineWidth',1.5);
plot([0 1280], [1024 1024], 'k-.','LineWidth',1.5);
plot([1280 1280], [0 1024], 'k-.','LineWidth',1.5);
    
grid on;
%zoom out 3 * screen dimensions
axis([-1280 (2*1280) -1080 (2 * 1024)]);
    
%% angular plot
%pixel degree data; selecting 'fixof' position
[dx_fix, dy_fix] = screen_to_deg(xof_fix, yof_fix,opt.disttoscreen, ...
                                opt.scrSz(1), opt.scrSz(2), ...
                                opt.xres, opt.xres); 
 
% on markers in degrees                            
[dxon_fix, dyon_fix] = screen_to_deg(xon_fix, yon_fix,opt.disttoscreen, ...
                                opt.scrSz(1), opt.scrSz(2), ...
                                opt.xres, opt.xres);

% of markers in degrees                            
[dxof_fix, dyof_fix] = screen_to_deg(xof_fix, yof_fix,opt.disttoscreen, ...
                                opt.scrSz(1), opt.scrSz(2), ...
                                opt.xres, opt.xres);   

[x_axdeg, y_axdeg] = screen_to_deg([0, opt.xres], [0, opt.yres],...
                                    opt.disttoscreen, opt.scrSz(1),... 
                                    opt.scrSz(2), opt.xres, opt.yres);
                            
subplot(3,2,2);
plot(dx, dy, 'k');
hold on;
ax = scatter(dx_fix, dy_fix, 0.15 * dur_fix);
set(ax,'MarkerFaceColor','g');
alpha(ax, .2);

grid on;
axis([x_axdeg(1) x_axdeg(2) y_axdeg(1) y_axdeg(2)]);
     
% deg x and t only
subplot(6,1,3);
hold on;
plot(t, dx);
plot(ton_fix, dxon_fix,  'bo');
plot(tof_fix, dxof_fix,  'ro');
% starts and ends
plot(onset, lenz, 'k-')
plot(soundon, lenz, 'g-')
plot(offset, lenz, 'k-')
grid on;
axis([t(1)-1000 t(end)+ 1000 -16 16]);

%deg y and t only
subplot(6,1,4);
hold on;
plot(t, dy);
plot(ton_fix, dyon_fix,  'bo');
plot(tof_fix, dyof_fix,  'ro');
% starts and ends
plot(onset, lenz, 'k-')
plot(soundon, lenz, 'g-')
plot(offset, lenz, 'k-')
grid on;
axis([t(1)-1000 t(end)+1000 -14 14]);

%angular velocity    
subplot(6,1,5);
hold on;
plot(t, v);
plot(onset, lenz, 'k-')
plot(soundon, lenz, 'g-')
plot(offset, lenz, 'k-')
grid on
axis([t(1)-1000 t(end)+1000 0 800]);
grid on

annotation('textbox', [0 0.9 1 0.1], ...
    'String', ([ID ' trial ' num2str(trial_no) ...
               ' Missing data percentage: ' ...
                num2str(100 * nanProp)]) , ...
    'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center')

%fig = gcf;
% fig.PaperPositionMode = 'auto';
%fig.PaperType = 'a1';
%print('ScreenSizeFigure','-dpng','-r0')

saveas(h,[opt.plotpath ID num2str(trial_no) '.png']);

close(h);