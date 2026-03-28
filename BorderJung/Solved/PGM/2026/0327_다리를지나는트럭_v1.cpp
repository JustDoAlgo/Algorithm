// PGM 다리를지나는트럭 (초기 풀이 - 시간 1씩 증가)
#include <iostream>
#include <string>
#include <vector>
#include <queue>
#define x first
#define y second

using namespace std;

int solution(int bridge_length, int weight, vector<int> truck_weights) {
    queue<pair<int, int>> q; // weight - distance
    q.push(make_pair(truck_weights[0], 1));
    int i = 1;
    int t = 1;
    int partSum = truck_weights[0];
    while (!q.empty() && i < truck_weights.size()) {
        auto fw = q.front();
        if (t - fw.y < bridge_length) {
            if (partSum + truck_weights[i] <= weight) {
                partSum += truck_weights[i];
                q.push(make_pair(truck_weights[i++], t));
            }
        }
        else {
            q.pop();
            partSum -= fw.x;
            if (partSum + truck_weights[i] <= weight) {
                partSum += truck_weights[i];
                q.push(make_pair(truck_weights[i++], t));
            }
        }
        t += 1;
    }

    if (!q.empty())
        return q.back().y + bridge_length;

    return t;
}
