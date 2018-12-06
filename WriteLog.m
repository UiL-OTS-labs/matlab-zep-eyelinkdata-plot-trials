function WriteLog(Data)
persistent FID
% Open the file
if strcmp(Data, 'open')
  FID = fopen(fullfile(tempdir, ['gap_overlap_' datestr(datetime('now'),'yyyymmddTHHMMSS') '.log']), 'a');
  if FID < 0
     error('Cannot open file');
  end
  return;
elseif strcmp(Data, 'close')
  fclose(FID);
  FID = -1;
else
fprintf(FID, '%s\n', Data);
end
% Write to the screen at the same time:
%fprintf('%s\n', Data);