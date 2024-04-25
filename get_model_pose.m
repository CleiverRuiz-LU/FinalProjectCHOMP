function pose = get_model_pose(model_name)
% get_model_pose - This method will create an action client that talks to Gazebo's
% get_model_state action server to retrieve the pose of a given model_name wrt to the world.
%
% Inputs
%   - model_name (string): name of existing model in Gazebo
%
% Ouput
%   - models (gazebo_msgs/GetModelStateResponse): contains Pose and Twist
%
% Also see: 
%


%% 01 Create get_model_state action client
global get_models_client;% = rossvcclient('/gazebo/get_model_state', ...
                                 %'DataFormat','struct');

%% 02 Create model_client_msg and set ModelName
get_models_client_msg = rosmessage(get_models_client);
get_models_client_msg.ModelName = model_name;

%% 04 Call client 
try
    [pose, status,statustext] = call(get_models_client,get_models_client_msg);
catch
    disp('Error - model could not be found')
    pose = rosmessage('gazebo_msgs/GetModelStateResponse', 'DataFormat','struct');
end


