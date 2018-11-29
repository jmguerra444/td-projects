%% Check dataset is available
if ~isfile('data/images/detection/DSC_9757.JPG')
    error ('make sure you have downloaded the dataset')
end

%% Loads necessary data
clear
load('../ex1/xAll.mat')
load('../ex1/CameraParams.mat');
load('../ex1/sift_points.mat'); %loads old sift points


if and(isfile ('new_sift_points.mat'),isfile ('new_images.mat'))
    disp ('Your images and and sift point of training data were sucesfully loaded')
    load ('new_sift_points.mat');
    load ('new_images.mat')
else
    wb = waitbar(0,'Wait... images are being loaded');
    new_images = load_images('data/images/detection');
    new_sift_points = cell (size(new_images, 3),1);
    for I = 1:size(new_images,3)
        wb = waitbar(I/size(new_images,3),wb,'Please wait...computing sift points');
        [f,d] = vl_sift(new_images(I));
        sift_.features = f;
        sift_.descriptor = d;
        new_sift_points{I} = sift_;
    end
    clear f d sift_
    save new_images new_images
    save new_sift_points new_sift_points
    close(wb)
end
return