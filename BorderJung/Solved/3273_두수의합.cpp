#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

/*
1~n의 수 중 2개를 골라 더했을 때 x가 나오게 하는 쌍의 수
i < j니까 조합으로 골라야 해.

투포인터 문제인 듯 한데
1. 오름차순 정렬

1,2,3,4,5 이고 x = 7이라 하면
- e1 = 1
- e2 = 5

e1 + e2 = 6 < 7 이니 e1을 하나 추가
...

*/
int main()
{
    cin.tie(0);
    ios::sync_with_stdio(false);

    // input
    int n, x;
    cin >> n;
    vector<int> nums(n, 0);
    for (auto& e : nums)
        cin >> e;
    cin >> x;

    // solve
    int e1 = 0;
    int e2 = n - 1;
    sort(nums.begin(), nums.end());

    int result = 0;
    while (e1 < e2)
    {
        int sum = nums[e1] + nums[e2];
        // 합이 x와 동일한 경우, 결과 갱신 후 e1을 1 step 증가 시킨다.
        if (sum == x)
        {
            //cout << "nums[" << e1 << "] + nums[" << e2 << "] = " << sum << '\n';
            result += 1;
            e1 += 1;
        }
        // 합이 x보다 작은 경우, e1을 1 step 증가 시킨다.
        else if (sum < x)
        {
            //cout << "nums[" << e1 << "] + nums[" << e2 << "] = " << sum << '\n';
            e1 += 1;
        }
        // 합이 x보다 큰 경우, e2를 1 step 감소 시킨다.
        else if (sum > x)
        {
            //cout << "nums[" << e1 << "] + nums[" << e2 << "] = " << sum << '\n';
            e2 -= 1;
        }
    }

    cout << result;
}