% load descriptors and correspondig features
load('desc_loc.mat'); 
path_test = 'images\tracking';
teabox = read_ply('teabox.ply');

if ~exist('images_track','var')
    disp('loading images')
    images_track = load_images(path_test);
end

num_images = 2; %has to be al least 2

%% Compute initial pose using ransac
disp('computing initial camera pose')
disp('Computing features')
[fa0, da0] = vl_sift(images_track(:,:,1)); %gets features of the first image
disp('finding matches')
[matches,~] = vl_ubcmatch(da0, dAll'); %da: descriptor image
                                      %dAll: descriptors database
                                      %fa(1:2,:): coordinates of features in I0
num_iterations = 100;
threshold = 50;
cameraParams = getCameraParams();
disp('doing RANSAC')
[R0,t0] = getinitial_Extrinsecs(matches,fa0, xAll, cameraParams,num_iterations, threshold);
projectedPoints = worldToImage(cameraParams, R0, t0, teabox);
plotBounds(projectedPoints', int64(images_track(:,:,1)))
disp(size(matches))

%% Track next frames

for imIn =2:num_images
    [fa, da] = vl_sift(images_track(:,:,1));
    [matches,~] = vl_ubcmatch(da0, da);
end


%% Function appendix

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

function cameraParams = getCameraParams()
fx = 2960.37845;  %Ku*f
fy = 2960.37845;  %Kv*f     pixel_size_X = pizel_size_Y
%focal lenght
s  = 1;
cx = 1841.68855;
cy = 1235.23369;  %projection of camera centre in the image coordinate system

K = [fx 0 0; s fy 0; cx cy 1];
cameraParams = cameraParameters('IntrinsicMatrix',K);
end
