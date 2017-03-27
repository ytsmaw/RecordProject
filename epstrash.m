function msg = epstrash(x,y,xlim,ylim,fname)

%how to write EPS: http://www.tcm.phy.cam.ac.uk/~mjr/eps.pdf

xlim = xlim * 1000;
ylim = ylim * 1000;
x = 1000 * x + xlim/2;
y = 1000 * y + ylim/2;

epsboy = fopen(fname,'w');
s = '%';
%now for the tough stuff
fprintf(epsboy,'%s!PS-Adobe-2.0 EPSF-2.0 \n%s%sBoundingBox: 0 0 %g %g \nnewpath \n%g %g moveto \n',s,s,s, xlim, ylim, x(1), y(1));

tic
for i = 2:10000
    fprintf(epsboy,'%g %g lineto \n',x(i),y(i));
end
tim = toc;
fprintf('Estimated time: %3f minutes\n', (length(x)-10000)/10000 * tim /60);

for i = 10001:length(x)
    fprintf(epsboy,'%g %g lineto\n',x(i),y(i));
end


fprintf(epsboy,'1 setlinejoin\n 1 setlinewidth\nstroke');
fclose(epsboy);
msg='Done, losers!';
end