% Read the data
data = readtable('data.csv');
data_nogender = readtable('data - no gender removed.csv'); % CRIMES WITH NO VICTIM GENDER WERE REMOVED

test = readtable('test.csv'); % NECESSARY TO DEAL WITH A BUG
test2 = readtable('test2.csv');

%----------------------Basic Gender Analysis----------------------%
females = data.(29);
males = data.(28);
threat = data.(27);

% logistic regression?
mdl = fitglm(males, threat, 'distribution', 'binomial')
%mdl1 = fitglm(females, threat, 'distribution', 'binomial');
figure;
x = randi([0 1], 9999, 1);
y_hat = predict(mdl, x);
plot(x, y_hat);
title('Logistic Regression of Gender vs. Predicted Threat Probability');
xlabel('Progression from Female to Male');
ylabel('Predicted Threat Level');
% NOTES: by plotting this it appears that males tend to be victims more
% than females

% logistic regression WITH GENDER REMOVED
females1 = data_nogender.(29);
males1 = data_nogender.(28);
threat1 = data_nogender.(27);

mdl2 = fitglm(males1, threat1, 'distribution', 'binomial');
mdl13 = fitglm(females1, threat1, 'distribution', 'binomial');

% NOTES: when we removed all the data with no gender specified, males
% suddenly became significant data. Not sure why this is, but we should
% remove all instances where there was no victim gender specified. Most of
% them appear to be stolen vehicles, theft from vehicles, or embezzlement
% with no weapons involved.

%----------------------Age Analysis using linear model----------------------%
age = data.(11);
% doing basic plot and scatter was not very informative
% Try fitting a linear model, then polynomial model
formula = 'Threat ~ 1 + Victim_Age';
model = fitlm(data, formula)
predictions = predict(model, data);
figure;
plot(age,predictions);
title('Linear Model of Age vs. Predicted Threat Probability');
xlabel('Victim Age');
ylabel('Predicted Threat Level');
% NOTES: when we did a simple linear model, our results seemed very
% different from what we have. Should have some kind of threshold or use a
% different model

%----------------------Age Analysis using HW3-4 approach----------------------%
age = test.Victim_Age;
threat = test.Threat;
figure;
boxplot(age,threat, 'Labels', {'Crime without Threats', 'Crime with Threats'});
title('Crime with Threats vs. Crime without Threats');
ylabel('Victim Age');
% NOTES: Crime with threats seems to have less outliers, smaller
% distribution. Smaller median as well. This means that in crimes with
% threats involved the ages tended to be younger overall, although this
% does not mean that old people were not threatened!
model = fitglm(test, 'Threat ~ Victim_Age', 'distribution','binomial')
figure;
x = [0:0.1:max(age)]';
y_hat = predict(model, x);
plot(x, y_hat);
title('Logistic Regression of Age vs. Predicted Threat Probability');
xlabel('Victim Age');
ylabel('Predicted Threat Level');
% NOTES: we get a similar result to using the linear model. Most of the
% data has crimes that do not involve weapons, which is why most of the
% data is below 0.5. Again this reinforces the idea that the younger you
% are, the more likely you are to experience a threat.

% FUTURE IDEAS: Find younger vs. older population in LA, combine this with
% gender data, specify data more, using a polynomial, threshold,
% kfolds/subset

% Using age and gender, males are 1 and females are 0
formula = 'Threat ~ 1 + Victim_Age + Males';
model = fitlm(test2, formula)
figure;
x = zeros(991,2);
x(:,1) = [0:0.1:max(age)]';
x(:,2) = randi([0 1], length(x(:,1)), 1);
y_hat = predict(model, x);
plot(x, y_hat); % this was not very helpful

% Determining if these 2 predictors are reliable enough, or if there is a
% good enough correlation or just due to chance (age and gender will not
% affect your chances), use k-folds
% Explain why or why not it is like that