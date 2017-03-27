%Pathboy
close all



%% inputs
filename = 'Eskim.mp3';
GPI = 150; %Grooves Per Inch (in)
G_width = .005; %Max Groove width (in) equals number of rotations over space filled with grooves.
rec_diam = 5; %Record diameter (in)
w = 45; %rotation speed (RPM)
shrink_factor = 2; % 2 = 1/2 sampling rate, 3 = 1/3, etc.
type = 'eps'; %eps or svg

%% The calculation

[source, fs] = audioread(filename);

source = RIAAprep(source,fs);
source = source(shrink_factor:shrink_factor:length(source));
fs = fs/shrink_factor;
len = length(source);

outer_R = (rec_diam - .5)/2; % outer diameter of music

linPath = source'./(max(abs(source))) .* G_width/2; %linear path of music

numRev = (len/fs) / (60/w); % number of revolutions

inner_R = outer_R - (GPI^-1 * numRev); % inner diameter of music

min_point_spacing = ( 1/(60/w)*(2*pi) ) / fs; %how far apart data points will be (in degrees) at the interior diameter.

rot_num = (1:len) * (numRev/len); %a vector of full rotations

space = min_point_spacing * ( outer_R ./ ( inner_R + (outer_R-inner_R) * (rot_num./numRev) ) ); %a calculation which determines the spacing of points radially to account for changing speed with diameter.

disp('Commencing Theta summation');

theta = zeros(1,len);
theta(1) = 0;
for i = 2:len
    theta(i) = theta(i-1) + space(i); % sum the spaces between the points
end

spiral = inner_R + (1:len) * (outer_R-inner_R)/len; %creating the base spiral that the audio will be superposed upon
rho = spiral + linPath; % the superposition!

%% the display
figure(1)
grid off
line = polarplot(theta,rho, [0,2*pi], [rec_diam, rec_diam]);
[x,y] = pol2cart(theta,rho);
figure(2)
axis equal
plot(x,y)
xlabel inches
ylabel inches
title 'Groove Path'
pause(0)

%% the path creation
if strcmp(type,'eps')
    fname = sprintf('%s_d%ggpi%gw%g.eps', filename(1:(length(filename)-4)),rec_diam,GPI,w); %creating the file name
    disp('Commencing EPS creation')
    m = epstrash(x,y,rec_diam, rec_diam, fname); %converting X-Y coordinates to EPS
    disp(m);
else
    fname = sprintf('%s_d%ggpi%gw%g.svg', filename(1:(length(filename)-4)),rec_diam,GPI,w); %creating the file name
    disp('Commencing SVG creation')
    m = svgtrash(x,y,rec_diam, rec_diam, fname); %converting X-Y coordinates to SVG
    disp(m);
end
% output = [0,theta;0,rho]';
% 

% 
% fid = fopen(fname,'w');
% csvwrite(fname,output);
% fid = fclose(fid);
% 
