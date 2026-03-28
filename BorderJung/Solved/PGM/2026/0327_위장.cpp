// PGM 위장
#include <iostream>
#include <string>
#include <vector>
#include <unordered_map>

using namespace std;

int solution(vector<vector<string>> clothes) {
    unordered_map<string, vector<string>> m; // type, names
    for (auto& e : clothes) {
        if (m.find(e[1]) == m.end()){
            m[e[1]] = vector<string>();
        }
        m[e[1]].push_back(e[0]);
    }
    int result = 1;
    for (auto& [key, val] : m) {
        result *= val.size() + 1;
    }
    return result - 1;
}
