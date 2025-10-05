#include <iostream>
#include <list>
#include <vector>
using namespace std;

int main()
{
    cin.tie(0);
    ios::sync_with_stdio(0);

    int n, k;
    cin >> n >> k;

    list<int> l;
    for (int i=1; i<=n; ++i)
        l.push_back(i);

    auto it = l.begin();
    vector<int> result;
    int cnt = 1;

    /*
    매 턴 한 칸씩 이동.
    만약 현재 cnt가 k의 배수이면, 제거 후 cnt 초기화 + it은 전으로 이동해야 해.
    */
    while (!l.empty())
    {
        // 만약 현재 원소를 제거해야 한다면, 초기화 후 continue
        if (cnt % k == 0)
        {
            int value = *it;
            result.push_back(value);
            it = l.erase(it);
            if (it == l.end())
                it = l.begin();

            // init
            cnt = 1;

            continue;
        }

        // 한 칸 이동 로직 구현

        // 1. 한 칸 이동.
        cnt += 1;
        ++it;

        // 2. 만약 끝까지 갔다면 처음으로 돌려야 해
        if (it == l.end())
        {
            it = l.begin();
        }
    }

    for (int i=0; i<result.size(); ++i)
    {
        if (i == 0) cout << '<';
        
        cout << result[i];
        
        if (i == result.size() - 1)
            cout << ">\n";
        else
            cout << ", ";
    }
}

// 다른 구현: 이게 좀 더 깔끔한데
// int main2()
// {
//     cin.tie(0);
//     ios::sync_with_stdio(0);

//     int n, k;
//     cin >> n >> k;

//     list<int> l;
//     for (int i=1; i<=n; ++i)
//         l.push_back(i);

//     auto it = l.begin();
//     vector<int> result;

//     while (!l.empty())
//     {
//         // 만약 현재 원소를 제거해야 한다면, 초기화 후 continue
//         for (int i=0; i<k; ++i)
//         {            
//             ++it;

//             // 만약 끝까지 갔다면 처음으로 돌려야 해
//             if (it == l.end())
//                 it = l.begin();
//         }

//         // 한 칸 이동 로직 구현
//         result.push_back(*it);
//         it = l.erase(it);
//     }

//     cout << '<';
//     for (int i=0; i<result.size(); ++i)
//     {
//         cout << result[i];
        
//         if (i != result.size() - 1)
//             cout << ", ";
//     }
//     cout << ">\n";
// }