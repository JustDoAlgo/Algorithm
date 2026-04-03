#include <vector>
#include <string>
#include <algorithm>
using namespace std;

int solution(vector<string> arr)
{
    int n = (arr.size() + 1) / 2;
    vector<int> num;
    vector<char> c;
    num.push_back(stoi(arr[0]));
    for (int i=1; i<arr.size(); i+=2) {
        num.push_back(stoi(arr[i+1]));
        c.push_back(arr[i][0]);
    }

    int dp_max[102][102]; // dp[i][j]: i~j 까지에서 최댓값
    int dp_min[102][102]; // dp[i][j]: i~j 까지에서 최솟값
    fill(&dp_max[0][0], &dp_max[101][101] + 1, -987654321);
    fill(&dp_min[0][0], &dp_min[101][101] + 1, 987654321);

    for (int i=0; i<n; ++i) {
        dp_max[i][i] = dp_min[i][i] = num[i];
    }

    for (int l=2; l<=n; ++l) {
        for (int i=0; i<=n-l; ++i) {
            int j = i + l - 1;
            for (int k=i; k<j; ++k) {
                if (c[k] == '+') {
                    dp_max[i][j] = max(dp_max[i][j], dp_max[i][k] + dp_max[k+1][j]);
                    dp_min[i][j] = min(dp_min[i][j], dp_min[i][k] + dp_min[k+1][j]);
                }
                else {
                    dp_max[i][j] = max(dp_max[i][j], dp_max[i][k] - dp_min[k+1][j]);
                    dp_min[i][j] = min(dp_min[i][j], dp_min[i][k] - dp_max[k+1][j]);
                }
            }
        }
    }

    return dp_max[0][n-1];
}
