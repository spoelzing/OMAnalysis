function F = myfun(x,xdata)
F= x(1)*sin(2*pi*x(2)/1000*xdata +x(3))-x(4)+x(5)*sin(2*pi*x(6)/1000*xdata+x(7))+x(8)*xdata;