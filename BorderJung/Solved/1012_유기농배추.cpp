#include <iostream>
#include <queue>
using namespace std;
#define x first
#define y second

int board[52][52];
bool visited[52][52];
int dx[4] = {1,0,-1,0};
int dy[4] = {0,1,0,-1};
int n, m, k;

void bfs(int x, int y)
{
    queue<pair<int, int>> q;
    q.push({x, y});
    while (!q.empty())
    {
        pair<int, int> here = q.front(); q.pop();
        for (int i=0; i<4; ++i)
        {
            int nx = here.x + dx[i];
            int ny = here.y + dy[i];
            if (nx < 0 || nx >= n || ny < 0 || ny >= m)
                continue;
            if (!visited[nx][ny] && board[nx][ny] == 1)
            {
                visited[nx][ny] = true;
                q.push({nx, ny});
            }
        }
    }
}

int main()
{
    cin.tie(0);
    ios::sync_with_stdio(0);

    int t; cin >> t;
    while (t--)
    {
        cin >> m >> n >> k;

        for (int i=0; i<52; ++i)
        {
            fill(board[i], board[i] + 52, 0);
            fill(visited[i], visited[i] + 52, false);
        }

        while (k--)
        {
            int x, y; cin >> x >> y;
            board[y][x] = 1;
        }

        int result = 0;
        for (int i=0; i<n; ++i)
        {
            for (int j=0; j<m; ++j)
            {
                if (board[i][j] == 1 && !visited[i][j])
                {
                    result += 1;
                    bfs(i, j);
                }
            }
        }
        cout << result << '\n';
    }
}