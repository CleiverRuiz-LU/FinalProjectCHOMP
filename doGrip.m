function [res,state] = doGrip(type)
%--------------------------------------------------------------------------
% Tell gripper to either pick or place via the ros gripper action client
%
% Input: type (string) - 'pick' or 'place'
% Output: actoin result and state
%--------------------------------------------------------------------------

    %% 01. Create a gripper action client
    grip_action_client = rosactionclient('/gripper_controller/follow_joint_trajectory', ...
                                          'control_msgs/FollowJointTrajectory',...
                                          'DataFormat','struct');
        grip_msg = rosmessage(grip_action_client);                          % Create a gripper goal action message

    %% 02. Set Grip Pos by default to pick/close Gripper
    gripPos = 0.23; 

    % Modify it if place (i.e. open)
    if strcmp(type,'place')
        gripPos = 0;           
    end

    %% 03. Pack gripper information intro ROS message
    grip_goal = packGripGoal_struct(gripPos,grip_msg);

    %% 04. Send action goal
    disp('Sending grip goal...');

    if waitForServer(grip_action_client)
        disp('Connected to action server. Sending goal...')
        [res,state,status] = sendGoalAndWait(grip_action_client,grip_goal);
    else
        % Re-attempt
        disp('First try failed... Trying again...');
        [res,state,status] = sendGoalAndWait(grip_action_client,grip_goal);
    end    
end