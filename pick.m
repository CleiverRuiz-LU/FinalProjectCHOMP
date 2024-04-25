function grip_result = pick(strategy,mat_R_T_M, mat_R_T_G)
% pick - Top-level function to executed a complete pick. 
% 
%   01 Calls moveTo to move to desired pose
%   02 Calls doGrip to execute a grip
%
% Inputs
%   - strategy: determines the approach to be used for picking an object,specifies
%       the method or technique the robot will use to perform the pick operation.
%   - strategy = 'topdown'  or 'direct'
%
%   - mat_R_T_M [4x4]: object pose wrt to base_link
%   - mat_R_T_G  [4x4]: gripper pose wrt to base_link used as starting
%   - point in ctraj (optional)    
%
% Outputs:
%   - ret (bool): 0 indicates success, other failure.
%
    %% 1. Move to desired location with strategy
    if strcmp(strategy,'topdown')
        % Hover over
        over_R_T_M = lift(mat_R_T_M, ops("z_offset") );                   % HANGE POSE - Add z-offset to Robot-to-Model Homogenous Transpormation Matrix
        traj_result = moveTo(over_R_T_M,ops);                             % MOVE TO - move to over_R_T_M hang pose with z-offset
        % Descend
        if ~traj_result
            traj_result = moveTo(mat_R_T_M,ops);
        else
            error('ErrorID', int2str(traj_result));            
        end

    elseif strcmpi(strategy,'CHOMP')
        % Hover over
        over_R_T_M = lift(mat_R_T_M, ops("z_offset") );                     
        traj_result = moveToCHOMP(over_R_T_M,ops);                               
        % Descend
        if ~traj_result
            traj_result = moveTo(mat_R_T_M,ops);
        else
            disp('ErrorID');
            % traj_result = moveTo(over_R_T_M,ops);
            % traj_result = moveTo(mat_R_T_M,ops);
        end
    elseif strcmpi(strategy,'pouch')
        % Hover over
        over_R_T_M = lift(mat_R_T_M, ops("z_offset") );                     
        traj_result = moveTo(over_R_T_M,ops);                               
        % Descend
        if ~traj_result
            traj_result = moveTo(mat_R_T_M,ops("z_offset"));
        else
            disp('ErrorID');
        end
    elseif strcmpi(strategy,'direct')
        traj_result = moveTo(mat_R_T_M,ops);
    end


    %% 2. Pick if successfull (check structure of resultState). Otherwise...
    if ~traj_result
        [grip_result,grip_state] = doGrip('pick'); 
        grip_result = grip_result.ErrorCode;
    else
        error('ErrorID', int2str(grip_result));
    end
end