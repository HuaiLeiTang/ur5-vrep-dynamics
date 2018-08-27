vrep=remApi('remoteApi');
vrep.simxFinish(-1);
id = vrep.simxStart('127.0.0.1', 19997, true, true, 2000, 5);
if id < 0
    disp('Failed connecting to remote API server. Exiting.');
    vrep.delete();
    return;
end
fprintf('Connection %d to remote API server open.\n', id);
% If your main code is run as a function, and not a script,
% you can use this command to ensure that cleanup_vrep is
% automatically run when there is a failure:
% cleanupObj = onCleanup(@() cleanup_vrep(vrep, id));

%% Construct the joints frame for UR5
handles = struct('id', id);
jointNames={'UR5_joint1','UR5_joint2','UR5_joint3','UR5_joint4',...
    'UR5_joint5','UR5_joint6'};
ur5Joints = -ones(1,6); 
for i = 1:6
    [res, ur5Joints(i)] = vrep.simxGetObjectHandle(id, ...
        jointNames{i}, vrep.simx_opmode_oneshot_wait); 
    vrchk(vrep, res);
end
handles.ur5Joints = ur5Joints;

[res, ur5Ref] = vrep.simxGetObjectHandle(id, 'UR5', ...
    vrep.simx_opmode_oneshot_wait); 
vrchk(vrep, res);

[res, ur5Gripper] = vrep.simxGetObjectHandle(id, 'UR5_connection', ...
    vrep.simx_opmode_oneshot_wait);
vrchk(vrep, res);

handles.ur5Ref = ur5Ref;
handles.ur5Gripper = ur5Gripper;

%% Construct the Base frame
[res, handles.base] = vrep.simxGetObjectHandle(id, ...
    'Frame0', vrep.simx_opmode_oneshot_wait);
vrchk(vrep, res);

%% Construct coordinates for each joint and endeffctor
% And compute the transformation from base to each frame at default
handles.FrameEnd = copyf( id, vrep, eye(4), handles.base, handles.base);
handles.FrameEndTarget = copyf( id, vrep, eye(4), handles.base, handles.base);
vrchk(vrep, res);

%% Other Initialization Stuff

% Stream wheel angles, Hokuyo data, and robot pose (see usage below)
% Wheel angles are not used in this example, but they may/will be necessary in
% your project.
for i = 1:6,
  res = vrep.simxGetJointPosition(id, handles.ur5Joints(i),...
      vrep.simx_opmode_streaming); 
  vrchk(vrep, res, true);
end
res = vrep.simxGetObjectPosition(id, handles.ur5Ref, -1,...
    vrep.simx_opmode_streaming); 
vrchk(vrep, res, true);
res = vrep.simxGetObjectOrientation(id, handles.ur5Ref, -1,...
    vrep.simx_opmode_streaming); 
vrchk(vrep, res, true);

% Stream the arm joint angles and the tip position/orientation
res = vrep.simxGetObjectPosition(id, handles.ur5Gripper, handles.ur5Ref, vrep.simx_opmode_streaming);
vrchk(vrep, res, true);
res = vrep.simxGetObjectOrientation(id, handles.ur5Gripper, handles.ur5Ref, vrep.simx_opmode_streaming);
vrchk(vrep, res, true);
for i = 1:6
  res = vrep.simxGetJointPosition(id, handles.ur5Joints(i),...
      vrep.simx_opmode_streaming);
  vrchk(vrep, res, true);
end

vrep.simxGetPingTime(id); % make sure that all streaming data has reached the client at least once

res = vrep.simxStartSimulation(id, vrep.simx_opmode_oneshot_wait);

handles.ur5Ref = ur5Ref;
handles.ur5Gripper = ur5Gripper;
qd=[1 1 1 1 1 1];
tau = [0.0000   -0.3108   -0.0771    0.0187   -0.0042    0]*1.0e-14;
%tau=[0 -29.2324 -8.7993 1.3051 -0.1517 0];
vrep.simxPauseCommunication(id, 1);
for i = 1:6
   res = vrep.simxSetJointTargetVelocity(id, handles.ur5Joints(i), sign(qd(i)), vrep.simx_opmode_oneshot);
   res = vrep.simxSetJointForce(id, handles.ur5Joints(i), abs(tau(i))*100e10, vrep.simx_opmode_oneshot);
   %vrep.simxSetJointForce(id, handles.ur5Joints(2), 1, vrep.simx_opmode_oneshot);
   vrchk(vrep, res, true);
end
vrep.simxPauseCommunication(id, 0);

% qd=[0 0 0 0 0 0];
% tau=[0 0 0 0 0 0];
% vrep.simxPauseCommunication(id, 1);
% for i = 1:6
%    res = vrep.simxSetJointTargetVelocity(id, handles.ur5Joints(i), sign(qd(i))*10e10, vrep.simx_opmode_oneshot);
%    res = vrep.simxSetJointForce(id, handles.ur5Joints(i), abs(tau(i)), vrep.simx_opmode_oneshot);
%    %vrep.simxSetJointForce(id, handles.ur5Joints(2), 1, vrep.simx_opmode_oneshot);
%    vrchk(vrep, res, true);
% end
% vrep.simxPauseCommunication(id, 0);