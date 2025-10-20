#include <iostream>
#include <vector>
#include <queue>
using namespace std;
#define X first
#define Y second

struct Node
{
    int x, y, n;
    Node(int _x, int _y, int _n):x(_x), y(_y), n(_n) {}
};

int main()
{
    ios::sync_with_stdio(0);
    cin.tie(0);

    int n, m; cin >> n >> m;
    vector<vector<char>> road(n, vector<char>(m));
    vector<vector<bool>> vis(n, vector<bool>(m));
    for (int i=0; i<n; ++i)
    {
        string line; cin >> line;
        for (int j=0; j<m; ++j)
            road[i][j] = line[j];
    }

    queue<Node> Q;
    int dx[4] = {1, 0, -1, 0};
    int dy[4] = {0, 1, 0, -1};
    Q.push(Node(0, 0, 1));
    vis[0][0] = true;
    while (!Q.empty())
    {
        pair<int, int> here = {Q.front().x, Q.front().y};
        int cnt = Q.front().n; 
        Q.pop();
        for (int i=0; i<4; ++i)
        {
            int nx = here.X + dx[i];
            int ny = here.Y + dy[i];
            if (nx < 0 || nx >= n || ny < 0 || ny >= m) continue;
            if (road[nx][ny] != '1' || vis[nx][ny]) continue;
            vis[nx][ny] = true;
            if (vis[n-1][m-1])
            {
                cout << cnt + 1;
                return 0;
            }
            Q.push(Node(nx, ny, cnt + 1));
        }
    }
}