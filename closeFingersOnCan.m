% Function to close fingers around rCan3
function closeFingersOnCan
    % Connect to ROS
    rosinit('NodeName','matlab_node');
    
    % ROS action client for controlling gripper
    grip_client = rosactionclient('/gripper_controller/follow_joint_trajectory','control_msgs/FollowJointTrajectory', 'DataFormat', 'struct');
    
    % Instantiate the goal message
    gripGoal = rosmessage(grip_client);
    
    % Create goal message to close fingers around rCan3
    gripPos = 0.7; % Closing position for fingers
    gripGoal = packGripGoal(gripPos, gripGoal);
    
    % Send goal to action server
    sendGoal(grip_client, gripGoal);
    
    % Wait for goal completion
    wait(grip_client);
    
    % Get end-effector pose at the time it touches the can
    % This depends on your implementation and may require subscribing to robot state
    % and retrieving the end-effector pose information
    endEffectorPose = [x, y, z, roll, pitch, yaw]; % Update with actual values
    
    % Output the end-effector pose at the time it touches the can
    disp("End-effector pose at the time it touches the can:");
    disp(endEffectorPose);
    

end