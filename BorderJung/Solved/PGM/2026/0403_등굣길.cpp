#include <string>
#include <vector>
#include <queue>
#include <iostream>
#define MOD 1000000007
#define x first
#define y second
using namespace std;

int solution(int m, int n, vector<vector<int>> puddles) {
    int answer = 0;

    bool puddle[102][102] = {0, };
    for (auto& e : puddles) puddle[e[1]][e[0]] = true;

    // dp[x][y] = dp[x-1][y] + dp[x][y-1];
    int dp[102][102] = {0, };
    for (int i=0; i<m; ++i) {
        if (!puddle[0][i]) dp[0][i] = 1;
        else break;
    }
    for (int i=0; i<n; ++i) {
        if (!puddle[i][0]) dp[i][0] = 1;
        else break;
    }

    for (int i=1; i<n; ++i) {
        for (int j=1; j<m; ++j) {
            if (!puddle[i][j]) {
                dp[i][j] = (dp[i-1][j] + dp[i][j-1]) % MOD;
            }
        }
    }

    return dp[n-1][m-1];
}
