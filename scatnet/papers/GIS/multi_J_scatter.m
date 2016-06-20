function mScatt=multi_J_Scatter(sig,fparam,options,Jmax)
%Compute the scattering vector for all the J such that 1<=J<=Jmax. Note
%that no values of J has been defined in fparam (no fparam.J) and that the
%filters used with these functions will most of the time be cubic spline
%wavelets.

N=length(sig);
Wops=cell(Jmax,1);

for k=1:Jmax
    fparam.J=k;
	options.M = fparam.J;
    Wops{k} = wavelet_factory_1d(N, fparam, options);
end

mScatt=zeros(Jmax+1,2*N);
mScatt(1,1:N)=sig;


for p=2:Jmax+1
   
    tScatt=reorderScatt(scat(sig,Wops{p-1}));
  
  mScatt(p,:)=tScatt;
end