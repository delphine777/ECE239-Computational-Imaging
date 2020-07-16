clear all;
close all;
clc;
v = VideoReader('video.mp4');
frame1 = read(v,1);
figure(1)
imshow(frame1);
hold on;
rectangle('Position',[450,180,80,230],'LineWidth',2,'EdgeColor','r');
rectangle('Position',[300,110,330,400],'LineWidth',2,'EdgeColor','b');
gray1 = rgb2gray(frame1);
figure(2)
imshow(gray1);
template = gray1(180:410,450:530);
template = im2double(template);
window = gray1(110:510,300:630);
c = normxcorr2(template,window);
figure(3)
imshow(c);
hold on;
axis on;
xlabel('Pixel location in x direction','FontSize',12);
ylabel('Pixel location in y direction','FontSize',12);
colorbar;
 
x = zeros(1,413);
y = zeros(1,413);
n = v.NumberOfFrame;
J = zeros();
for i=1:413
    frame_i = read(v,i);
    frame_i = im2double(frame_i);
    gray_i = rgb2gray(frame_i);
    window_i = gray_i(110:510,300:630);
    c = normxcorr2(template,window_i);
    [m,index] = max(c(:));
    [x(i),y(i)] = ind2sub(size(c),index);
    if i == 1 
        x_shift = 0;
        y_shift = 0;
    else
        x_shift = x(1)-x(i);
        y_shift = y(1)-y(i);
    end
    J = J + imtranslate(frame_i,[y_shift,x_shift])./413;
end
figure(4)
imshow(J,[]);
