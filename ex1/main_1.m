%%
%Right-Hand Method: index (X), middle (Y), thumb (Z)
num_vertexes = 8; 

%% Get points
if ~true
    points=mark_images('data/data/images/init_texture',num_vertexes);
    save points
else
    load('points_ok.mat');
end

%% Load Poly and generate intrinsics matrix
% Load Ply
[ply_vertex, ~ ] = read_ply('data/data/model/teabox.ply');

%Camera Parameters
fx = 2960.37845;  %Ku*f
fy = 2960.37845;  %Kv*f     pixel_size_X = pizel_size_Y  
                  %focal lenght
s  = 1;
cx = 1841.68855;    
cy = 1235.23369;  %projection of camera centre in the image coordinate system  

intrinsic_matrix = [fx 0 0; s fy 0; cx cy 1];
cam_par = cameraParameters('IntrinsicMatrix',intrinsic_matrix);

%% Estimate carema pose

WO = zeros(3,3,size(points,3));
WL = zeros(1,3,size(points,3));
pcshow(ply_vertex,'VerticalAxis','Y',...
       'VerticalAxisDir','down','MarkerSize',200);
hold on

for i=1:size(points,3)
    image_points=points(:,:,i);
    world_points= ply_vertex;
    world_points(any(isnan(image_points), 2), :) = [];
    image_points(any(isnan(image_points), 2), :) = [];
    [WO(:,:,i),WL(:,:,i)] = estimateWorldCameraPose(image_points,...
        world_points,cam_par,'MaxReprojectionError',15);
    
    plotCamera('Size',0.05,'Orientation',WO(:,:,i),'Location',...
     WL(:,:,i));
    hold on
end

hold off
clear fx fy s cx cy world_points image_points

%% 
function points= mark_images(path, num_vertexes)
   imshow(imread('data/data/images/init_texture/guia.png'))
   uiwait(msgbox('plase follow the shown patern')) 
   old_path = cd; 
   cd(path);
   files= dir('**/*.JPG');
   points = NaN(num_vertexes,2,length(files));
   figure('units','normalized','outerposition',[0 0 1 1])

   for j=1:num_vertexes
       for i= 1:length(files)
       imshow(imread(files(i).name))
       title(strcat('click on the outside left of image to skip-- current corner: -',num2str(j)));
       [x,y]=getpts;
       points(j,1:2,i)= [x,y];
       end
       uiwait(msgbox('track next point'));
       
   end
   points(points<0)=NaN;
   cd(old_path)
   close all
end