function msg = dxftrash(x,y,diam,fname,name)

% http://www.autodesk.com/techpubs/autocad/acad2000/dxf/header_section_group_codes_dxf_02.htm

x = x+diam/2;
x = round(x,3);
y = y+diam/2;
y = round(y,3);
%info: http://paulbourke.net/dataformats/dxf/min3d.html
nel = length(x); % number of elements

if exist(strcat(pwd,'\Outputs\'),'dir') == false
    mkdir(strcat(pwd,'\Outputs\'));
    disp('Outputs folder created!')
end
if exist(strcat(pwd,'\Outputs\',fname),'dir') == false
    mkdir(strcat(pwd,'\Outputs\',fname));
end

dxfboy = fopen(strcat(pwd,'\Outputs\',fname,name),'w');

%% Head, Tables
tp = fopen('Top.txt');
tline = 'poop';
while ischar(tline)
    tline = fgets(tp);
    if ischar(tline)
        fprintf(dxfboy, '%s', tline);
    end
end
fclose(tp);

%% Entities Section
fprintf(dxfboy,'0\r\nSECTION\r\n2\r\nENTITIES\r\n');

%fprintf(dxfboy,'0\r\nLWPOLYLINE\r\n100\r\nAcDbPolyline\r\n5\r\nGROOVES\r\n8\r\n0\r\n90\r\n%d\r\n',nel);
%fprintf(dxfboy,'39\r\n1\r\n'); % setting line thickness
tic
for i = 2:10000
    fprintf(dxfboy,'0\r\nLINE\r\n8\r\n0\r\n10\r\n%g\r\n20\r\n%g\r\n30\r\n0\r\n11\r\n%g\r\n21\r\n%g\r\n31\r\n0\r\n',x(i-1),y(i-1),x(i),y(i));
end
tim = toc;
fprintf('%s Estimated time: %3f minutes\n', name, (length(x)-10000)/10000 * tim /60);

for i = 10001:nel %length(x)
    fprintf(dxfboy,'0\r\nLINE\r\n8\r\n0\r\n10\r\n%g\r\n20\r\n%g\r\n30\r\n0\r\n11\r\n%g\r\n21\r\n%g\r\n31\r\n0\r\n',x(i-1),y(i-1),x(i),y(i));
end
%}
%fprintf(dxfboy,'0\r\nLWPOLYLINE\r\n5\r\n1\r\n330\r\n1F\r\n100\r\nAcDbEntity\r\n8\r\n0\r\n100\r\nAcDbPolyline\r\n90\r\n2\r\n43\r\n0.0\r\n10\r\n0.0\r\n20\r\n0.0\r\n10\r\n%g\r\n20\r\n%g\r\n',diam,diam); % line across canvas
fprintf(dxfboy,'0\r\nCIRCLE\r\n8\r\n1\r\n100\r\nAcDbCircle\r\n10\r\n%g\r\n20\r\n%g\r\n30\r\n0\r\n40\r\n%g\r\n',diam/2,diam/2,diam/2); % outer circle
fprintf(dxfboy,'0\r\nCIRCLE\r\n8\r\n1\r\n100\r\nAcDbCircle\r\n10\r\n%g\r\n20\r\n%g\r\n30\r\n0\r\n40\r\n%g\r\n',diam/2,diam/2,.286/2); % inner hole
fprintf(dxfboy,'0\r\nENDSEC\n');

%% Objects, end of file

nd = fopen('end.txt');
tline = 'poop';
while ischar(tline)
    tline = fgets(nd);
    if ischar(tline)
        fprintf(dxfboy, '%s', tline);
    end
end
fclose(nd);

fclose(dxfboy);
msg='Done, losers!';
end
    
