function [ImgRot] = RandRot(Img,S,IsEuler)
      %random orientation in the sphere
    
if IsEuler
    X = 2*pi*rand() - pi ;% -180 to 180
	Y = pi*rand() - pi*0.5; % -90 to 90
	Z = 2*pi*rand() - pi; % -180 to 180
    q=compose_rotation(X(:),Y(:),Z(:));
else
%             u=randn(3,1);
%             q(:,1)=u/norm(u);
%         
%             u=randn(3,1);
%             u=u-(q(:,1)'*u)*q(:,1);
%             q(:,2)=u/norm(u);
%             
%             u=randn(3,1);
%             u=u-(q(:,1)'*u)*q(:,1)-(q(:,2)'*u)*q(:,2);
%             q(:,3)=u/norm(u);
             u=randn(3);
             [q,~,~]=svd(u,0);
             
end

ImgRot=RotateSphrImg(Img,S,q)  ;
%              Srot=q'*S;
% %       q(:,1)=q(:,1)/norm(q(:,1));
% %       q(:,2)=q(:,2)/norm(q(:,2));
% %       q(:,3)=q(:,3)/norm(q(:,3));
%       
%            
%           ImgRot=zeros(size(Img));
%             [Phi,Theta]=cart2sph(S(1,:),S(2,:),S(3,:));  
%             [PhiNew,ThetaNew]=cart2sph(Srot(1,:),Srot(2,:),Srot(3,:));
% %             [Xnew,Ynew,Znew]=sph2cart(PhiNew,ThetaNew,ones(size(Phi)));
% %             [PhiNew,ThetaNew]=cart2sph(Xnew,Ynew,Znew);
%              
%             for indx_=1:size(Phi(:))
%                 [~,CurrIndx]   = min(abs(Phi(:)-PhiNew(indx_))+abs(Theta(:)-ThetaNew(indx_)));
%                 ImgRot(indx_)=Img(CurrIndx(1));
%                 disp(CurrIndx);
%             end
             
end