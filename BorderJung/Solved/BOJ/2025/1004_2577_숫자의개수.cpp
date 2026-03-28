// #include <iostream>
// using namespace std;

// int main()
// {
//     cin.tie(0); cout.tie(0);
//     ios::sync_with_stdio(0);

//     int a, b, c;
//     cin >> a >> b >> c;

//     long long multiple = a * b * c;

//     int numCounts[10] = {0, };
//     while (multiple > 0)
//     {
//         int r = multiple % 10;
//         numCounts[r] += 1;
//         multiple /= 10;
//     }

//     for (int i=0; i<10; ++i)
//     {
//         cout << numCounts[i] << '\n';
//     }
// }

// 제미나이 추천으로 다시 짜기
#include <iostream>
#include <vector>
#include <string> // to_string()
#define ll long long
using namespace std;

int main()
{
    cin.tie(0);
    ios::sync_with_stdio(false);

    int a, b, c;
    cin >> a >> b >> c;
    ll product = (ll)a * b * c;

    vector<int> counts(10, 0);

    string s = to_string(product);

    for (char c : s)
    {
        counts[c - '0'] += 1;
    }

    for (auto& e : counts)
        cout << e << '\n';
}