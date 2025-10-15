/*
i-2, i-1, i 중 최솟값을 구하는 것임.
i < 2 인 경우는 최댓값으로 보고 하면 됨.
*/

#include <iostream>
#include <deque>
#include <vector>
using namespace std;

int main()
{
    cin.tie(0);
    ios::sync_with_stdio(false);

    int n, l; cin >> n >> l;

    int minA = 987654321;
    
    vector<int> v(n);
    for (auto& e : v) cin >> e;
    
    deque<int> dq;

    // 슬라이딩 윈도우 !!
    for (int i=0; i<n; ++i)
    {
        if (!dq.empty() && dq.front() < i - l + 1)
        {
            dq.pop_front();
        }

        // 현재 숫자보다 크다면 더 이상 존재 이유가 없음
        // 현재 숫자가 가장 오래 남을 것이기 때문에
        while (!dq.empty() && v[dq.back()] > v[i])
        {
            dq.pop_back();
        }

        dq.push_back(i);
        cout << v[dq.front()] << ' ';
    }
}