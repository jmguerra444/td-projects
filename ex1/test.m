%%
mesh_orig = read_ply('C:\Users\rajat\Dropbox\WiSe18\TDCV\exercise01\data\data\model\teabox.ply');
K = [2960.37845, 0, 1841.68855;
                0, 2960.37845, 1235.23369;
                0, 0, 1];
originWorld =  mesh_orig(8, :);
tex1 = imread('C:\Users\rajat\Dropbox\WiSe18\TDCV\exercise01\data\data\images\init_texture\DSC_9743.jpg');
tex2 = imread('C:\Users\rajat\Dropbox\WiSe18\TDCV\exercise01\data\data\images\init_texture\DSC_9744.jpg');
tex3 = imread('C:\Users\rajat\Dropbox\WiSe18\TDCV\exercise01\data\data\images\init_texture\DSC_9745.jpg');
tex4 = imread('C:\Users\rajat\Dropbox\WiSe18\TDCV\exercise01\data\data\images\init_texture\DSC_9746.jpg');
tex5 = imread('C:\Users\rajat\Dropbox\WiSe18\TDCV\exercise01\data\data\images\init_texture\DSC_9747.jpg');
tex6 = imread('C:\Users\rajat\Dropbox\WiSe18\TDCV\exercise01\data\data\images\init_texture\DSC_9748.jpg');
tex7 = imread('C:\Users\rajat\Dropbox\WiSe18\TDCV\exercise01\data\data\images\init_texture\DSC_9749.jpg');
tex8 = imread('C:\Users\rajat\Dropbox\WiSe18\TDCV\exercise01\data\data\images\init_texture\DSC_9750.jpg');

tex1_pts = [4, 8, 7, 3, 2, 1];
tex2_pts = [3, 7, 6, 2, 1, 4, 8];
tex3_pts = [3, 7, 6, 2, 1, 4];
tex4_pts = [2, 6, 5, 1, 4, 3, 7];
tex5_pts = [2, 6, 5, 1, 4, 3];
tex6_pts = [1, 5, 8, 4, 3, 2, 6];
tex7_pts = [1, 5, 8, 4, 3, 2];
tex8_pts = [4, 8, 7, 3, 2, 1, 5];

IntrinsicMatrix = [2960.37845 0 0; 0 2960.37845 0; 1841.68855 1235.23369 1];
cameraParams = cameraParameters('IntrinsicMatrix',IntrinsicMatrix); 

useSaved = 0;
%% tex1
% do for image1
figure();
imshow(tex1);
% use mouse button to zoom in or out
% Press Enter to get out of the zoom mode
zoom on;
% Wait for the most recent key to become the return/enter key
waitfor(gcf, 'CurrentCharacter', char(13))
zoom reset
zoom off
if useSaved == 1
    imagePoints = imagePointsTex1;
else
    imagePoints = ginput(size(tex1_pts, 2))
end
worldPoints = mesh_orig(tex1_pts,:,:);

[worldOrientation1, worldLocation1] = estimateWorldCameraPose(imagePoints,...
    worldPoints, cameraParams, 'MaxReprojectionError', 15)
% imagePointsTex1 = imagePoints;
close all
%% tex2
% do for image2
figure();
imshow(tex2);
% use mouse button to zoom in or out
% Press Enter to get out of the zoom mode
zoom on;
% Wait for the most recent key to become the return/enter key
waitfor(gcf, 'CurrentCharacter', char(13))
zoom reset
zoom off
if useSaved == 1
    imagePoints = imagePointsTex2;
else
    imagePoints = ginput(size(tex2_pts, 2))
end
worldPoints = mesh_orig(tex2_pts,:,:);

[worldOrientation2, worldLocation2] = estimateWorldCameraPose(imagePoints,...
    worldPoints, cameraParams, 'MaxReprojectionError', 6)
% imagePointsTex2 = imagePoints;
close all

%% tex3
figure();
imshow(tex3);
% use mouse button to zoom in or out
% Press Enter to get out of the zoom mode
zoom on;
% Wait for the most recent key to become the return/enter key
waitfor(gcf, 'CurrentCharacter', char(13))
zoom reset
zoom off
if useSaved == 1
    imagePoints = imagePointsTex3;
else
    imagePoints = ginput(size(tex3_pts, 2))
