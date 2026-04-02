#include <string>
#include <vector>
#include <queue>
#include <algorithm>

using namespace std;

bool visited[205];

void bfs(int& n, vector<vector<int>>& computers, int here) {
    visited[here] = true;
    queue<int> q;
    q.push(here);
    while (!q.empty()) {
        here = q.front(); q.pop();
        for (int i=0; i<n; ++i) {
            if (!visited[i] && computers[here][i] == 1) {
                visited[i] = true;
                q.push(i);
            }
        }
    }
}

int solution(int n, vector<vector<int>> computers) {
    fill(visited, visited + 255, false);

    int answer = 0;

    for (int i=0; i<n; ++i) {
        if (!visited[i]) {
            bfs(n, computers, i);
            answer += 1;
        }
    }

    return answer;
}
