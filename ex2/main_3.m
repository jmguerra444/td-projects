%% set up VLFeat
%VLFEATROOT = 'D:/vlfeat-0.9.21/toolbox/vl_setup'
load('desc_loc.mat'); %load descriptors and correspondig features
path_test = 'data\images\detection';

if ~exist('images_test','var')
    images_test = load_images(path_test);
end

%% hyperparameters and initialization
iterations = 1000;
threshold = 50;
n = 4;
K = [2960.37845 0 0; 0 2960.37845 0; 1841.68855 1235.23369 1]; %intrinsics
cameraParams = cameraParameters('IntrinsicMatrix',K);


%% iterate over images
num_images = 15;
cameras = cell (num_images,3);

mesh_orig = read_ply('C:\Users\Jorgue Guerra\td-projects\ex1\data\data\model\teabox.ply');
pcshow(mesh_orig,'VerticalAxis','Y','VerticalAxisDir','down','MarkerSize',1000);
hold on

for imIn = 1:num_images 
    best_inlier = 0;
    max_inliers = 0;
    best_rot = zeros(3, 3); best_WO = 0; best_WL = 0;
    best_trans = zeros(3, 1);
    
    string_ = strcat("camera ", num2str(imIn)," of ",num2str(num_images)," is being processed");
    wb = waitbar(0, char(string_));
    I = images_test(:,:,imIn);
    disp ("Computing SIFT features")
    [fa, da] = vl_sift(I);
    disp ("Done.")
    [matches,~] = vl_ubcmatch(da, dAll');
    
    for i = 1:iterations
        wb = waitbar(i/iterations,wb, char(string_));
        %samples n=4 random points
        rand_n_points = randi(size(matches, 2), n, 1);
        
        %get corresponding world points that match those image points
        imagePoints_est = [fa(1, matches(1,rand_n_points)); fa(2,matches(1,rand_n_points))]';
        worldPoints = xAll(matches(2,rand_n_points),:);
        
        % Compute R|t with random points
        [worldOrientation_est, worldLocation_est, ~ , status] = estimateWorldCameraPose(imagePoints_est,...
            worldPoints, cameraParams, 'MaxReprojectionError', 1000);

        if status == 2
            continue;
        end
        
        [R_est, t_est] = cameraPoseToExtrinsics(worldOrientation_est, worldLocation_est);
        inliers = 0;
        world_point_est = [];
        image_point_est =[];
        
        % get inliners within thershold
        for j = 1:size(matches,2)
            wp = xAll(matches(2,j),:); % 3D point to be tested
            ip = [fa(1, matches(1,j)), fa(2,matches(1,j))]; %2D
            reproj_pt = worldToImage(cameraParams,R_est,t_est, wp );
            orig_pt = ip;           
            euc_dist = sqrt(sum((reproj_pt - orig_pt).^2));
   
            if euc_dist <= threshold %wp + ip is an inliner
                inliers = inliers + 1;
                world_point_est = [world_point_est; wp];
                image_point_est = [image_point_est; ip];
            end
        end
        
        
        % compute better R|t with inliners found
        if inliers > 5 %arbitrary thershold
            
            %better model
            [worldOrientation_est, worldLocation_est, ~ , status] = estimateWorldCameraPose(image_point_est,...
                world_point_est, cameraParams, 'MaxReprojectionError', 1000); 
            %better camera pose
            [R_est, t_est] = cameraPoseToExtrinsics(worldOrientation_est, worldLocation_est);

            inliers_better_model = 0;
            
            for j = 1:size(matches,2)
                wp = xAll(matches(2,j),:); % 3D point to be tested
                ip = [fa(1, matches(1,j)), fa(2,matches(1,j))]; % 2d location of feature
                reproj_pt = worldToImage(cameraParams,R_est,t_est, wp );
                orig_pt = ip;
                euc_dist = sqrt(sum((reproj_pt - orig_pt).^2));
                
                if euc_dist <= threshold %wp + ip is an inliner
                    inliers_better_model = inliers_better_model + 1;
                end
            end 
             disp([i inliers inliers_better_model max_inliers])

            if inliers_better_model > max_inliers
                max_inliers = inliers_better_model;
                best_rot = R_est;
                best_trans = t_est;
                best_WO = worldOrientation_est;
                best_WL = worldLocation_est;
            end
        end
        
    end
    
    close(wb)
    cameras{imIn,1} = best_rot;
    cameras{imIn,2} = best_trans;
    cameras{imIn,3} = max_inliers;
    disp("Maximum inliners " + max_inliers)
    
    cam_size = 0.0125;
    WO = best_WO; WL = best_WL;
    plotCamera('Size',cam_size,'Orientation',WO,'Location',WL,'color',[1 0 0]);
    hold on

end

%% Attempt to draw 3D points in 2D
for j=1:num_images
    close all
    aux = images_test(:,:,j);
    R = cameras {j,1};
    t = cameras {j,2};
    projectedPoints = worldToImage(cameraParams, R, t, mesh_orig);
    plotBounding3D(projectedPoints', int64(aux))
end

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