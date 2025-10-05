#include <iostream>
#include <list>
using namespace std;

int main()
{
    ios::sync_with_stdio(false);
    cin.tie(0);

    int n; cin >> n;
    while (n--)
    {
        string s; cin >> s;
        list<char> l;
        auto it = l.begin();

        for (auto& e : s)
        {
            if (e == '-')
            {
                if (it != l.begin())
                    it = l.erase(prev(it));
            }
            else if (e == '<')
            {
                if (it != l.begin())
                    --it;
            }
            else if (e == '>')
            {
                if (it != l.end())
                    ++it;
            }
            else
            {
                l.insert(it, e);
            }
        }

        // for (auto it = l.begin(); it != l.end(); ++it)
        //     cout << *it;
        // list도 범위기반 탐색이 가능하다는거..
        for (auto& e : l)
            cout << e;
        cout << '\n';
    }
}