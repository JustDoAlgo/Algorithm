#include <string>
#include <vector>

using namespace std;

// dp[x][y] = triangle[x][y] + max(dp[i-1][y], dp[i-1][y+1]
// 중요한건 인덱스 예외처리가 되겠다

int solution(vector<vector<int>> triangle) {
    int answer = 0;

    int h = triangle.size();

    vector<vector<int>> dp(h, vector<int>(h));
    dp[0][0] = triangle[0][0];

    for (int i=1; i<h; ++i) {
        for (int j=0; j<=i; ++j) {
            int left  = dp[i-1][j-1] + triangle[i][j];
            int right = dp[i-1][j  ] + triangle[i][j];

            if      (j == 0) dp[i][j] = right;
            else if (j == i) dp[i][j] = left;
            else             dp[i][j] = max(left, right);

            if (i == h-1)
                answer = max(answer, dp[i][j]);
        }
    }
    return answer;
}
