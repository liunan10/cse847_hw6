clear;
% load color image
img = imread('Wall_Street.bmp');
X = double(img);

% randomly remove 50% of pixels
idx = randperm(128*128,128*128/2);
X_missing = X;
X_missing(idx) = 0;
X_missing(128*128+idx) = 0;
X_missing(128*128*2+idx) = 0;
Omega = true(128,128);
Omega(idx) = false;

% different ranks
r_arr = [1, 5, 10, 15, 20, 25, 30];
len = length(r_arr);

% apply hard-impute
X_complete = {};
error = zeros(len,1);
X_onechannel = zeros(128,128);
for i=1:len
    X_complete{i} = zeros(128,128,3);
    X_onechannel = X_missing(:,:,1);
    X_complete{i}(:,:,1) = hardimpute(X_onechannel, Omega, r_arr(i));
    X_onechannel = X_missing(:,:,2);
    X_complete{i}(:,:,2) = hardimpute(X_onechannel, Omega, r_arr(i));
    X_onechannel = X_missing(:,:,3);
    X_complete{i}(:,:,3) = hardimpute(X_onechannel, Omega, r_arr(i));  
    error(i) = sum(sum(sum((X_complete{i}-X).^2)));
end

% plot errors
figure;
plot(r_arr, error, 'x-');
xlabel('Hard impute with rank r');
ylabel('Recovery errors');

% plot recovery images
figure;
hold on;
ax = subplot(3,3,1);
set ( ax, 'visible', 'off');
imshow(uint8(X));
title('Original image');

ax = subplot(3,3,2);
set ( ax, 'visible', 'off');
imshow(uint8(X_missing));
title('Noise image');

for i=1:len
    ax = subplot(3,3,i+2);
    set ( ax, 'visible', 'off');
    imshow(uint8(X_complete{i}));
    title( ['r=' num2str(r_arr(i))]);
end
hold off;
