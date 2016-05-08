sphere; h = findobj('Type','surface');
hemisphere = [zeros(10,56); zeros(28, 14) reshape(imgs(:,1), 28, 28) zeros(28, 14); zeros(10,56)];
set(h,'CData',flipud(hemisphere),'FaceColor','texturemap')
colormap(map)
axis equal
view([90 0])