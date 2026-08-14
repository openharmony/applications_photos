/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "simplex.h"
#include <math.h>
#include "HmcService.h"
#define MMAX 30
#define NMAX 30
#define REAL double

/**
 * LP求解精度
 * 高精度适用旋转/拖动裁剪框求极值 getLargestAlignedRect、getReachableRect
 * 中精度适用移动/固定比例求极值 getNearestMovement、getLargestRectUnderRatio
 * 低精度适用自由比例裁剪 getReachableRectFreeRatio
 */
#define EPS_HEIGHT (1e-6)
#define EPS_MIDDLE (1e-3)
#define EPS_LOW (1e-2)

#define CHECK_REACHABLE_RECT_AND_RETURN(a, b)                \
    do {                                                     \
        float lla = a;                                       \
        float llb = b;                                       \
        if (!(lla < llb || fabsf(lla - llb) < EPS_LOW)) {    \
            return false;                                    \
        }                                                    \
    } while (0)

typedef REAL MAT[MMAX][NMAX];

MAT A;
int IPOSV[MMAX], IZROV[NMAX];
int i, j, ICASE, N, M, M1, M2, M3;
REAL R;
int g_objectiveIndex = 2;
static float g_positionHalf = 0.5;
static int g_secondIndex = 2;
static int g_thirdIndex = 3;
static int g_fourthIndex = 4;
static int g_fifthIndex = 5;
static int g_sixthIndex = 6;
static int g_seventhIndex = 7;
static int g_eighthIndex = 8;
static int g_ninthIndex = 9;
static int g_tenthIndex = 10;
static int g_eleventhIndex = 11;
static int g_twelfthIndex = 12;
static int g_thirteenthIndex = 13;
static int g_fourteenthIndex = 14;
static int g_fifteenthIndex = 15;
static int g_sixteenthIndex = 16;
static int g_seventeenthIndex = 17;
static int g_eighteenthIndex = 18;
static int g_nineteenthIndex = 19;
static int g_twentiethIndex = 20;
static int g_twentyFirstIndex = 21;
static int g_twentySecondIndex = 22;
static int g_twentyThirdIndex = 23;
static int g_twentyFourthIndex = 24;
static int g_twentyFifthIndex = 25;
static int g_twentySixthIndex = 26;

