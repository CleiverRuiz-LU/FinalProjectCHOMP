function traj_result = moveToCHOMP(mat_R_T_M,ops)
    %% Instantiate robot object and robot manipulator object
    robot = loadrobot("universalUR5e", DataFormat = "row");
    robot = urdfAdjustment(robot,"UR5e",0);
    robot_manipulator = manipulatorCHOMP(robot);
    %% Define collision sphere objects in environment
    Models_Collisions = [0.2    0.0577476  0.429985    0.67747;                  % [r y x z] or in gazebo [r y x z]
                         0.3    0          0.3        -0.665; 
                         0.3    0          0.94       -0.665; 
                         0.3    0.5        0.3        -0.665;
                         0.3    0.5        0.94       -0.665;
                         0.3    -0.5       0.3        -0.665; 
                         0.3    -0.5       0.94       -0.665]';

    robot_manipulator.SphericalObstacles = Models_Collisions;

    % robot_manipulator.SmoothnessOptions = chompSmoothnessOptions(SmoothnessCostWeight = 1e-2);
    % robot_manipulator.CollisionOptions = chompCollisionOptions(CollisionCostWeight = 10);
    % robot_manipulator.SolverOptions = chompSolverOptions(Verbosity="none",LearningRate = 7.0);
    if ops('debug')
       show(robot_manipulator);
    end
    %% Get Robot and Model Trajectory angles
    ur5e = loadrobot("universalUR5e",DataFormat="row");
    [goal,rob_joint_names, error_mesg] = convertPoseTraj2JointTraj(ur5e,mat_R_T_M,ops('toolFlag')); 
    % if error_mesg == 1
    %     traj_result = 1;
    %     return
    % end
    clear ur5e;
    robot_int_config = [0 0 0 0 0 0];
    %% Retrieve waypoints and corresponding timestamps via optimization algorithm
    [mat_joint_traj,tsamples] = optimize(robot_manipulator, ...
                                        [robot_int_config; goal], ...
                                        [0 5], ...
                                        0.1, ...
                                        InitialTrajectoryFitType = "minjerkpolytraj");
    % Visualize trajectory
    if ops('debug')
       show(robot_manipulator,mat_joint_traj,NumSamples=30);
    end
    %% Send and receive waypoint trajectories via ROS action client
    pick_traj_act_client = rosactionclient('/pos_joint_traj_controller/follow_joint_trajectory',...
                                           'control_msgs/FollowJointTrajectory', ...
                                           'DataFormat', 'struct');
    traj_goal = rosmessage(pick_traj_act_client); 
    pick_traj_act_client.FeedbackFcn = [];
    traj_goal = convert2ROSPointVec(mat_joint_traj,rob_joint_names,51,max(tsamples),traj_goal); 


    disp('Sending traj to action server...')
    if waitForServer(pick_traj_act_client)
        disp('Connected to action server. Sending goal...')
        [traj_result,state,status] = sendGoalAndWait(pick_traj_act_client,traj_goal);
    else   % Re-attempt
        disp('First try failed... Trying again...');
        [traj_result,state,status] = sendGoalAndWait(pick_traj_act_client,traj_goal);
    end 

    traj_result = traj_result.ErrorCode;
    clear pick_traj_act_client;
end