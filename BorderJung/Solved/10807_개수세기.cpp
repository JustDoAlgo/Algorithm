#include <iostream>
#include <map>
using namespace std;

int main()
{
    cin.tie(0);
    ios::sync_with_stdio(false);

    int N;
    cin >> N;
    
    map<int, int> m;
    while (N--)
    {
        int a;
        cin >> a;

        // 만약 아직 나오지 않았다면, 1로 초기화
        if (m.find(a) == m.end())
        {
            m[a] = 1;
        }
        // 이미 있는 숫자라면, +1
        else
        {
            m[a] += 1;
        }
    }

    int v;
    cin >> v;

    if (m.find(v) == m.end())
    {
        cout << 0;
    }
    else
    {
        cout << m[v];
    }
}

// 제미나이 식
// #include <iostream>
// #include <unordered_map>
// using namespace std;

// int main()
// {
//     ios::sync_with_stdio(0);
//     cin.tie(0);

//     int n;
//     cin >> n;
    
//     unordered_map<int, int> freq;
//     while(n--)
//     {
//         int a;
//         cin >> a;
//         freq[a]++; // key가 없으면 0으로 초기화 되어 있음.
//     }

//     int v;
//     cin >> v;
//     cout << freq[v];
// }