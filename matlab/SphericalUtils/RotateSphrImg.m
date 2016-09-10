function ImgRot=RotateSphrImg(Img,S,RotMtrx)        
          ImgRot=zeros(size(Img));

    Srot=RotMtrx'*S;
%       q(:,1)=q(:,1)/norm(q(:,1));
%       q(:,2)=q(:,2)/norm(q(:,2));
%       q(:,3)=q(:,3)/norm(q(:,3));
      
           
          
            [Phi,Theta]=cart2sph(S(1,:),S(2,:),S(3,:));  
            [PhiNew,ThetaNew]=cart2sph(Srot(1,:),Srot(2,:),Srot(3,:));
%             [Xnew,Ynew,Znew]=sph2cart(PhiNew,ThetaNew,ones(size(Phi)));
%             [PhiNew,ThetaNew]=cart2sph(Xnew,Ynew,Znew);
             
            for indx_=1:size(Phi(:))
                [~,CurrIndx]   = min(abs(Phi(:)-PhiNew(indx_))+abs(Theta(:)-ThetaNew(indx_)));
                ImgRot(indx_)=Img(CurrIndx(1));
                %disp(CurrIndx);
            end
end