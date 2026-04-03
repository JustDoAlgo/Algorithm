#include <string>
#include <vector>
#include <map>
#include <algorithm>

using namespace std;

map<string, vector<string>> board;
map<string, vector<bool>> visited;
int total;

bool dfs(string here, vector<string>& v) {
    v.push_back(here);

    if (v.size() == total + 1) return true;

    for (int i=0; i<board[here].size(); ++i) {
        if (!visited[here][i]) {
            visited[here][i] = true;
            if (dfs(board[here][i], v))
                return true;
            visited[here][i] = false;
        }
    }

    v.pop_back();
    return false;
}

vector<string> solution(vector<vector<string>> tickets) {
    board.clear();
    visited.clear();
    total = tickets.size();
    for (auto& t : tickets) {
        board[t[0]].push_back(t[1]);
    }
    for (auto& [key, value] : board) {
        sort(value.begin(), value.end());
        visited[key].resize(board[key].size(), false);
    }

    vector<string> answer;
    dfs("ICN", answer);
    return answer;
}
