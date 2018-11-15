% author: Ivan Pavlov
% date: 8 November 2018
% MIT License
% https://spdx.org/licenses/MIT.html

function I = mark_image(path)

path_template = fullfile(path, '*.JPG');
img_files = dir(path_template);
num_files = length(img_files);
% Initialize array
I = [];
% Initialize figure
figure;
% For every point iterate through image files
for j=1:num_files
    img_data = imread(fullfile(path, img_files(j).name));
    title_message_1 = sprintf('Image №%d ', j);
    title(title_message_1)
    imshow(img_data);
    [x,y] = getpts();
    I = [I;x,y];
end
end