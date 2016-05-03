% load alzheimers data
load('alzheimers/ad_data.mat');
load('alzheimers/feature_name.mat')

X_train = [X_train, ones(size(X_train,1),1)];
X_test = [X_test, ones(size(X_test,1),1)];

% L1 parameters
par  = 0.1;

% Apply bootstrap function
bootstat = bootstrp(1000, @logistic_l1_train, X_train, y_train, par);

% Find top 20 features
bootstat = (bootstat~=0);
count = sum(bootstat);
[count,idx] = sort(count,'descend');

fprintf('Top 20 features:\nName\tScore\n');
for i=1:20
    fprintf('%s\t%f\n',FeatureNames_PET{idx(i)},count(i)/1000);
end
