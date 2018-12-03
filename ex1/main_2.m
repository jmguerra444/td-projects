%% This script contains SIFT feature interception given camera angles

clear
images = load_images('data/data/images/init_texture');
load('CameraParams.mat');
[vertices, faces] = read_ply('./data/data/model/teabox.ply'); 

faces(9:10,:) = []; %deletes not visible faces
centroid = [0.165 0.063 0.093]./2;
xAll = [];
dAll = [];
wb = waitbar(0,'Please wait...');
for imIn = 1:size(images,3) %iterates over camera pose
    
    wb = waitbar(imIn/size(images,3),wb,'Please wait...');
    I = images(:,:,imIn);
    [f,d] = vl_sift(I) ;
    
    cameraVector = centroid - WL(:,:,imIn);
    
    % Estimate a threshold (not so accurate)
    facestemp = faces;
    xList = [];
    
    for i =(1:size(faces,1)) %checks what faces intercept that camera angle
        vector1 = vertices(faces(i,2)+1,:) - vertices(faces(i,1)+1,:);
        vector2 = vertices(faces(i,3)+1,:) - vertices(faces(i,1)+1,:);
        normal = cross(vector1,vector2);
        CosTheta = dot(cameraVector,normal)/(norm(cameraVector)*norm(normal));
        ThetaInDegrees = acosd(CosTheta);
        
        if ThetaInDegrees < 95
            xList = [xList;i];
        end
    end
    facestemp(xList,:) = [];
    %%
    WLiter = WL(:,:,imIn);
    WOiter = WO(:,:,imIn);
    for j = (1:size(facestemp,1)) %find points corresponding to 
        [xCr, dCr] = computePoints(WLiter,WOiter,intrinsic_matrix,f,d,vertices,facestemp(j,:) + 1);
        xAll = [xAll; xCr];
        dAll = [dAll; dCr];
    end
end

close(wb)
figure;
scatter3(xAll(:,1,:), xAll(:,2,:), xAll(:,3,:))
save('desc_loc.mat','xAll', 'dAll');

%% Funtion repository
function [xCoorVec, dListVec] = computePoints(WLj,WOj,intrinsic_matrix,f,d,vertices,visibleTriangle)
[R, t] = cameraPoseToExtrinsics(WOj, WLj);
Q = intrinsic_matrix' * R;
q = intrinsic_matrix' * t';
C = -Q\q;
fLine = @(x,y) (C + Q\[x,y,1]');
xCoorVec = [];
dListVec = [];
    for i = (1:size(f,2))
        [intersect, ~, ~, ~, xcoor] = TriangleRayIntersection(C, fLine(f(1,i),...
                                       f(2,i)), vertices(visibleTriangle(1),:),...
                                       vertices(visibleTriangle(2),:),...
                                       vertices(visibleTriangle(3),:));
        if(intersect)
            xCoorVec = [xCoorVec; xcoor];
            dListVec = [dListVec; d(:,i)'];
        end
    end
end

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


