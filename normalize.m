function[I_out]=normalize(I)
mmin = min(min(I));
mmax = max(max(I));
I_out = ((I-mmin) ./ mmax) .*255;