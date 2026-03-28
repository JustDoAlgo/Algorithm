// PGM 프로세스
#include <string>
#include <vector>
#include <queue>

using namespace std;
#define x first
#define y second

int solution(vector<int> priorities, int location) {
    int answer = 0;

    queue<pair<int, int>> q; // 우선순위, 위치
    priority_queue<int, vector<int>, less<int>> pq; // 우선순위 내림차순 큐
    for (int i=0; i<priorities.size(); ++i) {
        q.push(make_pair(priorities[i], i));
        pq.push(priorities[i]);
    }

    while (!q.empty() && !pq.empty()) {
        auto here = q.front(); q.pop();
        int high = pq.top();
        while (here.x != high) {
            q.push(here);
            here = q.front(); q.pop();
        }
        answer += 1;
        pq.pop();
        if (here.y == location) break;
    }

    return answer;
}
