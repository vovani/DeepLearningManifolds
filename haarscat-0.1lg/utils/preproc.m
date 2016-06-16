function [moys, x_out] = preproc(x_in)

epsilon = 1e-5;

moys = mean(x_in) ;

x_out = bsxfun(@minus, x_in, mean(x_in));
x_out = bsxfun(@rdivide,x_out,sqrt(sum(x_out.^2,1))+epsilon);

end