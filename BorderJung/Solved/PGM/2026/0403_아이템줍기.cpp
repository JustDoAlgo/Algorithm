#include <string>
#include <vector>
#include <iostream>
#include <queue>
#include <algorithm>
#include <string.h>
#define x first
#define y second
using namespace std;

int draw[105][105];
int dist[105][105];
int dx8[8] = {1,1,0,-1,-1,-1,0,1};
int dy8[8] = {0,1,1,1,0,-1,-1,-1};
int dx4[4] = {1,0,-1,0};
int dy4[4] = {0,1,0,-1};

bool is_edge(int x, int y) {
    if (draw[x][y] == 0) return false;
    int cnt = 0;
    for (int i=0; i<8; ++i) {
        int nx = x + dx8[i];
        int ny = y + dy8[i];
        if (nx < 0 || nx >= 105 || ny < 0 || ny >= 105) continue;
        if (draw[nx][ny] == 0) return true;
    }
    return false;
}
int solution(vector<vector<int>> rectangle, int characterX, int characterY, int itemX, int itemY) {
    // fill(&draw[0][0], &draw[104][104] + 1, 0);
    // fill(&dist[0][0], &dist[104][104] + 1, -1);
    memset(draw, 0, sizeof(draw));
    memset(dist, -1, sizeof(dist));

    // draw
    for (auto& e : rectangle) {
        for (int i=e[0]*2; i<=e[2]*2; ++i) {
            for (int j=e[1]*2; j<=e[3]*2; ++j) {
                draw[i][j] = 1;
            }
        }
    }
    // edge
    int sx = characterX * 2, sy = characterY * 2;
    int ex = itemX * 2, ey = itemY * 2;
    queue<pair<int, int>> q;
    q.push({sx, sy});
    dist[sx][sy] = 0;
    while (!q.empty()) {
        auto here = q.front(); q.pop();
        if (here.x == ex && here.y == ey) return dist[ex][ey] / 2;
        for (int i=0; i<4; ++i) {
            int nx = here.x + dx4[i];
            int ny = here.y + dy4[i];
            if (nx < 0 || nx >= 105 || ny < 0 || ny >= 105) continue;
            if (dist[nx][ny] != -1) continue;
            if (!is_edge(nx, ny)) continue;
            dist[nx][ny] = dist[here.x][here.y] + 1;
            q.push({nx, ny});
        }
    }
    return -1;
}
