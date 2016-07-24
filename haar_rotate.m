function [ X ] = haar_rotate( grid_img, S )
    N = size(S,2);
    M0 = 128;
    p = 1;
    tmp = grid_img;
    digit = imresize(tmp,[M0 M0],'bicubic');

    u=randn(3,1);q(:,1)=u/norm(u);
    u=randn(3,1);u=u-(q(:,1)'*u)*q(:,1);q(:,2)=u/norm(u);
    u=randn(3,1);u=u-(q(:,1)'*u)*q(:,1)-(q(:,2)'*u)*q(:,2);q(:,3)=u/norm(u);

    c=q'*S;
    I=find(c(1,:)>0);
    bis = (c(:,I)./(repmat(c(1,I),[3 1])));
    bis= bis(2:3,:);
    II=find(max(abs(bis)) < p);
    bis = bis(:,II);
    bis = min(M0,max(1,round(M0/2 + (M0/(2*p))*bis)));
    X=zeros(N,1);
    index = bis(1,:) + M0*(bis(2,:)-1);
    X(I(II)) = digit(index);
end

