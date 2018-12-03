%% set up VLFeat
%VLFEATROOT = 'D:/vlfeat-0.9.21/toolbox/vl_setup'
run('D:/vlfeat-0.9.21/toolbox/vl_setup')
vl_version verbose
% vl_setup demo
% vl_demo_sift_basic
% http://www.vlfeat.org/install-matlab.html
%% load test images
load('desc_loc.mat')
dAllTransposed = dAll';
%%
path_test = 'C:\Users\rajat\Dropbox\WiSe18\TDCV\exercise02\data\images\detection'
images_test = load_images(path_test);
%% perform something
for imIn = 1:1 %size(images,3)
    I = images_test(:,:,imIn);
    [fa, da] = vl_sift(I);
    [matches, scores] = vl_ubcmatch(da, dAllTransposed, 2);
end
%% implement RANSAC by hand
X = randi(size(matches, 2), 4,1);
indices_test_image = matches(1,:); % indices of test image
% imagePoints_ind_est = fa[:,indices];
imagePoints_est(:,1) = imagePoints_ind_est(1,:);
imagePoints_est(:,2) = imagePoints_ind_est(2,:);
worldPoints_est = xdetected;
[worldOrientation_est, worldLocation_est] = estimateWorldCameraPose(imagePoints_est,...
    worldPoints, cameraParams)    
%%  
indexes = matches(2,:); % indices of train dataset
xdetected = xAll(indexes,:,:); % see which 3d points matched from our dataset
scatter3(xdetected(:,1,:), xdetected(:,2,:), xdetected(:,3,:));
%% automatic part
K = [2960.37845, 0, 1841.68855;
                0, 2960.37845, 1235.23369;
                0, 0, 1];
IntrinsicMatrix = [2960.37845 0 0; 0 2960.37845 0; 1841.68855 1235.23369 1];
cameraParams = cameraParameters('IntrinsicMatrix',IntrinsicMatrix);
tex1 = imread('C:\Users\rajat\Dropbox\WiSe18\TDCV\exercise02\data\images\detection\DSC_9751.jpg');
indexes_test = matches(1,:);
imagePoints_beta = fa(:,indexes_test);
imagePoints_(:,2) = imagePoints_beta(1,:);
imagePoints_(:,1) = imagePoints_beta(2,:);
worldPoints = xdetected;
[worldOrientation_est, worldLocation_est] = estimateWorldCameraPose(imagePoints_,...
    worldPoints, cameraParams, 'MaxNumTrials', 1000000)         
mesh_orig = read_ply('C:\Users\rajat\Dropbox\WiSe18\TDCV\exercise01\data\data\model\teabox.ply');

pcshow(mesh_orig,'VerticalAxis','Y','VerticalAxisDir','down', ...
     'MarkerSize',1000);
hold on
cam_size = 0.0125
plotCamera('Size',cam_size,'Orientation',worldOrientation_est,'Location',...
     worldLocation_est);
hold on
plotCamera('Size',cam_size,'Orientation',worldOrientation1,'Location',...
      worldLocation1);
figure();
imshow(tex1);
[R_est, t_est] = cameraPoseToExtrinsics(worldOrientation_est, worldLocation_est);
%%
w_cam = [];
for i = (1:8)
%     disp(i)
    w_cam = [w_cam, K*[R_est, t_est']*[mesh_orig(i,:),1]'];
end
w_cam2 = w_cam;
% w_cam2 = w_cam;
w_cam(1,:) = w_cam(1,:)./w_cam(3,:);
w_cam(2,:) = w_cam(2,:)./w_cam(3,:);
w_cam(3,:) = w_cam(3,:)./w_cam(3,:);
figure();
imshow(tex1);
hold on;
plot(w_cam(2,:), w_cam(1,:),'r*')
%tex1(round(w_cam(2,1)), round(w_cam(1,1)),:) = [0,0,0];
%imshow(tex1)
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