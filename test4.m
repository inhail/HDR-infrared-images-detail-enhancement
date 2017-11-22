%I_B1, I_D1, I_B2 are datas from "test.m" evaluation
clear all;
clc;
load I_B1.mat;
load I_D1.mat;
load I_B2.mat;
I = imread('Image05.jpg');
I = rgb2gray(I);
I_D2 = I_B1 - I_B2;
% gray distribution adjustment of base layer
I_B2n = I_B2 .^0.6;
%figure,imshow(I_B2n,[0,255]),title('r0 = 0.6'); % the best result !!
% remove holo effect of detail layer
[gx,gy] = Local_grad_gxgy(I);
[D1_gx,D1_gy] = Local_grad_gxgy(I_D1);
[D2_gx,D2_gy] = Local_grad_gxgy(I_D2);
if norm(D1_gx) >= 2*norm(gx)
    D1_gx = gx;
end
if norm(D1_gy) >=2*norm(gy)
    D1_gy = gy;
end
if norm(D2_gx) >= 2*norm(gx)
    D2_gx = gx;
end
if norm(D2_gy) >=2*norm(gy)
    D2_gy = gy;
end
[I_D1p]= poisson_solver(D1_gx,D1_gy,I_D1);
[I_D2p]= poisson_solver(D2_gx,D2_gy,I_D2);
figure;imshow(I_D1p,[0,255])
% stretch the detail layer based on human vision principle
% idx = find(I_B2n<0.3);
% I_B2n(idx) = 0.3;
% I_D2pp = (I_D2p .^0.8) .* I_B2n;
% I_D1pp = (I_D1p .^0.8) .*I_B2n;
% I_E1 = I_B2n + 0.2*I_D2pp +0.1*I_D1pp;
% I_E2 = I_B2n + 0.3*I_D2pp +0.1*I_D1pp;
% I_E3 = I_B2n + 0.8*I_D2pp +0.8*I_D1pp;
% 
% figure,imshow(normalize(I_E1),[0,255])
% figure,imshow(normalize(I_E2),[0,255])
% figure,imshow(normalize(I_E3),[0,255])
