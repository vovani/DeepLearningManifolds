function [X_tr, C_tr, X_te, C_te] = haar_read_mnist_sphere(path_to_mnist, S, options)

if nargin < 4
    options = struct();
end
options = fill_struct(options, 'mode', 'uniform');

switch options.mode
    case 'uniform'
        alpha = 1;
    case 'mild'
        alpha = 0;
end

NClass = 9;

X_te = cell(NClass,1);
C_te = cell(NClass,1);
X_tr = cell(NClass,1);
C_tr = cell(NClass,1);
for iclass = 1:NClass
    X_tr{iclass} = [];
    X_te{iclass} = [];
end

N=4096;
% S=randn(3,N);
% S=S./repmat(sqrt(sum(S.^2)),[3 1]);

M0 = 128;
p = 1;
dilf=0.2;
dilo=0.75;

maxclasses=(0:NClass-1)';

[labels] = haar_readidx(fullfile(path_to_mnist,'mnist','train-labels-idx1-ubyte'),60000,60000);
[xifres] = haar_readidx(fullfile(path_to_mnist,'mnist','train-images-idx3-ubyte'),60000,60000);

for d=1:NClass
    d
    sli=find(labels==maxclasses(d));
    X_tr{d} = zeros(N,length(sli));
    C_tr{d} = zeros(3, N, length(sli));
    for isample=1:length(sli)
        tmp=xifres(:,sli(isample));
        tmp = reshape(tmp,28,28);
        digit = imresize(tmp,[M0 M0],'bicubic');
        
        if alpha == 1
            %random orientation in the sphere
            u=randn(3,1);q(:,1)=u/norm(u);
            u=randn(3,1);u=u-(q(:,1)'*u)*q(:,1);q(:,2)=u/norm(u);
            u=randn(3,1);u=u-(q(:,1)'*u)*q(:,1)-(q(:,2)'*u)*q(:,2);q(:,3)=u/norm(u);
        else
%             u=alpha*randn(3)+(1-alpha)*diag([3 2 1]);
%             [q,~,~]=svd(u,0);
            q = eye(size(S));
        end
        
        c=q'*S;
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
        
        X_tr{d}(:,isample) = slice;
        C_tr{d}(:, :, isample) = c;
    end
end

clear labels;
clear xifres;

[xifres] = haar_readidx(fullfile(path_to_mnist,'mnist','t10k-images-idx3-ubyte'),10000,10000);
[labels] = haar_readidx(fullfile(path_to_mnist,'mnist','t10k-labels-idx1-ubyte'),10000,10000);

for d=1:NClass
    d
    sli=find(labels==maxclasses(d));
    X_te{d} = zeros(N,length(sli));
    C_te{d} = zeros(3, N, length(sli));
    for isample=1:length(sli)
        tmp=xifres(:,sli(isample));
        tmp = reshape(tmp,28,28);
        digit = imresize(tmp,[M0 M0],'bicubic');
        
        if alpha == 1
            %random orientation in the sphere
            u=randn(3,1);q(:,1)=u/norm(u);
            u=randn(3,1);u=u-(q(:,1)'*u)*q(:,1);q(:,2)=u/norm(u);
            u=randn(3,1);u=u-(q(:,1)'*u)*q(:,1)-(q(:,2)'*u)*q(:,2);q(:,3)=u/norm(u);
        else
            u=alpha*randn(3)+(1-alpha)*diag([3 2 1]);
            [q,~,~]=svd(u,0);
        end
        
        c=q'*S;
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
        
        X_te{d}(:,isample) = slice;
        C_te{d}(:, :, isample) = c;
    end
end


end