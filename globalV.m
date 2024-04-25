global get_models_client;
global joint_state_sub; 

get_models_client = rossvcclient('/gazebo/get_model_state','DataFormat','struct');
joint_state_sub =  rossubscriber("/joint_states", 'DataFormat','struct');


ops = dictionary();                                                     % Type of global dictionary with all options to facilitate passing of options
ops("debug")               = 0;                                         % If set to true visualize traj before running  
ops("toolFlag")            = 0;                                         % Include rigidly attached robotiq fingers
ops("traj_steps")          = 1;                                         % Num of traj steps
ops("z_offset")            = 0.1;                                       % Vertical z-offset for top-down approach
ops("z_offset_pouch")      = 0.01;                                      % 
ops("traj_duration")       = 2;                                         % Traj duration (secs)
grip_result                = -1;                                        % Init to failure number  