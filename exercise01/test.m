% author: Adria Font
% date: 14 November 2018
% MIT License
% https://spdx.org/licenses/MIT.html

%%
addpath('./data');
addpath('./auxiliary_code');
%% Get world Points
[worldPoints, face] = read_ply('./data/data/model/teabox.ply');
%%  intrinsic parameters fu fv cx cu
IntrinsicMatrix = [2960.37845 0 0; 0 2960.37845 0; 1841.68855 1235.23369 1];
cameraParams = cameraParameters('IntrinsicMatrix',IntrinsicMatrix);
%% Point selection interface
path = './data/data/images/init_texture';
path_template = fullfile(path, '*.JPG');
img_files = dir(path_template);
num_files = length(img_files);
% Initialize arrays TODO: point sequence more intuitive.
pointIndices = {};
worldOrientationAll = {};
worldLocationAll = {};
pointIndices{1} = [4, 8, 7, 3, 2, 1];
pointIndices{2} = [4, 8, 7, 3, 2, 1, 6];
pointIndices{3} = [4, 7, 3, 2, 1, 6];
pointIndices{4} = [4, 7, 3, 2, 1, 5, 6];
pointIndices{5} = [4, 3, 2, 1, 5, 6];
pointIndices{6} = [4, 8, 3, 2, 1, 5, 6];
pointIndices{7} = [4, 8, 3, 2, 1, 5];
pointIndices{8} = [4, 8, 7, 3, 2, 1, 5];
% Initialize figure
figure;
% For every point iterate through image files
for j=1:num_files
    img_data = imread(fullfile(path, img_files(j).name));
    imshow(img_data);
    title_message_1 = sprintf('Image №%d  ', j);
    title(title_message_1)
    [x,y] = getpts();
    numVisiblePoints = numel(x);
    imagePoints = [x,y];
    [worldOrientation, worldLocation] = estimateWorldCameraPose(imagePoints, worldPoints(pointIndices{j},:), cameraParams,'MaxReprojectionError',6);
    worldOrientationAll{j} = worldOrientation;
    worldLocationAll{j} = worldLocation;
    
end


%% Plot obtained camera location and orientation in 3D 
figure;
pcshow(worldPoints,'verticalAxis','Y','verticalAxisDir','down','Markersize',1000)
camSize = 0.025;
for j=1:num_files
    hold on;
    plotCamera('Size',camSize,'Orientation',worldOrientationAll{j},'Location',worldLocationAll{j});
end

