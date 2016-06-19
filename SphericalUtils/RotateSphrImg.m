function ImgRot=RotateSphrImg(Img,S,RotMtrx)        
    
    ImgRot=zeros(size(Img));
    Srot=RotMtrx'*S;
%       q(:,1)=q(:,1)/norm(q(:,1));
%       q(:,2)=q(:,2)/norm(q(:,2));
%       q(:,3)=q(:,3)/norm(q(:,3));

    [Phi,Theta]=cart2sph(S(1,:),S(2,:),S(3,:));  
    [PhiNew,ThetaNew]=cart2sph(Srot(1,:),Srot(2,:),Srot(3,:));
    nPoints=length(Phi(:));
%             [Xnew,Ynew,Znew]=sph2cart(PhiNew,ThetaNew,ones(size(Phi)));
%             [PhiNew,ThetaNew]=cart2sph(Xnew,Ynew,Znew);
             
    for indx_=1:size(Phi(:))
        %  distance(,'radians')
        ArrPoints=repmat([ThetaNew(indx_) PhiNew(indx_)],nPoints,1);
        dist_=distance(([Theta; Phi])', ArrPoints,'radians' );
        [MinPoints,MinIndx] =sort(dist_);
        Wiegths=exp(-MinPoints(1:4));
        Wiegths=Wiegths/sum(Wiegths);
        %                 [~,CurrIndx]   = min(abs(Phi(:)-PhiNew(indx_))+abs(Theta(:)-ThetaNew(indx_)));
         ImgRot(indx_)=sum(Wiegths.*Img(MinIndx(1:4)));
        %disp(CurrIndx);
    end
end