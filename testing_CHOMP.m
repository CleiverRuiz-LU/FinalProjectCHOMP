robot = loadrobot('universalUR5e',DataFormat="row");
robot = urdfAdjustment(robot,'UR5e',0);    
robot_manipulator = manipulatorCHOMP(robot);
show(robot);
show(robot_manipulator);


% docker exec -it armgazebo tmux
% cd src/arm_gazebo/config
% cd ../scripts/ 
% ./reset_world.bash ../config/ARM_yellowCan.m

%% Sets Collision Options in Enviorment
Models_Collisions = [0.2  0.0577476  0.429985 0.57747+0.1;                  % [r y x z] or in gazebo [r y x z]
                     0.5    0          0        (0-0.565); 
                     0.5    0         (0+0.94)  (0-0.565); 
                     0.5    (0+0.5)    0 (0-0.565);  
                     0.5    (0+0.5)   (0+0.94)  (0-0.565);
                     0.5    (0-0.5)    0        (0-0.565); 
                     0.5    (0-0.5)   (0+0.94) (0-0.565)]';   

robot_manipulator.SphericalObstacles = Models_Collisions;
show(robot_manipulator);
%% Sets CHOMP Manipulator Properties 
robot_manipulator.SmoothnessOptions = chompSmoothnessOptions(SmoothnessCostWeight = 1e-3);
robot_manipulator.CollisionOptions = chompCollisionOptions(CollisionCostWeight = 10);
robot_manipulator.SolverOptions = chompSolverOptions(Verbosity="none",LearningRate = 7.0);
%% 
robot_int_config = [0 0 0 0 0 0];
goal = [-0.15,1.69,-0.47,-1.23,0.00,-1.72];


[wptsamples,tsamples] = optimize(robot_manipulator, ...
                                [robot_int_config; goal], ...
                                [0 5], ...
                                0.1, ...
                                InitialTrajectoryFitType = "minjerkpolytraj");

show(robot_manipulator,wptsamples,NumSamples=30);