clc
clear all
format long

%User inputs for number of files and probe columns
r = input('Number of files where pressure is increasing?');
p = input('Number of files where pressure is decreasing?');
q = r + p;
x = input('First Probe Column?');
y = input('Last Probe Column?');
disp('Please input increasing data first and decreasing data second.')
n = 1;
m = x;
s = 0;
data2 = zeros(4);

%Loop used to get rid of first row of zeros, determine mean and pressure matrices
for k = 1:q
  [filename1, pathname] = uigetfile;
  data1 = csvread(strcat(pathname,filename1));
  z(k,:) = input('What is the pressure?')
  while m <=y
    for n = 1:length(data1)
        if data1(n,m) == 0
          s = s + 1;
          continue
        elseif data1(n,m) > 0
          data2((n-s),(m-x+1)) = data1(n,m);
        end
     end
    s = 0;
    m = m + 1;
     end
  mn(k,:) = mean(data2);
  m=x;
  clear data2
end

%Loop used to assemble polyfit matrix for increasing data
for k = 1:(y-x+1)
  f1(:,:,k) = polyfit(mn((1:r),k),z((1:r),1),1);
  f2(:,:,k) = polyfit(mn(((r+1):q),k),z(((r+1):q),1),1);
end

%Loop to form Hysteresis graphs
%D is arbitrary domain to graph data
d = [0:.001:.25];
for k = (x-1):(y-1)
  figure
  mxu = f1(1,1,(k+2-x));
  mxd = f2(1,1,(k+2-x));
  bu = f1(1,2,(k+2-x));
  bd = f2(1,2,(k+2-x));
  yxu = mxu*d + bu;
  yxd = mxd*d + bd;
  plot(d,yxu,d,yxd)
  title(['Probe ' num2str(k)])
  legend('Increasing','Decreasing')
  xlabel('Voltage')
  ylabel('Pressure')
end
