function [ weights_fnl ] = ridgeRegress(x, y, nfold )
%RIDGEREGRESS for learning multivariate ridge regression with linear kernal
%input: x: n * p dimensional matrix, n is the size of samples, p is the dimensionality of observation
%       y: n * k dimensional matrix, n is the size of samples, k is the dimensionality of label
%       nfold: the number of fold for cross validation
%output: weights_fnl: p+1 dimensional vector, where the former p dimensional elements are the learned weights, and the last element is the bias term

k_fold = nfold;

xtrain_enhanced = x;
ytrain_temp = y;

%% nfold cross-validation 
    bestC = 0;
    mae = 100000000000000;
    ntrain_frame = size(xtrain_enhanced,1);
    for power = -5 : 2
         paraC = 10^(power);
         maeError = 0;
         
         for split = 1 : k_fold
             crossTe = [(split-1)*floor(ntrain_frame/k_fold)+1 : split*floor(ntrain_frame/k_fold)];
             crossTr = setdiff(1:ntrain_frame, crossTe);
             
             TrainCrossX = xtrain_enhanced(crossTr,:);
             TrainCrossY = ytrain_temp(crossTr,:);
             ValidaCrossX = xtrain_enhanced(crossTe,:);
             ValidaCrossY = ytrain_temp(crossTe,:);
             
             C = paraC;
             
             % initialisation
             Q1=0;Q2=0;Q3=0;Q4=0; p1=0;p2=0;
             
             TrainSetX = TrainCrossX';
             TrainSetY = TrainCrossY';
             n=size(TrainSetX,2);
             
             % summarization
             for ii=1:n
                 tempQ1=TrainSetX(:,ii)*TrainSetX(:,ii)';
                 Q1=Q1+tempQ1;
                 Q2=Q2+TrainSetX(:,ii);
                 Q3=Q3+TrainSetX(:,ii)';
                 Q4=Q4+1;
                 p1=p1+TrainSetY(:,ii)*TrainSetX(:,ii)'; %because of our code using Ax-b=0 instead of Qx+p=0, so minus will be removed here
                 p2=p2+TrainSetY(:,ii);
             end
             
             Q1=2*C*Q1+eye(size(TrainSetX,1));
             Q2=2*C*Q2;
             Q3=2*C*Q3;
             Q4=2*C*Q4;
             Q=[Q1 Q2; Q3 Q4];
             
             p1=2*C*p1;
             p2=2*C*p2;
             p=[p1 p2]';
             
             weights =  Q \ p;
             
             % validate
             TestSetX = ValidaCrossX';
             TestSetY = ValidaCrossY';
             n = size(TestSetX,2);
             
             for ij=1:n
                 predict(ij,:)=(weights(1:end-1,:)'*TestSetX(:,ij))'+weights(end,:);
             end
             
             maeError = maeError + sum(abs(predict - TestSetY'));
         end
        
         if maeError < mae
             bestC = paraC;
             mae =maeError;
         end
    end
     

%% training

C = bestC;
    
    % training
    Q1=0;
    Q2=0;
    Q3=0;
    Q4=0;

    p1=0;
    p2=0;
    
    TrainSetX = xtrain_enhanced';
    TrainSetY = ytrain_temp';
    
    n=size(TrainSetX,2);

for ii=1:n
    tempQ1=TrainSetX(:,ii)*TrainSetX(:,ii)';
    Q1=Q1+tempQ1;
    Q2=Q2+TrainSetX(:,ii);
    Q3=Q3+TrainSetX(:,ii)';
    Q4=Q4+1;
    p1=p1+TrainSetY(:,ii)*TrainSetX(:,ii)'; %because of our code using Ax-b=0 instead of Qx+p=0, so minus will be removed here
    p2=p2+TrainSetY(:,ii);
end

Q1=2*C*Q1+eye(size(TrainSetX,1));
Q2=2*C*Q2;
Q3=2*C*Q3;
Q4=2*C*Q4;

Q=[Q1 Q2; Q3 Q4];

p1=2*C*p1;
p2=2*C*p2;
p=[p1 p2]';


weights_fnl =  Q \ p;

end


%%% do training and testing globally
%nfold=3;
%[ weights_fnl ] = ridgeRegress(traindata, trainclass, nfold )

%w=weights_fnl(1:end-1,:);
%b=weights_fnl(end,:);

%ypred=testdata*w;
%ypred(:,1)=ypred(:,1)+b(1);
%ypred(:,2)=ypred(:,2)+b(2);
%ypred(:,3)=ypred(:,3)+b(3);

