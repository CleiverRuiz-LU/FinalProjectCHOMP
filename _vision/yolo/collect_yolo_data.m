    %% 00 Connect to ROS (use your own masterhost IP address)
    clc
    clear
    rosshutdown;
    
    pause(2);       % Check if more down time helps diminish connection errors
    masterhostIP = "10.51.71.122";
    rosinit(masterhostIP)

    %% 02 Go Home
    disp('Going home...');
    goHome('qr');   
    disp('Resetting the world...');
    resetWorld;     

    %% 03 Get Images
    % Save all the names of objects in world
    obj_names = {'yCan1'};

    obj_len = length(obj_names); 
    img_struct = cell(1,obj_len);

    % Save image structures in the cells
    for i=1:length(obj_names)
        img_struct{i} = collect_obj_images(obj_names{i});        % Move arm around object and save imgs as struct
    end