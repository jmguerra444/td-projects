%run('/u/halle/calvaron/home_at/bin/vlfeat-0.9.21//toolbox/vl_setup')

images = load_images('data/data/images/init_texture');
load('CameraParams.mat');
xAll = [];


for imIn = 1:8
    disp(imIn)
    I = squeeze(images(:,:,imIn));
    [f,d] = vl_sift(I) ;
    %%
    [vertices, faces] = read_ply('./data/data/model/teabox.ply');
    faces(9:10,:) = [];
    centroid = [0.165 0.063 0.093]./2;
    %WL(:,:,imIn) = worldLocation2;
    %WO(:,:,imIn) = worldOrientation2;
    cameraVector = centroid - WL(:,:,imIn);
    % Estimate a threshold (not so accurate)
    facestemp = faces;
    xList = [];
    for i =(1:10)
        vector1 = vertices(faces(i,2)+1,:) - vertices(faces(i,1)+1,:);
        vector2 = vertices(faces(i,3)+1,:) - vertices(faces(i,1)+1,:);
        normal = cross(vector1,vector2);
        CosTheta = dot(cameraVector,normal)/(norm(cameraVector)*norm(normal));
        ThetaInDegrees = acosd(CosTheta);
        if ThetaInDegrees < 100
            xList = [xList;i];
        end
    end
    facestemp(xList,:) = [];
    %%
    WLiter = WL(:,:,imIn);
    WOiter = WO(:,:,imIn);
    for j = (1:size(facestemp,1))
        xCr = computePoints(WLiter,WOiter,intrinsic_matrix,f,vertices,facestemp(j,:) + 1);
        disp('face:')
        disp(j)
        size(xCr,1)
        xAll = [xAll; xCr];
    end
end
%%
figure;
scatter3(xAll(:,1,:), xAll(:,2,:), xAll(:,3,:))

function xCoorVec=computePoints(WLj,WOj,intrinsic_matrix,f,vertices,visibleTriangle)
[R, t] = cameraPoseToExtrinsics(WOj, WLj);
Q = intrinsic_matrix' * R;
q = intrinsic_matrix' * t';
C = -Q\q;
fLine = @(x,y) (C + Q\[x,y,1]');
xCoorVec = [];
for i = (1:size(f,2))
    [intersect, t, u, v, xcoor] = TriangleRayIntersection(C, fLine(f(1,i),f(2,i)), vertices(visibleTriangle(1),:), vertices(visibleTriangle(2),:), vertices(visibleTriangle(3),:));
    if(intersect)
        xCoorVec = [xCoorVec;[xcoor]];
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


