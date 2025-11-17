// 왜 안 풀릴까. 아니 생각한건 그대로인데 왜 안 돌아가지 ㅠ
#include <iostream>
#include <queue>
using namespace std;
#define x first
#define y second

int board[102][102];
int n;

int main()
{
    ios::sync_with_stdio(0);
    cin.tie(0);

    cin >> n;
    for (int i=0; i<n; ++i)
        for (int j=0; j<n; ++j)
            cin >> board[i][j];
}