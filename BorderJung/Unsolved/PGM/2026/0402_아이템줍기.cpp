#include <string>
#include <vector>
#include <algorithm>
#include <queue>
#define x first
#define y second

using namespace std;

// 1. 외곽선 구하기
    // 이때 전체 길이도 함께 구해둔다.
// 2. 아무 방향으로 아이템 찾기. 그 후 전체 길이에서 뺀 값과 비교

int board[55][55];
int draw[55][55];
int t[55][55];
int dx[8] = {1,1,0,-1,-1,-1,0,1};
int dy[8] = {0,1,1,1,0,-1,-1,-1};
int dx4[4] = {1,0,-1,0};
int dy4[4] = {0,1,0,-1};

bool isEdge(int x, int y) {
    if (draw[x][y] != 1) return false;
    int cnt = 0;
    for (int i=0; i<8; ++i) {
        int nx = x + dx[i];
        int ny = y + dy[i];
        if (nx < 0 || nx >= 50 || ny < 0 || ny >= 50) continue;
        if (draw[nx][ny] == 1)
            cnt += 1;
    }
    // 망망대해 또는 내부
    if (cnt == 8 || cnt == 0) return false;
    return true;
}

void bfs(int x, int y, int itemX, int itemY) {
    queue<pair<int,int>> q;
    q.push({x, y});
    t[x][y] = 0;
    while (!q.empty()) {
        auto here = q.front(); q.pop();
        for (int i=0; i<4; ++i) {
            int nx = here.x + dx4[i];
            int ny = here.y + dy4[i];
            if (nx < 0 || nx >= 50 || ny < 0 || ny >= 50) continue;
            if (t[nx][ny] > t[here.x][here.y] + 1) {
                t[nx][ny] = t[here.x][here.y] + 1;
                continue;
            }
            if (board[nx][ny] == 1) {
                t[nx][ny] = t[here.x][here.y] + 1;
                q.push({nx, ny});
            }
        }
    }
}

int solution(vector<vector<int>> rectangle, int characterX, int characterY, int itemX, int itemY) {
    fill(&board[0][0], &board[55][55], 0);
    fill(&draw[0][0], &draw[55][55], 0);
    fill(&t[0][0], &t[55][55], 987654321);

    for (auto& v : rectangle) {
        pair<int, int> a = {v[0], v[1]};
        pair<int, int> b = {v[2], v[3]};
        for (int i=a.x; i<=b.x; ++i) {
            for (int j=a.y; j<=b.y; ++j) {
                draw[i][j] = 1;
            }
        }
    }

    // board에 외곽선 저장
    for (int i=0; i<50; ++i){
        for (int j=0; j<50; ++j) {
            if (isEdge(i, j)) board[i][j] = 1;
        }
    }

    bfs(characterX-1, characterY-1, itemX-1, itemY-1);

    return t[itemX-1][itemY-1];
}
