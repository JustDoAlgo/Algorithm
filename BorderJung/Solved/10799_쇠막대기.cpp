#include <iostream>
#include <stack>
using namespace std;

/*
'('가 나올 때마다 막대의 개수(cnt)를 하나씩 늘린다.
만약 '()'이 완성되는 순간이 온다면,
    cnt = cnt - 1(현재 괄호는 빼)을 result에 대함
*/
int main()
{
    cin.tie(0);
    ios::sync_with_stdio(false);

    string s; cin >> s;

    stack<char> cs;
    int cnt = 0;
    int result = 0;
    for (auto& c : s)
    {
        if (c == '(')
        {
            cnt += 1;
        }
        else if (!cs.empty() && c == ')')
        {
            cnt -= 1;
            if (cs.top() == '(') result += cnt;
            else result += 1;
        }
        cs.push(c);
    }

    cout << result;
}