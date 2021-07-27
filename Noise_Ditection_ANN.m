%% importing data
clc;
clear all;
table=readtable("two_week_voltage.xlsx");
data_table=table(:,1:2);
data=table2array(data_table);
t= data(1:end,2);
v= data(1:25000,1);
%% augmentation
v_aug=[];
size_of_ip = size(v);
c=1; i=1;
fixed_win=find(t==100);   %fixed window length
sliding_win=find(t==101); %sliding window length
while 1
    v_aug(:,i)=v(c:c+fixed_win-1);
    c=c+sliding_win-1;
    i=i+1;
    if(c+fixed_win-1>size_of_ip)
        break;
    end
end
x=v_aug';
%% Insert Noise
x(100:220,:) = x(100:220,:)+10.0*rand(1, fixed_win);
y(1:250,1:2) = 0;
y(1:100,1) = 1;
y(100:220,2) = 1;
%% training data preparation
XTrain(1:200,:) = x(1:200,:);    %training data input
YTrain(1:200,:) = y(1:200,:);    %training data output
XTrain=XTrain';
YTrain=YTrain';
%% testing data preparation
XTest(:,:) = x(201:250,:);    %training data input
YTest(:,:) = y(201:250,:);    %training data output
XTest=XTest';
YTest=YTest';
%% training
net=patternnet(100);
[model,tr]=train(net,XTrain,YTrain);
%% testing
prediction=model(XTest);
class_pred=vec2ind(prediction);
class_act=vec2ind(YTest);
plot(class_pred);
hold on;
plot(class_act,'color', 'r');