function tf = cellstr2logical(c, casesensitive)
% Converts cell arrays of 'true' or 'false' strings to logcal arrays.
% 
% TF = CELLSTR2LOGICAL(C) takes a cell array of strings and returns a
% logical array.  Where the input value is 'true' (matched case
% insensitively), then the corresponding return value is true.
% Likewise, where the input value is 'false' (matched case
% insensitively), then the corresponding return value is false.  An
% error is thrown if any other strings are contained in c.
% 
% TF = CELLSTR2LOGICAL(C, 1) is as above, but the strings are matched
% case sensitively.
% 
% EXAMPLES:
% cellstr2logical({'false', 'True'; 'TRUE' 'FAlsE'})
% ans =
%      0     1
%      1     0
% 
% cellstr2logical({'false', 'True'; 'TRUE' 'FAlsE'}, 1)
% ??? Error using ==> cellstr2logical at 30
% The input contained a string that wasn't 'true' or 'false'  
% 
% $ Author: Richard Cotton $		$ Date: 2009/07/10 $    $ Version 1.2 $
%
% See also LOGICAL2CELLSTR, CELL2MAT, CELL2STRUCT

if nargin < 1 || isempty(c)
   tf = [];
   return;
end

if nargin < 2 || isempty(casesensitive)
   casesensitive = false;
end

if casesensitive
   cmpfn = @strcmp;
else
   cmpfn = @strcmpi;
end

if ~iscellstr(c)
   error('cell2logical:NotCellstr', ...
      'The input was not a cell array of strings.');
end

tf = cmpfn(c, 'true');

if ~all(tf(:) | cmpfn(c(:), 'false'))
   error('cell2logical:BadString', ...
      'The input contained a string that wasn''t ''true'' or ''false''.');
end

end