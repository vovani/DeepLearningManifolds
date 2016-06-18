%function rotation_matrix_demo

	disp('Picking random Euler angles (radians)');

	x = 2*pi*rand() - pi ;% -180 to 180
	y = pi*rand() - pi*0.5; % -90 to 90
	z = 2*pi*rand() - pi; % -180 to 180

	disp('\nRotation matrix is:');
	R = compose_rotation(x,y,z);
	
	disp('Decomposing R');
	[x2,y2,z2] = decompose_rotation(R);

	disp('');
	err = sqrt((x2-x)*(x2-x) + (y2-y)*(y2-y) + (z2-z)*(z2-z));

	if err < 1e-5
		disp('Results are correct!');
	else
		disp('Oops wrong results :(');
    end
    
   X = 2*pi*rand(9,1) - pi ;% -180 to 180
	Y = pi*rand(9,1) - pi*0.5; % -90 to 90
	Z = 2*pi*rand(9,1) - pi; % -180 to 180
    RotMtrx=compose_rotation(X(:),Y(:),Z(:));
    
%      N=32;
%      aplha=linspace(-pi,pi,N);
%      betta=linspace(-.5*pi,.5*pi,N);
%      gamma=linspace(-pi,pi,N);
%      
%      [X,Y,Z]=meshgrid(aplha,betta,gamma);
%      
%      RotMtrx=compose_rotation(X(:),Y(:),Z(:));
%end