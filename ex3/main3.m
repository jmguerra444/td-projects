%% set up VLFeat
%VLFEATROOT = 'D:/vlfeat-0.9.21/toolbox/vl_setup'
load('desc_loc.mat'); %load descriptors and correspondig features
path_test = 'data/images/tracking';

num_images = 2;
iterations = 100;
threshold = 30;
MaxReprojectionError = 50;

%% Load / compute new features and 
if ~exist('images_test','var')
    disp('loading images')
    images_test = load_images(path_test);
end

if isfile('new_sift.mat')
    load('new_sift.mat')
else
    fa_ = cell (num_images,1);
    da_ = cell (num_images,1);
    for imIn = 1:num_images
        a = 'runnning images'
        I = images_test(:,:,imIn);
        [fa_{imIn}, da_{imIn}] = vl_sift(I);
    end
    save new_sift fa_ da_
end


%% hyperparameters and initialization
plotCam = false;
n = 4;
%Camera Parameters
fx = 2960.37845;  %Ku*f
fy = 2960.37845;  %Kv*f     pixel_size_X = pizel_size_Y  
                  %focal lenght
s  = 1;
cx = 1841.68855;    
cy = 1235.23369;  %projection of camera centre in the image coordinate system  

K = [fx 0 0; s fy 0; cx cy 1];
cameraParams = cameraParameters('IntrinsicMatrix',K);

cameras = cell (num_images,3);

mesh_orig = read_ply('teabox.ply');

if plotCam
    pcshow(mesh_orig,'VerticalAxis','Y','VerticalAxisDir','down','MarkerSize',1000);
    hold on
end
%% RANSAC 1st image to get the initial points
imIn = 1;
max_inliers = 0;
best_rot = zeros(3, 3); best_WO = 0; best_WL = 0;
best_trans = zeros(3, 1);

I = images_test(:,:,imIn);

fa = fa_{imIn}; da = da_{imIn};
disp ("Getting matches.")
[matches,~] = vl_ubcmatch(da, dAll',3);
disp ("OK")
% Compute Ransac
[best_rot,best_trans,best_WO,best_WL] = Ransac(n,matches,xAll,fa,iterations,threshold,MaxReprojectionError,cameraParams,max_inliers);

cameras{imIn,1} = best_rot;
cameras{imIn,2} = best_trans;
cameras{imIn,3} = max_inliers;
disp("Maximum inliners " + max_inliers)

cam_size = 0.0125;
WO = best_WO; WL = best_WL;

if plotCam
    plotCamera('Size',cam_size,'Orientation',WO,'Location',WL,'color',[1 0 0]);
    hold on
end

initialPoints = worldToImage(cameraParams, best_rot, best_trans, mesh_orig);
plotBounding3D(projectedPoints', int64(aux))
saveas(gcf,char("results/camera"+j),'bmp256')

%%
