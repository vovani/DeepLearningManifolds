L = 64;
[theta, phi] = nsht_sampling_points(L);

for i = 0:L-1
    theta_indecies(i^2 +1: (i+1)^2) = i + 1;
end

theta = theta(theta_indecies);

rect = zeros(L);
rect( L / 4 : 3 * L / 4 , L / 8 : 5 * L / 8) = 1;
rot_rect = rect';

mnist = loadMNISTImages('train-images-idx3-ubyte');
mnist5 = padarray(reshape(mnist(:,1), 28, 28), [18 18]);

dirs = [phi; theta]';
img(1) = project_on_sphere(mnist5, dirs);
img(2) = img(1).rotate(pi/2, 0, 0);
img(3) = sh_image(dirs, haar_rotate(mnist5, img(2).S));
img(4) = sh_image(dirs, haar_rotate(mnist5, img(2).S));
img(5) = sh_image(dirs, haar_rotate(mnist5, img(2).S));
img(6) = sh_image(dirs, haar_rotate(mnist5, img(2).S));
img(7) = sh_image(dirs, haar_rotate(mnist5, img(2).S));
% Y = getSH(L - 1, dirs, 'complex');
% Y = Y / norm(Y(:,1));
% weights = diag(sin(dirs(:,2)));

for i = 1 : length(img)
    sh_f(i,:) = nsht_forward(img(i).values', L);
    sh_r(i,:) = nsht_inverse(sh_f(i,:), L);
    diff(i,:) = sh_r(i, :) - img(i).values';
    err_p1(i) = max(diff(i,:));
    err_p2(i) = norm(diff(i,:));
    energy(i,:) = band_energy(L-1, sh_f(i,:));
end


