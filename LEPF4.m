function[I_out] = LEPF4(I,w)
% difference between LEPF3 is the output, only left the I_out
% input : input image(I), input image size(m,n), window size(w)
% output : filtered base/detail layer(I_out)
% coefficients(aw,bw)
% the overlapping window
% mean, variance and gradient are vectors, whose size are equal to input image
% add zeros to the input image to become a (m+1)x(n+1) image
% started form the left-up pixel
[m,n] = size(I);
local_mean = zeros(m,n);
local_var = zeros(m,n);
local_grad = zeros(m,n);
gx = zeros(m,n);
gy = zeros(m,n);
aw = zeros(m,n);
bw = zeros(m,n);
I_ex = [zeros(1,n);I;zeros(1,n)];
I_ex = [zeros(m+2,1),I_ex,zeros(m+2,1)];
% evaluate local mean, variance and gradient
for i = 1:m-2
    for j = 1:n-2
        local_mean(i,j) = mean(mean(I_ex(i:i+w-1,j:j+w-1)));
        local_var(i,j) = var(var(I_ex(i:i+w-1,j:j+w-1)));
        gx(i,j) = I_ex(i+2,j)+2*I_ex(i+2,j+1)+I_ex(i+2,j+2)-I_ex(i,j)-2*I_ex(i,j+1)-I_ex(i,j+2);
        gy(i,j) = I_ex(i,j+2)+2*I_ex(i+1,j+2)+I_ex(i+2,j+2)-I_ex(i,j)-2*I_ex(i+1,j)-I_ex(i+2,j);
        local_grad(i,j) = abs(gx(i,j)) + abs(gy(i,j));
    end
end
% evaluate mean_local_grad
mean_local_grad = zeros(m,n);
local_grad_ex = [zeros(1,n);local_grad;zeros(1,n)];
local_grad_ex = [zeros(m+2,1),local_grad_ex,zeros(m+2,1)];
for i = 1:m-2
    for j = 1:n-2
        mean_local_grad(i,j) =  mean(mean(local_grad_ex(i:i+w-1,j:j+w-1)));
    end
end
I_out = zeros(m,n);
for i = 1:m
    for j = 1:n
        aw(i,j) = (local_var(i,j))/(local_var(i,j) + 0.1*mean_local_grad(i,j));
        bw(i,j) = local_mean(i,j)*(1- aw(i,j));
        I_out(i,j) = aw(i,j) * I(i,j) + bw(i,j);
        if isnan(I_out(i,j))
            if j ==1
                I_out(i,j) = 0;
            else
                I_out(i,j) = I_out(i,j-1);
            end
        end
    end
end