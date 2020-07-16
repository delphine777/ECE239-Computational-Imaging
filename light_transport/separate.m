clc;
close all;
clear all;
imgPath = '/Users/delphine/Documents/239computational imaging/quiz3/quiz3_scenes/scene1/';
imgDir  = dir([imgPath '*.png']);
allImg_gray = zeros(964,1288,26);
allImg_rgb = zeros(964,1288,3,26);
white = imread('/Users/delphine/Documents/239computational imaging/quiz3/quiz3_scenes/white.png');
black = imread('/Users/delphine/Documents/239computational imaging/quiz3/quiz3_scenes/black.png');
bm = black./white;
b = mean(bm(:));
for i = 1:length(imgDir)      
    img = imread([imgPath imgDir(i).name]); 
    allImg_rgb(:,:,:,i)=img;
    imgray = rgb2gray(img);
    allImg_gray(:,:,i) = imgray;
end
img_max = uint8(zeros(964,1288,3));
img_min = uint8(zeros(964,1288,3));
max_gray = uint8(zeros(964,1288));
min_gray = uint8(zeros(964,1288));
for i = 1:964
    for j=1:1288
        [Max,channelMax] = max(allImg_gray(i,j,:));
        img_max(i,j,:) = allImg_rgb(i,j,:,channelMax);
        [Min,channelMin] = min(allImg_gray(i,j,:));
        img_min(i,j,:) = allImg_rgb(i,j,:,channelMin);
    end
end
figure()
imshow(img_max,[])
figure()
imshow(img_min,[])
globalLight(:,:,1) = 2*(img_min(:,:,1)-b*img_max(:,:,1))/((1-b)*(1+b));
globalLight(:,:,2) = 2*(img_min(:,:,2)-b*img_max(:,:,2))/((1-b)*(1+b));
globalLight(:,:,3) = 2*(img_min(:,:,3)-b*img_max(:,:,3))/((1-b)*(1+b));
directLight(:,:,1) = (img_max(:,:,1) - img_min(:,:,1))/(1-b);
directLight(:,:,2) = (img_max(:,:,2) - img_min(:,:,2))/(1-b);
directLight(:,:,3) = (img_max(:,:,3) - img_min(:,:,3))/(1-b);
figure()
imshow(globalLight,[]);
title('Global Light')
figure()
imshow(directLight,[]);
title('Direct Light')
% clc;
% close all;
% 
% imgPath = '/Users/delphine/Documents/239computational imaging/quiz3/quiz3_scenes/scene1/';
% imgDir  = dir([imgPath '*.png']);
% allImg_gray = zeros(964,1288,26);
% allImg_rgb = zeros(964,1288,3,26);
% for i = 1:length(imgDir)      
%     img = imread([imgPath imgDir(i).name]); 
%     imgray = rgb2gray(img);
%     allImg_gray(:,:,i) = imgray;
% end
% img_max = zeros(964,1288);
% img_min = zeros(964,1288);
% for i = 1:964
%     for j=1:1288
%         img_max(i,j) = max(allImg_gray(i,j,:));
%         img_min(i,j) = min(allImg_gray(i,j,:));
%     end
% end
% figure()
% imshow(img_max,[])
% figure()
% imshow(img_min,[])
% globalLight = img_min *2;
% directLight = img_max - img_min;
% 
% Global(:,:,1) = white(:,:,1).*globalLight;
% Global(:,:,2) = white(:,:,2).*globalLight;
% Global(:,:,3) = white(:,:,3).*globalLight;
% 
% figure()
% imshow(Global,[]);
% % figure()
% % imshow(directLight,[]);
