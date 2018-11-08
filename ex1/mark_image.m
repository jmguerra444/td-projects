% author: Ivan Pavlov
% date: 8 November 2018
% MIT License
% https://spdx.org/licenses/MIT.html

function I = mark_image(path, max_points)
% Marking points on an image
% Iterating through all images for every point
% Arguments: 
% path - the path to a directory with images
% max_points - the number of points of 3D object to mark
% Output:
% 3-dimensional array
% 1st dimension - (1:2) x, y coordinates
% 2nd dimension - (1:max_points) index of a point
% 3rd dimension - (1:maximum number of files) index of a file in directory
% Usage:
% path = './data/data/images/init_texture';
% I = mark_image(path, 8);

path_template = fullfile(path, '*.jpg');

img_files = dir(path_template);
num_files = length(img_files);

% Initialize array
I = NaN(2, max_points, length(img_files));

% For every point iterate through image files
for i=1:max_points
    for j=1:num_files
        
        img_data = imread(fullfile(path, img_files(j).name));
        fig = figure;
%         With imshow I can't tackle getpts shift axis problem, so image()
%         imshow(img_data);
        image(img_data);
        
%         Title message with info
        title_message = ['Image №%d  Point №%d    Mark point №%d ' ... 
        'and press Enter/Return'];
        title_message_1 = sprintf(title_message, j, i, i);
        title_message_2 = ['If point is not in the picture, press' ...
        ' Enter/Return without selecting a point. (Use Delete to deselect a point)'];
        title({title_message_1;title_message_2})

        [x,y] = getpts();
        
        [maxValY, maxValX, ~]  = size(img_data);
        
%         If user pressed Enter without selecting point we should continue
        if isempty(x) || isempty(y)
            close(fig);
            continue
        end
        
%         Check if point's coordinates is in limits of original picture
        if ((x <= maxValX) && (x >= 0)) || ((y <= maxValY) && (y >= 0))
%             I'm not sure if it's possible to capture not more than 1
%             point using getpts(), so only taking 1st element of x and y
            
            I(1, i, j) = x(1);
            I(2, i, j) = y(1);
        end
        
        close(fig);
        
    end
end
end