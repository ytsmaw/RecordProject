function msg = dxftrash(x,y,xlim,ylim,fname)

x = x+xlim/2;
y=y+ylim/2;

%info: http://paulbourke.net/dataformats/dxf/min3d.html
nel = 10000; % number of elements

if exist(strcat(pwd,'\Outputs\'),'dir') == false
    mkdir(strcat(pwd,'\Outputs\'));
    disp('Outputs folder created!')
end
dxfboy = fopen(strcat(pwd,'\Outputs\',fname),'w');
s = '%';

fprintf(dxfboy,'0\r\nSECTION\r\n2\r\nHEADER\r\n9\r\n$EXTMIN\r\n10\r\n0.0\r\n20\r\n0.0\r\n9\r\n$EXTMAX\r\n10\r\n%g\r\n20\r\n%g\r\n0\r\nENDSEC\r\n',xlim,ylim);
fprintf(dxfboy,'0\r\nSECTION\r\n2\r\nENTITIES\r\n100\r\nAcDbPolyline\r\n90\r\n%d\r\n',nel);

for i = 1:nel %length(x)
    fprintf(dxfboy,'10\r\n%g\r\n20\r\n%g',x(i),y(i));
end

fprintf(dxfboy,'0\r\nENDSEC');
fclose(dxfboy);
msg='Done, losers!';
    
