function GEplot_3D(filename,Lat_susp,Lon_susp,Elev_susp,style_susp,Lat_bot,Lon_bot,Elev_bot,style_bot,ERH,Spawning_Location,T2_Gas_bladder,opt11,opt12,opt21,opt22)
%
%3D adaptation of GEplot.  3D version will plot a 3 dimensional plot given the added elevation vector
%input--P.R. Jackson, USGS, 1-16-08
%input-- Tatiana Garcia, USGS, 5-18-15.  This version generates a 3D plot
%with two line paths or two folders with placemarks and two colors.
%The symbols where changed to the shaded dot from google earth images.
%            1         2       3         4          5        6       7        8         9     10  11    12    13    14  15
%Eplot_3D(filename,Lat_susp,Lon_susp,Elev_susp,style_susp,Lat_bot,Lon_bot,Elev_bot,style_bot,ERH,Xi,opt11,opt12,opt21,opt22)
% function GEplot(filename,Lat,Lon,style,opt11,opt12,opt21,opt22)
% function GEplot_3D(filename,Lat,Lon,Elev,style,opt11,opt12,opt21,opt22)

% Description: creates a file in kml format that can be opened into Google Earth.
%    GEplot_3D uses the same syntax as the traditional plot function but
%    requires Latitude and Longitudd (WGS84) instead of x and y (note that Lat is
%    the first argument).
%    If you need to convert from UTM to Lat/Lon you may use utm2deg.m also
%    available at Matlab Central
%
% Arguments:
%    filename Example 'rafael', will become 'rafael.kml'.  The same name
%             will appear inside Temporary Places in Google Earth as a layer.
%    dot_size Approximate size of the mark, in meters
%    Lat, Lon Vectors containing Latitudes and Longitudes.  The number of marks
%             created by this function is equal to the length of Lat/Lon vectors
%(opt)style   allows for specifying symbols and colors (line styles are not
%             supported by Google Earth currently. (see bellow)
%(opt)opt...   allows for specifying symbol size and line width (see bellow)
%
% Example:
%    GEplot('my_track',Lat,Lon,'o-r','MarkerSize',10,'LineWidth',3)
%    GEplot('my_track',Lat,Lon)
%
% Plot style parameters implemented in GEplot
%            color               symbol                line style
%            -----------------------------------------------------------
%            b     blue          .     point              -    solid
%            g     green         o     circle          (none)  no line
%            r     red           x     x-mark
%            c     cyan          +     plus
%            m     magenta       *     star
%            y     yellow        s     square
%            k     black         d     diamond
%            w     white (new)   S     filled square (new)
%                                D     filled diamond (new)
%                                O     filled circle=big dot (new)
%
% Plot properties: 'MarkerSize' 'LineWidth'
%
% Additional Notes:
% 'Hold on' and 'Hold off' were not implemented since one can generate a
%    .kmz file for each plot and open all simultaneously within GE.
% Unless you have a lot of data point it is recomended to show the symbols
%    since they are created in a separate folder so within Google Earth it
%    is very easy to show/hide the line or the symbols.
% Current kml/kmz format does not support different linestyles, just solid.
%    Nevertheless it is possible to define the opacity of the color (the
%    first FF in the color definition means no transparency).
% Within Matlab, it is possible to generate a second plot with the
%    same name, then you just need to select File/Revert within GE to update.
%
%
% Author: Rafael Palacios, Universidad Pontificia Comillas
% http://www.iit.upcomillas.es/palacios
% November 2006
% Version 1.1: Fixed an error while plotting graphs without symbols.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Argument checking
%
error(nargchk(11,15, nargin));  %8 arguments required, 14 maximum
n1=length(Lat_susp);
n2=length(Lon_susp);
n3=length(Elev_susp);
if (n1~=n2 | n1~=n3)
    error('Lat, Lon, and Elev vectors should have the same length');
end
n4=length(Lat_bot);
n5=length(Lon_bot);
n6=length(Elev_bot);
if (n4~=n5 | n4~=n6)
    error('Lat, Lon, and Elev vectors should have the same length');
end
if (nargin==13 || nargin==15)
    error('size arguments must be "MarkerSize" or "LineWidth" strings followed by a number');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% symbol size and line width
%
markersize=7; %matlab default
linewidth=2;  %matlab default is 0.5, too thin for map overlay
if (nargin==14)
    if (strcmpi(opt11,'markersize')==1)
        markersize=opt12;
    elseif (strcmpi(opt11,'linewidth')==1)
        linewidth=opt12;
    else
        error('size arguments must be "MarkerSize" or "LineWidth" strings followed by a number');
    end
end
if (nargin==16)
    if (strcmpi(opt21,'markersize')==1)
        markersize=opt22;
    elseif (strcmpi(opt21,'linewidth')==1)
        linewidth=opt22;
    else
        error('size arguments must be "MarkerSize" or "LineWidth" strings followed by a number');
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% symbol, line style and color
%
symbol='none';
iconfilename='none';
linestyle='-';
color='b';
colorstring='7fff0000';

if (nargin>=9)
    %linestyle
    if (strfind(style_susp,'-'))
        linestyle='-';
    else
        linestyle='none';
    end
    %%
    if (strfind(style_bot,'-'))
        linestyle='-';
    else
        linestyle='none';
    end
    %%
    %symbol
    if (strfind(style_susp,'.')), symbol='.'; iconfilename_susp='dot'; end
    if (strfind(style_susp,'o')), symbol='o'; iconfilename_susp='circle'; end
    if (strfind(style_susp,'x')), symbol='x'; iconfilename_susp='x'; end
    if (strfind(style_susp,'+')), symbol='+'; iconfilename_susp='plus'; end
    if (strfind(style_susp,'*')), symbol='*'; iconfilename_susp='star'; end
    if (strfind(style_susp,'s')), symbol='s'; iconfilename_susp='square'; end
    if (strfind(style_susp,'d')), symbol='d'; iconfilename_susp='diamond'; end
    if (strfind(style_susp,'S')), symbol='S'; iconfilename_susp='Ssquare'; end
    if (strfind(style_susp,'D')), symbol='D'; iconfilename_susp='Sdiamon'; end
    if (strfind(style_susp,'O')), symbol='O'; iconfilename_susp='dot'; end
    if (strfind(style_susp,'0')), symbol='O'; iconfilename_susp='dot'; end
    
    if (strfind(style_bot,'.')), symbol='.'; iconfilename_bot='dot'; end
    if (strfind(style_bot,'o')), symbol='o'; iconfilename_bot='circle'; end
    if (strfind(style_bot,'x')), symbol='x'; iconfilename_bot='x'; end
    if (strfind(style_bot,'+')), symbol='+'; iconfilename_bot='plus'; end
    if (strfind(style_bot,'*')), symbol='*'; iconfilename_bot='star'; end
    if (strfind(style_bot,'s')), symbol='s'; iconfilename_bot='square'; end
    if (strfind(style_bot,'d')), symbol='d'; iconfilename_bot='diamond'; end
    if (strfind(style_bot,'S')), symbol='S'; iconfilename_bot='Ssquare'; end
    if (strfind(style_bot,'D')), symbol='D'; iconfilename_bot='Sdiamon'; end
    if (strfind(style_bot,'O')), symbol='O'; iconfilename_bot='dot'; end
    if (strfind(style_bot,'0')), symbol='O'; iconfilename_bot='dot'; end
    
    %color
    if (strfind(style_susp,'b')), color_susp='b'; colorstring_susp='7fff0000'; end
    if (strfind(style_susp,'g')), color_susp='g'; colorstring_susp='7f00ff00'; end
    if (strfind(style_susp,'r')), color_susp='r'; colorstring_susp='7f0000ff'; end
    if (strfind(style_susp,'c')), color_susp='c'; colorstring_susp='7fffff00'; end
    if (strfind(style_susp,'m')), color_susp='m'; colorstring_susp='7fff00ff'; end
    if (strfind(style_susp,'y')), color_susp='y'; colorstring_susp='7f00ffff'; end
    if (strfind(style_susp,'k')), color_susp='k'; colorstring_susp='7f000000'; end
    if (strfind(style_susp,'w')), color_susp='w'; colorstring_susp='7fffffff'; end
    
    if (strfind(style_bot,'b')), color_bot='b'; colorstring_bot='7fff0000'; end
    if (strfind(style_bot,'g')), color_bot='g'; colorstring_bot='7f00ff00'; end
    if (strfind(style_bot,'r')), color_bot='r'; colorstring_bot='7f0000ff'; end
    if (strfind(style_bot,'c')), color_bot='c'; colorstring_bot='7fffff00'; end
    if (strfind(style_bot,'m')), color_bot='m'; colorstring_bot='7fff00ff'; end
    if (strfind(style_bot,'y')), color_bot='y'; colorstring_bot='7f00ffff'; end
    if (strfind(style_bot,'k')), color_bot='k'; colorstring_bot='7f000000'; end
    if (strfind(style_bot,'w')), color_bot='w'; colorstring_bot='7fffffff'; end
end

% iconfilename_susp=strcat('GEimages/',iconfilename_susp,'_',color_susp,'.png');
% iconfilename_bot=strcat('GEimages/',iconfilename_bot,'_',color_bot,'.png');

if (symbol=='.')
    markersize=markersize/5;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creating kml file
%
fp=fopen(strcat(filename,'.kml'),'w');
if (fp==-1)
    message=disp('Unable to open file %s.kml',filename);
    error(message);
end
fprintf(fp,'<?xml version="1.0" encoding="UTF-8"?>\n');
fprintf(fp,'<kml xmlns="http://earth.google.com/kml/2.1">\n');
fprintf(fp,'<Document>\n');
name=regexp(filename, '\\', 'split');name=name(end);

%Symbol styles definition
%%=======================================================================================================
fprintf(fp,'<Style id="mystyle1">\n');
fprintf(fp,'   <IconStyle>\n');
fprintf(fp,'      <color>%s</color>\n',colorstring_susp);
fprintf(fp,'      <scale>%.2f</scale>\n',markersize); %scale adjusted for .png image sizes
fprintf(fp,'      <Icon><href>http://maps.google.com/mapfiles/kml/shapes/shaded_dot.png</href></Icon>\n');
fprintf(fp,'   </IconStyle>\n');
% fprintf(fp,'   <IconStyle>\n');
% fprintf(fp,'      <scale>%.2f</scale>\n',markersize/14); %scale adjusted for .png image sizes
% fprintf(fp,'      <Icon><href>%s</href></Icon>\n',iconfilename_susp);
% fprintf(fp,'   </IconStyle>\n');
fprintf(fp,'   <LineStyle>\n');
fprintf(fp,'      <color>%s</color>\n',colorstring_susp);
fprintf(fp,'      <width>%d</width>\n',linewidth);
fprintf(fp,'   </LineStyle>\n');
fprintf(fp,'   <PolyStyle>\n');
fprintf(fp,'      <color>7fffffff</color>\n');
fprintf(fp,'      <colorMode>normal</colorMode>\n');
fprintf(fp,'      <fill>1</fill>\n');
fprintf(fp,'      <outline>1</outline>\n');
fprintf(fp,'   </PolyStyle>\n');
fprintf(fp,'</Style>\n');
fprintf(fp,'\n');
%%=======================================================================================================
fprintf(fp,'<Style id="mystyle2">\n');
fprintf(fp,'   <IconStyle>\n');
fprintf(fp,'      <color>%s</color>\n',colorstring_bot);
fprintf(fp,'      <scale>%.2f</scale>\n',markersize); %scale adjusted for .png image sizes
fprintf(fp,'      <Icon><href>http://maps.google.com/mapfiles/kml/shapes/shaded_dot.png</href></Icon>\n');
fprintf(fp,'   </IconStyle>\n');
fprintf(fp,'   <LineStyle>\n');
fprintf(fp,'      <color>%s</color>\n',colorstring_bot);
fprintf(fp,'      <width>%d</width>\n',linewidth);
fprintf(fp,'   </LineStyle>\n');
fprintf(fp,'   <PolyStyle>\n');
fprintf(fp,'      <color>7fffffff</color>\n');
fprintf(fp,'      <colorMode>normal</colorMode>\n');
fprintf(fp,'      <fill>1</fill>\n');
fprintf(fp,'      <outline>1</outline>\n');
fprintf(fp,'   </PolyStyle>\n');
fprintf(fp,'</Style>\n');
fprintf(fp,'\n');
%%=======================================================================================================


if (linestyle=='-')
    if T2_Gas_bladder==0 % If user did not simulate larvae stage...
        fprintf(fp,'<name>%s</name>\n',['Longitudinal distribution of eggs at hatching time ' char(name)]);
        fprintf(fp,'<description>Longitudinal distribution of eggs (using GEplot.m and the VMT version-GEplot_3D.m)</description>\n');
        %%
        fprintf(fp,'    <Placemark>\n');
        fprintf(fp,'      <description><![CDATA[Longitudinal distribution of eggs in suspension]]></description>\n');
        fprintf(fp,'      <name>Eggs in suspension</name>\n');
        fprintf(fp,'      <visibility>1</visibility>\n');
        fprintf(fp,'      <open>1</open>\n');
        fprintf(fp,'      <styleUrl>mystyle1</styleUrl>\n');
        fprintf(fp,'      <LineString>\n');
        fprintf(fp,'        <extrude>1</extrude>\n');
        fprintf(fp,'        <tessellate>1</tessellate>\n');
        fprintf(fp,'        <altitudeMode>relativeToGround</altitudeMode>\n');
        fprintf(fp,'        <coordinates>\n');
        for k=1:n1
            fprintf(fp,'%.6f,%.6f,%07.2f\n',Lon_susp(k),Lat_susp(k),Elev_susp(k)); %max(Elev)-
        end
        fprintf(fp,'        </coordinates>\n');
        fprintf(fp,'      </LineString>\n');
        fprintf(fp,'    </Placemark>\n');
        %%
        if ~isempty(Lat_bot)
            
            fprintf(fp,'    <Placemark>\n');
            fprintf(fp,'      <description><![CDATA[Longitudinal distribution of eggs near the bottom]]></description>\n');
            fprintf(fp,'      <name>Eggs near the bottom</name>\n');
            fprintf(fp,'      <visibility>1</visibility>\n');
            fprintf(fp,'      <open>1</open>\n');
            fprintf(fp,'      <styleUrl>mystyle2</styleUrl>\n');
            fprintf(fp,'      <LineString>\n');
            fprintf(fp,'        <extrude>1</extrude>\n');
            fprintf(fp,'        <tessellate>1</tessellate>\n');
            fprintf(fp,'        <altitudeMode>relativeToGround</altitudeMode>\n');
            fprintf(fp,'        <coordinates>\n');
            for k=1:n4
                fprintf(fp,'%.6f,%.6f,%07.2f\n',Lon_bot(k),Lat_bot(k),Elev_bot(k)); %max(Elev)-
            end
            fprintf(fp,'        </coordinates>\n');
            fprintf(fp,'      </LineString>\n');
            fprintf(fp,'    </Placemark>\n');
        end
        %%
        % Peak egg concentration
        idmax=find(Elev_susp==max(Elev_susp));idmax=idmax(1);
        %
        fprintf(fp,'    <Placemark>\n');
        fprintf(fp,'<name>%s</name>\n',['Approximately ' num2str(round((ERH*10)/10)) '% of eggs are at risk of hatching']);
        fprintf(fp,'    <Style>\n');
        fprintf(fp,'    <IconStyle>\n');
        fprintf(fp,'    <scale>0</scale>\n');
        fprintf(fp,'    <color>ffffff00</color>\n');
        fprintf(fp,'    </IconStyle>\n');
        fprintf(fp,'    </Style>\n');
        fprintf(fp,'    <Point>\n');
        fprintf(fp,'    <gx:drawOrder>1</gx:drawOrder>\n');
        fprintf(fp,'    <coordinates>%.6f,%.6f,%07.2f</coordinates>\n',Lon_susp(idmax),Lat_susp(idmax),Elev_susp(idmax));
        fprintf(fp,'        <altitudeMode>relativeToGround</altitudeMode>\n');
        fprintf(fp,'    </Point>\n');
        fprintf(fp,'    </Placemark>\n');
        
    else
        fprintf(fp,'<name>%s</name>\n',['Longitudinal distribution of larvae at gas bladder inflation stage ' char(name)]);
        fprintf(fp,'<description>Longitudinal distribution of of larvae at gas bladder inflation stage (using GEplot.m and the VMT version-GEplot_3D.m)</description>\n');
        %%
        fprintf(fp,'    <Placemark>\n');
        fprintf(fp,'      <description><![CDATA[Longitudinal distribution of of larvae at gas bladder inflation stage]]></description>\n');
        fprintf(fp,'      <name>Larvae at gas bladder stage</name>\n');
        fprintf(fp,'      <visibility>1</visibility>\n');
        fprintf(fp,'      <open>1</open>\n');
        fprintf(fp,'      <styleUrl>mystyle1</styleUrl>\n');
        fprintf(fp,'      <LineString>\n');
        fprintf(fp,'        <extrude>1</extrude>\n');
        fprintf(fp,'        <tessellate>1</tessellate>\n');
        fprintf(fp,'        <altitudeMode>relativeToGround</altitudeMode>\n');
        fprintf(fp,'        <coordinates>\n');
        for k=1:n1
            fprintf(fp,'%.6f,%.6f,%07.2f\n',Lon_susp(k),Lat_susp(k),Elev_susp(k)); %max(Elev)-
        end
        fprintf(fp,'        </coordinates>\n');
        fprintf(fp,'      </LineString>\n');
        fprintf(fp,'    </Placemark>\n');
        %%
    end
end %if distribution
%%=======================================================================================================

if (strcmp(symbol,'none')==0)
    if ~isempty(Lat_bot)
        fprintf(fp,'<name>%s</name>\n',['Egg plume at hatching time ' char(name)]);
        fprintf(fp,'<description>Streamwise location of eggs at hatching time (using GEplot.m and the VMT version-GEplot_3D.m)</description>\n');
    else
        fprintf(fp,'<name>%s</name>\n',['Larvae (gas bladder stage) plume ' char(name)]);
        fprintf(fp,'<description>Streamwise location of gas bladder stage larvae (using GEplot.m and the VMT version-GEplot_3D.m)</description>\n');
    end
    
    %%=======================================================================================================
    fprintf(fp,'    <Folder>\n');
    if ~isempty(Lat_bot)
        fprintf(fp,'      <name>Streamwise position of eggs in suspension</name>\n');
    else
        fprintf(fp,'      <name>Streamwise position of larvae at gas bladder stage</name>\n');
    end
    for k=1:n1
        fprintf(fp,'      <Placemark>\n');
        fprintf(fp,'         <description><![CDATA[Egg location]]></description>\n');
        %    fprintf(fp,'         <name>Point %d</name>\n',k);  %you may add point labels here
        fprintf(fp,'         <visibility>1</visibility>\n');
        fprintf(fp,'         <open>1</open>\n');
        fprintf(fp,'         <styleUrl>mystyle1</styleUrl>\n');
        fprintf(fp,'         <Point>\n');
        fprintf(fp,'           <coordinates>\n');
        fprintf(fp,'%.6f,%.6f,%07.2f\n',Lon_susp(k),Lat_susp(k),Elev_susp(k)); %max(Elev)-
        fprintf(fp,'           </coordinates>\n');
        fprintf(fp,'         </Point>\n');
        fprintf(fp,'      </Placemark>\n');
    end
    fprintf(fp,'    </Folder>\n');
    %%=======================================================================================================
    
    if ~isempty(Lat_bot)
        fprintf(fp,'    <Folder>\n');
        fprintf(fp,'      <name>Streamwise position of eggs near the bed</name>\n');
        for k=1:n4
            fprintf(fp,'      <Placemark>\n');
            fprintf(fp,'         <description><![CDATA[Egg location]]></description>\n');
            %    fprintf(fp,'         <name>Point %d</name>\n',k);  %you may add point labels here
            fprintf(fp,'         <visibility>1</visibility>\n');
            fprintf(fp,'         <open>1</open>\n');
            fprintf(fp,'         <styleUrl>mystyle2</styleUrl>\n');
            fprintf(fp,'         <Point>\n');
            fprintf(fp,'           <coordinates>\n');
            fprintf(fp,'%.6f,%.6f,%07.2f\n',Lon_bot(k),Lat_bot(k),Elev_bot(k)); %max(Elev)-
            fprintf(fp,'           </coordinates>\n');
            fprintf(fp,'         </Point>\n');
            fprintf(fp,'      </Placemark>\n');
        end
        fprintf(fp,'    </Folder>\n');
    end
    %%=======================================================================================================
end

%%=======================================================================================================
fprintf(fp,'    <Placemark>\n');
fprintf(fp,'<name>%s</name>\n',['Spawning location']);
fprintf(fp,'    <Style>\n');
fprintf(fp,'    <IconStyle>\n');
fprintf(fp,'    <Icon>\n');
fprintf(fp,'    <href>http://maps.google.com/mapfiles/kml/shapes/fishing.png</href>\n');
fprintf(fp,'    </Icon>\n');
fprintf(fp,'    <scale>1.2</scale>\n');
fprintf(fp,'    <color>ffffff00</color>\n');
fprintf(fp,'    </IconStyle>\n');
fprintf(fp,'    </Style>\n');
fprintf(fp,'    <Point>\n');
%fprintf(fp,'    <gx:drawOrder>1</gx:drawOrder>\n');
fprintf(fp,'    <coordinates>%.6f,%.6f,%07.2f</coordinates>\n',Spawning_Location(2),Spawning_Location(1),0);
fprintf(fp,'        <altitudeMode>relativeToGround</altitudeMode>\n');
fprintf(fp,'    </Point>\n');
fprintf(fp,'    </Placemark>\n');
%%=======================================================================================================

fprintf(fp,'</Document>\n');
fprintf(fp,'</kml>\n');

fclose(fp);
