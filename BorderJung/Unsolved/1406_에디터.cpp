#include <iostream>
#include <list>
using namespace std;

/*
abcd

(1)L -> (2)D -> (3)B -> P $

(1) 커서는 가장 처음 그대로
(2) 커서는 a, b 사이
(3) a 삭제 후 커서는 가장 처음에 위치
*/

void printList(list<char> l)
{
    for (auto it = l.begin(); it != l.end(); ++it)
    {
        cout << *it;
    }
    cout << '\n';
}

int main()
{
    cin.tie(0);
    ios::sync_with_stdio(false);

    string str; cin >> str;
    int n; cin >> n;

    // string to list
    list<char> cl = list<char>();
    for (auto& e : str)
        cl.push_back(e);

    list<char>::iterator it = cl.end();

    while (n--)
    {
        char op, value;
        cin >> op;
        switch (op)
        {
            case 'L':
                if (it != cl.begin())
                    --it;
                break;
            case 'D':
                if (it != cl.end())
                    ++it;
                break;
            case 'B':
                if (it != cl.begin())
                {
                    // 여기가 중요! erase한 iterator는 더 이상 사용 불가능
                    // 따라서 erase로 **다음** iterator를 반환받아야 함!!

                    // erase로 제거하면 다음 iterator를 반환한다.
                    // prev는 이전 원소 제거
                    // next는 다음 원소 제거
                    // prev와 next는 안전한 제거를 위해 사용
                    it = cl.erase(prev(it));
                }
                break;
            case 'P':
                cin >> value;
                // 현재 iterator **앞**에 삽입
                cl.insert(it, value);
                break;
            default:
                break;
        }
        //printList(cl);
    }
    for (auto& e : cl)
        cout << e;
}