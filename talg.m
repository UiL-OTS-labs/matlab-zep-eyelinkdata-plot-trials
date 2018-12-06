function [newon, newof] = talg(on, of, ts)
%Adapt an 'on' or 'of time marker if they are not of equal length. 
%
% So we can get on with our life. This is quick hacky thing, still
%
% Test timestamps for fixations:
%
% on = [78351 79313 79649 80323 81079];
% of = [79263 79601 80307 81067];

% disp("difference between on and off:")
d = abs(length(on) - length(of));

if d > 1
    %this never seems to happen
    disp('talg: errorrrr')
end

minlen = min([length(on), length(of)]);
maxleft = length(on);
maxright = length(of);

newon = on;
newof = of;

if length(on) > length(of)
    % this happens quite often.
    disp('extra ON found, it just must be in the end')
    newon = on(1:end-1);
    newof = newof;
end

if length(of) > length(on)
    % this never seems to happen
    disp ('extra OF found, it must be in the beginning')
    disp (on)
    disp (of)
    pause(10)
end

if newon(1) > newof(1)
    disp('START! inserting trialstart_t as first fix onset')
    % this also never seems to happen
    pause (10)
    newon = cat(2, ts, on);
    newof = newof;
end
end

        
