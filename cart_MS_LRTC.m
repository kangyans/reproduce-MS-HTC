% this is a simple version of
% MS-HTC(https://github.com/loyalliu/MS-HTC.git),
% but with the core function provided.

%% Prepare workspace
close all; clc; clear;

addpath(genpath('D:\uva\apps\Projects\sp2HASTE\tensor_toolbox-v3.6\'))

%% Prepare data
load .\data\T1w_SE.mat
load .\data\mask_3x_vd0_1D_N360.mat
R = 3; slice_list = 1:4;

data = raw(:, :, slice_list, :);
[nx, ny, ns, nc] = size(data);
mask = crop(mask, [nx, ny, ns]);
mask = repmat(mask, [1 1 1 nc]);

data = permute(data, [1 2 4 3]);
mask = permute(mask, [1 2 4 3]);


%% Retrospective undersampling
data_un = data.*mask;

%% Reconstruction
% 2DFFT
im_ref_mc = ifft2c(data   );
im_un_mc  = ifft2c(data_un);

% MS-LRTC reconstruction
tic;res = MS_LRTC(data_un, data, [3,3], 200, [87 27 4], 8e-2);toc;
im_MSLRTC_mc = ifft2c(res);


%% Save reconstructed images
im_ref    = demax(squeeze(sos(im_ref_mc, 3)));
im_un     = demax(squeeze(sos(im_un_mc , 3)));
im_MSLRTC = demax(squeeze(sos(im_MSLRTC_mc, 3)));

im_all = cat(1, im_ref, im_un, im_MSLRTC);
figure(11), imshow3(im_all, [], [1, ns]);
