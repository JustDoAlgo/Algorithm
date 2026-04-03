#include <string>
#include <vector>
#include <algorithm>
#include <iostream>
#include <string.h>
#define x first
#define y second
using namespace std;

int n;
bool visited[52][52];
int dx[4] = {1,0,-1,0};
int dy[4] = {0,1,0,-1};

void dfs(int x, int y, vector<pair<int,int>>& v, vector<vector<int>>& adj, int match) {
    visited[x][y] = true;
    v.push_back({x, y});
    for (int i=0; i<4; ++i) {
        int nx = x + dx[i];
        int ny = y + dy[i];
        if (nx < 0 || nx >= n || ny < 0 || ny >= n) continue;
        if (!visited[nx][ny] && adj[nx][ny] == match) {
            dfs(nx, ny, v, adj, match);
        }
    }
}

void normalize(vector<pair<int,int>>& v) {
    int minX = v[0].x, minY = v[0].y;
    for (auto& e : v) {
        minX = min(e.x, minX);
        minY = min(e.y, minY);
    }
    for (auto& e : v) {
        e.x -= minX;
        e.y -= minY;
    }
    sort(v.begin(), v.end());
}

void rotate(vector<vector<pair<int, int>>>& v) {
    int originCnt = v.size();

    for (int i=0; i<originCnt; ++i) {
        vector<pair<int, int>> tmp;
        for (auto e : v[i]) {
            e = make_pair(-e.y, e.x);
            tmp.push_back(e);
        }
        normalize(tmp);
        v.push_back(tmp);
    }

    for (int i=0; i<originCnt; ++i) {
        vector<pair<int, int>> tmp;
        for (auto e : v[i]) {
            e = make_pair(-e.x, -e.y);
            tmp.push_back(e);
        }
        normalize(tmp);
        v.push_back(tmp);
    }

    for (int i=0; i<originCnt; ++i) {
        vector<pair<int, int>> tmp;
        for (auto e : v[i]) {
            e = make_pair(e.y, -e.x);
            tmp.push_back(e);
        }
        normalize(tmp);
        v.push_back(tmp);
    }
}

int solution(vector<vector<int>> game_board, vector<vector<int>> table) {
    n = game_board.size();

    vector<vector<pair<int, int>>> g_blocks;
    vector<vector<pair<int, int>>> t_blocks;

    memset(visited, false, sizeof(visited));
    for (int i=0; i<n; ++i) {
        for (int j=0; j<n; ++j) {
            if (!visited[i][j] && game_board[i][j] == 0) {
                vector<pair<int,int>> v;
                dfs(i, j, v, game_board, 0);
                normalize(v);
                g_blocks.push_back(v);
            }
        }
    }

    memset(visited, false, sizeof(visited));
    for (int i=0; i<n; ++i) {
        for (int j=0; j<n; ++j) {
            if (!visited[i][j] && table[i][j] == 1) {
                vector<pair<int,int>> v;
                dfs(i, j, v, table, 1);
                normalize(v);
                t_blocks.push_back(v);
            }
        }
    }
    int originCnt = t_blocks.size();
    rotate(t_blocks);

    int answer = 0;
    vector<bool> t_flag(originCnt);
    for (int i=0; i<g_blocks.size(); ++i) {
        for (int j=0; j<t_blocks.size(); ++j) {
            if (!t_flag[j%originCnt] && g_blocks[i] == t_blocks[j]) {
                t_flag[j%originCnt] = true;
                answer += t_blocks[j].size();
                break;
            }
        }
    }

    return answer;
}
