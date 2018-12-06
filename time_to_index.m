function [indx] = time_to_index(number, freq)
% A fixation(or saccade) marker has time as unit. 
% This calculates the corresponding sample index given a specified time.
% EXAMPLE: time = [0 3 6 9 12 15 18] (so tc = 3ms)
% '6' is in third position, so the index is ===> (6 + tc)/tc = 9/3 = 3
tc = 1000/freq;
indx = round((number + tc)/tc, 0);