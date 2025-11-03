#include <iostream>
#include <queue>
using namespace std;
#define x first
#define y second

int r, c;
char board[1002][1002]; // 입력
int ft[1002][1002]; // 불이 퍼지는 시간
int jt[1002][1002]; // 지훈이 도달한 시간
int dx[4] = {1,0,-1,0};
int dy[4] = {0,1,0,-1};

int main()
{
    cin.tie(0);
    ios::sync_with_stdio(0);

    cin >> r >> c;
    queue<pair<int, int>> fq;
    queue<pair<int, int>> jq;
    for (int i=0; i<r; ++i)
    {
        fill(ft[i], ft[i]+c, -1);
        fill(jt[i], jt[i]+c, -1);
    }
    for (int i=0; i<r; ++i)
    {
        string line; cin >> line;
        for (int j=0; j<line.size(); ++j)
        {
            board[i][j] = line[j];
            if (board[i][j] == 'J')
            {
                jq.push({i, j});
                jt[i][j] = 0;
            }
                
            if (board[i][j] == 'F')
            {
                fq.push({i, j});
                ft[i][j] = 0;
            }
        }
    }
    

    /*
    지훈이와 불을 각각 BFS를 돌린다.
    불 BFS를 먼저 돌려서 퍼지는 시간 t를 구한다.
    지훈 BFS를 돌리며, (1)벽이 아니고, (2)t보다 작으면 갈 수 있다.
    만약 범위(r, c)를 벗어나면 탈출이다.
    */
    while (!fq.empty())
    {
        pair<int, int> here = fq.front(); fq.pop();
        for (int i=0; i<4; ++i)
        {
            int nx = here.x + dx[i];
            int ny = here.y + dy[i];
            if (nx < 0 || nx >= r || ny < 0 || ny >= c)
                continue;

            if (ft[nx][ny] >= 0 || board[nx][ny] == '#')
                continue;

            ft[nx][ny] = ft[here.x][here.y] + 1;
            fq.push({nx, ny});
        }
    }
    while (!jq.empty())
    {
        pair<int, int> here = jq.front(); jq.pop();
        for (int i=0; i<4; ++i)
        {
            int nx = here.x + dx[i];
            int ny = here.y + dy[i];
            if (nx < 0 || nx >= r || ny < 0 || ny >= c)
            {
                cout << jt[here.x][here.y] + 1;
                return 0;    
            }

            if (jt[nx][ny] >= 0 || board[nx][ny] == '#')
                continue;

            if (ft[nx][ny] != -1 && jt[here.x][here.y] + 1 >= ft[nx][ny])
                continue;

            jt[nx][ny] = jt[here.x][here.y] + 1;
            jq.push({nx, ny});
        }
    }

    cout << "IMPOSSIBLE";
}