function plotBounding3D(vertex_coord,img)
    figure
    imshow(img,[])
    hold on
    vertexes = [1 2;2 3;1 4;4 3;4 8;3 7; 2 6; 1 5; 8 5; 5 6; 7 6; 7 8];
    plot(vertex_coord(1,[1,2]),vertex_coord(2,[1,2]),'r','LineWidth',0.5)
    plot(vertex_coord(1,[2,3]),vertex_coord(2,[2,3]),'r','LineWidth',0.5)
    plot(vertex_coord(1,[1,4]),vertex_coord(2,[1,4]),'r','LineWidth',0.5)
    plot(vertex_coord(1,[4,3]),vertex_coord(2,[4,3]),'r','LineWidth',0.5)
    plot(vertex_coord(1,[4,8]),vertex_coord(2,[4,8]),'r','LineWidth',0.5)
    plot(vertex_coord(1,[3,7]),vertex_coord(2,[3,7]),'r','LineWidth',0.5)
    plot(vertex_coord(1,[2,6]),vertex_coord(2,[2,6]),'r','LineWidth',0.5)
    plot(vertex_coord(1,[1,5]),vertex_coord(2,[1,5]),'r','LineWidth',0.5)
    plot(vertex_coord(1,[8,5]),vertex_coord(2,[8,5]),'r','LineWidth',0.5)
    plot(vertex_coord(1,[5,6]),vertex_coord(2,[5,6]),'r','LineWidth',0.5)
    plot(vertex_coord(1,[7,6]),vertex_coord(2,[7,6]),'r','LineWidth',0.5)
    plot(vertex_coord(1,[7,8]),vertex_coord(2,[7,8]),'r','LineWidth',0.5)
    waitforbuttonpress
end
