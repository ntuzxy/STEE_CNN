HWLab = load('HW_Predicted_Labels_GT_Data.txt');
SWLab = load('SW_Predicted_Labels_GT_Data.txt');
disp('HW Vs. SW results')
a = find(HWLab==SWLab);
accuracy = length(a)/length(SWLab)

load('F:\STEE_PROJ\CONV\Matlab\ModularisedEBBIOT_Type2\GT_train_42x42_20190924_ON_OFF.mat');
labels = labels(test_data_inds)+1;
labels(labels==7)=4; %van/truck combined
withoutHumans = find(labels~=5);
label = labels(withoutHumans); %humans removed
label(label==6)=5;
GTLab = label';
disp('HW Vs. GT Labels')
a = find(HWLab==GTLab);
accuracy = length(a)/length(GTLab)

disp('SW Vs. GT Labels')
a = find(SWLab==GTLab);
accuracy = length(a)/length(GTLab)

%%
HWLab = load('HW_Predicted_Labels_GT_Data.txt');
SWLab = load('testing_data\server_brainlab\GT_1B2C_HR_TruckVanCombined\SW_labels.txt');
GTLab = load('testing_data\server_brainlab\GT_1B2C_HR_TruckVanCombined\GT_labels.txt');
disp('HW Vs. SW results')
a = find(HWLab-1==SWLab);
accuracy = length(a)/length(HWLab)
disp('HW Vs. GT results')
a = find(HWLab-1==GTLab);
accuracy = length(a)/length(HWLab)
disp('SW Vs. GT results')
a = find(SWLab==GTLab);
accuracy = length(a)/length(HWLab)


