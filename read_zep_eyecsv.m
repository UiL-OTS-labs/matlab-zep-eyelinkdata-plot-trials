function [data] = read_zep_eyecsv(filename)
% Read the typical zep data file into cell-arrays. 
%
% 1 : type (string) 
%         Event type ID 
%                         GAZE_SAMPLE, FIXATION_UPDATE, FIXATION_END, 
%                         SACCADE_START, SACCADE_END, BLINK_START, 
%                         BLINK_END, MESSAGE (maybe more)
% 2 : t (int) 
%          Generic timestamp (ms)
%                         Regular timestamp, for different events
%  3 : t_start (int)
%          Specific event start time (ms)
%                         Specific start timestamp for specific event
%  4 : t_end (int)
%          Specific event end time (ms)
%                         Specific end timestamp for some specific event
%  5 : t_update (int)
%          Fixation update specific time (ms)
%                         Refers back to the previous *fixation* start
%                         the eyelink updates the fixation event
%  6 : eye (string)
%          Eye related info
%                         EYE_TYPE_NONE (no eye related event)
%                         EYE_TYPE_RIGHT (right eye event)
%                         EYE_TYPE_LEFT (left eye event)
%
%  7 : ignore (string type boolean [true|false])
%          Fixation, blink and message-events--> false
%          Gaze samples ----> true
%                         The name probably makes sense to people 
%                         interested in the eyelink event detection 
%                         output.
%  8 : distance (int)
%          Distance of the eye to the camera, probably in millimeters.
%                         
%  9 : left_x (int)    
%          Left X eye position in pixels 
%          (can be dummy/copy of measured eye).
%  
%  10: left_y (int)
%          Left Y eye position in pixels 
%          (can be dummy/copy of measured eye).
%  
%  11: left_pupil (int)
%          Pupil diameter or area, measured in uncalibrated, 
%          arbitrary units. 
%          From eyelink docs:
%          Typical pupil area is 100 to 10000 units, with a precision of 
%          1 unit, while pupil diameter is in the range of 400-16000 units.
%  
%  12: right_x (int)    
%          Right X eye position in pixels (can be dummy).
%  
%  13: right_y (int)
%          Right Y eye position in pixels (can be dummy).
%  
%  14: right_pupil (int)
%          Right pupil size (see 11).
%  
%  15: msg (string)
%          Some message from the psychophysics program, i.e. Zep
         
                     
fileID = fopen(filename);
data = textscan(fileID,'%s %d %d %d %d %s %s %d %d %d %d %d %d %d %s',...
    'Delimiter',';','TreatAsEmpty',{'NA','na'},'CommentStyle','#',...
    'headerLines', 2);
fclose(fileID);
end