namespace {
void simp1(MAT, int, int *, int, int, int *, REAL *);
void simp2(MAT, int, int, int *, int, int *, int, REAL *, REAL EPS);
void simp3(MAT, int, int, int, int);
bool E1(MAT a, int &m, int *l1, int &nl1, int &kp, REAL &bmax, REAL &eps, int *icase, int &m12, int &m1, int &m2,
    int ip, int *iposv, int &n, int &ir, int *l3, int &k, int *l2, int &nl2, REAL &q1, int &kh, int &is, int *izrov);
bool E10(MAT a, int &m, int *l1, int &nl1, int &kp, REAL &bmax, REAL &eps, int *icase, int &m12, int &m1, int &m2,
    int ip, int *iposv, int &n, int &ir, int *l3, int &k, int *l2, int &nl2, REAL &q1, int &kh, int &is, int *izrov);
bool E20(MAT a, int &m, int *l1, int &nl1, int &kp, REAL &bmax, REAL &eps, int *icase, int &m12, int &m1, int &m2,
    int ip, int *iposv, int &n, int &ir, int *l3, int &k, int *l2, int &nl2, REAL &q1, int &kh, int &is, int *izrov);
bool E30(MAT a, int &m, int *l1, int &nl1, int &kp, REAL &bmax, REAL &eps, int *icase, int &m12, int &m1, int &m2,
    int ip, int *iposv, int &n, int &ir, int *l3, int &k, int *l2, int &nl2, REAL &q1, int &kh, int &is, int *izrov);

void simplx(MAT a, int m, int n, int m1, int m2, int m3, int *icase, int *izrov, int *iposv, REAL EPS)
{
    /* ----------------------------------------------------------------------------------------
    USES simp1,simp2,simp3
    Simplex method for linear programming. Input parameters a, m, n, mp, np, m1, m2, and m3,
    and output parameters a, icase, izrov, and iposv are described above (see reference).
    Parameters: MMAX is the maximum number of constraints expected; NMAX is the maximum number
    of variables expected; EPS is the absolute precision, which should be adjusted to the
    scale of your variables.
    ----------------------------------------------------------------------------------------- */
    int i, ip, ir, is, k, kh, kp, m12, nl1, nl2, l1[NMAX], l2[MMAX], l3[MMAX];
    REAL bmax, q1;
    bool flag;
    if (m != m1 + m2 + m3) {
        LOGD("Bad input constraint counts in simplx.");
        return;
    }
    nl1 = n;
    for (k = 1; k <= n; k++) {
        l1[k] = k;    // Initialize index list of columns admissible for exchange.
        izrov[k] = k; // Initially make all variables right-hand.
    }
    nl2 = m;
    for (i = 1; i <= m; i++) {
        if (a[i + 1][1] < 0.0) {
            LOGD(" Bad input tableau in simplx, Constants bi must be nonnegative.");
            return;
        }
        l2[i] = i;
        iposv[i] = n + i;
        /* ------------------------------------------------------------------------------------------------
         Initial left-hand variables. m1 type constraints are represented by having their slackv ariable
         initially left-hand, with no artificial variable. m2 type constraints have their slack
         variable initially left-hand, with a minus sign, and their artificial variable handled implicitly
         during their first exchange. m3 type constraints have their artificial variable initially
         left-hand.
        ------------------------------------------------------------------------------------------------ */
    }
    for (i = 1; i <= m2; i++)
        l3[i] = 1;
    ir = 0;
    if (m2 + m3 == 0) {
        flag = E30(a, m, l1, nl1, kp, bmax, EPS, icase, m12, m1, m2, ip, iposv, n, ir, l3, k, l2, nl2, q1, kh, is,
            izrov); // The origin is a feasible starting solution. Go to phase two.
        if (!flag) {
            return;
        }
    }
        
    ir = 1;
    for (k = 1; k <= n + 1; k++) { // Compute the auxiliary objective function.
        q1 = 0.0;
        for (i = m1 + 1; i <= m; i++)
            q1 += a[i + 1][k];
        a[m + g_objectiveIndex][k] = -q1;
    }
    
    E10(a, m, l1, nl1, kp, bmax, EPS, icase, m12, m1, m2, ip, iposv, n, ir, l3, k, l2, nl2, q1, kh, is, izrov);
} // return for another iteration.

bool E1(MAT a, int &m, int *l1, int &nl1, int &kp, REAL &bmax, REAL &eps, int *icase, int &m12, int &m1, int &m2,
    int ip, int *iposv, int &n, int &ir, int *l3, int &k, int *l2, int &nl2, REAL &q1, int &kh, int &is, int *izrov)
{
    simp3(a, m + 1, n, ip, kp);
    // Exchange a left- and a right-hand variable (phase one), then update lists.
    if (iposv[ip] >= n + m1 + m2 + 1) { // Exchanged out an artificial variable for an
        // equality constraint. Make sure it stays
        // out by removing it from the l1 list.
        for (k = 1; k <= nl1; k++) {
            if (l1[k] == kp) {
                goto e2;
            }
        }
    e2:
        nl1 = nl1 - 1;
        for (is = k; is <= nl1; is++) {
            l1[is] = l1[is + 1];
        }
    } else {
        if (iposv[ip] < n + m1 + 1) {
            return E20(a, m, l1, nl1, kp, bmax, eps, icase, m12, m1, m2, ip, iposv, n, ir, l3, k, l2, nl2, q1, kh, is,
                izrov);
        };
        
        kh = iposv[ip] - m1 - n;
        if (l3[kh] == 0) {
            return E20(a, m, l1, nl1, kp, bmax, eps, icase, m12, m1, m2, ip, iposv, n, ir, l3, k, l2, nl2, q1, kh, is,
                izrov);
        };
        l3[kh] = 0;   // If it’s the first time, correct the pivot column
        // or the minus sign and the implicit
        // artificial variable.
    }
    a[m + g_objectiveIndex][kp + 1] += 1.0;
    for (i = 1; i <= m + g_objectiveIndex; i++) {
        a[i][kp + 1] *= -1.0;
    }

    return E20(a, m, l1, nl1, kp, bmax, eps, icase, m12, m1, m2, ip, iposv, n, ir, l3, k, l2, nl2, q1, kh, is, izrov);
}

bool E30(MAT a, int &m, int *l1, int &nl1, int &kp, REAL &bmax, REAL &eps, int *icase, int &m12, int &m1, int &m2,
    int ip, int *iposv, int &n, int &ir, int *l3, int &k, int *l2, int &nl2, REAL &q1, int &kh, int &is, int *izrov)
{
    simp1(a, 0, l1, nl1, 0, &kp, &bmax); // Test the z-row for doneness.
    if (bmax <= eps) {                   // Done. Solution found. Return with the good news.
        *icase = 0;
        return false;
    }
    simp2(a, m, n, l2, nl2, &ip, kp, &q1, eps); // Locate a pivot element (phase two).
    if (ip == 0) {                              // Objective function is unbounded. Report and return.
        *icase = 1;
        return false;
    }
    simp3(a, m, n, ip, kp); // Exchange a left- and a right-hand variable (phase two),
    return E20(a, m, l1, nl1, kp, bmax, eps, icase, m12, m1, m2, ip, iposv, n, ir, l3, k, l2, nl2, q1, kh, is,
        izrov); // update lists of left- and right-hand variables and
}

bool E10(MAT a, int &m, int *l1, int &nl1, int &kp, REAL &bmax, REAL &eps, int *icase, int &m12, int &m1, int &m2,
    int ip, int *iposv, int &n, int &ir, int *l3, int &k, int *l2, int &nl2, REAL &q1, int &kh, int &is, int *izrov)
{
    simp1(a, m + 1, l1, nl1, 0, &kp, &bmax); // Find max. coeff. of auxiliary objective fn
    if (bmax <= eps && a[m + g_objectiveIndex][1] < -eps) {
        *icase = -1; // Auxiliary objective function is still negative and can’t be improved,
        return false;      // hence no feasible solution exists.
    } else if (bmax <= eps && a[m + g_objectiveIndex][1] <= eps) {
        // Auxiliary objective function is zero and can’t be improved; we have a feasible starting vector.
        // Clean out the artificial variables corresponding to any remaining equality constraints by
        // goto 1’s and then move on to phase two by goto 30.
        m12 = m1 + m2 + 1;
        if (m12 <= m) {
            for (ip = m12; ip <= m; ip++) {
                if (iposv[ip] == ip + n) { // Found an artificial variable for an equalityconstraint.
                    simp1(a, ip, l1, nl1, 1, &kp, &bmax);
                    if (bmax > eps) {
                        return E1(a, m, l1, nl1, kp, bmax, eps, icase, m12, m1, m2, ip, iposv, n, ir, l3, k, l2, nl2,
                            q1, kh, is, izrov); // Exchange with column corresponding to maximum
                    }
                }
            }
        }
        ir = 0;
        m12 = m12 - 1;
        if (m1 + 1 > m12) {
            return E30(a, m, l1, nl1, kp, bmax, eps, icase, m12, m1, m2, ip, iposv, n, ir, l3, k, l2, nl2, q1, kh, is,
                izrov);
        }
        for (i = m1 + 1; i <= m1 + m2; i++) {  // Change sign of row for any m2 constraints
            if (l3[i - m1] == 1) {  // still present from the initial basis.
                for (k = 1; k <= n + 1; k++) {
                    a[i + 1][k] *= -1.0;
                }
            }
        }
        return E30(a, m, l1, nl1, kp, bmax, eps, icase, m12, m1, m2, ip, iposv, n, ir, l3, k, l2, nl2, q1, kh, is,
            izrov);
    }

    simp2(a, m, n, l2, nl2, &ip, kp, &q1, eps); // Locate a pivot element (phase one).

    if (ip == 0) {   // Maximum of auxiliary objective function is
        *icase = -1; // unbounded, so no feasible solution exists.
        return false;
    }
    
    return E1(a, m, l1, nl1, kp, bmax, eps, icase, m12, m1, m2, ip, iposv, n, ir, l3, k, l2, nl2, q1, kh, is, izrov);
}

bool E20(MAT a, int &m, int *l1, int &nl1, int &kp, REAL &bmax, REAL &eps, int *icase, int &m12, int &m1, int &m2,
    int ip, int *iposv, int &n, int &ir, int *l3, int &k, int *l2, int &nl2, REAL &q1, int &kh, int &is, int *izrov)
{
    is = izrov[kp]; // Update lists of left- and right-hand variables.
    izrov[kp] = iposv[ip];
    iposv[ip] = is;
    if (ir != 0) {
        return E10(a, m, l1, nl1, kp, bmax, eps, icase, m12, m1, m2, ip, iposv, n, ir, l3, k, l2, nl2, q1, kh, is,
            izrov); // if still in phase one, go back to 10.
    }
    return E30(a, m, l1, nl1, kp, bmax, eps, icase, m12, m1, m2, ip, iposv, n, ir, l3, k, l2, nl2, q1, kh, is, izrov);
}

// The preceding routine makes use of the following utility subroutines:

void simp1(MAT a, int mm, int *ll, int nll, int iabf, int *kp, REAL *bmax)
{
    // Determines the maximum of those elements whose index is contained in the supplied list
    // ll, either with or without taking the absolute value, as flagged by iabf.
    int k;
    REAL test;
    *kp = ll[1];
    *bmax = a[mm + 1][*kp + 1];
    if (nll < 2)
        return;
    for (k = 2; k <= nll; k++) {
        if (iabf == 0)
            test = a[mm + 1][ll[k] + 1] - (*bmax);
        else
            test = fabs(a[mm + 1][ll[k] + 1]) - fabs(*bmax);
        if (test > 0.0) {
            *bmax = a[mm + 1][ll[k] + 1];
            *kp = ll[k];
        }
    }
    return;
}

void simp2(MAT a, int m, int n, int *l2, int nl2, int *ip, int kp, REAL *q1, REAL EPS)
{
    // Locate a pivot element, taking degeneracy into account.
    int i, ii, k;
    REAL q, q0, qp;
    *ip = 0;
    if (nl2 < 1)
        return;
    for (i = 1; i <= nl2; i++)
        if (a[i + 1][kp + 1] < -EPS)
            goto e2;
    return; // No possible pivots. Return with message.
e2:
    *q1 = -a[l2[i] + 1][1] / a[l2[i] + 1][kp + 1];
    *ip = l2[i];
    if (i + 1 > nl2)
        return;
    for (i = i + 1; i <= nl2; i++) {
        ii = l2[i];
        if (a[ii + 1][kp + 1] < -EPS) {
            q = -a[ii + 1][1] / a[ii + 1][kp + 1];
            if (q < *q1) {
                *ip = ii;
                *q1 = q;
            } else if (q == *q1) { // We have a degeneracy.
                for (k = 1; k <= n; k++) {
                    qp = -a[*ip + 1][k + 1] / a[*ip + 1][kp + 1];
                    q0 = -a[ii + 1][k + 1] / a[ii + 1][kp + 1];
                    if (q0 != qp)
                        goto e6;
                }
            e6:
                if (q0 < qp)
                    *ip = ii;
            }
        }
    }
    return;
}

void simp3(MAT a, int i1, int k1, int ip, int kp)
{
    // Matrix operations to exchange a left-hand and right-hand variable (see text).
    int ii, kk;
    REAL piv;
    piv = 1.0 / a[ip + 1][kp + 1];
    if (i1 >= 0)
        for (ii = 1; ii <= i1 + 1; ii++)
            if (ii - 1 != ip) {
                a[ii][kp + 1] *= piv;
                for (kk = 1; kk <= k1 + 1; kk++)
                    if (kk - 1 != kp)
                        a[ii][kk] -= a[ip + 1][kk] * a[ii][kp + 1];
            }
    for (kk = 1; kk <= k1 + 1; kk++)
        if (kk - 1 != kp)
            a[ip + 1][kk] = -a[ip + 1][kk] * piv;
    a[ip + 1][kp + 1] = piv;
    return;
}

void PostiveM1(MAT &a, int &m1, int &n, MAT &tmp, int &index)
{
    for (i = 1; i <= m1; i++) {
        if (a[i + 1][1] >= 0) {
            for (j = 1; j <= n + 1; j++) {
                tmp[index][j] = a[i + 1][j];
            }
            index++;
        }
    }
}
void PositiveM2(MAT &a, int &m1, int &m2, int &n, MAT &tmp, int &index)
{
    for (i = m1 + 1; i <= m1 + m2; i++) {
        if (a[i + 1][1] < 0) {
            for (j = 1; j <= n + 1; j++) {
                tmp[index][j] = -a[i + 1][j];
            }
            index++;
        }
    }
}
void PositiveM1ForNegative(MAT &a, int &m1, int &n, MAT &tmp, int &index)
{
    for (i = 1; i <= m1; i++) {
        if (a[i + 1][1] < 0) {
            for (j = 1; j <= n + 1; j++) {
                tmp[index][j] = -a[i + 1][j];
            }
            index++;
        }
    }
}
void PositiveM2ForNegative(MAT &a, int &m1, int &m2, int &n, MAT &tmp, int &index)
{
    for (i = m1 + 1; i <= m1 + m2; i++) {
        if (a[i + 1][1] >= 0) {
            for (j = 1; j <= n + 1; j++) {
                tmp[index][j] = a[i + 1][j];
            }
            index++;
        }
    }
}
bool makeAllConstantsPositive(MAT &a, int &m1, int &m2, int m3, int n)
{
    MAT tmp;
    memcpy(tmp, a, sizeof(a));

    int index = 1;
    for (j = 1; j <= n + 1; j++) {
        tmp[index][j] = a[1][j];
    }
    index++;
    PostiveM1(a, m1, n, tmp, index);
    PositiveM2(a, m1, m2, n, tmp, index);
    int newM1 = index - 2;
    PositiveM1ForNegative(a, m1, n, tmp, index);
    PositiveM2ForNegative(a, m1, m2, n, tmp, index);
    int newM2 = index - newM1 - 2;
    for (i = m1 + m2 + 1; i <= m1 + m2 + m3; i++) {
        int direction = (a[i + 1][1] >= 0) ? 1 : -1;
        for (j = 1; j <= n + 1; j++) {
            tmp[index][j] = direction * a[i + 1][j];
        }
        index++;
    }

    memcpy(a, tmp, sizeof(tmp));

    m1 = newM1;
    m2 = newM2;
    return true;
}

void GenConstraints(int position, float constant, float left, float top, float right, float bottom)
{
    A[position][1] = constant;
    A[position][g_secondIndex] = left;
    A[position][g_thirdIndex] = top;
    A[position][g_fourthIndex] = right;
    A[position][g_fifthIndex] = bottom;
}

void GenConstraints(int position, float constant, float left, float top, float right, float bottom, float u1, float u2)
{
    A[position][1] = constant;
    A[position][g_secondIndex] = left;
    A[position][g_thirdIndex] = top;
    A[position][g_fourthIndex] = right;
    A[position][g_fifthIndex] = bottom;
    A[position][g_sixthIndex] = u1;
    A[position][g_seventhIndex] = u2;
}

void InitLargestRectUnderRatio(float *corners, float *limitation, float centerX, float centerY, float ratio)
{
    float x1 = corners[0];
    float y1 = corners[1];
    float x2 = corners[g_secondIndex];
    float y2 = corners[g_thirdIndex];
    float x3 = corners[g_fourthIndex];
    float y3 = corners[g_fifthIndex];
    float x4 = corners[g_sixthIndex];
    float y4 = corners[g_seventhIndex];
    // maximize z= r - l
    GenConstraints(1, 0, -1, 0, 1, 0);

    // b - t <= 0
    GenConstraints(g_secondIndex, 0, 0, -1, 0, 1);

    GenConstraints(g_thirdIndex, 0, 1, 0, -1, 0);

    GenConstraints(g_fourthIndex, y2 - x2 / (x1 - x2) * (y1 - y2), -1 / (x1 - x2) * (y1 - y2), 1, 0, 0);

    GenConstraints(g_fifthIndex, y2 - x2 / (x1 - x2) * (y1 - y2), 0, 1, -1 / (x1 - x2) * (y1 - y2), 0);

    GenConstraints(g_sixthIndex, y2 - x2 / (x1 - x2) * (y1 - y2), -1 / (x1 - x2) * (y1 - y2), 0, 0, 1);

    GenConstraints(g_seventhIndex, y2 - x2 / (x1 - x2) * (y1 - y2), 0, 0, -1 / (x1 - x2) * (y1 - y2), 1);

    GenConstraints(g_eighthIndex, x3 - y3 / (y2 - y3) * (x2 - x3), 1, -1 / (y2 - y3) * (x2 - x3), 0, 0);

    GenConstraints(g_ninthIndex, x3 - y3 / (y2 - y3) * (x2 - x3), 1, 0, 0, -1 / (y2 - y3) * (x2 - x3));

    GenConstraints(g_tenthIndex, x3 - y3 / (y2 - y3) * (x2 - x3), 0, -1 / (y2 - y3) * (x2 - x3), 1, 0);

    GenConstraints(g_eleventhIndex, limitation[g_secondIndex], 0, 0, 1, 0);

    GenConstraints(g_twelfthIndex, limitation[1], 0, 1, 0, 0);

    GenConstraints(g_thirteenthIndex, x3 - y3 / (y2 - y3) * (x2 - x3), 0, 0, 1, -1 / (y2 - y3) * (x2 - x3));

    GenConstraints(g_fourteenthIndex, y4 - x4 / (x3 - x4) * (y3 - y4), -1 / (x3 - x4) * (y3 - y4), 1, 0, 0);

    GenConstraints(g_fifteenthIndex, y4 - x4 / (x3 - x4) * (y3 - y4), 0, 1, -1 / (x3 - x4) * (y3 - y4), 0);

    GenConstraints(g_sixteenthIndex, y4 - x4 / (x3 - x4) * (y3 - y4), -1 / (x3 - x4) * (y3 - y4), 0, 0, 1);

    GenConstraints(g_seventeenthIndex, y4 - x4 / (x3 - x4) * (y3 - y4), 0, 0, -1 / (x3 - x4) * (y3 - y4), 1);

    GenConstraints(g_eighteenthIndex, x1 - y1 / (y4 - y1) * (x4 - x1), 1, -1 / (y4 - y1) * (x4 - x1), 0, 0);

    GenConstraints(g_nineteenthIndex, x1 - y1 / (y4 - y1) * (x4 - x1), 1, 0, 0, -1 / (y4 - y1) * (x4 - x1));

    GenConstraints(g_twentiethIndex, x1 - y1 / (y4 - y1) * (x4 - x1), 0, -1 / (y4 - y1) * (x4 - x1), 1, 0);

    GenConstraints(g_twentyFirstIndex, x1 - y1 / (y4 - y1) * (x4 - x1), 0, 0, 1, -1 / (y4 - y1) * (x4 - x1));

    GenConstraints(g_twentySecondIndex, limitation[0], 1, 0, 0, 0);

    GenConstraints(g_twentyThirdIndex, limitation[g_thirdIndex], 0, 0, 0, 1);

    GenConstraints(g_twentyFourthIndex, 0, -1, -ratio, 1, ratio);

    GenConstraints(g_twentyFifthIndex, centerX * g_secondIndex, 1, 0, 1, 0);

    GenConstraints(g_twentySixthIndex, centerY * g_secondIndex, 0, 1, 0, 1);
}

void WriteResult(float *outputRect)
{
    LOGD("Maximum of E.F. = %f", A[1][1]);
    for (i = 1; i <= N; i++) {
        for (j = 1; j <= M; j++) {
            if (IPOSV[j] == i && i <= g_fourthIndex) {
                outputRect[i - 1] = A[j + 1][1];
                LOGD("  X%d = %f", i, A[j + 1][1]);
                goto e3;
            }
        }
        LOGD("  X%d = %f", i, 0.0);
    e3:;
    }
}

void InitNearestMovement(float *corners, float *inputRect)
{
    float x1 = corners[0];
    float y1 = corners[1];
    float x2 = corners[g_secondIndex];
    float y2 = corners[g_thirdIndex];
    float x3 = corners[g_fourthIndex];
    float y3 = corners[g_fifthIndex];
    float x4 = corners[g_sixthIndex];
    float y4 = corners[g_seventhIndex];
    float centerX = (inputRect[0] + inputRect[g_secondIndex]) / g_secondIndex;
    float centerY = (inputRect[1] + inputRect[g_thirdIndex]) / g_secondIndex;
    // max: -(U1 + U2)
    GenConstraints(1, 0, 0, 0, 0, 0, -1, -1);

    // b - t <= 0
    GenConstraints(g_secondIndex, 0, 0, -1, 0, 1);

    // l - r <= 0
    GenConstraints(g_thirdIndex, 0, 1, 0, -1, 0);

    // t - 1/(x1 -x2)*(y1-y2) * l <= y2 - x2/(x1 -x2)*(y1-y2)
    GenConstraints(g_fourthIndex, y2 - x2 / (x1 - x2) * (y1 - y2), -1 / (x1 - x2) * (y1 - y2), 1, 0, 0);

    // t - 1/(x1 -x2)*(y1-y2) * r <= y2 - x2/(x1 -x2)*(y1-y2)
    GenConstraints(g_fifthIndex, y2 - x2 / (x1 - x2) * (y1 - y2), 0, 1, -1 / (x1 - x2) * (y1 - y2), 0);

    // b - 1/(x1 -x2)*(y1-y2) * l <= y2 - x2/(x1 -x2)*(y1-y2)
    GenConstraints(g_sixthIndex, y2 - x2 / (x1 - x2) * (y1 - y2), -1 / (x1 - x2) * (y1 - y2), 0, 0, 1);

    // b - 1/(x1 -x2)*(y1-y2) * r <= y2 - x2/(x1 -x2)*(y1-y2)
    GenConstraints(g_seventhIndex, y2 - x2 / (x1 - x2) * (y1 - y2), 0, 0, -1 / (x1 - x2) * (y1 - y2), 1);

    // l - 1/(y2 - y3)*(x2-x3) * t <= x3 - y3/(y2 -y3)*(x2-x3)
    GenConstraints(g_eighthIndex, x3 - y3 / (y2 - y3) * (x2 - x3), 1, -1 / (y2 - y3) * (x2 - x3), 0, 0);

    // l - 1/(y2 - y3)*(x2-x3) * b <= x3 - y3/(y2 -y3)*(x2-x3)
    GenConstraints(g_ninthIndex, x3 - y3 / (y2 - y3) * (x2 - x3), 1, 0, 0, -1 / (y2 - y3) * (x2 - x3));

    // r - 1/(y2 - y3)*(x2-x3) * t <= x3 - y3/(y2 -y3)*(x2-x3)
    GenConstraints(g_tenthIndex, x3 - y3 / (y2 - y3) * (x2 - x3), 0, -1 / (y2 - y3) * (x2 - x3), 1, 0);

    // r - 1/(y2 - y3)*(x2-x3) * b <= x3 - y3/(y2 -y3)*(x2-x3)
    GenConstraints(g_eleventhIndex, x3 - y3 / (y2 - y3) * (x2 - x3), 0, 0, 1, -1 / (y2 - y3) * (x2 - x3));

    // (l+r)*0.5 - U1 <= centerX
    GenConstraints(g_twelfthIndex, centerX, 0.5, 0, 0.5, 0, -1, 0);

    // (t+b)*0.5 - U2 <= centerY
    GenConstraints(g_thirteenthIndex, centerY, 0, 0.5, 0, 0.5, 0, -1);

    // t - 1/(x3 - x4)*(y3 - y4) * l >= y4 - x4/(x3 -x4)*(y3 - y4)
    GenConstraints(g_fourteenthIndex, y4 - x4 / (x3 - x4) * (y3 - y4), -1 / (x3 - x4) * (y3 - y4), 1, 0, 0);

    // t - 1/(x3 - x4)*(y3 - y4) * r >= y4 - x4/(x3 -x4)*(y3 - y4)
    GenConstraints(g_fifteenthIndex, y4 - x4 / (x3 - x4) * (y3 - y4), 0, 1, -1 / (x3 - x4) * (y3 - y4), 0);

    // b - 1/(x3 - x4)*(y3 - y4) * l >= y4 - x4/(x3 -x4)*(y3 - y4)
    GenConstraints(g_sixteenthIndex, y4 - x4 / (x3 - x4) * (y3 - y4), -1 / (x3 - x4) * (y3 - y4), 0, 0, 1);

    // b - 1/(x3 - x4)*(y3 - y4) * r >= y4 - x4/(x3 -x4)*(y3 - y4)
    GenConstraints(g_seventeenthIndex, y4 - x4 / (x3 - x4) * (y3 - y4), 0, 0, -1 / (x3 - x4) * (y3 - y4), 1);

    // l - 1/(y4 - y1)*(x4 - x1) * t >= x1 - y1/(y4 -y1)*(x4 - x1)
    GenConstraints(g_eighteenthIndex, x1 - y1 / (y4 - y1) * (x4 - x1), 1, -1 / (y4 - y1) * (x4 - x1), 0, 0);

    // l - 1/(y4 - y1)*(x4 - x1) * b >= x1 - y1/(y4 -y1)*(x4 - x1)
    GenConstraints(g_nineteenthIndex, x1 - y1 / (y4 - y1) * (x4 - x1), 1, 0, 0, -1 / (y4 - y1) * (x4 - x1));

    // r - 1/(y4 - y1)*(x4 - x1) * t >= x1 - y1/(y4 -y1)*(x4 - x1)
    GenConstraints(g_twentiethIndex, x1 - y1 / (y4 - y1) * (x4 - x1), 0, -1 / (y4 - y1) * (x4 - x1), 1, 0);

    // r - 1/(y4 - y1)*(x4 - x1) * b >= x1 - y1/(y4 -y1)*(x4 - x1)
    GenConstraints(g_twentyFirstIndex, x1 - y1 / (y4 - y1) * (x4 - x1), 0, 0, 1, -1 / (y4 - y1) * (x4 - x1));

    // (l+r)*0.5 + U1 >= centerX
    GenConstraints(g_twentySecondIndex, centerX, 0.5, 0, 0.5, 0, 1, 0);

    // (t+b)*0.5 + U2 >= centerY
    GenConstraints(g_twentyThirdIndex, centerY, 0, 0.5, 0, 0.5, 0, 1);

    // r - l - width = 0
    GenConstraints(g_twentyFourthIndex, inputRect[g_secondIndex] - inputRect[0], -1, 0, 1, 0);

    // t - b - height = 0
    GenConstraints(g_twentyFifthIndex, inputRect[1] - inputRect[g_thirdIndex], 0, 1, 0, -1);
}

void InitDirectionAndRatioConstraints(float *inputRect, float targetRatio, int *direction)
{
    int position = g_twentyThirdIndex;
    if (direction[0] == 0) {
        position++;
        GenConstraints(position, inputRect[0], 1, 0, 0, 0);
    }
    if (direction[1] == 0) {
        position++;
        GenConstraints(position, inputRect[1], 0, 1, 0, 0);
    }
    if (direction[g_secondIndex] == 0) {
        position++;
        GenConstraints(position, inputRect[g_secondIndex], 0, 0, 1, 0);
    }
    if (direction[g_thirdIndex] == 0) {
        position++;
        GenConstraints(position, inputRect[g_thirdIndex], 0, 0, 0, 1);
    }
    if (targetRatio > 1e-6) {
        position++;
        // r - l - ratio * t + ratio * b = 0
        GenConstraints(position, 0, -1, -targetRatio, 1, targetRatio);
    }
}
void InitReachableRect(float *&corners, float *inputRect, float targetRatio, int *direction)
{
    float x1 = corners[0];
    float y1 = corners[1];
    float x2 = corners[g_secondIndex];
    float y2 = corners[g_thirdIndex];
    float x3 = corners[g_fourthIndex];
    float y3 = corners[g_fifthIndex];
    float x4 = corners[g_sixthIndex];
    float y4 = corners[g_seventhIndex];
    
    GenConstraints(1, 0, 0, 0, 0, 0, -1, -1);

    // b - t <= 0
    GenConstraints(g_secondIndex, 0, 0, -1, 0, 1);

    // l - r <= 0
    GenConstraints(g_thirdIndex, 0, 1, 0, -1, 0);

    GenConstraints(g_fourthIndex, y2 - x2 / (x1 - x2) * (y1 - y2), -1 / (x1 - x2) * (y1 - y2), 1, 0, 0);

    GenConstraints(g_fifthIndex, y2 - x2 / (x1 - x2) * (y1 - y2), 0, 1, -1 / (x1 - x2) * (y1 - y2), 0);

    GenConstraints(g_sixthIndex, y2 - x2 / (x1 - x2) * (y1 - y2), -1 / (x1 - x2) * (y1 - y2), 0, 0, 1);

    GenConstraints(g_seventhIndex, y2 - x2 / (x1 - x2) * (y1 - y2), 0, 0, -1 / (x1 - x2) * (y1 - y2), 1);

    GenConstraints(g_eighthIndex, x3 - y3 / (y2 - y3) * (x2 - x3), 1, -1 / (y2 - y3) * (x2 - x3), 0, 0);

    GenConstraints(g_ninthIndex, x3 - y3 / (y2 - y3) * (x2 - x3), 1, 0, 0, -1 / (y2 - y3) * (x2 - x3));

    GenConstraints(g_tenthIndex, x3 - y3 / (y2 - y3) * (x2 - x3), 0, -1 / (y2 - y3) * (x2 - x3), 1, 0);

    GenConstraints(g_eleventhIndex, x3 - y3 / (y2 - y3) * (x2 - x3), 0, 0, 1, -1 / (y2 - y3) * (x2 - x3));

    GenConstraints(g_twelfthIndex, inputRect[0] + inputRect[g_secondIndex], 1, 0, 1, 0, -1, 0);

    GenConstraints(g_thirteenthIndex, inputRect[1] + inputRect[g_thirdIndex], 0, 1, 0, 1, 0, -1);

    GenConstraints(g_fourteenthIndex, y4 - x4 / (x3 - x4) * (y3 - y4), -1 / (x3 - x4) * (y3 - y4), 1, 0, 0);

    GenConstraints(g_fifteenthIndex, y4 - x4 / (x3 - x4) * (y3 - y4), 0, 1, -1 / (x3 - x4) * (y3 - y4), 0);

    GenConstraints(g_sixteenthIndex, y4 - x4 / (x3 - x4) * (y3 - y4), -1 / (x3 - x4) * (y3 - y4), 0, 0, 1);

    GenConstraints(g_seventeenthIndex, y4 - x4 / (x3 - x4) * (y3 - y4), 0, 0, -1 / (x3 - x4) * (y3 - y4), 1);

    GenConstraints(g_eighteenthIndex, x1 - y1 / (y4 - y1) * (x4 - x1), 1, -1 / (y4 - y1) * (x4 - x1), 0, 0);

    GenConstraints(g_nineteenthIndex, x1 - y1 / (y4 - y1) * (x4 - x1), 1, 0, 0, -1 / (y4 - y1) * (x4 - x1));

    GenConstraints(g_twentiethIndex, x1 - y1 / (y4 - y1) * (x4 - x1), 0, -1 / (y4 - y1) * (x4 - x1), 1, 0);

    GenConstraints(g_twentyFirstIndex, x1 - y1 / (y4 - y1) * (x4 - x1), 0, 0, 1, -1 / (y4 - y1) * (x4 - x1));

    GenConstraints(g_twentySecondIndex, inputRect[0] + inputRect[g_secondIndex], 1, 0, 1, 0, 1, 0);

    GenConstraints(g_twentyThirdIndex, inputRect[1] + inputRect[g_thirdIndex], 0, 1, 0, 1, 0, 1);

    InitDirectionAndRatioConstraints(inputRect, targetRatio, direction);
}

void PrintInputTable()
{
    LOGD("Input Table:");
    for (i = 1; i <= M + 1; i++) {
        for (j = 1; j <= N + 1; j++) {
            LOGD("%8.2f", A[i][j]);
        }
    }
}

void InitLargestAlignedRect(float *corners, float ratio, bool isCenterFixed, float centerX, float centerY)
{
    float x1 = corners[0];
    float y1 = corners[1];
    float x2 = corners[g_secondIndex];
    float y2 = corners[g_thirdIndex];
    float x3 = corners[g_fourthIndex];
    float y3 = corners[g_fifthIndex];
    float x4 = corners[g_sixthIndex];
    float y4 = corners[g_seventhIndex];
    // maximize z= r - l
    GenConstraints(1, 0, -1, 0, 1, 0);

    GenConstraints(g_secondIndex, 0, 0, -1, 0, 1);

    GenConstraints(g_thirdIndex, 0, 1, 0, -1, 0);

    GenConstraints(g_fourthIndex, y2 - x2 / (x1 - x2) * (y1 - y2), -1 / (x1 - x2) * (y1 - y2), 1, 0, 0);

    GenConstraints(g_fifthIndex, y2 - x2 / (x1 - x2) * (y1 - y2), 0, 1, -1 / (x1 - x2) * (y1 - y2), 0);

    GenConstraints(g_sixthIndex, y2 - x2 / (x1 - x2) * (y1 - y2), -1 / (x1 - x2) * (y1 - y2), 0, 0, 1);

    GenConstraints(g_seventhIndex, y2 - x2 / (x1 - x2) * (y1 - y2), 0, 0, -1 / (x1 - x2) * (y1 - y2), 1);

    GenConstraints(g_eighthIndex, x3 - y3 / (y2 - y3) * (x2 - x3), 1, -1 / (y2 - y3) * (x2 - x3), 0, 0);

    GenConstraints(g_ninthIndex, x3 - y3 / (y2 - y3) * (x2 - x3), 1, 0, 0, -1 / (y2 - y3) * (x2 - x3));

    GenConstraints(g_tenthIndex, x3 - y3 / (y2 - y3) * (x2 - x3), 0, -1 / (y2 - y3) * (x2 - x3), 1, 0);

    GenConstraints(g_eleventhIndex, x3 - y3 / (y2 - y3) * (x2 - x3), 0, 0, 1, -1 / (y2 - y3) * (x2 - x3));

    GenConstraints(g_twelfthIndex, y4 - x4 / (x3 - x4) * (y3 - y4), -1 / (x3 - x4) * (y3 - y4), 1, 0, 0);

    GenConstraints(g_thirteenthIndex, y4 - x4 / (x3 - x4) * (y3 - y4), 0, 1, -1 / (x3 - x4) * (y3 - y4), 0);

    GenConstraints(g_fourteenthIndex, y4 - x4 / (x3 - x4) * (y3 - y4), -1 / (x3 - x4) * (y3 - y4), 0, 0, 1);

    GenConstraints(g_fifteenthIndex, y4 - x4 / (x3 - x4) * (y3 - y4), 0, 0, -1 / (x3 - x4) * (y3 - y4), 1);

    GenConstraints(g_sixteenthIndex, x1 - y1 / (y4 - y1) * (x4 - x1), 1, -1 / (y4 - y1) * (x4 - x1), 0, 0);

    GenConstraints(g_seventeenthIndex, x1 - y1 / (y4 - y1) * (x4 - x1), 1, 0, 0, -1 / (y4 - y1) * (x4 - x1));

    GenConstraints(g_eighteenthIndex, x1 - y1 / (y4 - y1) * (x4 - x1), 0, -1 / (y4 - y1) * (x4 - x1), 1, 0);

    GenConstraints(g_nineteenthIndex, x1 - y1 / (y4 - y1) * (x4 - x1), 0, 0, 1, -1 / (y4 - y1) * (x4 - x1));

    GenConstraints(g_twentiethIndex, 0, -1, -ratio, 1, ratio);

    if (isCenterFixed) {
        GenConstraints(g_twentyFirstIndex, centerX, g_positionHalf, 0, g_positionHalf, 0);

        GenConstraints(g_twentySecondIndex, centerY, 0, g_positionHalf, 0, g_positionHalf);
    }
}
}

