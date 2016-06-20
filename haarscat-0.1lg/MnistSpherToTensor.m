function [Xtensor, Ytensor] = MnistSpherToTensor(X)
Xtensor=[];
Ytensor=[];
for i=1:length(X)
    Xtensor=[Xtensor,X{i}];
    
    Ytensor=[Ytensor; i*ones(size(X{i},2),1)];
end
Xtensor=Xtensor';
Xtensor=reshape(Xtensor,size(Xtensor,1),1,sqrt(size(Xtensor,2)),sqrt(size(Xtensor,2)));
end

