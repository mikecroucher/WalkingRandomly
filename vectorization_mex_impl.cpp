//
// Compile with: mex -largeArrayDims vectorization_mex_impl.cpp
//

#include "mex.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // validate input/output arguments
    if(nrhs != 1 || nlhs > 1)
        mexErrMsgIdAndTxt("mex:error", "Wrong number of arguments.");
    if(!mxIsDouble(prhs[0]) || !mxIsScalar(prhs[0]))
        mexErrMsgIdAndTxt("mex:error", "Invalid argument.");

    // create output and fill it
    mwSize N = static_cast<mwSize>(mxGetScalar(prhs[0]));
    plhs[0] = mxCreateDoubleMatrix(N, N, mxREAL);
    double *x = mxGetPr(plhs[0]);
    for (mwIndex i=1; i<=N; i++)
        for (mwIndex j=1; j<=N; j++)
            *x++ = (i+j);
}
