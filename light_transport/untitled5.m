clc;
close all;
clear all;


imgPath = '/Users/delphine/Documents/239computational imaging/quiz3/quiz3_scenes/scene3/';
imgDir = dir([imgPath '*.png']);
allImg_hsi = zeros(964,1288,3,26);
allImg_rgb = zeros(964,1288,3,26);
imgrgb = imread('/Users/delphine/Documents/239computational imaging/quiz3/quiz3_scenes/white.png');
glhsi = rgb2hsi(imgrgb);
dlhsi = glhsi;
for i = 1:length(imgDir)      
    img = imread([imgPath imgDir(i).name]); 
    imhsi = rgb2hsi(img);
    allImg_hsi(:,:,:,i) = imhsi;
end
img_max = zeros(964,1288);
img_min = zeros(964,1288);
for i = 1:964
    for j=1:1288
        img_max(i,j) = max(allImg_hsi(i,j,3,:));
        img_min(i,j) = min(allImg_hsi(i,j,3,:));
    end
end
% figure()
% imshow(img_max,[])
% figure()
% imshow(img_min,[])
globalLight = img_min * 2;
glhsi(:,:,3) = globalLight;
gl = hsi2rgb(glhsi);
directLight = img_max - img_min;
dlhsi(:,:,3) = directLight;
dl = hsi2rgb(dlhsi);
figure()
imshow(dl,[]);
figure()
imshow(gl,[]);


function hsi = rgb2hsi(rgb)
    % hsi = rgb2hsi(rgb)???RGB?????HSI???
    % ????????????M×N×3????
    % ???????????????????????????????????
    % ?????RGB?????????HSI?????????
    % ???????double??????[0, 1]??uint8? uint16?
    %
    % ??HSI???double?
    % ??hsi(:, :, 1)?????????????2*pi??[0, 1]?
    % hsi(:, :, 2)??????????[0, 1]?
    % hsi(:, :, 3)?????????[0, 1]?

    % ??????
    rgb = im2double(rgb);
    r = rgb(:, :, 1);
    g = rgb(:, :, 2);
    b = rgb(:, :, 3);

    % ??????
    num = 0.5*((r - g) + (r - b));
    den = sqrt((r - g).^2 + (r - b).*(g - b));
    theta = acos(num./(den + eps)); %?????0

    H = theta;
    H(b > g) = 2*pi - H(b > g);
    H = H/(2*pi);

    num = min(min(r, g), b);
    den = r + g + b;
    den(den == 0) = eps; %?????0
    S = 1 - 3.* num./den;

    H(S == 0) = 0;

    I = (r + g + b)/3;

    % ?3?????????HSI??
    hsi = cat(3, H, S, I);
end
function rgb = hsi2rgb(hsi)
% rgb = hsi2rgb(hsi)???HSI?????RGB???
% ??hsi(:, :, 1)?????????????2*pi??[0, 1]?
% hsi(:, :, 2)??????????[0, 1]?
% hsi(:, :, 3)?????????[0, 1]?
%
% ???????
% rgb(:, :, 1)???
% rgb(:, :, 2)???
% rgb(:, :, 3)???

% ??????
hsi = im2double(hsi);
H = hsi(:, :, 1) * 2 * pi;
S = hsi(:, :, 2);
I = hsi(:, :, 3);

% ??????
R = zeros(size(hsi, 1), size(hsi, 2));
G = zeros(size(hsi, 1), size(hsi, 2));
B = zeros(size(hsi, 1), size(hsi, 2));

% RG??(0 <= H < 2*pi/3)
idx = find( (0 <= H) & (H < 2*pi/3));
B(idx) = I(idx) .* (1 - S(idx));
R(idx) = I(idx) .* (1 + S(idx) .* cos(H(idx)) ./ ...
cos(pi/3 - H(idx)));
G(idx) = 3*I(idx) - (R(idx) + B(idx));

% BG??(2*pi/3 <= H < 4*pi/3)
idx = find( (2*pi/3 <= H) & (H < 4*pi/3) );
R(idx) = I(idx) .* (1 - S(idx));
G(idx) = I(idx) .* (1 + S(idx) .* cos(H(idx) - 2*pi/3) ./ ...
cos(pi - H(idx)));
B(idx) = 3*I(idx) - (R(idx) + G(idx));

% BR??
idx = find( (4*pi/3 <= H) & (H <= 2*pi));
G(idx) = I(idx) .* (1 - S(idx));
B(idx) = I(idx) .* (1 + S(idx) .* cos(H(idx) - 4*pi/3) ./ ...
cos(5*pi/3 - H(idx)));
R(idx) = 3*I(idx) - (G(idx) + B(idx));

% ?3?????????RGB??
rgb = cat(3, R, G, B);
rgb = max(min(rgb, 1), 0);
end
