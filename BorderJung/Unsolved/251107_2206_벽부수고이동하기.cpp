#include <iostream>
#include <queue>
#include <tuple>
using namespace std;
#define x first
#define y second

char board[1002][1002];
int t[1002][1002][2];
int n, m;
int dx[4] = {1,0,-1,0};
int dy[4] = {0,1,0,-1};

int main()
{
    cin.tie(0);
    ios::sync_with_stdio(0);

    cin >> n >> m;
    for (int i=0; i<1002; ++i)
    {
        for (int j=0; j<1002; ++j)
            fill(t[i][j], t[i][j] + 2, -1);
    }
    
    for (int i=0; i<n; ++i)
    {
        string line; cin >> line;
        for (int j=0; j<m; ++j)
        {
            board[i][j] = line[j];
        }
    }

    queue<tuple<int, int, int>> q; // x, y, isBrokenWall
    q.push({0, 0, 0});
    t[0][0][0] = 1;

    /*
    기존의 BFS 코드에서 조건을 하나 추가한다.
    만약 isBroken == false 라면, queue에 벽을 부순 경우, 아닌 경우 2개를 추가한다.
    isBroken == true 라면, 그냥 curIsBroken을 그대로 넣으면 된다.

    문제가
    지름길로 먼저 도달해서 길을 막아놓고,
    아직 벽 안 부순 더 빨리 갈 수 있는 녀석이 나아가지 못하게 할 수 있어.
    */
    while (!q.empty())
    {
        int curX, curY, curIsBroken;
        tie(curX, curY, curIsBroken) = q.front(); q.pop();
        if (curX == n - 1 && curY == m - 1) 
        {
            cout << t[curX][curY][curIsBroken];
            return 0;
        }
        for (int i=0; i<4; ++i)
        {
            int nx = curX + dx[i];
            int ny = curY + dy[i];
            if (nx < 0 || nx >= n || ny < 0 || ny >= m) continue;
            if (board[nx][ny] == '0' && t[nx][ny][curIsBroken] == -1)
            {
                q.push({nx, ny, curIsBroken});
                t[nx][ny][curIsBroken] = t[curX][curY][curIsBroken] + 1;
            }
            // 벽을 부수자
            if (board[nx][ny] == '1' && !curIsBroken && t[nx][ny][1] == -1)
            {
                q.push({nx, ny, 1});
                t[nx][ny][1] = t[curX][curY][curIsBroken] + 1;
            }
        }
    }
    cout << -1;
}