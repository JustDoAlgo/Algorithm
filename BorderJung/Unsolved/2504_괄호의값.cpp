#include <iostream>
#include <stack>
using namespace std;

int main()
{
    cin.tie(0);
    ios::sync_with_stdio(0);

    string s; cin >> s;
    stack<char> cs;

    // 완성된 괄호만 값만 2 or 3이 된다.
    int value = 1;  // result에 더할 값
    int result = 0; // 최종 계산 결과

    for (int i=0; i<s.size(); ++i)
    {
        char c = s[i];
        if (c == '(')
        {
            cs.push(c);
            value *= 2;
        }
        if (c == '[')
        {
            cs.push(c);
            value *= 3;
        }
        if (c == ')')
        {
            if (cs.empty() || cs.top() != '(')
            {
                result = 0;
                break;
            }

            if (s[i - 1] == '(') result += value;
            value /= 2;
            cs.pop();
        }
        if (c == ']')
        {
            if (cs.empty() || cs.top() != '[')
            {
                result = 0;
                break;
            }

            if (s[i - 1] == '[') result += value;
            value /= 3;
            cs.pop();
        }
    }
    if (cs.empty())
        cout << result;
    else
        cout << 0;
}