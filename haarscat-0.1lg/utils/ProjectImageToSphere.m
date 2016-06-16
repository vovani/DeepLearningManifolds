function [ ImgSphere ] = ProjectImageToSphere( Img2D ,resize2D, alpha, Scoord )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
M0=resize2D(1);
p = 1;
dilf=0.2;
dilo=0.75;

      %  tmp=xifres(:,sli(isample));
        N=length(Scoord);
        
       % tmp = reshape(Img2D,OrgnImageSize);
        digit = imresize(Img2D,resize2D,'bicubic');
        
        if alpha == 1
            %random orientation in the sphere
            u=randn(3,1);q(:,1)=u/norm(u);
            u=randn(3,1);u=u-(q(:,1)'*u)*q(:,1);q(:,2)=u/norm(u);
            u=randn(3,1);u=u-(q(:,1)'*u)*q(:,1)-(q(:,2)'*u)*q(:,2);q(:,3)=u/norm(u);
        else
            u=alpha*randn(3)+(1-alpha)*diag([3 2 1]);
            [q,~,~]=svd(u,0);
        end
        
        c=q'*Scoord;
        I=find(c(1,:)>0);
        h=dilo+dilf*rand;
        bis = h*(c(:,I)./(repmat(c(1,I),[3 1])));
        bis= bis(2:3,:);
        II=find(max(abs(bis)) < p);
        bis = bis(:,II);
        bis = min(M0,max(1,round(M0/2 + (M0/(2*p))*bis)));
        slice=zeros(N,1);
        index = bis(1,:) + M0*(bis(2,:)-1);
        slice(I(II)) = digit(index);
        
        ImgSphere = slice;
end

