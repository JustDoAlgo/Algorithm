#include <string>
#include <vector>

using namespace std;

void dfs(vector<int>& numbers, int& target, int& answer, int i, int ps) {
    if (i == numbers.size()) {
        if (ps == target) answer += 1;
        return;
    }
    dfs(numbers, target, answer, i+1, ps+numbers[i]);
    dfs(numbers, target, answer, i+1, ps-numbers[i]);
}

int solution(vector<int> numbers, int target) {
    int answer = 0;
    dfs(numbers, target, answer, 0, 0);
    return answer;
}
