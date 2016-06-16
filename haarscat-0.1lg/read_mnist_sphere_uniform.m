function [X_tr, X_te,S,Theta,Phi,theta,phi] = read_mnist_sphere_uniform(path_to_mnist, options)

if nargin < 2
    options = struct();
end
options = fill_struct(options, 'mode', 'uniform');

switch options.mode
    case 'uniform'
        alpha = 1;
    case 'mild'
        alpha = 0;
end

NClass = 10;

X_te = cell(NClass,1);
X_tr = cell(NClass,1);
for iclass = 1:NClass
    X_tr{iclass} = [];
    X_te{iclass} = [];
end

N=4096;
S=zeros(3,N);
n=sqrt(N);
theta=linspace(0,2*pi,n+1);
theta=theta(1:end-1);
phi=linspace(0,pi,n+1);
phi=phi(1:end-1);
[Theta,Phi]=meshgrid(theta,phi);
Theta=Theta(:);
Phi=Phi(:);
[S(1,:),S(2,:),S(3,:)]=sph2cart(Phi,Theta,ones(size(Phi)));
%S=randn(3,N);
%S=S./repmat(sqrt(sum(S.^2)),[3 1]);

M0 = 128;
p = 1;
dilf=0.2;
dilo=0.75;

maxclasses=(0:NClass-1)';


[labels] = readidx(fullfile(path_to_mnist,'mnist','train-labels.idx1-ubyte'),60000,60000);
[xifres] = readidx(fullfile(path_to_mnist,'mnist','train-images.idx3-ubyte'),60000,60000);

for d=1:NClass
    d
    sli=find(labels==maxclasses(d));
    X_tr{d} = zeros(N,length(sli));
    
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
        
        X_tr{d}(:,isample) = slice;
    end
end

clear labels;
clear xifres;

[xifres] = readidx(fullfile(path_to_mnist,'mnist','t10k-images.idx3-ubyte'),10000,10000);
[labels] = readidx(fullfile(path_to_mnist,'mnist','t10k-labels.idx1-ubyte'),10000,10000);

for d=1:NClass
    d
    sli=find(labels==maxclasses(d));
    X_te{d} = zeros(N,length(sli));
    
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
    end
end


end
