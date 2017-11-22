function[local_mean,local_var] = Local_mean_variance(I,w)
% input : input image(I), input image size(m,n), window size(w)
% output : mean(local_mean), variance(local_var)
% the overlapping window
% mean and variance are vectors, whose size are equal to input image
% add zeros to the input image to become a (m+1)x(n+1) image
% started form the left-up pixel
[m,n] = size(I);
local_mean = zeros(m,n);
local_var = zeros(m,n);
varr = 0;
I = [zeros(1,n);I;zeros(1,n)];
I = [zeros(m+2,1),I,zeros(m+2,1)];
% evaluate local mean
for i = 1:m-2
    for j = 1:n-2
        sumup = sum(I(i:i+w-1,j:j+w-1));
        local_mean(i,j) = sum(sumup) / (w^2);
    end
end
% evaluate local variance
for i = 1:m-2
    for j = 1:n-2
        for s = i:i+w-1
            for t = j:j+w-1
                varr = varr + (I(s,t)-local_mean(s,t))^2;
            end
        end
        local_var(i,j) = varr / (w^2);
        varr = 0;
    end
end