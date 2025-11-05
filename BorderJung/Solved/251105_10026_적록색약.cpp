#include <iostream>
#include <queue>
using namespace std;
#define x first
#define y second

/*
BFS로 구역 개수 구하기
일반인: 그냥 BFS
적록색양: R, G를 같은 걸로 본 BFS
*/

char board[102][102];
bool visited1[102][102];
bool visited2[102][102];
int n;
int dx[4] = {1,0,-1,0};
int dy[4] = {0,1,0,-1};

void bfs(int x, int y)
{
    queue<pair<int, int>> q;
    q.push({x, y});
    visited1[x][y] = true;
    while (!q.empty())
    {
        pair<int, int> here = q.front(); q.pop();
        for (int i=0; i<4; ++i)
        {
            int nx = here.x + dx[i];
            int ny = here.y + dy[i];
            if (nx < 0 || nx >= n || ny < 0 || ny >= n) continue;
            if (visited1[nx][ny] || board[nx][ny] != board[here.x][here.y]) continue;
            visited1[nx][ny] = true;
            q.push({nx, ny});
        }
    }
}

void bfs2(int x, int y)
{
    queue<pair<int, int>> q;
    q.push({x, y});
    visited2[x][y] = true;
    while (!q.empty())
    {
        pair<int, int> here = q.front(); q.pop();
        for (int i=0; i<4; ++i)
        {
            int nx = here.x + dx[i];
            int ny = here.y + dy[i];
            if (nx < 0 || nx >= n || ny < 0 || ny >= n) continue;
            if (visited2[nx][ny]) continue;
            char cur = board[here.x][here.y];
            char next = board[nx][ny];
            if (cur == 'R' && next == 'B') continue;
            if (cur == 'G' && next == 'B') continue;
            if (cur == 'B' && (next == 'R' || next == 'G')) continue;

            visited2[nx][ny] = true;
            q.push({nx, ny});
        }
    }
}

int main()
{
    cin.tie(0);
    ios::sync_with_stdio(0);

    cin >> n;
    for (int i=0; i<n; ++i)
    {
        string line; cin >> line;
        for (int j=0; j<n; ++j)
            board[i][j] = line[j];
    }

    int result1 = 0;
    int result2 = 0;
    for (int i=0; i<n; ++i)
    {
        for (int j=0; j<n; ++j)
        {
            if (!visited1[i][j])
            {
                result1 += 1;
                bfs(i, j);
            }
            if (!visited2[i][j])
            {
                result2 += 1;
                bfs2(i, j);
            }
        }
    }
    cout << result1 << ' ' << result2;
}