end
worldPoints = mesh_orig(tex3_pts,:,:);
[worldOrientation3, worldLocation3] = estimateWorldCameraPose(imagePoints,...
    worldPoints, cameraParams, 'MaxReprojectionError', 6)
% imagePointsTex3 = imagePoints;
close all
%% tex4
figure();
imshow(tex4);
% use mouse button to zoom in or out
% Press Enter to get out of the zoom mode
zoom on;
% Wait for the most recent key to become the return/enter key
waitfor(gcf, 'CurrentCharacter', char(13))
zoom reset
zoom off
if useSaved == 1
    imagePoints = imagePointsTex4;
else
    imagePoints = ginput(size(tex4_pts, 2))
end
worldPoints = mesh_orig(tex4_pts,:,:);
[worldOrientation4, worldLocation4] = estimateWorldCameraPose(imagePoints,...
    worldPoints, cameraParams, 'MaxReprojectionError', 6)
% imagePointsTex4 = imagePoints;
close all
%% tex5
figure();
imshow(tex5);
% use mouse button to zoom in or out
% Press Enter to get out of the zoom mode
zoom on;
% Wait for the most recent key to become the return/enter key
waitfor(gcf, 'CurrentCharacter', char(13))
zoom reset
zoom off
if useSaved == 1
    imagePoints = imagePointsTex5;
else
    imagePoints = ginput(size(tex5_pts, 2))
end
worldPoints = mesh_orig(tex5_pts,:,:);
[worldOrientation5, worldLocation5] = estimateWorldCameraPose(imagePoints,...
    worldPoints, cameraParams, 'MaxReprojectionError', 6)
% imagePointsTex5 = imagePoints;
close all
%% tex6
figure();
imshow(tex6);
% use mouse button to zoom in or out
% Press Enter to get out of the zoom mode
zoom on;
% Wait for the most recent key to become the return/enter key
waitfor(gcf, 'CurrentCharacter', char(13))
zoom reset
zoom off
if useSaved == 1
    imagePoints = imagePointsTex6;
else
    imagePoints = ginput(size(tex6_pts, 2))
end
worldPoints = mesh_orig(tex6_pts,:,:);
[worldOrientation6, worldLocation6] = estimateWorldCameraPose(imagePoints,...
    worldPoints, cameraParams, 'MaxReprojectionError', 6)
% imagePointsTex6 = imagePoints;
close all
%% tex7
figure();
imshow(tex7);
% use mouse button to zoom in or out
% Press Enter to get out of the zoom mode
zoom on;
% Wait for the most recent key to become the return/enter key
waitfor(gcf, 'CurrentCharacter', char(13))
zoom reset
zoom off
if useSaved == 1
    imagePoints = imagePointsTex7;
else
    imagePoints = ginput(size(tex7_pts, 2))
end
worldPoints = mesh_orig(tex7_pts,:,:);
[worldOrientation7, worldLocation7] = estimateWorldCameraPose(imagePoints,...
    worldPoints, cameraParams, 'MaxReprojectionError', 6)
% imagePointsTex7 = imagePoints;
close all
%% tex8
figure();
imshow(tex8);
% use mouse button to zoom in or out
% Press Enter to get out of the zoom mode
zoom on;
% Wait for the most recent key to become the return/enter key
waitfor(gcf, 'CurrentCharacter', char(13))
zoom reset
zoom off
if useSaved == 1
    imagePoints = imagePointsTex8;
else
    imagePoints = ginput(size(tex8_pts, 2))
end
worldPoints = mesh_orig(tex8_pts,:,:);
[worldOrientation8, worldLocation8] = estimateWorldCameraPose(imagePoints,...
    worldPoints, cameraParams, 'MaxReprojectionError', 6)
% imagePointsTex7 = imagePoints;
close all;
%% plot
pcshow(mesh_orig,'VerticalAxis','Y','VerticalAxisDir','down', ...
     'MarkerSize',1000);
hold on
cam_size = 0.025
plotCamera('Size',cam_size,'Orientation',worldOrientation1,'Location',...
     worldLocation1);
waitfor(gcf, 'CurrentCharacter', char(13))
plotCamera('Size',cam_size,'Orientation',worldOrientation2,'Location',...
    worldLocation2);
plotCamera('Size',cam_size,'Orientation',worldOrientation3,'Location',...
     worldLocation3);