bool getLargestRectUnderRatio(float *corners, float *limitation, float centerX, float centerY, float ratio,
    float *outputRect)
{
    LOGI("getLargestRectUnderRatio begin");

    N = 4;   // Number of variables in E.F.
    M1 = 12; // Number of <= inequalities
    M2 = 10; // Number of >= inequalities
    M3 = 3;  // Number of = equalities

    M = M1 + M2 + M3; // Total number of constraints

    for (i = 1; i <= M + 2; i++)
        for (j = 1; j <= N + 1; j++)
            A[i][j] = 0.0;

    InitLargestRectUnderRatio(corners, limitation, centerX, centerY, ratio);

    if (!makeAllConstantsPositive(A, M1, M2, M3, N)) {
        return false;
    }

    for (i = 1; i <= M; i++) {
        for (j = 2; j <= N + 1; j++) {
            A[i + 1][j] = -A[i + 1][j];
        }
    }
    
    simplx(A, M, N, M1, M2, M3, &ICASE, IZROV, IPOSV, EPS_MIDDLE);

    if (ICASE == 0) { // result ok.
        WriteResult(outputRect);
        LOGI("getLargestRectUnderRatio end");
        return true;
    } else {
        LOGE(" No solution (error code = %d).", ICASE);
        LOGI("getLargestRectUnderRatio end");
        return false;
    }
}

