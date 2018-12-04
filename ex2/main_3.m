%% set up VLFeat
%VLFEATROOT = 'D:/vlfeat-0.9.21/toolbox/vl_setup'
load('desc_loc.mat'); %load descriptors and correspondig features
path_test = 'ex2\data\images\detection';

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
num_images = 1;
cameras = cell (num_images,3);

mesh_orig = read_ply('C:\Users\Jorgue Guerra\td-projects\ex1\data\data\model\teabox.ply');
pcshow(mesh_orig,'VerticalAxis','Y','VerticalAxisDir','down','MarkerSize',1000);
hold on

for imIn = 1:num_images 
    
    max_inliers = 0;
    best_rot = zeros(3, 3);
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
     
        [worldOrientation_est, worldLocation_est, ~ , status] = estimateWorldCameraPose(imagePoints_est,...
            worldPoints, cameraParams, 'MaxReprojectionError', 500);
        prueba = 100*(worldPoints .* [1/0.165 1/0.063 1/0.093]);

        if status == 2
            continue;
        end
        
        [R_est, t_est] = cameraPoseToExtrinsics(worldOrientation_est, worldLocation_est);
        inliers = 0;
        
        for j = 1:size(matches,2)
            reproj_pt = worldToImage(cameraParams,R_est,t_est,xAll(matches(2,j),:));
            orig_pt = [fa(1, matches(1,j)), fa(2,matches(1,j))];           
            euc_dist = sqrt(sum((reproj_pt - orig_pt).^2));
            
            if euc_dist <= threshold
                inliers = inliers + 1;
            end
        end
        
        if inliers > max_inliers
            max_inliers = inliers;
            best_rot = worldOrientation_est;
            best_trans = worldLocation_est;          
        end
    end
    close(wb)
    cameras{imIn,1} = best_rot;
    cameras{imIn,2} = best_trans;
    cameras{imIn,3} = max_inliers;
    disp("Maximum inliners " + max_inliers)
    
    cam_size = 0.0125;
%TODO: are we sure that best_rot and best_trans are the correct parameters
%for camera plotting, check this
%https://www.mathworks.com/help/vision/ref/extrinsicstocamerapose.html
    
    %[WO,WL] = extrinsicsToCameraPose(best_rot,best_trans);
    WO = best_rot; WL = best_trans;
    plotCamera('Size',cam_size,'Orientation',WO,'Location',WL,'color',[1 0 0]);
    hold on

end

%% Attempt to draw 3D points in 2D

image_points = zeros (size(mesh_orig,1),2);
for j=1:num_images
    aux = images_test(:,:,j);
    for i=1:size(mesh_orig,1)
        R = cameras {j,1};
        t = cameras {j,2};
        image_points(i,:) =  worldToImage (cameraParams,R,t,mesh_orig(i,:));
        image_points = int64(abs(image_points));
        %aux = rgb2gray(insertMarker(aux,image_points(i,:)));
    end
    %aux(image_points)=255;
    figure()
    imshow(aux,[])
    hold on
    plot(image_points(:,1),image_points(:,2), 'r+', 'MarkerSize', 30, 'LineWidth', 2);
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