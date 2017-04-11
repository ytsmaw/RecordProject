function msg = dxftrash(x,y,xlim,ylim,fname)

x = x+xlim/2;
y=y+ylim/2;

%info: http://paulbourke.net/dataformats/dxf/min3d.html
nel = 30000; % number of elements

if exist(strcat(pwd,'\Outputs\'),'dir') == false
    mkdir(strcat(pwd,'\Outputs\'));
    disp('Outputs folder created!')
end
dxfboy = fopen(strcat(pwd,'\Outputs\',fname),'w');

fprintf(dxfboy,'0\r\nSECTION\r\n2\r\nHEADER\r\n9\r\n$ACADVER\r\n1\r\nAC1006\r\n9\r\n$INSBASE\r\n10\r\n0.0\r\n20\r\n0.0\r\n30\r\n0.0\r\n9\r\n');
fprintf(dxfboy,'$EXTMIN\r\n10\r\n0.0\r\n20\r\n0.0\r\n9\r\n$EXTMAX\r\n10\r\n%g\r\n20\r\n%g\r\n0\r\nENDSEC\r\n',xlim,ylim);
fprintf(dxfboy,'0\r\nSECTION\r\n2\r\nTABLES\r\n0\r\nENDSEC\r\n0\r\nSECTION\r\n2\r\nBLOCKS\r\n0\r\nENDSEC\r\n');

fprintf(dxfboy,'0\r\nSECTION\r\n2\r\nENTITIES\r\n0\r\nLWPOLYLINE\r\n100\r\nAcDbPolyline\r\n5\r\nGROOVES\r\n8\r\n0\r\n90\r\n%d\r\n39\r\n1\r\n',nel);

for i = 1:nel %length(x)
    fprintf(dxfboy,'10\r\n%g\r\n20\r\n%g\r\n',x(i),y(i));
end

fprintf(dxfboy,'0\r\nENDSEC\r\n0\r\nEOF');
fclose(dxfboy);
msg='Done, losers!';
    
