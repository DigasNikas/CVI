clear all
imgg1 = imread('moedas1.jpg');
imgg2 = imread('moedas2.jpg');
figure;
subplot(1,2,1), subimage(imgg1);
title('Moedas 1');
subplot(1,2,2), subimage(imgg2);
title('Moedas 2');

figure,imshow(imgg1)
thr = graythresh(imgg1)*255;
hold on
plot(thr, 0,'r*')
bw = rgb2gray(imgg1);
bw = bw > thr;
bw = medfilt2(bw);
bw = imdilate(bw, strel('disk',5));
figure,imshow(bw)

[lb num] = bwlabel(bw);
hold on
props = regionprops(lb,'Area','ConvexHull','BoundingBox');

Acc_poligono = zeros(size(imgg1));
aux          = zeros(size(imgg1));
figure(11)
subplot(1,2,1);
imagesc(imgg1); colormap gray

for i = 1 : num
    poligono = roipoly(aux,props(i).ConvexHull(:,1), props(i).ConvexHull(:,2));
    Acc_poligono = Acc_poligono + poligono;
%     
%     figure(9),imshow(img)
%     rectangle('Position', props(i).BoundingBox, 'EdgeColor', 'r', 'linewidth',2);
%     figure(10);
%     imagesc(Acc_poligono); axis off;
    
    figure(11)
    subplot(1,2,2);
    imagesc(Acc_poligono); axis off;
    subplot(1,2,1);
    rectangle('Position', props(i).BoundingBox, 'EdgeColor', 'r', 'linewidth',2); axis off;
    drawnow
end