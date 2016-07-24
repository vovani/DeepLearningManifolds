clear;
close all;
add_paths;

mnist = loadMNISTImages('train-images-idx3-ubyte');
mnist5 = padarray(reshape(mnist(:,1), 28, 28), [18 18]);

N = 128;
dirs = grid2dirs(360/N, 180/N);
weights = diag(sin(dirs(:, 2)));

Y = getSH(N-1, dirs, 'complex');
normalizer = norm(Y(:,1)' * sqrt(weights)) .^ 2;

const = 5 * ones(N);

pic = mnist5;
sizes = size(pic);
img(1) = project_on_sphere(mnist5, dirs);
img(2) = project_on_sphere(const, dirs);
img(3) = sh_image(dirs, haar_rotate(mnist5, img(1).S));

t=zeros(N^2,1);
for i = 1 : N
    t((i - 1) ^ 2 + 1: (i - 1) ^ 2 + 2 * i - 1) = 1 / (2 * i - 1);
end
t = sqrt(t);

for i = 1 : length(img)
    sf(i, :) = Y' * weights * img(i).values;
    sf(i,:) = sf(i, :) .* t';
    recon(i, :) = Y * sf(i,:)' ./ normalizer;
    err(i) = norm(recon(i,:)' - img(i).values) / norm(img(i).values);
end