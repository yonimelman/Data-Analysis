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
columns.congruity.col_num = find(ismember(header,columns.congruity.name))
columns.congruity.conditions = unique(data(:,columns.congruity.col_num));


%%