bool getNearestMovement(float *corners, unsigned cornersSize, float *inputRect, unsigned inputRectSize,
    float *outputRect, unsigned outputRectSize)
{
    LOGD("getNearestMovement begin %d,%d,%d", cornersSize, inputRectSize, outputRectSize);

    N = 6;   // Number of variables in E.F.
    M1 = 12; // Number of <= inequalities
    M2 = 10; // Number of >= inequalities
    M3 = 2;  // Number of = equalities

    M = M1 + M2 + M3; // Total number of constraints

    for (i = 1; i <= M + 2; i++)
        for (j = 1; j <= N + 1; j++)
            A[i][j] = 0;

    InitNearestMovement(corners, inputRect);

    if (!makeAllConstantsPositive(A, M1, M2, M3, N)) {
        return false;
    }

    for (i = 1; i <= M; i++) {
        for (j = 2; j <= N + 1; j++) {
            A[i + 1][j] = -A[i + 1][j];
        }
    }

    LOGD("Input Table:");
    for (i = 1; i <= M + 1; i++) {
        for (j = 1; j <= N + 1; j++)
            LOGD("%8.2f", A[i][j]);
    }

    simplx(A, M, N, M1, M2, M3, &ICASE, IZROV, IPOSV, EPS_MIDDLE);

    if (ICASE == 0) { // result ok.
        WriteResult(outputRect);
        LOGD("getNearestMovement end");
        return true;
    } else {
        LOGD(" No solution (error code = %d).", ICASE);
        LOGD("getNearestMovement end");
        return false;
    }
    return true;
}

