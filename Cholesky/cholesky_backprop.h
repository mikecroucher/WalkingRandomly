#include <cblas.h>

double mydot(int n, double* a,  int stride_a, double* b, int stride_b);
void chol_backprop(int N, double* df_dK, double* L);
void chol_backprop_blas(int N, double* df_dK, double* L);
