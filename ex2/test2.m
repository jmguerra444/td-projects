%% set up VLFeat
%VLFEATROOT = 'D:/vlfeat-0.9.21/toolbox/vl_setup'
load('desc_loc.mat'); %load descriptors and correspondig features
path_test = 'ex2\data\images\detection';
images_test = load_images(path_test);
%% perform computes new SIFT features

for imIn = 1:1 %size(images,3)
    I = images_test(:,:,imIn);
    [fa, da] = vl_sift(I);
    [matches,~] = vl_ubcmatch(da, dAll');
end

%% hyperparams
iterations = 1000;
threshold = 50;
n = 4;
K = [2960.37845 0 0; 0 2960.37845 0; 1841.68855 1235.23369 1]; %intrinsics
cameraParams = cameraParameters('IntrinsicMatrix',K);
%% implement RANSAC by hand
% indices_test
% best_rand_n_points = rand_n_points;
max_inliers = 0;
best_rot = zeros(3, 3);
best_trans = zeros(3, 1);
%%
wb = waitbar(0,'Please wait...');

for i = 1:iterations
    wb = waitbar(i/iterations,wb,'Please wait...');

    rand_n_points = randi(size(matches, 2), n, 1);
    imagePoints_est = [fa(1, matches(1,rand_n_points)); fa(2,matches(1,rand_n_points))]';
    worldPoints = xAll(matches(2,rand_n_points),:);
    [worldOrientation_est, worldLocation_est, ~ , status] = estimateWorldCameraPose(imagePoints_est,...
    worldPoints, cameraParams, 'MaxReprojectionError', 1000);

    if status == 2
        continue;
    end

    [R_est, t_est] = cameraPoseToExtrinsics(worldOrientation_est, worldLocation_est);
    inliers = 0;
    for j = 1:size(matches,2)

        reproj_pt = worldToImage(cameraParams,R_est,t_est,xAll(matches(2,j),:));
        orig_pt = [fa(1, matches(1,j)), fa(2,matches(1,j))];

        %disp('orig pt: ');disp(orig_pt)
        
        euc_dist = sqrt(sum((reproj_pt - orig_pt).^2));
        
        %disp('dist:');disp(euc_dist)        
        if euc_dist <= threshold
            inliers = inliers + 1;
%             disp(euc_dist)
        end
    end
    if inliers > max_inliers
        max_inliers = inliers;
        best_rot = worldOrientation_est;
        best_trans = worldLocation_est;
        
    end
end
close(wb)
%%
% image = matches(1,:); % indices of test image
% % imagePoints_ind_est = fa[:,indices];
% imagePoints_est(:,1) = imagePoints_ind_est(1,:);
% imagePoints_est(:,2) = imagePoints_ind_est(2,:);
% worldPoints_est = xdetected;
% [worldOrientation_est, worldLocation_est] = estimateWorldCameraPose(imagePoints_est,...
%     worldPoints, cameraParams)
%% let's plot the cam
figure()
mesh_orig = read_ply('C:\Users\Jorgue Guerra\td-projects\ex1\data\data\model\teabox.ply');
pcshow(mesh_orig,'VerticalAxis','Y','VerticalAxisDir','down', ...
     'MarkerSize',1000);
hold on
cam_size = 0.0125;
plotCamera('Size',cam_size,'Orientation',best_rot,'Location',...
     best_trans);
hold on
% plotCamera('Size',cam_size,'Orientation',worldOrientation1,'Location',...
%       worldLocation1);


%%  
% indexes = matches(2,:); % indices of train dataset
% xdetected = xAll(indexes,:,:); % see which 3d points matched from our dataset
% scatter3(xdetected(:,1,:), xdetected(:,2,:), xdetected(:,3,:));
% %% automatic part
% K = [2960.37845, 0, 1841.68855;
%                 0, 2960.37845, 1235.23369;
%                 0, 0, 1];
% K = [2960.37845 0 0; 0 2960.37845 0; 1841.68855 1235.23369 1];
% cameraParams = cameraParameters('IntrinsicMatrix',K);
% tex1 = imread('C:\Users\rajat\Dropbox\WiSe18\TDCV\exercise02\data\images\detection\DSC_9751.jpg');
% indexes_test = matches(1,:);
% imagePoints_beta = fa(:,indexes_test);
% imagePoints_(:,2) = imagePoints_beta(1,:);
% imagePoints_(:,1) = imagePoints_beta(2,:);
% worldPoints = xdetected;
% [worldOrientation_est, worldLocation_est] = estimateWorldCameraPose(imagePoints_,...
%     worldPoints, cameraParams, 'MaxNumTrials', 1000000)         
% mesh_orig = read_ply('C:\Users\rajat\Dropbox\WiSe18\TDCV\exercise01\data\data\model\teabox.ply');
% 
% pcshow(mesh_orig,'VerticalAxis','Y','VerticalAxisDir','down', ...
%      'MarkerSize',1000);
% hold on
% cam_size = 0.0125
% plotCamera('Size',cam_size,'Orientation',worldOrientation_est,'Location',...
%      worldLocation_est);
% hold on
% plotCamera('Size',cam_size,'Orientation',worldOrientation1,'Location',...
%       worldLocation1);
% figure();
% imshow(tex1);
% [R_est, t_est] = cameraPoseToExtrinsics(worldOrientation_est, worldLocation_est);
% %%
% [R_est, t_est] = cameraPoseToExtrinsics(best_rot, best_trans);
% tex1 = imread('C:\Users\rajat\Dropbox\WiSe18\TDCV\exercise02\data\images\detection\DSC_9751.jpg');
% 
% w_cam = [];
% for i = (1:8)
%     w_cam = [w_cam, K*[R_est, t_est']*[mesh_orig(i,:),1]'];
% end
% w_cam(1,:) = w_cam(1,:)./w_cam(3,:);
% w_cam(2,:) = w_cam(2,:)./w_cam(3,:);
% w_cam(3,:) = w_cam(3,:)./w_cam(3,:);
% figure();
% 
% % imshow(tex1);
% hold on;
% plot(w_cam(1,:), w_cam(2,:),'r*')
% %tex1(round(w_cam(2,1)), round(w_cam(1,1)),:) = [0,0,0];
% %imshow(tex1)
%% function repository
function data=load_images(path)
old_path = cd;
cd(path);
files= dir('**/*.JPG');
im=imread(files(1).name);
im=single(rgb2gray(im));
data = zeros(size(im,1),size(im,2),length(files));
for i= 1:length(files)
    im=imread(files(i).name);
    data(:,:,i)= single(rgb2gray(im));
end
cd(old_path)
data = single (data);
end