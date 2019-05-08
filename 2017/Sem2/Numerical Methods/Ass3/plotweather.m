
%dat points is (columns) lat, lon, air speed, air temp, dew point, baro
%pressure, rainfall, humidity, wind speed
%Collecting data points
datpoints1 =importdata('BOM_20170823130000.dat');
datpoints13 = importdata('BOM_20170823133000.dat');
datpoints2 =importdata('BOM_20170823140000.dat');
datpoints23 =importdata('BOM_20170823143000.dat');
lonlat = importdata('sa_coast_lonlat.dat'); %

x= linspace(138.2,139.4);
y= linspace(-35.6,-34.4);
[X,Y] = meshgrid(x,y);
stations = ["Adelaide Airport", "Adelaide (Kent Town)", "Adelaide (West Terrace)", "Edinburgh", "Hindmarsh Island", "Kuitpo", "Mount Crawford", "Mount Lofty", "Noarlunga", "Nuriootpa", "Pallamanna", "Paraeld", "Parawa West", "Roseworthy", "Strathalbyn"]';
f1=polyharm(X,Y,datpoints1(:,2),datpoints1(:,1),datpoints1(:,7));
f13=polyharm(X,Y,datpoints1(:,2),datpoints1(:,1),datpoints13(:,7));
f2=polyharm(X,Y,datpoints1(:,2),datpoints1(:,1),datpoints2(:,7));
f23 =polyharm(X,Y,datpoints1(:,2),datpoints1(:,1),datpoints23(:,7));
plot(datpoints1(:,2),datpoints(:,1),'r.')
p = contour(X,Y,f1);
plot(lonlat(:,1),lonlat(:,2),'k')
text(datpoints1(:,2),datpoints(:,1),char(stations))
d = colorbar;
ylabel(d,'Rainfall (mm)')
axis([138 139.5 -35.7 -34.4])
hold off

pause(0.05)
hold on
d = colorbar;
ylabel(d,'Rainfall (mm)')
axis([138 139.5 -35.7 -34.4])
contour(X,Y,f13)
plot(lonlat(:,1),lonlat(:,2),'k')
hold off

pause(0.05)

d = colorbar;
ylabel(d,'Rainfall (mm)')
axis([138 139.5 -35.7 -34.4])
contour(X,Y,f2)
plot(lonlat(:,1),lonlat(:,2),'k')
hold off

pause(0.05)

d = colorbar;
ylabel(d,'Rainfall (mm)')
axis([138 139.5 -35.7 -34.4])
contour(X,Y,f23)
plot(lonlat(:,1),lonlat(:,2),'k')
hold off