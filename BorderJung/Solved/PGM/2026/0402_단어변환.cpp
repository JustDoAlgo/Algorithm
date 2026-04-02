#include <string>
#include <vector>
#include <algorithm>
#include <queue>

using namespace std;

int n;
int board[30][30];
int visited[30];

void bfs(int here) {
    queue<int> q;
    q.push(here);
    visited[here] = 0;

    while(!q.empty()) {
        here = q.front(); q.pop();
        for (int next=0; next<n; ++next) {
            if (visited[next] == -1 && board[here][next] == 1) {
                visited[next] = visited[here] + 1;
                q.push(next);
            }
        }
    }
}

int solution(string begin, string target, vector<string> words) {
    fill(&board[0][0], &board[29][29]+1, 0);
    fill(&visited[0], &visited[29]+1, -1);

    words.push_back(begin);
    n = words.size();
    int ws = words[0].size();
    for (int i=0; i<n-1; ++i) {
        for (int j=i+1; j<n; ++j) {
            int diff = 0;
            for (int x=0; x<ws; ++x)
                if (words[i][x] != words[j][x])
                    diff += 1;
            if (diff == 1) {
                board[i][j] = 1;
                board[j][i] = 1;
            }
        }
    }

    int targetIndex = find(words.begin(), words.end(), target) - words.begin();

    bfs(n-1);
    if (visited[targetIndex] == -1)
        return 0;
    return visited[targetIndex];
}
