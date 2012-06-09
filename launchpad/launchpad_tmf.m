function tmf = launchpad_tmf(varargin)
if isunix
    tmf = 'launchpad_unix.tmf';
else
    tmf = 'launchpad_pc.tmf';
end