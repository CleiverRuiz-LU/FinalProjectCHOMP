%% SETUP FOR PICK_AND_PLACE.m
clc; clear;rosshutdown;
masterhostIP = "10.51.80.8";
rosinit(masterhostIP);

%% Pick and Place with CHOMP
disp('Getting goal...');
modelList = {'yCan1','yCan2','yCan3'};

for PickandPlace_Index = 1:length(modelList)
    modelname = modelList{PickandPlace_Index};
     
    % GET POSE- PICK
    fprintf('Picking up model: %s \n',modelname);
    [mat_R_T_G, mat_R_T_M] = get_robot_object_pose_wrt_base_link(modelname, 1);
    picked_up_model = pick("CHOMP", mat_R_T_M, mat_R_T_G);
    
    % GET PLACE - PLACE
    disp('Attempting place...')
    greenBin = [-0.4, -0.45, 0.25, -pi/2, -pi 0];
    place_pose = set_manual_goal(greenBin);
    fprintf('Moving to bin...');
    ret = moveToBin('topdown',mat_R_T_M,place_pose);
    
end










% docker exec -it armgazebo tmux
% cd src/arm_gazebo/config
% cd ../scripts/ 
% ./reset_world.bash ../config/ARM_CHOMPTEST1.txt
