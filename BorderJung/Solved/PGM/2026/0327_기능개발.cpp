// PGM 기능개발
#include <string>
#include <vector>
#include <queue>

using namespace std;

vector<int> solution(vector<int> progresses, vector<int> speeds) {
    vector<int> answer;

    queue<int> q;
    for (int i=0; i<progresses.size(); ++i) {
        q.push((100 - progresses[i] + speeds[i] - 1) / speeds[i]);
    }

    while (!q.empty()) {
        int cnt = 0;
        int here = q.front(); q.pop();
        cnt += 1;
        while (!q.empty() && here >= q.front()) {
            cnt += 1;
            q.pop();
        }
        answer.push_back(cnt);
    }

    return answer;
}
