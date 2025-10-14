#include <iostream>
#include <deque>
using namespace std;

int main()
{
    cin.tie(0);
    ios::sync_with_stdio(false);

    int n, m; cin >> n >> m;
    deque<int> d;
    
    for (int i=1; i<=n; ++i)
        d.push_back(i);

    // deque로 구현하고, 현재 index와 전체 개수로 left or right를 판단
    int result = 0;
    while (m--)
    {
        int p; cin >> p;

        // i는 left count

        //////////////////////////////////////
        // deque도 find method가 가능했다는거
        int left = find(d.begin(), d.end(), p) - d.begin();

        // 아래는 그냥 구한거 허허
        // for (left=0; left<d.size(); ++left)
        // {
        //     if (d[left] == p)
        //         break;
        // }
        //////////////////////////////////////

        int right = d.size() - left - 1;

        bool isRight = (left > right);
        //cout << "right = " << right << ", left = " << left << '\n';

        // 1번 연산은 pop_front()만 해당되니 가장 오른쪽에 있다면
        // 3번 연산을 한 번 더 해야 한다.
        if (isRight)
        {
            for (int i=0; i<right; ++i)
            {
                d.push_front(d.back());
                d.pop_back();
                result += 1;
            }
            //cout << "pop " << d.back() << " by " << right + 1 << " times\n";
            d.pop_back();
            result += 1;
        }
        else
        {
            for (int i=0; i<left; ++i)
            {
                d.push_back(d.front());
                d.pop_front();
                result += 1;
            }
            //cout << "pop " << d.front() << " by " << left + 1 << " times\n";
            d.pop_front();
        }
    }

    cout << result;
}