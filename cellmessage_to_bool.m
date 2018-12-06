function tf = cellmessage_to_bool(c, message, casesensitive)
% Converts cell arrays of strings to logical arrays.
% Params: 
% c             : cell array with strings in it.
% message       : some string you WANT to find, eg 'GAZE_SAMPLE' 
%                 (becomes 1)
% casesensitive : if 1, compares on case, too.


assert(nargin >= 2);

if nargin < 3 || isempty(casesensitive)
   casesensitive = false;
end

if casesensitive
   cmpfn = @strcmp;
else
   cmpfn = @strcmpi;
end

if ~iscellstr(c)
   error('cellmessage_2_bool:NotCellstr', ...
      'The input was not a cell array of strings.');
end

tf = cmpfn(c, message);

end