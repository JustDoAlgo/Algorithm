#include <iostream>
#include <stack>
#include <queue>
using namespace std;


/*
stack에 현재 숫자를 넣고 top과 수열 비교
(즉, 현재 숫자와 나와야 하는 수열의 수를 비교)
만약 같다면, '-' 후 pop을 같지 않을 때 까지 비교
만약 다르다면, '+'
*/
int main()
{
    ios::sync_with_stdio(false);
    cin.tie(0);

    int n; cin >> n;
    queue<int> arr;
    for (int i=0; i<n; ++i)
    {
        int currentNum; cin >> currentNum;
        arr.push(currentNum);
    }

    stack<int> s;
    string result = "";
    for (int i=1; i<=n; ++i)
    {
        s.push(i);
        result += "+\n";

        // 현재 숫자와 수열과 비교
        while (!s.empty() && !arr.empty() && s.top() == arr.front())
        {
            s.pop();
            arr.pop();
            result += "-\n";
        }
    }

    // arr에 남은 수열이 있다면, 불가능
    if (!arr.empty())
    {
        cout << "NO\n";
    }
        
    else
        cout << result;
}