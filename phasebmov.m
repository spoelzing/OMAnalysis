nomore
load bmov

for row=1:44
    for col=1:30
        bmov2(:,row,col)=conv2(squeeze(bmov(:,row,col)),ones(1,13),'same');
        tmovie(:,row,col)=(hilbert(squeeze(bmov2(:,row,col))));
        movie(:,row,col)=angle(tmovie(:,row,col));
        %movie(:,row,col)=63*(movie(:,row,col)-min(movie(:,row,col)))/(max(movie(:,row,col))-min(movie(:,row,col)));
        bmov(:,row,col)=63*(bmov(:,row,col)-min(bmov(:,row,col)))/(max(bmov(:,row,col))-min(bmov(:,row,col)));
    end
end

if 1==1
    [x y z]=size(bmov)
    
for count=1:x
    smmovie(count,:,:)=conv2(squeeze(bmov(count,:,:)),1/9*ones(3),'valid');
    phmovie(count,:,:)=conv2(squeeze(movie(count,:,:)),1/9*ones(3),'valid');
end
else
    smmovie=bmov;
    phmovie=movie;
end


disp('Ready. Hit Enter to Continue')
pause


for count=1:x
figure(100)
imagesc(squeeze(phmovie(count,:,:)))
figure(101)
image(squeeze(smmovie(count,:,:)))

end