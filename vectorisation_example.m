% This is a demonstration script for the blog post:
% http://www.walkingrandomly.com/?p=5774

clear all;
N=2000;

%Generate a N-by-N matrix where A(i,j) = i + j;
tic
for ii = 1:N
    for jj = 1:N
        Aloop(ii,jj) = ii + jj;
    end
end
original = toc;

%preallocate
tic
% Generate a N-by-N matrix where A(i,j) = i + j;
Aprealloc=zeros(N,N);
for ii = 1:N
     for jj = 1:N
         Aprealloc(ii,jj) = ii + jj;
     end
end
preallocate = toc;


%Switch loop order so that we make best use of CPU cache
tic
% Generate a N-by-N matrix where A(i,j) = i + j;
Aswitchloop=zeros(N,N);
for jj = 1:N
     for ii = 1:N
         Aswitchloop(ii,jj) = ii + jj;
     end
end
switchloop = toc;

%Method 1: MESHGRID.
tic
[X, Y] = meshgrid(1:N, 1:N);
Amesh = X + Y;
mesh_time=toc;

% Method 2: Matrix multiplication.
tic
Amatmul = (1:N).' * ones(1, N) + ones(N, 1) * (1:N);
matmul_time=toc;

% Method 3: REPMAT.
tic
Arepmat = repmat(1:N, N, 1) + repmat((1:N).', 1, N);
repmat_time=toc;

% Method 4: CUMSUM.
tic
Acumsum = cumsum(ones(N)) + cumsum(ones(N), 2);
cumsum_time=toc;

% Method 5: BSXFUN.
tic
Absxfun = bsxfun(@plus, 1:N, (1:N).');
bsxfun_time=toc;

fprintf('Original loop time is %f\n',original);
fprintf('Preallocate and loop is %f\n',preallocate);
fprintf('Switched loop order is %f\n',switchloop);
fprintf('Meshgrid time is %f\n',mesh_time);
fprintf('Matmul time is %f\n',matmul_time);
fprintf('Repmat time is %f\n',repmat_time);
fprintf('Cumsum time is %f\n',cumsum_time);
fprintf('bsxfun time is %f\n',bsxfun_time);

%test for equality
test = all(all(repmat(Aloop,1,7) == [Amesh,Aprealloc,Aswitchloop,Amatmul,Arepmat,Acumsum,Absxfun]));

if test==1
    fprintf('\nAll results are equal\n');
else
    fprintf('\nAll results are not equal\n');
end