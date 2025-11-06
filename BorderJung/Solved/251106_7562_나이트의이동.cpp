#include <iostream>
#include <queue>
using namespace std;
#define x first
#define y second

pair<int, int> night;
pair<int, int> target;
int timing[302][302];
int t, n;
int dx[8] = {2,1,-1,-2,-2,-1,1,2};
int dy[8] = {1,2,2,1,-1,-2,-2,-1};


int main()
{
    cin.tie(0);
    ios::sync_with_stdio(0);

    cin >> t;
    while (t--)
    {
        cin >> n >> night.x >> night.y >> target.x >> target.y;

        for (int i=0; i<302; ++i)
        {
            fill(timing[i], timing[i] + 302, -1);
        }

        queue<pair<int, int>> q;
        q.push(night);
        timing[night.x][night.y] = 0;

        if (night == target)
        {
            cout << 0 << '\n';
            continue;
        }

        bool stopCurrentLoop = false;
        while (!q.empty() && !stopCurrentLoop)
        {
            pair<int, int> here = q.front(); q.pop();
            for (int i=0; i<8; ++i)
            {
                int nx = here.x + dx[i];
                int ny = here.y + dy[i];
                if (nx < 0 || nx >= n || ny < 0 || ny >= n) continue;
                if (timing[nx][ny] != -1) continue;
                if (nx == target.x && ny == target.y)
                {
                    cout << timing[here.x][here.y] + 1 << '\n';
                    stopCurrentLoop = true;
                    break;
                }
                q.push({nx, ny});
                timing[nx][ny] = timing[here.x][here.y] + 1;
            }
        }
    }
}