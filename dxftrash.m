function msg = dxftrash(x,y,diam,fname)

% http://www.autodesk.com/techpubs/autocad/acad2000/dxf/header_section_group_codes_dxf_02.htm

x = x+diam/2;
y=y+diam/2;

%info: http://paulbourke.net/dataformats/dxf/min3d.html
nel = 2; % number of elements

if exist(strcat(pwd,'\Outputs\'),'dir') == false
    mkdir(strcat(pwd,'\Outputs\'));
    disp('Outputs folder created!')
end
dxfboy = fopen(strcat(pwd,'\Outputs\',fname),'w');

% vv I think acadver AC1012 for R13 is what I want but it throws an error so I'm
% just using AC1009 for R11-R12
fprintf(dxfboy,'0\r\nSECTION\r\n2\r\nHEADER\r\n9\r\n$ACADVER\r\n1\r\nAC1009\r\n9\r\n$INSBASE\r\n10\r\n0.0\r\n20\r\n0.0\r\n30\r\n0.0\r\n9\r\n');
fprintf(dxfboy,'$EXTMIN\r\n10\r\n0.0\r\n20\r\n0.0\r\n9\r\n$EXTMAX\r\n10\r\n%g\r\n20\r\n%g\r\n0\r\nENDSEC\r\n',diam,diam);
fprintf(dxfboy,'0\r\nSECTION\r\n2\r\nTABLES\r\n0\r\nENDSEC\r\n0\r\nSECTION\r\n2\r\nBLOCKS\r\n0\r\nENDSEC\r\n');

fprintf(dxfboy,'0\r\nSECTION\r\n2\r\nENTITIES\r\n');
%{
fprintf(dxfboy,'0\r\nLWPOLYLINE\r\n100\r\nAcDbPolyline\r\n5\r\nGROOVES\r\n8\r\n0\r\n90\r\n%d\r\n',nel);
%fprintf(dxfboy,'39\r\n1\r\n'); % setting line thickness

for i = 1:nel %length(x)
    fprintf(dxfboy,'10\r\n%g\r\n20\r\n%g\r\n',x(i),y(i));
end
%}
fprintf(dxfboy,'0\r\nLWPOLYLINE\r\n100\r\nAcDbPolyline\r\n100\r\nAcDbEntity\r\n\r\n330\r\n1F\r\n8\r\n0\r\n5\r\n1\r\n90\r\n2\r\n43\r\n0.0\r\n10\r\n0.0\r\n20\r\n0.0\r\n10\r\n%g\r\n20\r\n%g\r\n',diam,diam); % line across canvas
fprintf(dxfboy,'0\r\nCIRCLE\r\n8\r\n1\r\n5\r\n2\r\n330\r\n1F\r\n10\r\n%g\r\n20\r\n%g\r\n30\r\n0\r\n40\r\n%g\r\n',diam/2,diam/2,diam/2); % outer circle
fprintf(dxfboy,'0\r\nCIRCLE\r\n8\r\n1\r\n5\r\n3\r\n330\r\n1F\r\n10\r\n%g\r\n20\r\n%g\r\n30\r\n0\r\n40\r\n%g\r\n',diam/2,diam/2,.286/2); % inner hole

fprintf(dxfboy,'0\r\nENDSEC\r\n0\r\nEOF'); % end that file!
fclose(dxfboy);
msg='Done, losers!';
    
