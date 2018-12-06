function [proportion] = det_raw_nan_prop(data)
% Determines the proportion of NaNs in data. Returns float 
% (nansamples/allsamples). Only tested on 1D vector ('data')
N = length(data);
nanbool = isnan(data);
proportion = sum(nanbool)/N;
