function [Vector] = Velcal(xyt,VP)  %VP= velocity parameter

x=xyt(:,1);
y=xyt(:,2);
t=xyt(:,3);
M=length(xyt(:,1));
XYT=zeros(M,13);
for i=1:M
   dx=abs(xyt(:,1)-xyt(i,1));
   dy=abs(xyt(:,2)-xyt(i,2));
   dt=abs(xyt(:,3)-xyt(i,3));
   %find dx dy dt 
   %------------------------------------------------------------------------
   near=find((dx<=VP.how_nearxy)&(dy<=VP.how_nearxy)&(dt<=VP.how_neart));
   len=length(near);
   %specify the points by using the points that are close enough
   %------------------------------------------------------------------------
   
   if len>VP.how_many
      xytn=xyt(near,:)-ones(len,1)*xyt(i,:);
      x=xytn(:,1)*VP.X/1000;%unit of X,Y are mM
      y=xytn(:,2)*VP.Y/1000;
      t=xytn(:,3);
      %find dx dy dt of the specific points that are acceptable
      %------------------------------------------------------------------------
      fit     = [ones(len,1) x y x.^2 y.^2 x.*y];
      coefs   = fit\t;
      resi    = sqrt(sum((t-fit*coefs).^2)/sum(t.^2));
      resilin = sqrt(sum((t-fit(:,1:3)*coefs(1:3)).^2)/sum(t.^2));
      XYT(i,:)= [xyt(i,:),coefs',resi,len,cond(fit),resilin];
    end
end

fitlist=find( (XYT(:,1)~=0) & (XYT(:,2)~=0));
XYT=XYT(fitlist,:);


%------------------------------------------------------------------------------------------
%Find the Velocity
%------------------------------------------------------------------------------------------
%resthresh : threshold for residual error
%outliers  : switch to set if you wish to exclude outliers
%mspersamp : scale velocity by sampling interval in time
%MAXV      :  ignore velocities larger than MAXV

Vector.X=XYT(:,1);
Vector.Y=XYT(:,2);
Vector.T=XYT(:,3);

% Vector.Vx=(XYT(:,5)./(XYT(:,5).^2 + XYT(:,6).^2))*1000;
% Vector.Vy=(XYT(:,6)./(XYT(:,5).^2 + XYT(:,6).^2))*1000;
Vector.Vx=(XYT(:,5)./(XYT(:,5).^2 + XYT(:,6).^2))*VP.Srate; 
Vector.Vy=(XYT(:,6)./(XYT(:,5).^2 + XYT(:,6).^2))*VP.Srate; 



Vector.V=sqrt(Vector.Vx.^2+Vector.Vy.^2);
            

badNaN=(isnan(Vector.Vx)|isnan(Vector.Vy));
bad1=(XYT(:,10)>VP.resthresh);
%bad2=(XYT(:,12)>1000);
bad3=(Vector.V>VP.Vmax);
%bad10=(XYT(:,13)>0.95);

bad=find(bad1|bad3|badNaN);
%bad=find(bad1|bad10|bad2|bad3|badNaN);
%bad=find(bad3|badNaN|bad10);
%bad=find(bad3|badNaN);

Vector.Vx(bad)=[];Vector.Vy(bad)=[];Vector.X(bad)=[];Vector.Y(bad)=[];Vector.T(bad)=[];Vector.V(bad)=[];
