%% Vincentizing Script 
% * created by Yoni Melman, Cognitive Neuropsychology Lab, BGU
% * last update 10.12.2014

% Information
% ------------
%
% Calculates bin averages for data across participants for every condition
% and presents a vincentizing graph.
% Saves bin averages per subject per condition in sheet #2 of the input
% excel file.
%
% How to use
% ------------
% 1. 
% Orgenize your data in a new excel file in which sheet number 1
% contains *only correct* trials. the table should contain 3 columns, 
% A) subject number, B) Conditions, C) Reaction time
% each row should contain a single trial.
%
% * use the following table for refernce:
%
%                  | Subject Number |Conditions (numerical values) | RT  |
%  * trial 1       | -------1------ |---------------1--------------|-100-|
%  * trial 2       | -------1------ |---------------2--------------|-200-|
%  * trial ...     | -------------- |------------------------------|-----|
%  * trial n       | -------10----- |---------------1--------------|-150-|
%
% make sure you assign a numerical value to each condition. the script
% can't read txt label conditions. 
% for example, (1 = congruent, 2 = incongruent).
% 
% 2.
% Make sure you close your excel file! after that, 
% Run the script. it will ask you how many bins you would like for the
% analysis. enter a number (ex. 10) and press the 'Return' (Enter) key.
%
% 3.
% The script will run for a couple of seconds, and present you the
% vincentizing graph for the conditions. it will then access your data
% excel file and insert into sheet #2 the mean RT for every participant for
% every condition as well as a mean RT per bin (columns). this could be
% used for later analysis of the interaction of condition and bins.
% 
% ***********************************************************************

%% Generating the data
% loading the excel file and creating the relevant data structures for the
% script.

clear all; close all; clc;

[file_name, path_name] = uigetfile('*.xlsx', 'Pick an excel file'); % loads the path to the file

data = xlsread(strcat(path_name,file_name)); % loads the excel to data matrix

subjects = unique(data(:,1)); % verify the number of subjects
conditions = unique(data(:,2)); % verify the number of conditions

data = sortrows(data,[1 2 3]); % sorting the data by subject, condition, RT
n_bins = input('How many Bins? >> '); % change this to set the number of bins


% preparing the report file 
report_cell = cell(1,3+n_bins);
report_cell{1,1} = 'Subject_Num';
report_cell{1,2} = 'Condition';
report_cell{1,3} = 'mean_RT';
for j = 1:n_bins
    report_cell{1,3+j} = strcat('bin_',num2str(j));
end

    


%% Preprocessing
% creates a cell array sub_con_RT (Subject, Conditions) which holds the RT
% of the relevant trials for every participant and every condition.

sub_con_RT = cell(length(subjects),length(conditions));

% also inserts mean RT per subject per condition into the report file

for subject = subjects'
    for condition = conditions'
        rt_temp = data((data(:,1)==subject & data(:,2)==condition),3);
        sub_con_RT{subject,condition} = rt_temp;
        report_cell{end+1,1} = subject;
        report_cell{end,2} = condition;
        report_cell{end,3} = mean(rt_temp);
    end
end


%% Performing Vincentizing
% inserts into temporary vector vinc the mean RT for trials faster than
% bin edge(i) and slower or equal to bin edge(i+1);

bins = (100/n_bins):(100/n_bins):100;
sub_con_bins = zeros(length(subjects),length(conditions),n_bins);


counter = 1;
for subject = 1:length(subjects)
    for condition = conditions'
        rt = sub_con_RT{subjects(subject),condition};
        perc = [0, round(prctile(rt,bins))];
        for i = 1:n_bins
            temp = rt(rt>perc(i) & rt<=perc(i+1));
            vinc(i) = mean(temp);
        end
        sub_con_bins(subject,condition,:) = round(vinc);
        report_cell(1+counter,4:end) = mat2cell(round(vinc),1,ones(size(vinc)));
        counter = counter + 1;
    end
end

xlswrite(strcat(path_name,file_name),report_cell,2); % writes the report to the excel data file.



%% Averaging and ploting.

bin_mean = squeeze(mean(sub_con_bins,1)); % averages bin mean RTs across participants for every condition.

% ploting the vincentizing graph.

plot(bin_mean,[1:n_bins],'x-')
title('Vincentizing Graph')
legend(num2str(conditions))
xlabel('RT')
ylabel('Bins')





