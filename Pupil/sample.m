close all;
clear all;

warning('off')

load('allPupilData.mat')
startTime = -0.92;
endTime = 9.6;

colorRGB = [zeros(1,9)' linspace(0,1,9)' ones(1,9)'];

data = allPupilData{1,1};
x = [startTime:(endTime-startTime)/(size(data.PLR,2)-1):endTime];

for condition  = 1 : max(data.condition)
    ind = find(data.condition == condition);
    y = data.PLR(ind,:);
    x = [startTime:(endTime-startTime)/(size(y,2)-1):endTime];
    
    %% blink interpolation
    y = zeroInterp( y, 10, 'pchip');
    forLMMdata{1,condition} = y;
end

%% pre-processing
for iSub = 1: size(allPupilData,1)
    for condition  = 1 : max(data.condition)
        y = forLMMdata{iSub,condition};
%         pre_processing(pupil_data, sampling frequency, threshold, window for smoothing, time period of onset and offset)
        [y rejctNum] = pre_processing(y,250, 0.1, 10,[startTime endTime]);
        forLMMdata{iSub,condition} = y;
        toShowData{iSub,condition} = mean(y,1);
    end
end