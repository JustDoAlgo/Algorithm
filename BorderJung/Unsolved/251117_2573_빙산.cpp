#include <iostream>
#include <queue>
using namespace std;
#define x first
#define y second

int board[302][302];
bool visited[302][302];
int n, m, year;
int dx[4] = {1,0,-1,0};
int dy[4] = {0,1,0,-1};

void bfs(int x, int y)
{
    queue<pair<int, int>> q;
    q.push({x, y});
    visited[x][y] = true;
    while (!q.empty())
    {
        auto here = q.front(); q.pop();
        for (int i=0; i<4; ++i)
        {
            int nx = here.x + dx[i];
            int ny = here.y + dy[i];
            if (!visited[nx][ny] && board[nx][ny] != 0)
            {
                q.push({nx, ny});
                visited[nx][ny] = true;
            }
        }
    }
}

int main()
{
    ios::sync_with_stdio(0);
    cin.tie(0);

    cin >> n >> m;
    for (int i=0; i<n; ++i)
        for (int j=0; j<m; ++j)
            cin >> board[i][j];

    while (true)
    {
        year += 1;

        // 1년 뒤 빙산 녹음
        int zero[302][302] = {0, };
        for (int i=1; i<n-1; ++i)
        {
            for (int j=1; j<m-1; ++j)
            {
                if (board[i][j] == 0) continue;
                for (int k=0; k<4; ++k)
                {
                    if (board[i+dx[k]][j+dy[k]] == 0)
                        zero[i][j] += 1;
                }
            }
        }

        for (int i=1; i<n-1; ++i)
        {
            for (int j=1; j<m-1; ++j)
            {
                board[i][j] = max(0, board[i][j] - zero[i][j]);
            }
        }

        // 빙산 갯수 확인
        int cnt = 0;
        for (int i=0; i<302; ++i)
            fill(visited[i], visited[i] + 302, false);
        
        for (int i=1; i<n-1; ++i)
        {
            for (int j=1; j<m-1; ++j)
            {
                if (!visited[i][j] && board[i][j] != 0)
                {
                    bfs(i, j);
                    cnt += 1;
                }
            }
        }

        if (cnt == 0)
        {
            cout << 0;
            return 0;
        }
        else if (cnt >= 2)
        {
            cout << year;
            return 0;
        }
    }
}