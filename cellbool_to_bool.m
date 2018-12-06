function [numbool] = cellbool_to_bool(cellbool)
% Converts a true/false cell array to 0/1 cell array or to regular vector
% 
% Parameter: convert
% 0: keep as cell array
% 1: convert to regular array
% ended up using $ Author: Richard Cotton's routine (in l2c_c2l)

numbool = cellstr2logical(cellbool);
end



