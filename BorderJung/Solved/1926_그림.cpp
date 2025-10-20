#include <iostream>
#include <queue>
#include <vector>
using namespace std;
#define X first
#define Y second

int main()
{
    ios::sync_with_stdio(false);
    cin.tie(0);

    int n, m; cin >> n >> m;
    vector<vector<int>> paper(n, vector<int>(m, 0));
    vector<vector<bool>> vis(n, vector<bool>(m, false));
    for (int i=0; i<n; ++i)
        for (int j=0; j<m; ++j)
            cin >> paper[i][j];

    int dx[4] = {1, 0, -1, 0};
    int dy[4] = {0, 1, 0, -1};
    queue<pair<int, int>> Q;
    
    int result = 0;
    int maxArea = 0;
    for (int i=0; i<n; ++i)
    {
        for (int j=0; j<m; ++j)
        {
            if (paper[i][j] == 1 && !vis[i][j])
            {
                int area = 1;
                result += 1;
                vis[i][j] = true;
                Q.push({i, j});
                while (!Q.empty())
                {
                    pair<int, int> here = Q.front(); Q.pop();
                    for (int i=0; i<4; ++i)
                    {
                        int nx = here.X + dx[i];
                        int ny = here.Y + dy[i];
                        if (nx < 0 || nx >= n || ny < 0 || ny >= m) continue;
                        if (paper[nx][ny] == 0 || vis[nx][ny]) continue;
                        vis[nx][ny] = true;
                        Q.push({nx, ny});
                        area += 1;
                    }
                }
                maxArea = max(maxArea, area);
            }
        }
    }
    cout << result << '\n' << maxArea;
}
