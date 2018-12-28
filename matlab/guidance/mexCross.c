// [C] = crossprod(A,B)
#include "mex.h"
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    size_t m;
    double *A, *B;
    double *C;
    int i;
    m = mxGetM(prhs[0]);
    A = mxGetPr(prhs[0]);
    B = mxGetPr(prhs[1]);

    plhs[0] = mxCreateDoubleMatrix((int) m, 3, mxREAL);
    C = mxGetPr(plhs[0]);

    // Using column major indexing
    for(i = 0; i < m; i++) {
        C[i] = A[i + m]*B[i + 2*m] - A[i + 2*m]*B[i + m];
        C[i + m] = A[i + 2*m]*B[i] - A[i]*B[i + 2*m];
        C[i + 2*m] = A[i]*B[i + m] - A[i + m]*B[i];
    }
}