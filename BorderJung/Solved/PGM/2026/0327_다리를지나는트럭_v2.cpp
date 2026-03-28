// PGM 다리를지나는트럭 (개선 - 시간 점프)
#include <string>
#include <vector>
#include <queue>

using namespace std;

int solution(int bridge_length, int weight, vector<int> truck_weights) {
    queue<pair<int, int>> q;
    int i = 0, t = 1, partSum = 0;

    while (i < truck_weights.size()) {
        // 1. 탈출할 트럭 모두 pop
        while (!q.empty() && t - q.front().y >= bridge_length) {
            partSum -= q.front().first;
            q.pop();
        }
        // 2. 트럭 추가 시도
        if (partSum + truck_weights[i] <= weight) {
            partSum += truck_weights[i];
            q.push({truck_weights[i++], t});
            t += 1;
        } else {
            // 3. 못 올리면 선두 탈출 시점으로 점프
            t = q.front().y + bridge_length;
        }
    }

    return q.back().y + bridge_length;
}
