function doStuff()
clear all
imgg1 = imread('moedas1.jpg');

thr = graythresh(imgg1)*255;
hold on
bw = rgb2gray(imgg1);
bw = bw > thr;
bw = medfilt2(bw);
bw = imdilate(bw, strel('disk',5));

%contagem de objectos
[lb num] = bwlabel(bw);
hold on
% ---------------------

props = regionprops(bw,'Centroid','Perimeter', 'Area','MajorAxisLength','MinorAxisLength');

% Acc_poligono = zeros(size(imgg1));
% aux          = zeros(size(imgg1));
% figure(11)
% subplot(1,2,1);
% imagesc(imgg1); colormap gray


imgHandle = imshow(imgg1);
set(imgHandle, 'ButtonDownFcn',  @ClickCallBack);

for i = 1 : num
    viscircles(props(i).Centroid, 1);
    text(props(i).Centroid(1)+5,props(i).Centroid(2)-15,int2str(i), 'Color','red','FontSize',20);
    props(i).Rad = mean([props(i).MajorAxisLength props(i).MinorAxisLength],2)/2;
    viscircles(props(i).Centroid, props(i).Rad);
    drawnow
end

    lineOn=0;
    linhas = zeros(1, num);

    function ClickCallBack(objectHandle, eventData)
    axesHandle  = get(objectHandle,'Parent');
            coordinates = get(axesHandle,'CurrentPoint'); 
            coordinates = coordinates(1,1:2)
           
    for i = 1 : num
        res = (coordinates(1) - props(i).Centroid(1))^2 + (coordinates(2) - props(i).Centroid(2))^2 <= props(i).Rad^2;
        if res == 1
            if(lineOn==1)
                delete(linhas);
                linhas = zeros(1, num);
            end
            for j = 1 : num
                if(j~=i)
                    direction = props(j).Centroid-props(i).Centroid;
                    linhas(j) = line([props(i).Centroid(1),props(j).Centroid(1)],[props(i).Centroid(2),props(j).Centroid(2)]);
                    set(linhas(j),'color',[0 1 0],'Linewidth',2.2);
                    TextX = (props(j).Centroid(1) + props(i).Centroid(1))./2;
                    TextY = (props(j).Centroid(2) + props(i).Centroid(2))./2;
                    distance = sqrt(direction(1).^2 + direction(2).^2);
                    text(TextX,TextY,num2str(distance), 'Color','white','FontSize',10);
                    pause(1);
                    drawnow
                   
                end
            end
            lineOn=1;
        end
    end
end
end