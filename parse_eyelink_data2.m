function [t, x, y] = parse_eyelink_data2(D, subjectID, opt)      
% Parses the csv and returns -- at trial level --:
% 
% **** Raw signals ****
% 
% * Time in milliseconds
% * Raw pixels x
% * Raw fixels y
% * Raw distance to cam 
% * Raw pupil signal
% * Summized validity signal
% 
% **** Fixations, eyelink based ****
% 
% * Time of fixation start
% * Time of fixation end
% * Fixation x position
% * Fixation y position
% * Fixation duration
% * Median pupil size for fixation
% 
% **** Some zep messages ? ***
%% cell names for columns (endwithC)
eventC   = D{1};
tC       = D{2};
tsC      = D{3};
teC      = D{4};
tuC      = D{5};
eyeC     = D{6};
ignC     = D{7};
distC    = D{8};
xleftC   = D{9};
yleftC   = D{10};
pleftC   = D{11};
xrightC  = D{12};
yrightC  = D{13};
prightC  = D{14};
msgC     = D{15};

%% "Q" bools that we need of the original Cell-data length
gazeQ         = cellmessage_to_bool(eventC, 'GAZE_SAMPLE');
messageQ      = cellmessage_to_bool(eventC, 'MESSAGE');
updateQ       = cellmessage_to_bool(eventC, 'FIXATION_UPDATE');
fixstartQ     = cellmessage_to_bool(eventC, 'FIXATION_START');
fixendQ       = cellmessage_to_bool(eventC, 'FIXATION_END');
blinkstartQ   = cellmessage_to_bool(eventC, 'BLINK_START');
blinkendQ     = cellmessage_to_bool(eventC, 'BLINK_END');

 
%% let's also define what we want as trial onsets and offsets
disp_trialstartQ   = partial_cellmessage_to_bool(msgC,'DISPLAY');
sound_trialstartQ  = partial_cellmessage_to_bool(msgC,'SOUND');
trialendQ          = partial_cellmessage_to_bool(msgC,'trialend');

% adjust the trialstarts and trialends, to select only
% the eye data in between...

