// BOJ 15657 N과M(9)
/*
26.03.13 19:15~19:15
15657 N과 M (9)
*/

#include <iostream>
#include <vector>
#include <algorithm>
#include <unordered_map>
#include <map>
using namespace std;

int n, m;
vector<int> v;
map<vector<int>, bool> prevResults;
vector<int> result;
vector<bool> visited;

void func(int k)
{
    if (k == m)
    {
        if (result.size() != m) return;

        if (prevResults[result]) return;

        for (auto& e : result) cout << e << ' ';
        cout << '\n';
        prevResults[result] = true;
        return;
    }

    for (int i=0; i<n; ++i)
    {
        if (visited[i]) continue;
        visited[i] = true;
        result.push_back(v[i]);
        func(k+1);
        visited[i] = false;
        result.pop_back();
    }
}

int main()
{
    cin.tie(0); cout.tie(0);
    ios::sync_with_stdio(0);

    cin >> n >> m;
    v = vector<int>(n, -1);
    visited = vector<bool>(n, false);
    for (auto& e : v)
        cin >> e;
    sort(v.begin(), v.end());

    func(0);
}