bool getReachableRect(float *corners, float *inputRect, float targetRatio, int *direction, float *outputRect)
{
    LOGD("getReachableRect begin");

    N = 6;   // Number of variables in E.F.
    M1 = 12; // Number of <= inequalities
    M2 = 10; // Number of >= inequalities
    M3 = 5;  // Number of = equalities

    M = M1 + M2 + M3; // Total number of constraints

    for (i = 1; i <= M + 2; i++)
        for (j = 1; j <= N + 1; j++)
            A[i][j] = 0;

    InitReachableRect(corners, inputRect, targetRatio, direction);

    int m = g_twentyThirdIndex;
    for (int k = 0; k < g_fourthIndex; k++) {
        m += direction[k] == 0 ? 1 : 0;
    }
    m += targetRatio > 1e-6 ? 1 : 0;
    
    M3 = m - g_twentyThirdIndex;
    M = M1 + M2 + M3;

    if (!makeAllConstantsPositive(A, M1, M2, M3, N)) {
        return false;
    }

    for (i = 1; i <= M; i++) {
        for (j = 2; j <= N + 1; j++) {
            A[i + 1][j] = -A[i + 1][j];
        }
    }

    PrintInputTable();

    simplx(A, M, N, M1, M2, M3, &ICASE, IZROV, IPOSV, EPS_MIDDLE);

    if (ICASE == 0) { // result ok.
        WriteResult(outputRect);
        LOGD("getReachableRect end");
        return true;
    } else {
        LOGD(" No solution (error code = %d).", ICASE);
        LOGD("getReachableRect end");
        return false;
    }
    return true;
}