forbetterstart = [0 disp_trialstartQ']; %gaze data starts one sample after
forbetterend   = [trialendQ' 0]; % gaze data ends

betterstart    = forbetterstart(1:end-1);
betterend      = forbetterend(2:end);

starts         = find(betterstart == 1);
ends           = find(betterend == 1);

assert(length(starts) == length(ends));


for i = 1: length(starts)
    
    trialno = i;
    
    %% RAW messages and samples: x/y/t/event data within trial 
    % (includes other message samples)
    allx = xrightC(starts(i) : ends(i));
    ally = yrightC(starts(i) : ends(i));
    allt = tC(starts(i) : ends(i));
    
    allt_s = tsC(starts(i) : ends(i)); %only event start times!!!!!!!
    allt_e = teC(starts(i) : ends(i)); % only event end times
    
    
    allp = prightC(starts(i) : ends(i));
    alle = eventC(starts(i) : ends(i));
    allm = msgC(starts(i) : ends(i));
        
    % normalised timestamps, inluding messages, fix on/fix of times-
    nallt = double(allt - allt(1));
    nallte = double(allt_s - allt_s(1));
    
    %% Select only x and y GAZE_SAMPLES (within trial)
    qgaze = cellmessage_to_bool(alle, 'GAZE_SAMPLE');
        
    % to make clean raw gaze signals for x, y, t using only gaze_samples
    x = double(allx(qgaze));
    y = double(ally(qgaze));
    
    % find the first gaze sample's time, we need that to normalise other
    % event times
    firstgazetimes =  double(allt(qgaze));
    firstgazetime = firstgazetimes(1);
    
    % a time vector for gaze samples only
    nice_t = double(nallt(qgaze));
    
    t = double(nallt(qgaze)); %clean sample time with normalised values

    p = double(allp(qgaze)); 
        
    % make x/y/pup zeros--> NaN
    x(x==0) = nan;
    y(y==0) = nan;
    p(y==0) = nan;
    
    %% Just outside the trial range: let's validate zep info messages
    come = starts(i) - 1; 
    go   = ends(i) + 1;
    
    % verify basic info about onset and offset of trials
    displayon_msg = msgC(come);
    trialend_msg = msgC(go);
    
    %% within the trial range: find sound onset
    soundon_sel = partial_cellmessage_to_bool(allm,'SOUND');
    %unique(soundon_sel)
    
    soundon_time    = allt(soundon_sel);
    soundon_message = allm(soundon_sel);
        
    % time related: gather all trial onset times of zep clock
    displayon_t     = double(tC(come));
    displayon_t_n   = displayon_t - firstgazetime;
    
    trialend_t      = double(tC(go));
    trialend_t_n    = trialend_t - firstgazetime;
    
    soundon_t       = double(soundon_time);
    soundon_t_n     = soundon_t - firstgazetime;
    
    % we may need to insert this time as a fix onset if the first found is
    % offset
    trialstart_t = displayon_t_n;
    % in case we miss a fixation offset, we should remove the last onset,
    % since we're not sure when that fixation actually ends    
    
    %% find eyelink fixation messages (some starts/ends may be unfound)
    %% this is within all messages, so not only gaze samples
    q_el_fixon  = cellmessage_to_bool(alle, 'FIXATION_START');
    q_el_fixof = cellmessage_to_bool(alle, 'FIXATION_END');
    
    % get the original start and end times belonging to fix
    fixon_t_raw = double(allt_s(q_el_fixon));
    fixof_t_raw = double(allt_e(q_el_fixof));
    
    % and their trial clock (normalised) times
    fixon_t_n   = fixon_t_raw - firstgazetime;
    fixof_t_n   = fixof_t_raw - firstgazetime;
    
    %also get the x and y positions belonging to fixations. 
    xon_fix = double(allx(q_el_fixon));
    yon_fix = double(ally(q_el_fixon));
    
    xof_fix = double(allx(q_el_fixof));
    yof_fix = double(ally(q_el_fixof));
    
    % renaming eyelink even times because i am lazy
    el_fon_t = fixon_t_n;
    el_fof_t = fixof_t_n;
    
    disp(['Further processing ' subjectID ' trial ' num2str(i)]);
    
    skip = 0;
    startendadjusted = 0;
    corrected = 0;
    
    if isempty(el_fon_t) || isempty(el_fof_t)
        disp ('SKIP: empty trial')
        skip = 1;
    else
        % match to raw sample data within trial level
        % timestamps given raw sample data
        %dirty hack first, to make sure no times outside the trial range
        %are used. (check this again at some point!!!)
        if el_fon_t(1) < 0
            el_fon_t(1) = 0;
            disp('one')
            startendadjusted = 1;
        end
        if el_fof_t(1) < 0
            el_fof_t(1) = 0;
            disp('two')
            startendadjusted = 1;
        end
    
        if el_fon_t(end) > t(end)
            el_fon_t(end) = t(end);
            disp('three')
            startendadjusted = 1;
        end
        if el_fof_t(end) > t(end)
            el_fof_t(end) = t(end);
            disp('four')
            startendadjusted = 1;
        end
    end


    if ~skip
        % FIRST check for equal lengths + order        
        if ~(length(el_fon_t) == length(el_fof_t))
            
            disp ('Different lengths EL onsets & offsets in trial')
            disp ('Figure out which one is longer, on or off')
            
            disp ('Truncate one intelligently')
            
            [el_fon_t, ...
             el_fof_t] = talg(el_fon_t,...
                             el_fof_t,...
                             trialstart_t);
                         
            % correction seems to always come down to
            % removing the last fixation on time
            % so we should also truncate the last
            % x and y fixation ON values
            disp ('correting xon_yon fix,too')
            xon_fix = xon_fix(1:end-1);
            yon_fix = yon_fix(1:end-1);
                         
            corrected = 1;
        end
    end
   
    if corrected
        disp ('CORRECTED markers')
    else
        disp ('not corrected at al')
    end
    
    elfdur = double(el_fof_t - el_fon_t);
    
    %% prepare all plot function values
    xpix = x;
    ypix = y;
           
    [xdeg, ydeg] = screen_to_deg(xpix, ypix, opt.disttoscreen, ...
                                opt.scrSz(1), opt.scrSz(2), ...
                                opt.xres, opt.xres);
    
    vx = get_velo_acc(xdeg, 2, 250);
    vy = get_velo_acc(ydeg, 2, 250);
    v = sqrt(vx.^2 + vy.^2);
    
    % rename some fixation-based values
    ton_fix = el_fon_t;
    tof_fix = el_fof_t;
    dur_fix  = elfdur;
    
    % trial-inspection time/values
    display_on_t = displayon_t_n; %(trial start)
    sound_on_t   = soundon_t_n; %
    trial_end_t  = trialend_t_n; %
    
    plot_expbased_t(t, xpix, ypix, xdeg, ydeg, v, ...   
                    xon_fix,yon_fix,xof_fix,yof_fix,...
                    ton_fix,tof_fix,dur_fix,...
                    display_on_t, sound_on_t, trial_end_t,...
                    subjectID, trialno , opt)
    
end





