clc; clear; close all

%format long g

addpath(genpath('l2c_c2l')); % to deal with all those string data files


%% SETTINGS 

fs                      = filesep; % platform-independent file seperator
home                    = pwd;
infolderbase            = fullfile([home fs 'data' fs]);
outfigures              = fullfile([home fs 'inspect' fs]);


%% Parts taken from Roy Hessels I2MC event detection settings, 
% an 'opt' struct with some defaults for K-means algo

% GENERAL
opt.xres                = 1280; 
opt.yres                = 1024;
opt.missingx            = -opt.xres; 
opt.missingy            = -opt.yres; 
opt.freq                = 250; 
opt.plotpath            = outfigures;

% VISUAL ANGLE STUFF
screendiag              = 17.03155; %338 mm X 270 mm, diag = 432.6014 mm ---> converted to inches
opt.scrSz               = [33.8 27.0]; 

% EXTRA/settings, i was being lazy
xres1                   = 1280;
yres1                   = 1024;
cmH                     = 27.0;
cmW                     = 33.8;

diagpix                 = sqrt(xres1^2+yres1^2);
pixpercm                = diagpix/(screendiag*2.54);
opt.disttoscreen        = 60; % 
rad2deg                 = @(x) x/pi*180;
degpercm                = 2*rad2deg(atan(1/(2*opt.disttoscreen)));
pixperdeg               = pixpercm/degpercm;


%% some experiment specific AOI estimate (placeholder)
aoi_c = [0.5 0.5 0.5 0.5] + [-4.5 -4.5 4.5 4.5] ./ [cmW cmH cmW cmH];
opt.aoi = [0.5 0.5 0.5 0.5] + [-4.5 -4.5 4.5 4.5] ./ [cmW cmH cmW cmH];

% fixation statistics
basedir = [pwd fs];
%WriteFile('open', basedir) % we do this later?

% Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isdir(infolderbase)
  errorMessage = sprintf('Error: Folder non-exist:\n%s', infolderbase);
  uiwait(warndlg(errorMessage));
  return;
end

% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(infolderbase, '*.csv');
theFiles = dir(filePattern);

%% data file loop (contains trial data)
for i = 1 : length(theFiles)
    baseName = theFiles(i).name;
    fullName = fullfile(infolderbase, baseName);
    fprintf(1, 'Reading %s\n', fullName);
    D = read_zep_eyecsv(fullName);
    %% first: generic parsing stuff given EyeLink/Zep format
    [t, x, y] = parse_eyelink_data2(D, baseName, opt);
end





