plotCamera('Size',cam_size,'Orientation',worldOrientation4,'Location',...
     worldLocation4);
plotCamera('Size',cam_size,'Orientation',worldOrientation5,'Location',...
     worldLocation5);
plotCamera('Size',cam_size,'Orientation',worldOrientation6,'Location',...
     worldLocation6);
plotCamera('Size',cam_size,'Orientation',worldOrientation7,'Location',...
     worldLocation7);
plotCamera('Size',cam_size,'Orientation',worldOrientation8,'Location',...
     worldLocation8);
hold off 
%% set up VLFeat
%VLFEATROOT = 'D:/vlfeat-0.9.21/toolbox/vl_setup'
run('D:/vlfeat-0.9.21/toolbox/vl_setup')
vl_version verbose
% vl_setup demo
% vl_demo_sift_basic
% http://www.vlfeat.org/install-matlab.html

%% perform sift
I = single(rgb2gray(tex1)) ;
imshow(tex1);
% clf ; 
% imagesc(I)
% imshow(I)
% axis equal ; axis off ; axis tight ;
% vl_demo_print('sift_basic_1') ;

[f,d] = vl_sift(I) ;

hold on ;
% perm = randperm(size(f,2)) ;
% sel  = perm(1:50) ;
h1   = vl_plotframe(f) ; set(h1,'color','k','linewidth',3) ;
h2   = vl_plotframe(f) ; set(h2,'color','y','linewidth',2) ;

vl_demo_print('sift_basic_2') ;

% delete([h1 h2]);
% 
% h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
% set(h3,'color','k','linewidth',2) ;
% h4 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
% set(h4,'color','g','linewidth',1) ;
% h1   = vl_plotframe(f(:,sel)) ; set(h1,'color','k','linewidth',3) ;
h2   = vl_plotframe(f) ; 
% set(h2,'color','y','linewidth',2) ;

vl_demo_print('sift_basic_3') ;
 %% extra stuff
[R1, t1] = cameraPoseToExtrinsics(worldOrientation1, worldLocation1);
Q1 = K*R1;
q1 = K*t1';

C1 = -Q1\q1;

xcoor_array = [];
[mesh_orig, face_orig] = read_ply('C:\Users\rajat\Dropbox\WiSe18\TDCV\exercise01\data\data\model\teabox.ply');
face_vertices = [mesh_orig(4,:); mesh_orig(7,:); mesh_orig(8,:)];
for index = (1:size(f,2))
    m = [f(1:2,index);1];

    rayDirection = C1 + Q1\m;

    [intersect, t, u, v, xcoor] = TriangleRayIntersection (...
    C1, rayDirection, mesh_orig(4,:), mesh_orig(7,:), mesh_orig(8,:));
%     C1, rayDirection, [face_vertices(1,:),1] , [face_vertices(2,:),1], [face_vertices(3,:),1]);
    
    if(intersect)
%         disp(xcoor)
        xcoor_array = [xcoor_array; xcoor];
    end
end


xcoor_array2 = [];
for index = (1:size(f,2))
    m = [f(1:2,index);1];

    rayDirection = C1 + Q1\m;

    [intersect, t, u, v, xcoor] = TriangleRayIntersection (...
    C1, rayDirection, mesh_orig(4,:), mesh_orig(1,:), mesh_orig(3,:));
%     C1, rayDirection, [face_vertices(1,:),1] , [face_vertices(2,:),1], [face_vertices(3,:),1]);
    C1
    if(intersect)
%         disp(xcoor)
        xcoor_array2 = [xcoor_array2; xcoor];
    end
end
isequal(xcoor_array, xcoor_array2)
%%
% pcshow(mesh_orig,'VerticalAxis','Y','VerticalAxisDir','down', ...
%      'MarkerSize',1000);
%  hold on
% pcshow(xcoor_array,'VerticalAxis','Y','VerticalAxisDir','down', ...
%      'MarkerSize',1000);
% pcshow(xcoor_array2,'VerticalAxis','Y','VerticalAxisDir','down', ...
%      'MarkerSize',1000);
scatter3(xcoor_array(:,1,:), xcoor_array(:,2,:), xcoor_array(:,3,:)) 
hold on; 
scatter3(xcoor_array2(:,1,:), xcoor_array2(:,2,:), xcoor_array2(:,3,:))