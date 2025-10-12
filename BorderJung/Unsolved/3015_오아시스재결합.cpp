#include <iostream>
#include <stack>
#define x first
#define y second
using namespace std;

int main()
{
    cin.tie(0);
    ios::sync_with_stdio(false);

    /*
    Stack에 순서대로 쌓아가면서 전 사람과 키를 비교.
    1. 만약 전 사람보다 키가 크거나 같으면?
        전 사람을 볼 수 있으면 나도 보겠지.
    2. 만약 전 사람보다 키가 작으면?
        나를 볼 수 있는건 전 사람 뿐임
    */

    int n; cin >> n;
    stack<pair<int, int>> people; // 자기 키, 쌍 수

    long long result = 0;
    while (n--)
    {
        int h; cin >> h;
        int cnt = 1;
        while (!people.empty() && people.top().x <= h)
        {
            result += people.top().y;
            if (people.top().x == h)
                cnt += people.top().y;
            people.pop(); 
        }

        if (!people.empty())
            result += 1;
        
        people.push({h, cnt});
    }

    cout << result;
}