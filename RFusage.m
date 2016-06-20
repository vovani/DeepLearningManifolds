nTrees = 300; 
FBoot=0.75;%=1.0
paroptions = statset('UseParallel',true);%, 'Streams',RandStream.getGlobalStream()

%============CLASSSIFICATION
%RF parameters 
%OOBVarImp - feature importance on/off
TreeBagggerClasifParams={ 'Method','classification','Options',paroptions,...
        'FBoot',FBoot,'OOBVarImp','On''SampleWithReplacement','on',...
        'oobpred','on','MinLeaf',1};
%Crating RF model    
RFModelMethod = @(X,Y)((TreeBagger(nTrees,X,Y,TreeBagggerRegParams{:})));
%Prediction
RFpredict=@(Model,X)(str2double(Model.predict(X)));

%===========REGRESSION
%RF parameters 
TreeBagggerRegParams={  'Method','regression','Options',paroptions,...
        'FBoot',FBoot,'OOBVarImp','On','SampleWithReplacement','on',...
        'oobpred','on','MinLeaf',5};   
%Crating RF model      
RFModelMethod_Reg = @(X,Y)( TreeBagger(nTrees,X,Y,TreeBagggerRegParams{:}));
    % Predinction
RFpredict_Reg=@(Model,X)((Model.predict(X)));

%====================
%Example for Classification
%(Xtr,Ytr) - training set
%(Xts,Yts) - testting set

RF_Model=RFpredict(Xtr,Ytr);
%Prediction values
Ypred=RFpredict(Xts);

%Classification error (or MSE for regression case) 
ErrPred=error(RF_ModelReg,Xts,Yts);

%OOB error(out-of-the-bag)
oobErr=oobError(RF_Model);

figure,
bar(RF_Model.OOBPermutedPredictorDeltaError);
title('Features importance');


