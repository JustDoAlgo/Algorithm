#include <iostream>
#include <queue>
using namespace std;
#define X first
#define Y second

int box[1002][1002];
int cnt[1002][1002];

int main()
{
    ios::sync_with_stdio(0);
    cin.tie(0);

    int n, m; cin >> m >> n;
    
    int dx[4] = {1, 0, -1, 0};
    int dy[4] = {0, 1, 0, -1};
    queue<pair<int, int>> Q;
    for (int i=0; i<n; ++i)
    {
        for (int j=0; j<m; ++j)
        {
            cin >> box[i][j];
            if (box[i][j] == 1)
                Q.push({i, j});
            if (box[i][j] == 0)
                cnt[i][j] = -1;
        }
    }
            
    while (!Q.empty())
    {
        pair<int, int> here = Q.front(); Q.pop();
        for (int i=0; i<4; ++i)
        {
            int nx = here.X + dx[i];
            int ny = here.Y + dy[i];
            if (nx < 0 || nx >= n || ny < 0 || ny >= m) continue;
            if (cnt[nx][ny] >= 0) continue;
            Q.push({nx, ny});
            cnt[nx][ny] = cnt[here.X][here.Y] + 1;
        }
    }

    int result = 0;
    for (int i=0; i<n; ++i)
    {
        for (int j=0; j<m; ++j)
        {
            if (cnt[i][j] == -1)
            {
                cout << -1;
                return 0;
            }
            result = max(result, cnt[i][j]);
        }
    }
    cout << result;
}