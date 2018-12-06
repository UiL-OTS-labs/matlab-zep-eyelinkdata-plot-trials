function tf = partial_cellmessage_to_bool(c, messagepart)
% Converts cell arrays of strings to logical arrays.
% Params: 
% c             : cell array with strings in it.
% messagepart   : some part of string you WANT to find, eg 'finishthiswor' 
%                 (becomes 1)
% casesensitive : if 1, compares on case, too.

assert(nargin >= 2);

if ~iscellstr(c)
   error('cellmessage_2_bool:NotCellstr', ...
      'The input was not a cell array of strings.');
end

tf = logical(~cellfun(@isempty,regexp(c, messagepart, 'once')));

end