bool getReachableRectFreeRatio(float *corners, size_t cornersSize, float *inputRect, size_t inputRectSize,
    float *outputRect, size_t outputRectSize)
{
    LOGD("getReachableRectFreeRatio begin %zu,%zu,%zu", cornersSize, inputRectSize, outputRectSize);
    float x1 = corners[0];
    float y1 = corners[1];
    float x2 = corners[g_secondIndex];
    float y2 = corners[g_thirdIndex];
    float x3 = corners[g_fourthIndex];
    float y3 = corners[g_fifthIndex];
    float x4 = corners[g_sixthIndex];
    float y4 = corners[g_seventhIndex];

    float l = inputRect[0];
    float t = inputRect[1];
    float r = inputRect[g_secondIndex];
    float b = inputRect[g_thirdIndex];

    // t - 1/(x1 -x2)*(y1-y2) * l <= y2 - x2/(x1 -x2)*(y1-y2)
    CHECK_REACHABLE_RECT_AND_RETURN(t - 1 / (x1 - x2) * (y1 - y2) * l, y2 - x2 / (x1 - x2) * (y1 - y2));

    // t - 1/(x1 -x2)*(y1-y2) * r <= y2 - x2/(x1 -x2)*(y1-y2)
    CHECK_REACHABLE_RECT_AND_RETURN(t - 1 / (x1 - x2) * (y1 - y2) * r, y2 - x2 / (x1 - x2) * (y1 - y2));

    // b - 1/(x1 -x2)*(y1-y2) * l <= y2 - x2/(x1 -x2)*(y1-y2)
    CHECK_REACHABLE_RECT_AND_RETURN(b - 1 / (x1 - x2) * (y1 - y2) * l, y2 - x2 / (x1 - x2) * (y1 - y2));

    // b - 1/(x1 -x2)*(y1-y2) * r <= y2 - x2/(x1 -x2)*(y1-y2)
    CHECK_REACHABLE_RECT_AND_RETURN(b - 1 / (x1 - x2) * (y1 - y2) * r, y2 - x2 / (x1 - x2) * (y1 - y2));

    // l - 1/(y2 - y3)*(x2-x3) * t <= x3 - y3/(y2 -y3)*(x2-x3)
    CHECK_REACHABLE_RECT_AND_RETURN(l - 1 / (y2 - y3) * (x2 - x3) * t, x3 - y3 / (y2 - y3) * (x2 - x3));

    // l - 1/(y2 - y3)*(x2-x3) * b <= x3 - y3/(y2 -y3)*(x2-x3)
    CHECK_REACHABLE_RECT_AND_RETURN(l - 1 / (y2 - y3) * (x2 - x3) * b, x3 - y3 / (y2 - y3) * (x2 - x3));

    // r - 1/(y2 - y3)*(x2-x3) * t <= x3 - y3/(y2 -y3)*(x2-x3)
    CHECK_REACHABLE_RECT_AND_RETURN(r - 1 / (y2 - y3) * (x2 - x3) * t, x3 - y3 / (y2 - y3) * (x2 - x3));

    // r - 1/(y2 - y3)*(x2-x3) * b <= x3 - y3/(y2 -y3)*(x2-x3)
    CHECK_REACHABLE_RECT_AND_RETURN(r - 1 / (y2 - y3) * (x2 - x3) * b, x3 - y3 / (y2 - y3) * (x2 - x3));

    // t - 1/(x3 - x4)*(y3 - y4) * l >= y4 - x4/(x3 -x4)*(y3 - y4)
    CHECK_REACHABLE_RECT_AND_RETURN(y4 - x4 / (x3 - x4) * (y3 - y4), t - 1 / (x3 - x4) * (y3 - y4) * l);

    // t - 1/(x3 - x4)*(y3 - y4) * r >= y4 - x4/(x3 -x4)*(y3 - y4)
    CHECK_REACHABLE_RECT_AND_RETURN(y4 - x4 / (x3 - x4) * (y3 - y4), t - 1 / (x3 - x4) * (y3 - y4) * r);

    // b - 1/(x3 - x4)*(y3 - y4) * l >= y4 - x4/(x3 -x4)*(y3 - y4)
    CHECK_REACHABLE_RECT_AND_RETURN(y4 - x4 / (x3 - x4) * (y3 - y4), b - 1 / (x3 - x4) * (y3 - y4) * l);

    // b - 1/(x3 - x4)*(y3 - y4) * r >= y4 - x4/(x3 -x4)*(y3 - y4)
    CHECK_REACHABLE_RECT_AND_RETURN(y4 - x4 / (x3 - x4) * (y3 - y4), b - 1 / (x3 - x4) * (y3 - y4) * r);

    // l - 1/(y4 - y1)*(x4 - x1) * t >= x1 - y1/(y4 -y1)*(x4 - x1)
    CHECK_REACHABLE_RECT_AND_RETURN(x1 - y1 / (y4 - y1) * (x4 - x1), l - 1 / (y4 - y1) * (x4 - x1) * t);

    // l - 1/(y4 - y1)*(x4 - x1) * b >= x1 - y1/(y4 -y1)*(x4 - x1)
    CHECK_REACHABLE_RECT_AND_RETURN(x1 - y1 / (y4 - y1) * (x4 - x1), l - 1 / (y4 - y1) * (x4 - x1) * b);

    // r - 1/(y4 - y1)*(x4 - x1) * t >= x1 - y1/(y4 -y1)*(x4 - x1)
    CHECK_REACHABLE_RECT_AND_RETURN(x1 - y1 / (y4 - y1) * (x4 - x1), r - 1 / (y4 - y1) * (x4 - x1) * t);

    // r - 1/(y4 - y1)*(x4 - x1) * b >= x1 - y1/(y4 -y1)*(x4 - x1)
    CHECK_REACHABLE_RECT_AND_RETURN(x1 - y1 / (y4 - y1) * (x4 - x1), r - 1 / (y4 - y1) * (x4 - x1) * b);

    outputRect[0] = inputRect[0];
    outputRect[1] = inputRect[1];
    outputRect[g_secondIndex] = inputRect[g_secondIndex];
    outputRect[g_thirdIndex] = inputRect[g_thirdIndex];
    return true;
}

