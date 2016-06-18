function R = compose_rotation(x, y, z)
    N=length(x);
	if (N==1)
        X = eye(3,3);
        Y = eye(3,3);
        Z = eye(3,3);

        X(2,2) = cos(x);
        X(2,3) = -sin(x);
        X(3,2) = sin(x);
        X(3,3) = cos(x);

        Y(1,1) = cos(y);
        Y(1,3) = sin(y);
        Y(3,1) = -sin(y);
        Y(3,3) = cos(y);

        Z(1,1) = cos(z);
        Z(1,2) = -sin(z);
        Z(2,1) = sin(z);
        Z(2,2) = cos(z);

        R = Z*Y*X;
    else
        IndMtrx(1,:,:)=eye(3,3);
        X = repmat(IndMtrx,N,1,1);
        Y = repmat(IndMtrx,N,1,1);
        Z = repmat(IndMtrx,N,1,1);

        X(:,2,2) = cos(x);
        X(:,2,3) = -sin(x);
        X(:,3,2) = sin(x);
        X(:,3,3) = cos(x);

        Y(:,1,1) = cos(y);
        Y(:,1,3) = sin(y);
        Y(:,3,1) = -sin(y);
        Y(:,3,3) = cos(y);

        Z(:,1,1) = cos(z);
        Z(:,1,2) = -sin(z);
        Z(:,2,1) = sin(z);
        Z(:,2,2) = cos(z);
        
        R=zeros(N,3,3);
        for i=1:N
            R(i,:,:) = squeeze(Z(i,:,:))*squeeze(Y(i,:,:))*squeeze(X(i,:,:));
        end
    end
end
