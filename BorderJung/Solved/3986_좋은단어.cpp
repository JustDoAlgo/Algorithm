#include <iostream>
#include <stack>
using namespace std;

/*
무조건 뒤에 나온게 우선적으로 쌍이 지어져야 함.
like 괄호 문제
*/
int main()
{
    cin.tie(0);
    ios::sync_with_stdio(false);

    int n; cin >> n;
    int result = 0;
    while (n--)
    {
        string s; cin >> s;

        stack<char> cs;
        for (auto& c : s)
        {
            if (!cs.empty() && cs.top() == c)
            {
                cs.pop();
            }
            else
            {
                cs.push(c);
            }
        }

        if (cs.empty())
            result += 1;
    }

    cout << result;
}