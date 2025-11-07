#include <iostream>
#include <queue>
using namespace std;
#define x first
#define y second

char board[1002][1002];
int ft[1002][1002];
int st[1002][1002];
int dx[4] = {1,0,-1,0};
int dy[4] = {0,1,0,-1};

int main()
{
    cin.tie(0);
    ios::sync_with_stdio(0);

    int t; cin >> t;
    while (t--)
    {
        int w, h; cin >> w >> h;
        for (int i=0; i<1002; ++i)
        {
            fill(ft[i], ft[i] + 1002, -1);
            fill(st[i], st[i] + 1002, -1);
        }
        queue<pair<int, int>> fq;
        queue<pair<int, int>> sq;

        for (int i=0; i<h; ++i)
        {
            string line; cin >> line;
            for (int j=0; j<w; ++j)
            {
                board[i][j] = line[j];
                if (board[i][j] == '@')
                {
                    sq.push({i, j});
                    st[i][j] = 0;
                }
                if (board[i][j] == '*')
                {
                    fq.push({i, j});
                    ft[i][j] = 0;
                }
            }
        }

        // 불 퍼지는 시간 갱신
        while (!fq.empty())
        {
            pair<int, int> here = fq.front(); fq.pop();
            for (int i=0; i<4; ++i)
            {
                int nx = here.x + dx[i];
                int ny = here.y + dy[i];
                if (nx < 0 || nx >= h || ny < 0 || ny >= w) continue;
                if (ft[nx][ny] != -1 || board[nx][ny] == '#') continue;
                fq.push({nx, ny});
                ft[nx][ny] = ft[here.x][here.y] + 1;
            }
        }

        // 상근이 이동하기
        bool isEscape = false;
        while (!sq.empty() && !isEscape)
        {
            pair<int, int> here = sq.front(); sq.pop();
            for (int i=0; i<4; ++i)
            {
                int nx = here.x + dx[i];
                int ny = here.y + dy[i];
                if (nx < 0 || nx >= h || ny < 0 || ny >= w)
                {
                    cout << st[here.x][here.y] + 1 << '\n';
                    isEscape = true;
                    break;
                }
                if (st[nx][ny] != -1 || board[nx][ny] == '#') continue;
                if (ft[nx][ny] != -1 && ft[nx][ny] <= st[here.x][here.y] + 1) continue;
                sq.push({nx, ny});
                st[nx][ny] = st[here.x][here.y] + 1;
            }
        }

        if (!isEscape)
            cout << "IMPOSSIBLE\n";
    }
}