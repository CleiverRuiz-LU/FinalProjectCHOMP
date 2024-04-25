function Model_Collisons_List = getCollisions(models, flag)
% Input 
%   models - a cell of model names (string)
%   flag = 1(ready) &  0(not ready)    
%  
%   Example:
%       modelList = {'yCan1','yCan2','yCan3'};
%       Model_Collisions = getCollisions(modelList, 0)
%
    if flag == 0
        column_names = models;
        row_names = {'radius', 'y_coordinate', 'x_coordinate', 'z_coordinate'};
        values = zeros(4, length(models)); % Initialize an empty matrix
        Model_Collisons_ = values;
        Model_Collisons_List = array2table(Model_Collisons_, 'VariableNames', column_names, 'RowNames', row_names);

        % Save the table to a file - needs work
        writetable(Model_Collisons_List, 'Model_Collisons_List.csv');
    elseif flag == 1
        return
    end
end
