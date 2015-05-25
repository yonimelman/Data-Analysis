clear all; close all; clc

[file_name, path_name] = uigetfile('*.xlsx', 'Pick an excel file'); % loads the path to the file
data = xlsread(strcat(path_name,file_name)); % loads the excel to data matrix
[temp,header] = xlsread(strcat(path_name,file_name),'1:1');

%% Collecting Column names


disp('Fill in the following questions');

% Subject
columns.subject.name = input('Subject Col: ','s');
columns.subject.col_num = find(ismember(header,columns.subject.name));
columns.subject.conditions = unique(data(:,columns.subject.col_num));
%ACC
columns.acc.name = input('Accurace Col: ','s');
columns.acc.col_num = find(ismember(header,columns.acc.name));
%RT
columns.RT.name = input('RT Col: ','s');
columns.RT.col_num = find(ismember(header,columns.RT.name));
%BLOCK
% columns.block.name = input('RT Col: ','s');
% columns.block.col_num = find(ismember(header,columns.block.name));
% columns.block.conditions = unique(data(:,columns.block.col_num));

%DESIGN
if strcmp(input('within / between subjects Design?: ','s'),'within')
    columns.condition.name = input('Condition Col: ','s');
    columns.condition.col_num = find(ismember(header,columns.condition.name));
    columns.condition.conditions = unique(data(:,columns.condition.col_num));
end
%VARIABLES
vars = strsplit(input('Variables: (enter with spaces): ','s'));
for i = 1:length(vars)
    columns.vars(i).name = vars{i}
    columns.vars(i).col_num = find(ismember(header,columns.vars(i).name));
    columns.vars(i).conditions = unique(data(:,columns.vars(i).col_num));
end

if strcmp(input('handed response?: ','s'),'yes')
    columns.handed_resp.name = input('Handed Response Col: ','s');
    columns.handed_resp.col_num = find(ismember(header,columns.handed_resp.name));
    columns.handed_resp.conditions = unique(data(:,columns.handed_resp.col_num));

end

columns.congruity.name = input('Congruity Col: ','s');
columns.congruity.col_num = find(ismember(header,columns.congruity.name));
columns.congruity.conditions = unique(data(:,columns.congruity.col_num));


%% Creating the report cell

report_cell = {};
report_cell(1,:) = header;
report_cell{1,end+1} = 'removed';
report_cell{1,end+1} = 'cong_n-1';
for i = 1:length(vars)
    report_cell{1,end+1} = [columns.vars(i).name,'_n-1'];
    report_cell{1,end+1} = [columns.vars(i).name,'_n-1_repeat'];
end


%% Sequential Analysis

for s = 1:length(columns.subject.conditions)
    disp(['processing subject: ',num2str(columns.subject.conditions(s))])
    subject = columns.subject.conditions(s);
    
    %find first instance of subject
    index = find(data(:,columns.subject.col_num)==subject,1);
    
    report_cell(end+1,[1:length(header)]) = num2cell(data(index,:));
    for j = length(header)+1:size(report_cell,2)
        report_cell{end,j} = 1;
    end
    
    
    index = index + 1;
    
    
    while data(index,columns.subject.col_num)==subject
        % copy existing data to report cell
        report_cell(end+1,[1:length(header)]) = num2cell(data(index,:));
        
        % ACC - remove n-1 or n == 0
        if (data(index-1,columns.acc.col_num) == 0) || (data(index,columns.acc.col_num) == 0)
            report_cell{end,length(header)+1} = 1;
        else
            report_cell{end,length(header)+1} = 0;
        end
        
        % define cong condition of n-1
        report_cell{end,length(header)+2} = data(index-1,columns.congruity.col_num);
        
        % find n-1 and repeats
        for v = 1:length(vars)
            v_n_1 = data(index-1,columns.vars(v).col_num);
            v_n = data(index,columns.vars(v).col_num);
            
            report_cell{end,length(header)+2+(v-1)*2+1} = v_n_1;
            
            if v_n_1 == v_n
                report_cell{end,length(header)+2+(v-1)*2+2} = 1;
            else
                report_cell{end,length(header)+2+(v-1)*2+2} = 0;
            end
        end
            
            
        index = index+1;
        if index > size(data,1)
            break;
        end
        
    end
    
    
end



xlswrite(strcat(path_name,file_name),report_cell,2); % writes the report to the excel data file.

