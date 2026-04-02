#include <string>
#include <vector>
#include <algorithm>
#include <queue>
#define x first
#define y second
using namespace std;

int t[102][102];
int dx[4] = {1,0,-1,0};
int dy[4] = {0,1,0,-1};

int bfs(vector<vector<int>>& maps, int x, int y) {
    int n = maps.size();
    int m = maps[0].size();
    queue<pair<int, int>> q;
    q.push({x, y});
    t[x][y] = 1;
    while(!q.empty()) {
        auto here = q.front(); q.pop();
        if (here.x == n-1 && here.y == m-1)
            return t[n-1][m-1];

        for (int i=0; i<4; ++i) {
            int nx = here.x + dx[i];
            int ny = here.y + dy[i];

            if (nx < 0 || nx >= n || ny < 0 || ny >= m) continue;
            if (maps[nx][ny] == 0 || t[nx][ny] != -1) continue;

            t[nx][ny] = t[here.x][here.y] + 1;
            q.push({nx, ny});
        }
    }
    return -1;
}

int solution(vector<vector<int> > maps) {
    fill(&t[0][0], &t[101][101] + 1, -1);
    bfs(maps, 0, 0);
    int answer = t[maps.size()-1][maps[0].size()-1];
    return answer;
}
