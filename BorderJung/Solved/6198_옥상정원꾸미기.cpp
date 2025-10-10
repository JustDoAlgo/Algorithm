#include <iostream>
#include <stack>
using namespace std;

/*
현재 타워보다 키 작은 타워는 필요없음 -> pop
"나를 볼 수 있는 타워" 만을 남김
*/
int main()
{
    ios::sync_with_stdio(false);
    cin.tie(0);

    int n; cin >> n;
    stack<int> towers;
    long long result = 0;

    towers.push(1000000001); // 최댓값 + 1을 미리 넣어둬 stack이 비는걸 방지
    while (n--)
    {
        int h; cin >> h;

        while (towers.top() <= h)
        {
            towers.pop();    
        }

        result += towers.size() - 1; // 미리 넣어둔 padding은 제거
        // cout << "result + " << towers.size() - 1 << " = " << result << '\n';
        towers.push(h);
    }
    cout << result;
}