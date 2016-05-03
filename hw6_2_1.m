clear;
% load  image
img = imread('Wall_Street.bmp');
X = double(img);
X = X(:,:,1); % use the first channel
% randomly remove 50% of pixels
idx = randperm(128*128,128*128/2);
X_missing = X;
X_missing(idx) = 0;
Omega = true(128,128);
Omega(idx) = false;

% different ranks
r_arr = [1, 5, 10, 15, 20, 25, 30];
len = length(r_arr);

% apply hard-impute
X_complete = {};
error = zeros(len,1);
for i=1:len
    X_complete{i} = hardimpute(X_missing, Omega, r_arr(i));
    error(i) = sum(sum((X_complete{i}-X).^2));
end

% plot errors
figure;
plot(r_arr, error, 'x-');
xlabel('Hard impute with rank r');
ylabel('Recovery errors');

% plot recovery images
figure;
hold on;
% ax = subplot(3,3,1);
set ( ax, 'visible', 'off');
ax = subplot(3,3,1);
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
    title(['r=' num2str(r_arr(i))]);
end
hold off;
