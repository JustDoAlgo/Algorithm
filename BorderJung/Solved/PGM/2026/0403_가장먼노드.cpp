#include <string>
#include <vector>
#include <queue>
#include <string.h>

using namespace std;

bool visited[20002] = {0,};
vector<vector<int>> adj;

int solution(int n, vector<vector<int>> edge) {
    int answer = 0;

    adj = vector<vector<int>>(n+2, vector<int>());
    for (int i=0; i<edge.size(); ++i) {
        int s = edge[i][0];
        int e = edge[i][1];
        adj[s].push_back(e);
        adj[e].push_back(s);
    }

    vector<int> cnt(n+2, 0);

    memset(visited, false, sizeof(visited));
    queue<int> q;
    q.push(1);
    visited[1] = true;
    cnt[1] = 0;
    int dist = 0;
    while (!q.empty()) {
        int here = q.front(); q.pop();
        for (int i=0; i<adj[here].size(); ++i) {
            int next = adj[here][i];
            if (!visited[next]) {
                visited[next] = true;
                q.push(next);
                cnt[next] = cnt[here] + 1;
                dist = max(dist, cnt[next]);
            }
        }
    }

    for (auto& e : cnt)
        if (e == dist) answer += 1;

    return answer;
}