bool getLargestAlignedRect(float *corners, float ratio, bool isCenterFixed, float centerX, float centerY,
    float *outputRect)
{
    LOGD("getLargestAlignedRect begin");
    N = 4;                            // Number of variables in E.F.
    M1 = 10;                          // Number of <= inequalities
    M2 = 8;                           // Number of >= inequalities
    M3 = 1 + (isCenterFixed ? 2 : 0); // Number of = equalities

    M = M1 + M2 + M3; // Total number of constraints

    for (i = 1; i <= M + 2; i++)
        for (j = 1; j <= N + 1; j++)
            A[i][j] = 0.0;

    InitLargestAlignedRect(corners, ratio, isCenterFixed, centerX, centerY);

    if (!makeAllConstantsPositive(A, M1, M2, M3, N)) {
        return false;
    }

    for (i = 1; i <= M; i++) {
        for (j = 2; j <= N + 1; j++) {
            A[i + 1][j] = -A[i + 1][j];
        }
    }

    simplx(A, M, N, M1, M2, M3, &ICASE, IZROV, IPOSV, EPS_MIDDLE);

    if (ICASE == 0) { // result ok.
        WriteResult(outputRect);
        LOGD("getLargestAlignedRect end");
        return true;
    } else {
        LOGD(" No solution (error code = %d).", ICASE);
        LOGD("getLargestAlignedRect end");
        return false;
    }
}

bool getLargestAlignedRect(float *corners, float ratio, float *outputRect)
{
    return getLargestAlignedRect(corners, ratio, false, 0, 0, outputRect);
}

bool getLargestAlignedRect(float *corners, float ratio, float centerX, float centerY, float *outputRect)
{
    return getLargestAlignedRect(corners, ratio, true, centerX, centerY, outputRect);
}
// end of file tsimplex.cpp