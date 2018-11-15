%Load Data
images = load_images('data\data\images\init_texture');

%Compute SIFT features
[feat,desc]=compute_sift(images);

%%
function data=load_images(path)
   old_path = cd; 
   cd(path);
   files= dir('**/*.jpg');
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

function [features,descriptor] = compute_sift(data)
    features= cell(size(data,3)); %A frame is a disk of center f(1:2), scale f(3) and orientation f(4)
    descriptor= cell (size(data,3));
    f = waitbar(0,'Please wait...');
    for i=1:size(data,3)
       f = waitbar(i/size(data,3),f,'Please wait...');
       [features{i},descriptor{i}]= vl_sift(data(:,:,i));
    end
    close(f)
end