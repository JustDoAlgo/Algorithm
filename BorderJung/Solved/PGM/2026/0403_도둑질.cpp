#include <string>
#include <vector>

using namespace std;

// dp[i][0]: i번째 훔치지 않은 최댓값
// dp[i][1]: i번째 훔친 최댓값
// 원형 → 직선 2번: 0~n-2, 1~n-1

int dp0[1000002][2] = {0, }; // 0~n-2
int dp1[1000002][2] = {0, }; // 1~n-1

int solution(vector<int> money) {
    int answer = 0;

    dp0[0][0] = 0;
    dp0[0][1] = money[0];
    dp1[1][0] = 0;
    dp1[1][1] = money[1];

    int n = money.size();
    for (int i=1; i<n-1; ++i) {
        dp0[i][0] = max(dp0[i-1][1], dp0[i-1][0]);
        dp0[i][1] = dp0[i-1][0] + money[i];
        dp1[i+1][0] = max(dp1[i][1], dp1[i][0]);
        dp1[i+1][1] = dp1[i][0] + money[i+1];
    }

    return max(max(dp0[n-2][0], dp0[n-2][1]), max(dp1[n-1][0], dp1[n-1][1]));
}
