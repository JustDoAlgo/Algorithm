// BOJ 15651 N과M(3)
/*
2026.03.12 22:00~22:10
15651 - N과 M (3)
이지
*/

#include <iostream>
#include <vector>
using namespace std;

/*
여러 번 골라도 된다는 건, 0~n-1까지 전탐색 한다는 것.
그럼 다중 포문이 되는데, 7 이하니까 7^7이 최대
비벼볼만 한거 아닐까?
*/

int n, m;

void func(vector<int> v)
{
    if (!v.empty() && v.size() == m)
    {
        for (auto& e : v)
            cout << e << ' ';
        cout << '\n';
        return;
    }

    for (int i=1; i<=n; ++i)
    {
        v.push_back(i);
        func(v);
        v.pop_back();   
    }
}

int main()
{
    cin.tie(0);
    cout.tie(0);
    ios::sync_with_stdio(0);

    cin >> n >> m;
    vector<int> v;
    func(v);
}