function msg = svgtrash(x,y,xlim,ylim,fname)

if exist(strcat(pwd,'\Outputs\'),'dir') == false
    mkdir(strcat(pwd,'\Outputs\'));
    disp('Outputs folder created!')
end
svgboy = fopen(strcat(pwd,'\Outputs\',fname),'w');

% basic beginning stuff
xlim = xlim * 1000;
ylim = ylim * 1000;
x = 1000 * x + xlim/2;
y = 1000 * y + ylim/2;

L1 = '<?xml version="1.0" encoding="utf-8"?>';
L2 = '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">';
L3 = sprintf('<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="%gpx" height="%gpx" viewBox="%g %g %g %g" xml:space="preserve">' ...
    , xlim, ylim, 0, xlim, 0, ylim);

fprintf(svgboy,'%s\n%s\n%s\n',L1,L2,L3);
%now for the tough stuff
fprintf(svgboy,'\n<polyline points="');
tic
for i = 1:10000
    fprintf(svgboy,'%g,%g ',x(i),y(i));
end
tim = toc;
fprintf('Estimated time: %3f minutes\n', (length(x)-10000)/10000 * tim /60);

for i = 10001:length(x)
    fprintf(svgboy,'%g,%g ',x(i),y(i));
end

fprintf(svgboy,'" stroke="#000000" stroke-width=".5" fill="none"/> \n</svg>');
fclose(svgboy);

msg ='I did it, losers!';
end