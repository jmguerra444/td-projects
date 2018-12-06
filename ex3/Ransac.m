function [best_rot,best_trans,best_WO,best_WL] = Ransac(n,matches,xAll,fa,iterations,threshold,MaxReprojectionError,cameraParams,max_inliers)
%RANSAC
%   Detailed explanation goes here
    for i = 1:iterations
        %samples n=4 random points
        rand_n_points = randi(size(matches, 2), n, 1);
        
        %get corresponding world points that match those image points
        imagePoints_est = [fa(1, matches(1,rand_n_points)); fa(2,matches(1,rand_n_points))]';
        worldPoints = xAll(matches(2,rand_n_points),:);
        
        % Compute R|t with random points
        [worldOrientation_est, worldLocation_est, ~ , status] = estimateWorldCameraPose(imagePoints_est,...
            worldPoints, cameraParams, 'MaxReprojectionError', MaxReprojectionError);

        if status == 2; continue; end
        
        [R_est, t_est] = cameraPoseToExtrinsics(worldOrientation_est, worldLocation_est);
        inliers = 0;
        world_point_est = [];
        image_point_est =[];
        
        % get inliners within thershold
        for j = 1:size(matches,2)
            wp = xAll(matches(2,j),:); % 3D point to be tested
            ip = [fa(1, matches(1,j)), fa(2,matches(1,j))]; %2D
            reproj_pt =  worldToImage(cameraParams,R_est,t_est, wp );
            orig_pt = ip;           
            euc_dist = sqrt(sum((reproj_pt - orig_pt).^2));
   
            if euc_dist <= threshold %wp + ip is an inliner
                inliers = inliers + 1;
                world_point_est = [world_point_est; wp];
                image_point_est = [image_point_est; ip];
            end
        end
        
        
        % compute better R|t with inliners found
        if inliers > max_inliers %arbitrary thershold
            
            %better model
            [worldOrientation_est, worldLocation_est, ~ , status] = estimateWorldCameraPose(image_point_est,...
                world_point_est, cameraParams, 'MaxReprojectionError', MaxReprojectionError); 
            %better camera pose
            if status == 2; continue; end
            try
            [R_est, t_est] = cameraPoseToExtrinsics(worldOrientation_est, worldLocation_est);
            catch
            end
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
end

