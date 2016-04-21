function doStuff()
clear all
imgg1 = imread('moedas2.jpg');

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

props = regionprops(bw,'Centroid','Perimeter','BoundingBox', 'Area','MajorAxisLength','MinorAxisLength');

% Acc_poligono = zeros(size(imgg1));
% aux          = zeros(size(imgg1));
% figure(11)
% subplot(1,2,1);
% imagesc(imgg1); colormap gray

figure,
subplot(1,3,2);
imshow(lb == 5);
subplot(1,3,1);
imshow(lb == 2);
subplot(1,3,3);
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
    aux = zeros(3, num);
    circle = 0;
    function ClickCallBack(objectHandle, eventData)
    axesHandle  = get(objectHandle,'Parent');
            coordinates = get(axesHandle,'CurrentPoint'); 
            coordinates = coordinates(1,1:2)
           
    for i = 1 : num
        res = (coordinates(1) - props(i).Centroid(1))^2 + (coordinates(2) - props(i).Centroid(2))^2 <= props(i).Rad^2;
        if res == 1
            if(lineOn==1)
                delete(aux);
                delete(circle);
                aux=zeros(3,num);
            end
            circle=viscircles(props(i).Centroid, props(i).Rad,'LineStyle','--','edgecolor','green');
            %rectangle('Position', [props(i).Centroid(1),props(i).Centroid(2),100,250],'FaceColor', 'w','Curvature',1, 'linewidth',1);
            for j = 1 : num
                if(j~=i)
                    direction = props(j).Centroid-props(i).Centroid;
                    direction2 = props(i).Centroid-props(j).Centroid;
                    direction2=((direction2./sqrt((direction2(1).^2) + (direction2(2).^2)))*props(j).Rad)+props(j).Centroid
                    direction=((direction./sqrt( (direction(1).^2) + (direction(2).^2)))*props(i).Rad)+props(i).Centroid
                    
                    aux(1,j) = line([direction(1),direction2(1)],[direction(2),direction2(2)]);
                    
                    set(aux(1,j),'color',[0 1 0],'Linewidth',2.2);
                    TextX = (props(j).Centroid(1) + props(i).Centroid(1))./2;
                    TextY = (props(j).Centroid(2) + props(i).Centroid(2))./2;
                    direction=direction-direction2;
                    distance = sqrt(direction(1).^2 + direction(2).^2);
                    aux(2,j) = rectangle('Position', [TextX-5,TextY-30,75,20], 'FaceColor', 'w','Curvature',1, 'linewidth',1); axis off;
                    aux(3,j)=text(TextX,TextY-20,num2str(distance), 'Color','black','FontSize',10);
                   
                    pause(1);
                    drawnow
                   
                end
            end
            lineOn=1;
        end
    end
end
end