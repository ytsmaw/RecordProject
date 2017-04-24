%Pathboy
close all



%% inputs
filename = 'Warsh.mp3';
GPI = 30; %Grooves Per Inch (in)
G_width = .01; %Max Groove width (in) equals number of rotations over space filled with grooves.
rec_diam = 8; %Record diameter (in)
w = 45; %rotation speed (RPM)
shrink_factor = 1.5; % 2 = 1/2 sampling rate, 3 = 1/3, etc.
type = 'dxf'; %eps or svg or dxf
number_of_files = 10;

%% The calculation
addpath('Inputs')
[source, fs] = audioread(filename);
source = RIAAprep(source,fs);
source = source(floor(shrink_factor:shrink_factor:length(source)));

entrancelength = .25 * GPI * 60/w; % sec lead in 
source = [zeros(floor(entrancelength*fs),1); source]; % blank lead-in groove

fs = fs/shrink_factor;
len = length(source);

outer_R = (rec_diam)/2; % outer diameter of music

linPath = source'./(max(abs(source))) .* G_width/2; %linear path of music

numRev = (len/fs) / (60/w); % number of revolutions

inner_R = outer_R - (GPI^-1 * numRev) % inner diameter of music

pause()

min_point_spacing = ( 1/(60/w)*(2*pi) ) / fs; %how far apart data points will be (in degrees) at the interior diameter.

rot_num = (1:len) * (numRev/len); %a vector of full rotations

theta = (1:len) * 2 * pi * (numRev/len); % This is actually theta, the first thing was needlessly complicated.

spiral = outer_R - (1:len) * (outer_R-inner_R)/len; %creating the base spiral that the audio will be superposed upon
rho = spiral + linPath; % the superposition!
time = (1:len)/fs/60;
figure()
plot(time,rho);

%% the display
figure()
grid off
line = polarplot(theta,rho, [0,2*pi], [rec_diam, rec_diam]);
[x,y] = pol2cart(theta,rho);
figure()
axis equal
plot(x,y)
xlabel inches
ylabel inches
title 'Groove Path'
pause(0)

%% the path creation
switch type
    case 'eps'
    fname = sprintf('%s_d%ggpi%gw%g.eps', filename(1:(length(filename)-4)),rec_diam,GPI,w); %creating the file name
    disp('Commencing EPS creation')
    m = epstrash(x,y,rec_diam, rec_diam, fname); %converting X-Y coordinates to EPS
    disp(m);
    case 'svg'
    fname = sprintf('%s_d%ggpi%gw%g.svg', filename(1:(length(filename)-4)),rec_diam,GPI,w); %creating the file name
    disp('Commencing SVG creation')
    m = svgtrash(x,y,rec_diam, rec_diam, fname); %converting X-Y coordinates to SVG
    disp(m);
    case 'dxf'
    fname = sprintf('%s_d%ggpi%gw%gs%g\\', filename(1:(length(filename)-4)),rec_diam,GPI,w,shrink_factor); %creating the file name
    disp('Commencing DXF creation')
    for i = 1:number_of_files
        name = sprintf('%g.dxf',i);
        split = floor(length(x)/(number_of_files)-4);
        m = dxftrash(x( ((i-1)*split+1) : (i*split+4) ),y( ((i-1)*split+1) : (i*split+4) ),rec_diam,fname, name); %converting X-Y coordinates to SVG
    end
    disp(m);
end
% output = [0,theta;0,rho]';
% 

% 
% fid = fopen(fname,'w');
% csvwrite(fname,output);
% fid = fclose(fid);
% 
