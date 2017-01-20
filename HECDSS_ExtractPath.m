function data = HECDSS_ExtractPath(file,fpath)

file = strrep(file,'\','/');
% outfile = strrep(outfile,'\','/');

if ischar(fpath)
    fpath = {fpath};
end

if ~exist(file,'file')
    error(sprintf('File %s not found',file));
end

% get fpath object
pathStr = sprintf('%s\r',fpath{:});
type = textscan(pathStr,'%s','delimiter','/')';
type = type{1}(4:7:end);

% write the temp script
scFile = fullfile(pwd,'HECDSS_ExtractPathScript.py');
fid = fopen(scFile,'w');

fprintf(fid,'from hec.script import *\r\nfrom hec.io import *\r\nfrom hec.heclib.util import *\r\nfrom hec.heclib.dss import *\r\n');
fprintf(fid,'import java\r\n\r\n');

outfile = fullfile(pwd,'TempResults.txt');
outfile = strrep(outfile,'\','/');

fprintf(fid,'f = open("%s","w")\r\n',outfile);
fprintf(fid,'myDss = HecDss.open("%s")\r\n',file);


for i = 1:numel(fpath)
    fpath{i} = upper(fpath{i});
    fprintf(fid,'ts = myDss.get("%s",1)\r\n',fpath{i});
    
    fprintf(fid,'try:\r\n');
    fprintf(fid,' xval =  ts.numberValues\r\n x = ts.times\r\n y = ts.values\r\n');
    fprintf(fid,' hStr = ''%%d'' %% xval + ''\\t'' + ''%s'' + ''\\t'' + ts.units + ''\\t'' + ts.type + ''\\n''\r\n\r\n',fpath{i});
    
    fprintf(fid,'except:\r\n');
    fprintf(fid,' y = ts.yOrdinates\r\n y = y[0]\r\n x = ts.xOrdinates\r\n xval = ts.numberOrdinates\r\n');
    fprintf(fid,' hStr = ''%%d'' %% xval + ''\\t'' + ''%s'' + ''\\t'' + ts.xunits + ''\\t'' + ts.yunits + ''\\n''\r\n\r\n',fpath{i});
    
    % write the ordinate count and the fpath as a header
    
    fprintf(fid,'f.write(hStr)\r\n\r\n');
    fprintf(fid,'i = 0\r\n\r\nwhile i < xval:\r\n');
    fprintf(fid,' str = ''%%d'' %% x[i] + "," + ''%%.5f'' %% y[i] + "\\n"\r\n f.write(str)\r\n i = i+1\r\n\r\n');
end

fprintf(fid,'myDss.done()\r\nf.close()\r\n');
fclose(fid);

exStr = ['"C:\Program Files (x86)\HEC\HEC-DSSVue\HEC-DSSVue.exe" "' scFile '"'];
dos(exStr);

fid = fopen(outfile,'r');
header = textscan(fid,'%d%s%s%s',1,'delimiter','\t');
i = 1;

while ~feof(fid)
    temp = cell2mat(textscan(fid,'%f,%f',header{1},'collectoutput',true));
    data(i,1).path = header{2}{1};
    
    switch header{4}{1}
        case {'INST-VAL' 'INST-CUM' 'PER-AVER' 'PER-CUM'}
            %data(i).type = header{4}{1};
            %data(i).yUnits = header{3}{1};

            temp(:,1) = temp(:,1)/60/24+693961;
            data(i,1).startTime = upper(datestr(temp(1),'ddmmmyyyy HH:MM'));
            data(i).interval = (temp(2,1)-temp(1,1))*24*60;
            
            data(i).(SanitizeVar(type{i})) = temp(:,2);
            
            data(i).dssfile = file;
            
%             data(i).data = temp;
        otherwise
            data(i,1).xUnits = header{3}{1};
            data(i).yUnits = header{4}{1};
            data(i).data = temp;
            a = 1;
    end
    
    header = textscan(fid,'%d%s%s%s',1,'delimiter','\t');
    i = i+1;
end
fclose(fid);
% delete(outfile);

