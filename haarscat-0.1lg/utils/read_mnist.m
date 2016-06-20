function [X_tr, X_te] = read_mnist(path_to_mnist)

D=10;
maxclasses=(0:D-1)';

[labels] = readidx(fullfile(path_to_mnist,'mnist','train-labels.idx1-ubyte'),60000,60000);
[xifres] = readidx(fullfile(path_to_mnist,'mnist','train-images.idx3-ubyte'),60000,60000);

X_tr = cell(D,1);
tmp32=zeros(32);
for d=1:D
    sli=find(labels==maxclasses(d));
    X_tr{d} = zeros(1024,length(sli));
    for s=1:length(sli)
        tmp=xifres(:,sli(s));
        tmp32(3:30,3:30)=reshape(tmp,28,28);
        X_tr{d}(:,s) = tmp32(:);
    end
end

clear labels;
clear xifres;

[xifres] = readidx(fullfile(path_to_mnist,'mnist','t10k-images.idx3-ubyte'),10000,10000);
[labels] = readidx(fullfile(path_to_mnist,'mnist','t10k-labels.idx1-ubyte'),10000,10000);

X_te = cell(D,1);
for d=1:D
	sli=find(labels==maxclasses(d));
    X_te{d} = zeros(1024,length(sli));
	for s=1:length(sli)
            ind = 1+floor(rand(1)*length(sli)) ;
            tmp=xifres(:,sli(ind)) ;
            tmp32(3:30,3:30)=reshape(tmp,28,28);
            X_te{d}(:,s) = tmp32(:);
	end
end

end             