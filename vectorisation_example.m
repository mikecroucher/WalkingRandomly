% This is a demonstration script for the blog post:
% http://www.walkingrandomly.com/?p=5774

function varargout = vectorisation_example(N)
    % matrix size
    if nargin < 1, N = 2000; end

    % functions to test
    funcs = {...
        @() func1_loop_noprealloc_rowmajor(N) ;
        @() func2_loop_prealloc_rowmajor(N)   ;
        @() func3_loop_prealloc_colmajor(N)   ;
        @() func4_vectorized_meshgrid(N)      ;
        @() func5_vectorized_matmult(N)       ;
        @() func6_vectorized_repmat(N)        ;
        @() func7_vectorized_cumsum(N)        ;
        @() func8_vectorized_bsxfun(N)        ;
        @() func9_vectorized_hankel(N)        ;
        @() func10_mex_c(N)
    };

    % timeit
    t = cellfun(@timeit, funcs, 'UniformOutput',true);
    fprintf('N = %d\n', N);
    for i=1:numel(t)
        fprintf('%35s = %f seconds.\n', ...
            strrep(func2str(funcs{i}), '@()',''), t(i));
    end

    % check equal results
    v = cellfun(@feval, funcs, 'UniformOutput',false);
    assert(isequal(v{:}), 'Results are not equal');

    % return output if requested
    if nargout > 1, varargout{1} = t; end
    if nargout > 2, varargout{2} = v; end
end


function A = func1_loop_noprealloc_rowmajor(N)
    % Generate a N-by-N matrix where A(i,j) = i + j;
    for ii = 1:N
        for jj = 1:N
            A(ii,jj) = ii + jj; %#ok<AGROW>
        end
    end
end

function A = func2_loop_prealloc_rowmajor(N)
    % (with preallocation)
    % Generate a N-by-N matrix where A(i,j) = i + j;
    A = zeros(N,N);
    for ii = 1:N
         for jj = 1:N
             A(ii,jj) = ii + jj;
         end
    end
end

function A = func3_loop_prealloc_colmajor(N)
    % (Switch loop order so that we make best use of CPU cache)
    % Generate a N-by-N matrix where A(i,j) = i + j;
    A = zeros(N,N);
    for jj = 1:N
         for ii = 1:N
             A(ii,jj) = ii + jj;
         end
    end
end

function A = func4_vectorized_meshgrid(N)
    % Method 1: MESHGRID.
    [X, Y] = meshgrid(1:N, 1:N);
    A = X + Y;
end

function A = func5_vectorized_matmult(N)
    % Method 2: Matrix multiplication.
    A = (1:N).' * ones(1, N) + ones(N, 1) * (1:N);
end

function A = func6_vectorized_repmat(N)
    % Method 3: REPMAT.
    A = repmat(1:N, N, 1) + repmat((1:N).', 1, N);
end

function A = func7_vectorized_cumsum(N)
    % Method 4: CUMSUM.
    A = cumsum(ones(N)) + cumsum(ones(N), 2);
end

function A = func8_vectorized_bsxfun(N)
    % Method 5: BSXFUN.
    A = bsxfun(@plus, 1:N, (1:N).');
end

function A = func9_vectorized_hankel(N)
    % HANKEL
    A = hankel(2:N+1, N+1:2*N);
end

function A = func10_mex_c(N)
    % MEX-function
    A = vectorization_mex_impl(N);
end
